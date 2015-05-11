# WebStats – a simple example project in Swift
I originally created this as a demonstration of my skills as an iOS developer for a job application but then thought that it might be useful as an example for other people struggling around with Swift, ReactiveCocoa or generally with finding a good architecture for testable iOS apps.

## What this example contains
This example contains an app and an accompanying today widget

The app shows fake web site statistics for an unnamed website. You can choose whether you want to see the daily statistics for the last 7 days or the weekly statistics for the last 7 weeks. At the top there is an animated bar chart showing the page views, visits and bounces of the last 7 days or weeks. The chart is entirely build and animated using AutoLayout.

Below the chart is a textual representation summing up all the statistic values of the whole shown period. Here also the top pages and top referrers for that period are displayed.

Tapping on one of the bars of the chart, highlights it and the textual display now shows the data for the time period of the selected bar.

The today widget shows a bar chart containing one bar showing the statistics values for today. Below that the top pages for that day are shown.

## The architecture and its testability
In both cases – app and widget – the view controllers compose the UI and bind it via [ReactiveCocoa 3](https://github.com/ReactiveCocoa/ReactiveCocoa) to a *presenter* which provides the statistics data in a format directly usable by the UI. The presenter uses a *service* which generates fake data but would normally call some web service to obtain the requested data. Here also ReactiveCocoa is used to enable the presenter to asynchronously react once a request has been fulfilled. 

The way the view controller and presenter interact is an adaptation of the patterns [Model View ViewModel](https://en.wikipedia.org/wiki/Model_View_ViewModel) and [Model View Presenter](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter) to the usage in a CocoaTouch app.

As all the logic of the app and the widget is contained in their presenters and the service encapsulates the part calling remote services, the presenter can easily be tested which is demonstrated by the provided tests. The tests are written using the BDD-style testing frameworks [Quick](https://github.com/Quick/Quick) and [Nimble](https://github.com/Quick/Nimble).

## Used third-party frameworks
* [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)
* [antitypical/Result](https://github.com/antitypical/Result) as a dependency of ReactiveCocoa
* [robrix/Box](https://github.com/robrix/Box/releases) as a dependency of ReactiveCocoa
* [Quick](https://github.com/Quick/Quick) 
* [Nimble](https://github.com/Quick/Nimble)

## Known issues
* There is no error handling. When working with remote services you need to take into account that those may not be available or that internet access is for some reason currently not available. ReactiveCocoa provides the possibility to send errors. Those are neither faked in the service nor are the presenters prepared to handle them.
* The app should refresh the statistics values for today periodically. Now they are only fetched when the app is started or you change between the daily and weekly displays.
* This project should use [Carthage](https://github.com/Carthage/Carthage) to fetch and build all dependencies, but because of [Carthage #447](https://github.com/Carthage/Carthage/issues/447) this is currently not possible. So the binary releases provided by the frameworks are used.
* The linker complains that it is not safe to use ReactiveCocoa in an app extension because ReactiveCocoa is not build with the needed restrictions to be considered safe by the linker (see [ReactiveCocoa #1990](https://github.com/ReactiveCocoa/ReactiveCocoa/issues/1990)) 

## License 
All the code contained in this project is licensed under the MIT license. See [LICENSE.md](LICENSE.md) for further information.
