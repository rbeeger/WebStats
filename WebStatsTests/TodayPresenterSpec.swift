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

class TodayPresenterSpec: QuickSpec {
    override func spec() {
        describe("A presenter") {
            let presenter = TodayPresenter(statsService: StatsServiceMock(), dateUtil: DateUtilMock())
            
            context("before triggering an update") {
                it("has default bar values") {
                    expect(presenter.barValuesView.value) == [0, 0, 0]
                }
                it("has the default max bar value") {
                    expect(presenter.maxValueView.value) == 100
                }
                it("has an empty text listing the statistics values") {
                    expect(presenter.statisticsContentView.value) == ""
                }
                it("has an empty text for the top pages") {
                    expect(presenter.topPagesContentView.value) == ""
                }
            }
            context("after triggering an update") {
                it("has bar values for the current day") {
                    presenter.triggerUpdate().start()
                    expect(presenter.barValuesView.value) == [103, 102, 101]
                }
                it("has a sufficient max bar value") {
                    expect(presenter.maxValueView.value) == 113
                }
                it("has a text listing the statistics values for the current day") {
                    expect(presenter.statisticsContentView.value)
                        == "101 Bounces,  102 Visits, 103 Page Views"
                }
                it("has the top pages for the current day") {
                    expect(presenter.topPagesContentView.value) == "01-01 top page"
                }
            }
        }
        
    }
}
