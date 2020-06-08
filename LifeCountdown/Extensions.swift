//
//  Extensions.swift
//  LifeCountdown
//
//  Created by Ozan Mirza on 8/9/19.
//  Copyright © 2019 Ozan Mirza. All rights reserved.
//

import Foundation
import UIKit

class DateLabel: UILabel {
    var date: Date!
}

extension UIView {
    func removeAllConstraints() {
        var superview = self.superview
        while superview != nil {
            for constraints in (superview?.constraints)! {
                let firstItem = constraints.firstItem as? UIView
                let secondItem = constraints.secondItem as? UIView
                if firstItem != nil || secondItem != nil {
                    if firstItem == self || secondItem == self {
                        superview?.removeConstraints([constraints])
                    }
                }
                superview = superview?.superview
            }
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}
