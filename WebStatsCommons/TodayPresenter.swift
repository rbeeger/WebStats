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

import Foundation
import ReactiveCocoa

public class TodayPresenter {
    
    public let topPagesHeader = ConstantProperty("Top Pages")

    
    public let statisticsContentView: PropertyOf<String>
    public let topPagesContentView: PropertyOf<String>
    public let barValuesView: PropertyOf<[Int]>
    public let maxValueView: PropertyOf<Int>

    private let statsService: StatsService
    private let dateUtil: DateUtil
    private let statisticsContent: MutableProperty<String>
    private let topPagesContent: MutableProperty<String>
    private let barValues: MutableProperty<[Int]>
    private let maxValue: MutableProperty<Int>
    
    public init(statsService: StatsService, dateUtil: DateUtil) {
        self.statsService = statsService
        self.dateUtil = dateUtil
        
        barValues = MutableProperty([0, 0, 0])
        barValuesView = PropertyOf(barValues)
        
        maxValue = MutableProperty(100)
        maxValueView = PropertyOf(maxValue)
        
        statisticsContent = MutableProperty("")
        statisticsContentView = PropertyOf(statisticsContent)
        
        topPagesContent = MutableProperty("")
        topPagesContentView = PropertyOf(topPagesContent)
    }
    
    public func triggerUpdate() -> SignalProducer<Void, NoError> {
        return SignalProducer {
            observer, disposable in
            let now = self.dateUtil.now()
            let dayStart = self.dateUtil.dayStart(now)
            combineLatest(
                self.statsService.statisticsForLast(1, .Days),
                self.statsService.topPagesFrom(dayStart, to: now)).start(next: {
                    let statistics = $0.0.1
                    let topPages = $0.1
                    self.barValues.value = [
                        statistics.pageViews,
                        statistics.visits,
                        statistics.bounces]
                    self.maxValue.value =
                        max(self.maxValue.value, statistics.pageViews + statistics.pageViews / 10)
                    self.topPagesContent.value = join("\n", topPages)

                    self.statisticsContent.value = String(
                        format: "%d Bounces,  %d Visits, %d Page Views",
                        statistics.bounces, statistics.visits, statistics.pageViews)
                    
                    sendCompleted(observer)
                })
        }
    }
}
