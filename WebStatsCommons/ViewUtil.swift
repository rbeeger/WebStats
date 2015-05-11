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
    public enum Context: Int {
        case App    = 0
        case Widget = 1
        
        public var headerFont:UIFont {
            return Context.headerFonts[self.rawValue]
        }
        public var contentFont: UIFont {
            return Context.contentFonts[self.rawValue]
        }
        
        public var headerTextColor: UIColor {
            return Context.headerTextColors[self.rawValue]
        }
        public var contentTextColor: UIColor {
            return Context.contentTextColors[self.rawValue]
        }
        
        private static let headerFonts = [
            UIFont.boldSystemFontOfSize(18), UIFont.boldSystemFontOfSize(14)]
        private static let contentFonts = [
            UIFont.boldSystemFontOfSize(16), UIFont.boldSystemFontOfSize(13)]
        private static let contentTextColors = [
            UIColor(red:0.211, green:0.223, blue:0.227, alpha:1),
            UIColor(red:0.8, green:0.8, blue:0.8, alpha:1)]
        private static let headerTextColors = [
            UIColor(red:0, green:0.599, blue:0.932, alpha:1),
            UIColor.whiteColor()]
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
    
    
    public static func createHeaderLabelWithContext(context: Context) -> UILabel {
        let label = UILabel(frame: CGRectZero)
        label.font = context.headerFont
        label.textColor = context.headerTextColor
        label.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        label.setContentHuggingPriority(1000, forAxis: .Vertical)
        return label
    }
    
    public static func createContentLabelWithContext(context: Context,
        andContentSource contentSource:PropertyOf<String>) -> UILabel {
            let label = UILabel(frame: CGRectZero)
            label.font = context.contentFont
            label.textColor = context.contentTextColor
            label.numberOfLines = 0
            label.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
            label.setContentHuggingPriority(1000, forAxis: .Vertical)
            contentSource.producer.start(next: {label.text = $0})
            
            return label
    }
}
