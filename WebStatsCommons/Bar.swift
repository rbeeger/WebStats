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

public class Bar: UIView {
    public var maxValue = 100 {
        didSet {
            updateBars()
        }
    }
    
    public var values = [0, 0, 0] {
        didSet {
            updateBars()
        }
    }
    private class ValueDisplay {
        let valueDisplayView: UIView
        let fillConstraint:NSLayoutConstraint
        var value: Int
        
        init(valueDisplayView: UIView, fillConstraint:NSLayoutConstraint, value: Int) {
            self.valueDisplayView = valueDisplayView
            self.fillConstraint = fillConstraint
            self.value = value
        }
    }
    private var valueDisplays = [ValueDisplay]()
    private weak var dimmer:UIView?
    private let orientation: ChartOrientation
    

    init(backgroundColor:UIColor, valueColors:[UIColor], orientation: ChartOrientation) {
        self.orientation = orientation
        super.init(frame: CGRectZero)
        
        self.backgroundColor = backgroundColor
        let layout = Layout(parent: self)
        
        for valueColor in valueColors {
            let valueDisplayView = UIView(frame: CGRectZero)
            valueDisplayView.backgroundColor = valueColor
            addSubview(valueDisplayView)
            
            let fillConstraint: NSLayoutConstraint
            switch orientation {
            case .Horizontal:
                layout.stretchHorizontally(valueDisplayView, margin: 0)
                layout.alignBottom(valueDisplayView, margin: 0)
                fillConstraint = NSLayoutConstraint(
                    item: valueDisplayView,
                    attribute: .Top,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .Bottom,
                    multiplier: 1.0,
                    constant: 0)
            case .Vertical:
                layout.stretchVertically(valueDisplayView, margin: 0)
                layout.alignLeft(valueDisplayView, margin: 0)
                fillConstraint = NSLayoutConstraint(
                    item: valueDisplayView,
                    attribute: .Right,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .Left,
                    multiplier: 1.0,
                    constant: 0)
            }
            self.addConstraint(fillConstraint)
            
            valueDisplays.append(ValueDisplay(valueDisplayView: valueDisplayView,
                fillConstraint: fillConstraint, value: 0))
        }
        
        let dimmer = UIView()
        dimmer.backgroundColor = ViewUtil.chartBarDimColor
        addSubview(dimmer)
        layout.stretchHorizontally(dimmer)
        layout.stretchVertically(dimmer)
        dimmer.hidden = true
        
        self.dimmer = dimmer
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dim(dim:Bool) {
        dimmer?.hidden = !dim
    }
    
    private func updateBars() {
        precondition(count(values) == count(valueDisplays),
            "need to update with the matching number of values")
        
        let maxBarLength = orientation == .Horizontal ? self.bounds.height : self.bounds.width
        
        for zipped in zip(valueDisplays, values) {
            let valueDisplay = zipped.0
            let value = zipped.1
            var barLength = maxBarLength * min(1.0, CGFloat(value) / CGFloat(maxValue))
            if orientation == .Horizontal {
                barLength = -barLength
            }
            valueDisplay.value = value
            valueDisplay.fillConstraint.constant = barLength
        }
        UIView.animateWithDuration(3) {
            self.layoutIfNeeded()
        }
    }
    
    
    
}
