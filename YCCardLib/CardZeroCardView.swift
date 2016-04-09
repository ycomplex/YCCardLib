//
//  TaskZeroView.swift
//  Soapbox
//
//  Created by User on 05/04/2016.
//  Copyright © 2016 YComplex. All rights reserved.
//

import UIKit

public class CardZeroCardView: CustomCardView {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    
    let imageCount:UInt32 = 5
    
    var title = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var message = "" {
        didSet {
            self.messageTextView.selectable = true
            self.messageTextView.text = message
            self.messageTextView.selectable = false
        }
    }
    
    var imageName:String? {
        didSet {
            if (imageName != nil) {
                image.image = UIImage(named: imageName!)
            } else {
                image.image = nil
            }
        }
    }
    
    override func getNibName() -> String {
        return "TaskZeroCardView"
    }
    
    override func initProperties() {
        super.initProperties()
        let randomImage = arc4random_uniform(imageCount) + 1
        self.imageName = "zero-\(randomImage)"
        self.title = "Task Zero"
        self.message = "No active tasks left!\nTake a break, have some fun."
    }

}
