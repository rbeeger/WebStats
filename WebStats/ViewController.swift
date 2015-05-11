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

import ReactiveCocoa
import WebStatsCommons

class ViewController: UIViewController {
    private let presenter: Presenter
    private weak var chart: Chart?
    private var chartUpdatesRegistered = false

    
    init(presenter: Presenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.whiteColor()
        
        let intervalSelection = UISegmentedControl(items: presenter.statisticsIntervals)
        intervalSelection.tintColor = ViewUtil.controlTintColor
        intervalSelection.selectedSegmentIndex = presenter.currentStatisticsIntervalIndex
        view.addSubview(intervalSelection)
        
        let chart = Chart(
            barColors: [
                ViewUtil.oddContainerColor,
                ViewUtil.evenContainerColor,
                ViewUtil.oddContainerColor,
                ViewUtil.evenContainerColor,
                ViewUtil.oddContainerColor,
                ViewUtil.evenContainerColor,
                ViewUtil.oddContainerColor],
            valueColors: [
                ViewUtil.pageViewsColor,
                ViewUtil.visitsColor,
                ViewUtil.bouncesColor],
            orientation: .Horizontal,
            interactive:true)
        view.addSubview(chart)
        
        chart.selectedBar.producer.start(next: {
            if let selectedBar = $0 {
                self.presenter.selectedBarIndex.value = find(chart.bars, selectedBar)
            } else {
                self.presenter.selectedBarIndex.value = nil
            }
        })
        intervalSelection.rac_signalForControlEvents(
            UIControlEvents.ValueChanged).toSignalProducer().start(next: {
                _ in
                chart.selectedBar.value = nil
                self.presenter.currentStatisticsIntervalIndex = intervalSelection.selectedSegmentIndex
            })

        
        let intervalHeader = ViewUtil.createHeaderLabelWithContext(.App)
        presenter.intervalHeaderView.producer.start(next: {intervalHeader.text = $0})
        intervalHeader.textAlignment = .Center
        view.addSubview(intervalHeader)

        let statisticsContent = ViewUtil.createContentLabelWithContext(
            .App, andContentSource: presenter.statisticsContentView)
        view.addSubview(statisticsContent)
        
        let topPagesHeader = ViewUtil.createHeaderLabelWithContext(.App)
        topPagesHeader.text = presenter.topPagesHeader
        view.addSubview(topPagesHeader)
        
        let topPagesContent = ViewUtil.createContentLabelWithContext(
            .App, andContentSource: presenter.topPagesContentView)
        view.addSubview(topPagesContent)
        
        let topReferrersHeader = ViewUtil.createHeaderLabelWithContext(.App)
        topReferrersHeader.text = presenter.topReferrers
        view.addSubview(topReferrersHeader)
        
        let topReferrersContent = ViewUtil.createContentLabelWithContext(
            .App, andContentSource: presenter.topReferrersContentView)
        view.addSubview(topReferrersContent)
        
        let layout = Layout(parent: view)
        layout.alignTop(intervalSelection, margin: 30)
        layout.stretchHorizontally(intervalSelection, margin: 20)
        layout.put(chart, below: intervalSelection, separatorSpace: 10)
        layout.stretchHorizontally(chart, margin: 20)
        layout.put(intervalHeader, below: chart, separatorSpace: 20)
        layout.stretchHorizontally(intervalHeader, margin: 20)
        layout.put(statisticsContent, below: intervalHeader)
        layout.stretchHorizontally(statisticsContent, margin: 30)
        layout.put(topPagesHeader, below: statisticsContent, separatorSpace: 20)
        layout.stretchHorizontally(topPagesHeader, margin: 20)
        layout.put(topPagesContent, below: topPagesHeader, separatorSpace: 2)
        layout.stretchHorizontally(topPagesContent, margin: 30)
        layout.put(topReferrersHeader, below: topPagesContent, separatorSpace: 20)
        layout.stretchHorizontally(topReferrersHeader, margin: 20)
        layout.put(topReferrersContent, below: topReferrersHeader, separatorSpace: 2)
        layout.stretchHorizontally(topReferrersContent, margin: 30)
        layout.alignBottom(topReferrersContent, margin: 10)
        
        let recognizer = UITapGestureRecognizer(target: self, action: "tapped:")
        view.addGestureRecognizer(recognizer)
        
        self.chart = chart
    }
    
    func tapped(recognizer:UITapGestureRecognizer) {
        chart?.selectedBar.value = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let chart = chart where !chartUpdatesRegistered {
            for i in 0..<7 {
                presenter.barValueViews[i].producer.start(next: {chart.bars[i].values = $0})
            }
            presenter.maxValueView.producer.start(next: {
                for bar in chart.bars {
                    bar.maxValue = $0
                }
            })
            chartUpdatesRegistered = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

