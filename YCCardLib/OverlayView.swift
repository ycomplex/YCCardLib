//
//  OverlayView.swift
//  Soapbox
//
//  Created by User on 31/03/2016.
//  Copyright © 2016 YComplex. All rights reserved.
//

import Foundation
import UIKit

enum SBOverlayViewMode {
    case SBOverlayViewModeLeft
    case SBOverlayViewModeRight
}

class OverlayView: UIView{
    var _mode: SBOverlayViewMode! = SBOverlayViewMode.SBOverlayViewModeLeft
    // var imageView: UIImageView!
    var iconLabel: UILabel!, messageLabel: UILabel!
    
    var leftMessage: String?
    var rightMessage: String?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect,
         leftMessage: String?,
         rightMessage: String?) {
        self.leftMessage = leftMessage
        self.rightMessage = rightMessage

        super.init(frame: frame)
        
        //self.backgroundColor = UIColor.whiteColor()
        // imageView = UIImageView(image: UIImage(named: "cross"))
        messageLabel = UILabel(frame: self.bounds)
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.textAlignment = .Center
        self.addSubview(messageLabel)
        updateModeContent()
    }
    
    func setMode(mode: SBOverlayViewMode) -> Void {
        if _mode == mode {
            return
        }
        _mode = mode
        updateModeContent()
    }
    
    func updateModeContent() {
        if _mode == SBOverlayViewMode.SBOverlayViewModeLeft {
            if let message = self.leftMessage {
                messageLabel.text = message
            } else {
                messageLabel.text = ""
            }
        } else {
            if let message = self.rightMessage {
                messageLabel.text = message
            } else {
                messageLabel.text = ""
            }
        }
        
    }
}