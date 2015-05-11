// Copyright (c) 2015 Robert F. Beeger
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import NotificationCenter
import ReactiveCocoa
import WebStatsCommons

@objc (TodayViewController)
class TodayViewController: UIViewController, NCWidgetProviding {
    private weak var chart:Chart?
    private let presenter: TodayPresenter
    private var chartUpdatesRegistered = false
    
    init() {
        let dateUtil = DateUtil()
        let statsService = StatsService(dateUtil: dateUtil)
        presenter = TodayPresenter(statsService: statsService, dateUtil: dateUtil)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orientation = ChartOrientation.Vertical
        
        let chart = Chart(
            barColors: [ViewUtil.oddContainerColor],
            valueColors: [ViewUtil.pageViewsColor, ViewUtil.visitsColor, ViewUtil.bouncesColor],
            orientation: .Vertical,
            interactive:false)
        view.addSubview(chart)
        
        let statisticsContent = ViewUtil.createContentLabelWithContext(
            .Widget, andContentSource: presenter.statisticsContentView)
        view.addSubview(statisticsContent)
        
        let topPagesHeader = ViewUtil.createHeaderLabelWithContext(.Widget)
        topPagesHeader.text = presenter.topPagesHeader
        view.addSubview(topPagesHeader)
        
        let topPagesContent = ViewUtil.createContentLabelWithContext(
            .Widget, andContentSource: presenter.topPagesContentView)
        view.addSubview(topPagesContent)
        
        let layout = Layout(parent: view)
        layout.alignTop(chart, margin: 10)
        layout.alignLeft(chart, margin: 0)
        layout.alignRight(chart, margin: 10)
        layout.setHeight(chart, height: 30)
        layout.put(statisticsContent, below: chart, separatorSpace: 4)
        layout.stretchHorizontally(statisticsContent)
        layout.put(topPagesHeader, below: statisticsContent, separatorSpace: 10)
        layout.stretchHorizontally(topPagesHeader)
        layout.put(topPagesContent, below: topPagesHeader, separatorSpace: 4)
        layout.stretchHorizontally(topPagesContent, margin: 10)
        
        preferredContentSize = CGSize(width: 0, height: 140)
        self.chart = chart
    }
    
    override func loadView() {
        view = UIView(frame: CGRectZero)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let chart = chart where !chartUpdatesRegistered {
            presenter.barValuesView.producer.start(next: {chart.bars[0].values = $0})
            presenter.maxValueView.producer.start(next: {chart.bars[0].maxValue = $0})
            chartUpdatesRegistered = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        presenter.triggerUpdate().start(completed: {completionHandler(NCUpdateResult.NewData)})
    }
    
}
