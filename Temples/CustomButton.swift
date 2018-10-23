//
//  CustomButton.swift
//  Temples
//
//  Created by Peter Iontsev on 2018/10/15.
//  Copyright © 2018 Peter Iontsev. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Make sure to set CustomButton as the class of the UIButton in Identity inspector of storyboard
        // Make sure to set Custom as the type of the UIButton in Attributes inspector of storyboard
        setProperties()
    }
    
    func setProperties() {
        // Set tintColor (only if you want to replace the system default tintColor)
        tintColor = .black
        // Set the border's color
        layer.borderColor = tintColor?.cgColor
        // Set colors for title's states
        setTitleColor(.black, for: .normal)
    }
    override func tintColorDidChange() {
        super.tintColorDidChange()
        // When the tint color is changed by the system (eg when the button appears below the dimmed view of a UIAlertController), we have to manually update border color and title's text color
        layer.borderColor = tintColor?.cgColor
    }
    override func draw(_ rect: CGRect) {
        // Draw the border
        layer.borderWidth = 1
        layer.cornerRadius = 6
        layer.masksToBounds = true
    }
}
