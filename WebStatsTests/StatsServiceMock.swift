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
import WebStatsCommons
import ReactiveCocoa

class StatsServiceMock: StatsService {
    let dateFormatter: NSDateFormatter
    
    init() {
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        
        super.init(dateUtil: DateUtilMock())
    }
    
    
    override func statisticsForLast(entryCount: Int, _ queryIntervals: StatsService.QueryIntervals)
        -> SignalProducer<(Int, StatsService.Statistics), NoError> {
            typealias StatisticsResult = (Int, StatsService.Statistics)
            var results = [StatisticsResult]()
            for i in 0..<entryCount {
                let offset = 100 * (i + 1) + (queryIntervals == .Days ? 0 : 1000)
                let numberOfDays = queryIntervals == .Days ? 1 : 2
                results.append((i,
                    StatsService.Statistics(
                        interval: dateIntervalWithIndex(i, withNumberOfDays: numberOfDays),
                        pageViews: 3 + offset,
                        visits: 2 + offset,
                        bounces: 1 + offset)))
            }
            
            return SignalProducer(values: results)
    }
    
    override func topPagesFrom(startDate: NSDate, to endDate: NSDate)
        -> SignalProducer<[String], NoError> {
            return SignalProducer(value:
                [topEntryForIntervalFrom(startDate, to: endDate, withSuffix: "top page")])
    }
    
    override func topReferrersFrom(startDate: NSDate, to endDate: NSDate)
        -> SignalProducer<[String], NoError> {
            return SignalProducer(value:
                [topEntryForIntervalFrom(startDate, to: endDate, withSuffix: "top referrer")])
    }
    
    private func topEntryForIntervalFrom(startDate: NSDate, to endDate: NSDate,
        withSuffix suffix:String) -> String {
            return "\(dateFormatter.stringFromDate(startDate))-\(dateFormatter.stringFromDate(endDate)) \(suffix)"
    }
    
    
    private func dateIntervalWithIndex(index:Int, withNumberOfDays days:Int) -> Interval {
        let calendar = NSCalendar.currentCalendar()
        let startDay = 1 + (days * index)
        let startDate = calendar.dateWithEra(
            1, year: 2015, month: 5, day: startDay,
            hour: 0, minute: 0, second: 0, nanosecond: 0)!
        let endDate = calendar.dateWithEra(
            1, year: 2015, month: 5, day: startDay + days - 1,
            hour: 23, minute: 59, second: 59, nanosecond: 0)!
        
        return Interval(startDate: startDate, endDate: endDate)
    }

    
}