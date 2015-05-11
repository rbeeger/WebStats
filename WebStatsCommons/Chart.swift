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

import UIKit
import ReactiveCocoa

public class Chart: UIView {
    public let bars: [Bar]
    public let selectedBar = MutableProperty<Bar?>(nil)
    
    public init(barColors:[UIColor], valueColors:[UIColor], orientation: ChartOrientation,
        interactive:Bool) {
            var bars = [Bar]()
            for barColor in barColors {
                let bar = Bar(backgroundColor: barColor, valueColors: valueColors,
                    orientation: orientation)
                selectedBar.producer.start(next: {bar.dim(bar != $0 && $0 != nil)})
                bars.append(bar)
            }
            
            self.bars = bars
            super.init(frame: CGRectZero)
            
            for barContainer in bars {
                self.addSubview(barContainer)
            }
            let layout = Layout(parent: self)
            if let first = bars.first, last = bars.last {
                switch orientation {
                case .Horizontal:
                    layout.stretchVertically(first)
                    layout.alignLeft(first)
                    layout.lineUp(sameHeight: true, sameWidth: true, separatorSpace: 2, views: bars)
                    layout.alignRight(last)
                case .Vertical :
                    layout.stretchHorizontally(first)
                    layout.alignTop(first)
                    layout.stack(sameHeight: true, sameWidth: true, separatorSpace: 2, views: bars)
                    layout.alignBottom(last)
                }
            }
            
            if interactive {
                let recognizer = UITapGestureRecognizer(target: self, action: "tapped:")
                recognizer.numberOfTapsRequired = 1
                recognizer.numberOfTouchesRequired = 1
                addGestureRecognizer(recognizer)
            }
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapped(recognizer:UITapGestureRecognizer) {
        let location = recognizer.locationInView(self)
        for bar in bars {
            if bar.frame.contains(location) {
                selectedBar.value = bar
                break
            }
        }
    }
}
