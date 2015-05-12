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
import UIKit

public class Layout {
    private unowned let parent:UIView
    
    public init(parent:UIView) {
        self.parent = parent
    }
    
    public func stretchHorizontally(element:UIView, margin:CGFloat = 0.0) {
        alignLeft(element, margin: margin)
        alignRight(element, margin: margin)
    }
    
    public func stretchVertically(element:UIView, margin:CGFloat = 0.0) {
        alignTop(element, margin: margin)
        alignBottom(element, margin: margin)
    }
    
    public func alignTop(element:UIView, margin:CGFloat = 0.0, identifier:String? = nil) {
        align(element, attribute: .Top, margin: margin, identifier: identifier)
    }
    
    public func alignBottom(element:UIView, margin:CGFloat = 0.0, identifier:String? = nil) {
        align(element, attribute: .Bottom, margin: -margin, identifier: identifier)
    }
    
    public func alignLeft(element:UIView, margin:CGFloat = 0.0, identifier:String? = nil) {
        align(element, attribute: .Left, margin: margin, identifier: identifier)
    }
    
    public func alignRight(element:UIView, margin:CGFloat = 0.0, identifier:String? = nil) {
        align(element, attribute: .Right, margin: -margin, identifier: identifier)
    }
    
    public func align(element:UIView, attribute:NSLayoutAttribute, margin:CGFloat = 0.0,
        identifier:String? = nil) {
            element.setTranslatesAutoresizingMaskIntoConstraints(false)
            let constraint = NSLayoutConstraint(
                item: element,
                attribute: attribute,
                relatedBy: .Equal,
                toItem: parent,
                attribute: attribute,
                multiplier: 1.0,
                constant: margin)
            if let ident = identifier {
                constraint.identifier = ident
            }
            parent.addConstraint(constraint)
    }
    
    
    
    public func lineUp(sameHeight:Bool = true, sameWidth:Bool = false,
        streched:Bool = false, strechMargin: CGFloat = 0, separatorSpace:CGFloat = 8,
        views:UIView...) {
            lineUp(sameHeight: sameHeight, sameWidth: sameWidth, streched:streched, strechMargin: strechMargin,
                separatorSpace: separatorSpace, views: views)
    }
    
    public func lineUp(sameHeight:Bool = true, sameWidth:Bool = false,
        streched:Bool = false, strechMargin: CGFloat = 0, separatorSpace:CGFloat = 8,
        views:[UIView]) {
            var lastView:UIView?
            for view in views {
                view.setTranslatesAutoresizingMaskIntoConstraints(false)
                if let last = lastView {
                    put(view, right: last, separatorSpace: separatorSpace)
                    parent.addConstraint(NSLayoutConstraint(
                        item: view,
                        attribute: .CenterY,
                        relatedBy: .Equal,
                        toItem: last,
                        attribute: .CenterY,
                        multiplier: 1.0,
                        constant: 0.0))
                    if sameHeight {
                        parent.addConstraint(NSLayoutConstraint(
                            item: view,
                            attribute: .Height,
                            relatedBy: .Equal,
                            toItem: last,
                            attribute: .Height,
                            multiplier: 1.0,
                            constant: 0.0))
                    }
                    if sameWidth {
                        parent.addConstraint(NSLayoutConstraint(
                            item: view,
                            attribute: .Width,
                            relatedBy: .Equal,
                            toItem: last,
                            attribute: .Width,
                            multiplier: 1.0,
                            constant: 0.0))
                    }
                }
                lastView = view
            }
            if let first = views.first, last = views.last where streched {
                alignLeft(first, margin: strechMargin)
                alignRight(last, margin: strechMargin)
            }
    }
    
    public func stack(sameHeight:Bool = true, sameWidth:Bool = false, separatorSpace:CGFloat = 8,
        views:UIView...) {
            stack(sameHeight: sameHeight, separatorSpace: separatorSpace, views: views)
    }
    
    public func stack(sameHeight:Bool = false, sameWidth:Bool = true, separatorSpace:CGFloat = 8,
        views:[UIView]) {
            var lastView:UIView?
            for view in views {
                view.setTranslatesAutoresizingMaskIntoConstraints(false)
                if let last = lastView {
                    put(view, below: last, separatorSpace: separatorSpace)
                    parent.addConstraint(NSLayoutConstraint(
                        item: view,
                        attribute: .CenterX,
                        relatedBy: .Equal,
                        toItem: last,
                        attribute: .CenterX,
                        multiplier: 1.0,
                        constant: 0.0))
                    if sameHeight {
                        parent.addConstraint(NSLayoutConstraint(
                            item: view,
                            attribute: .Height,
                            relatedBy: .Equal,
                            toItem: last,
                            attribute: .Height,
                            multiplier: 1.0,
                            constant: 0.0))
                    }
                    if sameWidth {
                        parent.addConstraint(NSLayoutConstraint(
                            item: view,
                            attribute: .Width,
                            relatedBy: .Equal,
                            toItem: last,
                            attribute: .Width,
                            multiplier: 1.0,
                            constant: 0.0))
                    }
                }
                lastView = view
            }
    }
    
    
    public func centerHorizontally(element:UIView, identifier:String? = nil) {
        element.setTranslatesAutoresizingMaskIntoConstraints(false)
        let constraint = NSLayoutConstraint(
            item: element,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: parent,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0)
        if let ident = identifier {
            constraint.identifier = ident
        }
        parent.addConstraint(constraint)
    }
    
    public func centerVertically(element:UIView, identifier:String? = nil) {
        element.setTranslatesAutoresizingMaskIntoConstraints(false)
        let constraint = NSLayoutConstraint(
            item: element,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: parent,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0)
        if let ident = identifier {
            constraint.identifier = ident
        }
        parent.addConstraint(constraint)
    }
    
    public func center(element:UIView) {
        centerHorizontally(element)
        centerVertically(element)
    }
    
    public func setHeight(element:UIView, height:CGFloat, identifier:String? = nil) {
        element.setTranslatesAutoresizingMaskIntoConstraints(false)
        let constraint = NSLayoutConstraint(
            item: element,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: height)
        if let ident = identifier {
            constraint.identifier = ident
        }
        parent.addConstraint(constraint)
    }
    
    public func setWidth(element:UIView, width:CGFloat, identifier:String? = nil) {
        element.setTranslatesAutoresizingMaskIntoConstraints(false)
        let constraint = NSLayoutConstraint(
            item: element,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: width)
        if let ident = identifier {
            constraint.identifier = ident
        }
        parent.addConstraint(constraint)
    }
    
    public func put(element:UIView, above related:UIView, separatorSpace:CGFloat = 8,
        identifier:String? = nil) {
            element.setTranslatesAutoresizingMaskIntoConstraints(false)
            let constraint = NSLayoutConstraint(
                item: element,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: related,
                attribute: .Top,
                multiplier: 1.0,
                constant: -separatorSpace)
            if let ident = identifier {
                constraint.identifier = ident
            }
            parent.addConstraint(constraint)
    }
    
    public func put(element:UIView, below related:UIView, separatorSpace:CGFloat = 8,
        identifier:String? = nil) {
            element.setTranslatesAutoresizingMaskIntoConstraints(false)
            let constraint = NSLayoutConstraint(
                item: element,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: related,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: separatorSpace)
            if let ident = identifier {
                constraint.identifier = ident
            }
            parent.addConstraint(constraint)
    }
    
    public func put(element:UIView, left related:UIView, separatorSpace:CGFloat = 8,
        identifier:String? = nil) {
            element.setTranslatesAutoresizingMaskIntoConstraints(false)
            let constraint = NSLayoutConstraint(
                item: element,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: related,
                attribute: .Left,
                multiplier: 1.0,
                constant: -separatorSpace)
            if let ident = identifier {
                constraint.identifier = ident
            }
            parent.addConstraint(constraint)
    }
    
    public func put(element:UIView, right related:UIView, separatorSpace:CGFloat = 8,
        identifier:String? = nil) {
            element.setTranslatesAutoresizingMaskIntoConstraints(false)
            let constraint = NSLayoutConstraint(
                item: element,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: related,
                attribute: .Right,
                multiplier: 1.0,
                constant: separatorSpace)
            if let ident = identifier {
                constraint.identifier = ident
            }
            parent.addConstraint(constraint)
    }
    
    public func constraintWithIdentifier(identifier:String) -> NSLayoutConstraint? {
        for contstraintAny in parent.constraints() {
            if let constraint = contstraintAny as? NSLayoutConstraint, constId = constraint.identifier {
                if constId == identifier {
                    return constraint
                }
            }
        }
        return nil
    }
    
    public func removeconstraintWithIdentifier(identifier:String) {
        if let constraint = constraintWithIdentifier(identifier) {
            parent.removeConstraint(constraint)
        }
    }
    
    
}
