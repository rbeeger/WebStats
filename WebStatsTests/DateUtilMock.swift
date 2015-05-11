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

public class DateUtilMock:DateUtil {
    private let dateFormatter: NSDateFormatter
    private let nowDate: NSDate
    public override init() {
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d/yy"
        
        nowDate = NSCalendar.currentCalendar().dateWithEra(
            1, year: 2015, month: 5, day: 1, hour: 16, minute: 30, second: 0, nanosecond: 0)!
        super.init()
    }
    
    override public func stringFromDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
    
    public override func now() -> NSDate {
        return nowDate
    }
}

