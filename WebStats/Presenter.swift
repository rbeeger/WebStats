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
import WebStatsCommons

public class Presenter {
    public let statisticsIntervals = ["recent 7 days", "recent 7 weeks"]
    public var currentStatisticsIntervalIndex = 0 {
        didSet {
            updateStatistics()
        }
    }
    public let topPagesHeader = "Top Pages"
    public let topReferrers = "Top Referrers"
    
    public let intervalHeaderView: PropertyOf<String>
    public let statisticsContentView: PropertyOf<String>
    public let topPagesContentView: PropertyOf<String>
    public let topReferrersContentView: PropertyOf<String>
    public let barValueViews: [PropertyOf<[Int]>]
    public let maxValueView: PropertyOf<Int>
    public let selectedBarIndex: MutableProperty<Int?>
    
    private let statsService: StatsService
    private let dateUtil: DateUtil
    private let intervalHeader: MutableProperty<String>
    private let statisticsContent: MutableProperty<String>
    private let topPagesContent: MutableProperty<String>
    private let topReferrersContent: MutableProperty<String>
    private let barValues: [MutableProperty<[Int]>]
    private let maxValue: MutableProperty<Int>
    private let intervalStartDate: MutableProperty<NSDate>
    private let intervalEndDate: MutableProperty<NSDate>
    
    private var barIntervals: [Interval]
    
    public init(statsService: StatsService, dateUtil: DateUtil) {
        self.statsService = statsService
        self.dateUtil = dateUtil
        
        topPagesContent = MutableProperty("")
        topPagesContentView = PropertyOf(topPagesContent)
        topReferrersContent = MutableProperty("")
        topReferrersContentView = PropertyOf(topReferrersContent)
        barValues = [
            MutableProperty([0, 0, 0]),
            MutableProperty([0, 0, 0]),
            MutableProperty([0, 0, 0]),
            MutableProperty([0, 0, 0]),
            MutableProperty([0, 0, 0]),
            MutableProperty([0, 0, 0]),
            MutableProperty([0, 0, 0])
        ]
        
        barValueViews = [
            PropertyOf(barValues[0]),
            PropertyOf(barValues[1]),
            PropertyOf(barValues[2]),
            PropertyOf(barValues[3]),
            PropertyOf(barValues[4]),
            PropertyOf(barValues[5]),
            PropertyOf(barValues[6]),
        ]
        
        let now = NSDate()
        let nowInterval = Interval(startDate: now, endDate: now)
        barIntervals = [
            nowInterval,
            nowInterval,
            nowInterval,
            nowInterval,
            nowInterval,
            nowInterval,
            nowInterval
        ]
        
        maxValue = MutableProperty(100)
        maxValueView = PropertyOf(maxValue)
        
        intervalHeader = MutableProperty("")
        intervalHeaderView = PropertyOf(intervalHeader)
        intervalStartDate = MutableProperty(NSDate())
        intervalEndDate = MutableProperty(NSDate())

        selectedBarIndex = MutableProperty(nil)
        statisticsContent = MutableProperty("")
        statisticsContentView = PropertyOf(statisticsContent)
        
        combineLatest(intervalStartDate.producer, intervalEndDate.producer).start(next: {
            startDate, endDate in
            self.updateIntervalHeaderForIntervalFrom(startDate, to: endDate)
            self.updateTopsForIntervalFrom(startDate, to: endDate)
        })
        
        selectedBarIndex.producer.start(next: {
            self.updateIntervalDatesWithSelectedBar($0)
            self.updateStatisticsContentWithSelectedBar($0)
        })
        
        updateStatistics()
    }
    
    private func updateStatistics() {
        maxValue.value = 100
        statsService.statisticsForLast(
            7, currentStatisticsIntervalIndex == 0 ? .Days : .Weeks).start(next: {
                entryIndex, statistics in
                self.barValues[entryIndex].value = self.barValuesFromStatistics(statistics)
                self.barIntervals[entryIndex] = statistics.interval
                self.maxValue.value =
                    max(self.maxValue.value, statistics.pageViews + statistics.pageViews / 10)
                if entryIndex == 0 {
                    self.intervalStartDate.value = statistics.interval.startDate
                } else {
                    self.intervalEndDate.value = statistics.interval.endDate
                }
                self.updateStatisticsContentWithSelectedBar(self.selectedBarIndex.value)
            })
    }
    
    private func barValuesFromStatistics(statistics:StatsService.Statistics) -> [Int] {
        return [
            statistics.pageViews,
            statistics.visits,
            statistics.bounces]
    }
    
    private func updateIntervalHeaderForIntervalFrom(startDate:NSDate, to endDate:NSDate) {
        let startDateString = dateUtil.stringFromDate(startDate)
        if NSCalendar.currentCalendar().isDate(startDate, inSameDayAsDate: endDate) {
            intervalHeader.value = startDateString
        } else {
            let endDateString = dateUtil.stringFromDate(endDate)
            intervalHeader.value = "\(startDateString) - \(endDateString)"
        }
    }
    
    private func updateTopsForIntervalFrom(startDate:NSDate, to endDate:NSDate) {
        self.statsService.topPagesFrom(startDate, to: endDate).start(next: {
            self.topPagesContent.value = join("\n", $0)
        })
        self.statsService.topReferrersFrom(startDate, to: endDate).start(next: {
            self.topReferrersContent.value = join("\n", $0)
        })
    }
    
    private func updateIntervalDatesWithSelectedBar(selectedBarIndex:Int?) {
        if let index = selectedBarIndex {
            self.intervalStartDate.value = self.barIntervals[index].startDate
            self.intervalEndDate.value = self.barIntervals[index].endDate
        } else {
            self.intervalStartDate.value = self.barIntervals.first!.startDate
            self.intervalEndDate.value = self.barIntervals.last!.endDate
        }
    }
    
    private func updateStatisticsContentWithSelectedBar(selectedBarIndex:Int?) {
        var relevantBarValues: [[Int]]
        
        if let selectedBar = selectedBarIndex {
            relevantBarValues = [barValues[selectedBar].value]
        } else {
            relevantBarValues = barValues.map({$0.value})
        }

        var pageViews = 0
        var visits = 0
        var bounces = 0
        for values in relevantBarValues {
            pageViews += values[0]
            visits += values[1]
            bounces += values[2]
        }
        
        statisticsContent.value = String(
            format: "Page Views: \t%d\nVisits: \t\t\t%d\nBounces: \t\t%d",
            pageViews , visits, bounces)
    }
}
