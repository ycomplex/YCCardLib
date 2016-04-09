//
//  ExampleCardView.swift
//  Soapbox
//
//  Created by User on 02/04/2016.
//  Copyright © 2016 YComplex. All rights reserved.
//

import UIKit

public class ExampleCardView: CustomCardView {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
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
        return "ExampleCardView"
    }
}
