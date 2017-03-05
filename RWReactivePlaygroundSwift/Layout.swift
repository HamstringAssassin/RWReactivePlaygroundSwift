//
//  Layout.swift
//  RWReactivePlaygroundSwift
//
//  Created by Alan O'Connor on 02/02/2017.
//  Copyright © 2017 codebiscuits. All rights reserved.
//

import Foundation
import PureLayout

class Layout{
    
    class Grid{
        /// 20% small / 6% large
        static let column: CGFloat = UIScreen.percentage(multiplier: UIView.compact ? 0.20 : 0.06)
        /// 4% small / 2% large
        static let margin: CGFloat = UIScreen.percentage(multiplier: UIView.compact ? 0.04 : 0.02)
        /// 4% small / 3% large
        static let gutter: CGFloat = UIScreen.percentage(multiplier: UIView.compact ? 0.04 : 0.03)
    }
    
    /// Vertical spacing between elements
    enum Leading: CGFloat{
        /// 13pts
        case Small  = 13
        /// 25pts
        case Medium = 25
        /// 45pts
        case Large  = 45
        
        var points: CGFloat{
            return rawValue
        }
    }
    
    /// Height of specific UI element types
    class ElementHeight{
        /// 60pts
        static let CTAButton: CGFloat = 60
        /// 45pts
        static let TabButton: CGFloat = 45
        /// 60pts
        static let TextField: CGFloat = 60
        
        //aprx 116
        static let ProfileImageViewSmall: CGFloat = Layout.columns(cols: 2)
        
        //aprx 232
        static let ProfileImageViewLarge: CGFloat = Layout.columns(cols: 2) + Layout.margins(margins: 2)
    }
    
    /// The width of the specified cols + (cols-1) margins
    class func columns(cols: Int) -> CGFloat{
        return round((Grid.column * CGFloat(cols)) + (Grid.margin * (CGFloat(cols) - 1)))
    }
    
    // the width of a specified number of margins
    class func margins(margins: Int) -> CGFloat {
        return round(Grid.margin * CGFloat(margins))
    }
    
    // the width of a specified number of margins
    class func cardWidth(columns: Int) -> CGFloat {
        return Layout.columns(cols: columns) + margins(margins: 2)
    }
    
    
    class var fullWidth: CGFloat{
        return UIScreen.percentage(multiplier: 1.0)
    }
    
}

// PureLayout Additions
extension UIView{
    
    func autoPinEdge(edge: ALEdge, toEdge: ALEdge, ofView otherView: UIView, withLeading leading: Layout.Leading) -> NSLayoutConstraint{
        return autoPinEdge(edge, to: toEdge, of: otherView, withOffset: -leading.points)
    }
    
    func autoPinEdgeToSuperviewEdge(edge: ALEdge, withLeading leading: Layout.Leading) -> NSLayoutConstraint{
        return autoPinEdge(toSuperviewEdge: edge, withInset: leading.points)
    }
    
    func autoPinEdgeToSuperviewEdge(edge: ALEdge, withLeading leading: Layout.Leading, scale: CGFloat) -> NSLayoutConstraint{
        return autoPinEdge(toSuperviewEdge: edge, withInset: leading.points * scale)
    }
    
    func autoPinEdgeToSuperviewLayoutMargin(edge: ALEdge) -> NSLayoutConstraint{
        return autoPinEdge(toSuperviewEdge: edge, withInset: Layout.Grid.margin)
    }
}


// Current device
extension UIDevice{
    
    enum SizeClass{
        case small
        case medium
        case large
    }
    
    class var large: Bool{
        return sizeClass == .large
    }
    
    class var medium: Bool{
        return sizeClass == .large
    }
    
    class var small: Bool{
        return sizeClass == .large
    }
    
    class var sizeClass: SizeClass{
        let screenLength = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
        switch (UI_USER_INTERFACE_IDIOM(), screenLength == 736.0){
        case (.pad,    _):     return .large
        case (.phone,  true):  return .medium
        default:               return .small
        }
    }
    
    class func isIn(sizes: [SizeClass]) -> Bool{
        for size in sizes{
            if UIDevice.sizeClass == size{
                return true
            }
        }
        return false
    }
}

extension UIScreen {
    
    class func percentage(multiplier: CGFloat) -> CGFloat {
        return round(main.bounds.size.width * CGFloat(multiplier))
    }
}


extension UIView {
    
    enum LayoutClass{
        case Small
        case Medium
        case Large
    }
    
    class var useCompactLayout: Bool {
        return compact
    }
    
    class var compact: Bool {
        return UI_USER_INTERFACE_IDIOM() == .phone
    }
    
    class var layoutClass: LayoutClass{
        switch (UI_USER_INTERFACE_IDIOM(), _maxScreenLength == 736.0){
        case (.pad,    _):     return .Large
        case (.phone,  true):  return .Medium
        default:               return .Small
        }
    }
}

private var _maxScreenLength: CGFloat{
    return max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
}
