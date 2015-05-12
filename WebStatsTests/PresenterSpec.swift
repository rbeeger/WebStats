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
import WebStats

class PresenterSpec: QuickSpec {
    override func spec() {
        describe("A presenter") {
            let presenter = Presenter(statsService: StatsServiceMock(), dateUtil: DateUtilMock())
            
            context("fetches statistics for the last 7 days after being created and") {
                it("has the statistics values for them ready") {
                    expect(presenter.barValueViews[0].value) == [103, 102, 101]
                    expect(presenter.barValueViews[1].value) == [203, 202, 201]
                    expect(presenter.barValueViews[2].value) == [303, 302, 301]
                    expect(presenter.barValueViews[3].value) == [403, 402, 401]
                    expect(presenter.barValueViews[4].value) == [503, 502, 501]
                    expect(presenter.barValueViews[5].value) == [603, 602, 601]
                    expect(presenter.barValueViews[6].value) == [703, 702, 701]
                }
                it("has an interval text matching the shown time period") {
                    expect(presenter.intervalHeaderView.value) == "5/1/15 - 5/7/15"
                }
                it("has the top pages for the shown time period") {
                    expect(presenter.topPagesContentView.value) == "01-07 top page"
                }
                it("has the top referrers for the shown time period") {
                    expect(presenter.topReferrersContentView.value) == "01-07 top referrer"
                }
                it("has a sufficient max bar value") {
                    expect(presenter.maxValueView.value) == 773
                }
                it("has the sum of the page views of the shown days") {
                    expect(presenter.pageViewsContentView.value) == "2821"
                }
                it("has the sum of the visits of the shown days") {
                    expect(presenter.visitsContentView.value) == "2814"
                }
                it("has the sum of the bounces of the shown days") {
                    expect(presenter.bouncesContentView.value) == "2807"
                }
            }
            context("after changing to the 7 weeks overview") {
                it("has the statistics values for them ready") {
                    presenter.currentStatisticsIntervalIndex = 1
                    expect(presenter.barValueViews[0].value) == [1103, 1102, 1101]
                    expect(presenter.barValueViews[1].value) == [1203, 1202, 1201]
                    expect(presenter.barValueViews[2].value) == [1303, 1302, 1301]
                    expect(presenter.barValueViews[3].value) == [1403, 1402, 1401]
                    expect(presenter.barValueViews[4].value) == [1503, 1502, 1501]
                    expect(presenter.barValueViews[5].value) == [1603, 1602, 1601]
                    expect(presenter.barValueViews[6].value) == [1703, 1702, 1701]
                }
                it("has an interval text matching the shown time period") {
                    expect(presenter.intervalHeaderView.value) == "5/1/15 - 5/14/15"
                }
                it("has the top pages for the shown time period") {
                    expect(presenter.topPagesContentView.value) == "01-14 top page"
                }
                it("has the top referrers for the shown time period") {
                    expect(presenter.topReferrersContentView.value) == "01-14 top referrer"
                }
                it("has a sufficient max bar value") {
                    expect(presenter.maxValueView.value) == 1873
                }
                it("has the sum of the page views of the shown weeks") {
                    expect(presenter.pageViewsContentView.value) == "9821"
                }
                it("has the sum of the visits of the shown weeks") {
                    expect(presenter.visitsContentView.value) == "9814"
                }
                it("has the sum of the bounces of the shown weeks") {
                    expect(presenter.bouncesContentView.value) == "9807"
                }
            }
            context("after selecting a chart bar") {
                it("has an interval text matching the time period of the selected bar") {
                    presenter.selectedBarIndex.value = 1
                    expect(presenter.intervalHeaderView.value) == "5/3/15 - 5/4/15"
                }
                it("has the top pages for the time period of the selected bar") {
                    expect(presenter.topPagesContentView.value) == "03-04 top page"
                }
                it("has the top referrers for the time period of the selected bar") {
                    expect(presenter.topReferrersContentView.value) == "03-04 top referrer"
                }
                it("has the number of page views of the selected bar") {
                    expect(presenter.pageViewsContentView.value) == "1203"
                }
                it("has the number of visits of the selected bar") {
                    expect(presenter.visitsContentView.value) == "1202"
                }
                it("has the number of bounces of the selected bar") {
                    expect(presenter.bouncesContentView.value) == "1201"
                }
            }
        }
    }
}
