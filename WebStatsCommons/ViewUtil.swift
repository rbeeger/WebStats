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

public struct ViewUtil {
    public enum Context {
        case App
        case Widget
    }
    
    public enum LabelType {
        case IntervalDisplay
        case Header
        case Content
        
        public func fontInContext(context: Context) -> UIFont {
            return LabelType.fonts[self]![context]!
        }
        public func textColorInContext(context: Context) -> UIColor {
            return LabelType.textColors[self]![context]!
        }
        
        private static let fonts = [
            LabelType.IntervalDisplay: [
                Context.App: UIFont.boldSystemFontOfSize(20),
                Context.Widget: UIFont.boldSystemFontOfSize(16)],
            LabelType.Header: [
                Context.App: UIFont.boldSystemFontOfSize(18),
                Context.Widget: UIFont.boldSystemFontOfSize(14)],
            LabelType.Content: [
                Context.App: UIFont.systemFontOfSize(16),
                Context.Widget: UIFont.systemFontOfSize(13)]
        ]
        private static let textColors = [
            LabelType.IntervalDisplay: [
                Context.App: UIColor(red:0, green:0.538, blue:0.761, alpha:1),
                Context.Widget: UIColor.whiteColor()],
            LabelType.Header: [
                Context.App: UIColor(red:0, green:0.599, blue:0.932, alpha:1),
                Context.Widget: UIColor.whiteColor()],
            LabelType.Content: [
                Context.App: UIColor(red:0.211, green:0.223, blue:0.227, alpha:1),
                Context.Widget: UIColor(red:0.8, green:0.8, blue:0.8, alpha:1)]
        ]
    }
    
    public static let appBackgroundColor = UIColor.whiteColor()
    public static let widgetBackgroundColor = UIColor.clearColor()
    
    public static let oddContainerColor = UIColor(red:0.568, green:0.626, blue:0.645, alpha:1)
    public static let evenContainerColor = UIColor(red:0.383, green:0.458, blue:0.484, alpha:1)
    
    public static let pageViewsColor = UIColor(red:0.5, green:0.782, blue:0.877, alpha:1)
    public static let visitsColor = UIColor(red:0.128, green:0.436, blue:0.539, alpha:1)
    public static let bouncesColor = UIColor(red:0.027, green:0.226, blue:0.292, alpha:1)
    
    public static let chartBarDimColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    
    public static let controlTintColor = UIColor(red:0, green:0.538, blue:0.761, alpha:1)
    
    public static let separatorColor = UIColor(red:0, green:0.538, blue:0.761, alpha:1)
    
    
    public static func createLabelOfType<T:PropertyType where T.Value == String>(
        labelType:LabelType, inContext context:Context, withSource source:T) -> UILabel {
        let label = UILabel(frame: CGRectZero)
        label.font = labelType.fontInContext(context)
        label.textColor = labelType.textColorInContext(context)
        label.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        label.setContentHuggingPriority(1000, forAxis: .Vertical)
            label.numberOfLines = 0
        source.producer.start(next: {label.text = $0})
        return label
    }
}
