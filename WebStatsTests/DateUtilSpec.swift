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

import Quick
import Nimble
import WebStatsCommons

class DateUtilSpec: QuickSpec {
    func dateWithDay(day:Int, hour:Int = 0, minute:Int = 0, second:Int = 0) -> NSDate {
        return  NSCalendar.currentCalendar().dateWithEra(
            1, year: 2015, month: 5, day: day, hour: hour,
            minute: minute, second: second, nanosecond: 0)!
    }
    func intervalFrom(startDay: Int, to endDay:Int) -> Interval {
        return Interval(
            startDate: dateWithDay(startDay, hour: 0, minute: 0, second: 0),
            endDate: dateWithDay(endDay, hour: 23, minute: 59, second: 59))
    }
    override func spec() {
        describe("DateUtil") {
            let dateUtil = DateUtil()
            let calendar = NSCalendar.currentCalendar()
            let monday = self.dateWithDay(4)
            
            it("correctly finds the last Monday") {
                let wednesday = self.dateWithDay(6)
                
                expect(dateUtil.lastMondayFrom(wednesday)) == monday
            }
            it("recognizes the given date as the last Monday if it is a Monday") {
                expect(dateUtil.lastMondayFrom(monday)) == monday
            }
            it("creates the start time for a day") {
                expect(dateUtil.dayStart(self.dateWithDay(2, hour: 10, minute: 3, second: 2))) ==
                    self.dateWithDay(2, hour: 0, minute: 0, second: 0)

            }
            it("creates the end time for a day") {
                expect(dateUtil.dayEnd(self.dateWithDay(2, hour: 10, minute: 3, second: 2))) ==
                    self.dateWithDay(2, hour: 23, minute: 59, second: 59)
                
            }
            it("creates a time interval with normalized start and end dates") {
                let start = self.dateWithDay(1, hour: 13, minute: 12, second: 14)
                
                expect(dateUtil.intervalStartingOn(start, withNumberOfDays: 4))
                    == self.intervalFrom(1, to: 4)
            }
            it("creates consecutive interval collections") {
                let intervals = [
                    self.intervalFrom(1, to: 2),
                    self.intervalFrom(3, to: 4),
                    self.intervalFrom(5, to: 6)]
                let start = self.dateWithDay(5, hour: 11, minute: 14, second: 0)
                expect(dateUtil.intervalsWithLastIntervalStartingOn(
                    start, intervalLength: 2, intervalCount: 3)) == intervals
            }
            
        }
    }
}
