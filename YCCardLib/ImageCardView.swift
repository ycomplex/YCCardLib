//
//  ImageView.swift
//  Soapbox
//
//  Created by User on 02/04/2016.
//  Copyright © 2016 YComplex. All rights reserved.
//
import UIKit

class ImageCardView: CustomCardView {
    @IBOutlet weak var image: UIImageView!
    
    var imageName:String? {
        didSet {
            image.contentMode = .ScaleAspectFill
            if (imageName != nil) {
                image.image = UIImage(named: imageName!)
            }
        }
    }
    
    override func getNibName() -> String {
        return "ImageCardView"
    }
}
