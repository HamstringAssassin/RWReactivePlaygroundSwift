//
//  UIScreen+Extensions.swift
//  RWReactivePlaygroundSwift
//
//  Created by Alan O'Connor on 16/04/2017.
//  Copyright © 2017 codebiscuits. All rights reserved.
//

import UIKit

extension UIScreen {
    class func percentage(multiplier: CGFloat) -> CGFloat {
        return round(main.bounds.size.width * CGFloat(multiplier))
    }
}
