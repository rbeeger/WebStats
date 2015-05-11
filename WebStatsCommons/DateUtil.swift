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

public class DateUtil {
    private let dateFormatter: NSDateFormatter
    
    public init() {
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
    }
    
    public func now() -> NSDate {
        return NSDate()
    }
    
    public func stringFromDate(date:NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
    
    public func lastMondayFrom(date: NSDate) -> NSDate {
        var result:NSDate? = nil
        let calendar = NSCalendar.currentCalendar()
        if let sixDaysAgo = calendar.dateByAddingUnit(.CalendarUnitDay, value: -6,
            toDate: date, options: .allZeros) {
                if let lastMonday = calendar.nextDateAfterDate(
                    sixDaysAgo,
                    matchingUnit: .CalendarUnitWeekday,
                    value: 2,
                    options: .MatchNextTime) {
                        result = lastMonday
                }
        }
        
        assert(result != nil, "should have found the last Monday")
        return result!
    }
    
    public func intervalsWithLastIntervalStartingOn(
        startDate: NSDate, intervalLength: Int, intervalCount:Int) -> [Interval] {
            return (0..<intervalCount).map({
                NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay,
                    value: -(intervalLength * $0),
                    toDate: startDate, options: .allZeros)
            }).filter({$0 != nil}).map({
                self.intervalStartingOn($0!, withNumberOfDays: intervalLength)}).reverse()
            
    }
    
    public func dayStart(date:NSDate) -> NSDate {
        return NSCalendar.currentCalendar().dateBySettingHour(
            0, minute: 0, second: 0, ofDate: date, options: .allZeros)!
    }
    
    public func dayEnd(date:NSDate) -> NSDate {
        return NSCalendar.currentCalendar().dateBySettingHour(
            23, minute: 59, second: 59, ofDate: date, options: .allZeros)!
    }
    
    public func intervalStartingOn(startDate: NSDate, withNumberOfDays days:Int) -> Interval {
        let calendar = NSCalendar.currentCalendar()
        let startDateNormalized = dayStart(startDate)
        let endDate = NSCalendar.currentCalendar().dateByAddingUnit(
            .CalendarUnitDay, value: days - 1, toDate: startDateNormalized,
            options: .allZeros)!
        let endDateNormalized = dayEnd(endDate)
        return Interval(startDate: startDateNormalized, endDate: endDateNormalized ?? startDate)
    }
    
    
}
