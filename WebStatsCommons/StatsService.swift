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

public class StatsService {
    public enum QueryIntervals {
        case Days
        case Weeks
    }
    
    public struct Statistics {
        public let interval: Interval
        public let pageViews: Int
        public let visits: Int
        public let bounces: Int
        
        public init(interval: Interval, pageViews: Int, visits: Int, bounces: Int) {
            self.interval = interval
            self.pageViews = pageViews
            self.visits = visits
            self.bounces = bounces
        }
    }
    
    private let dateUtil: DateUtil
    
    public init(dateUtil: DateUtil) {
        self.dateUtil = dateUtil
    }
    
    public func statisticsForLast(entryCount:Int, _ queryIntervals:QueryIntervals)
        -> SignalProducer<(Int, Statistics), NoError> {
            return SignalProducer {
                observer, disposable in
                
                for (index,interval) in enumerate(self.dateIntervalsFrom(
                    queryIntervals, withCount: entryCount)) {
                        let pageViews = arc4random_uniform(queryIntervals == .Weeks ? 10000 : 1000)
                        let visits = arc4random_uniform(pageViews)
                        let bounces = arc4random_uniform(visits)
                        sendNext(observer, (index, Statistics(interval: interval,
                            pageViews: Int(pageViews), visits: Int(visits), bounces: Int(bounces))))
                }
                
                sendCompleted(observer)
            }
    }
    
    private func dateIntervalsFrom(queryIntervals:QueryIntervals, withCount count:Int) -> [Interval] {
        let calendar = NSCalendar.currentCalendar()
        var anchorDate = NSDate()
        if queryIntervals == .Weeks {
            anchorDate = dateUtil.lastMondayFrom(anchorDate)
        }
        
        var daysPerInterval = queryIntervals == .Days ? 1 : 7
        return dateUtil.intervalsWithLastIntervalStartingOn(anchorDate,
            intervalLength: daysPerInterval, intervalCount: count)
    }
    
    public func topPagesFrom(startDate:NSDate, to endDate:NSDate)
        -> SignalProducer<[String], NoError> {
            return SignalProducer {
                observer, disposable in
                sendNext(observer, self.randomThreeFrom(StatsService.pages))
                sendCompleted(observer)
            }
    }
    
    public func topReferrersFrom(startDate:NSDate, to endDate:NSDate)
        -> SignalProducer<[String], NoError> {
            return SignalProducer {
                observer, disposable in
                sendNext(observer, self.randomThreeFrom(StatsService.referrers))
                sendCompleted(observer)
            }
    }
    
    private static let pages = [
        "Start",
        "Contact",
        "Blog",
        "Shop",
        "Privacy",
        "Our New Product"]
    private static let referrers = [
        "Google",
        "DuckDuckGo",
        "Bing",
        "Yahoo",
        "Daring Fireball",
        "Macstories",
        "Golem",
        "heise Online News"]
    
    private func randomThreeFrom(strings:[String]) -> [String] {
        let upperBound = UInt32(count(strings))
        var randoms = Set<UInt32>()
        while count(randoms) < 3 {
            randoms.insert(arc4random_uniform(upperBound))
        }
        
        return map(randoms, {strings[Int($0)]})
    }
}