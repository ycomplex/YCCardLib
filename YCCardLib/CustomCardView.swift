//
//  CustomView.swift
//  TinderSwipeCardsSwift
//
//  Created by User on 31/03/2016.
//  Copyright © 2016 YComplex. All rights reserved.
//  See http://supereasyapps.com/blog/2014/12/15/create-an-ibdesignable-uiview-subclass-with-code-from-an-xib-file-in-xcode-6
//

import UIKit

public class CustomCardView: UIView {
    
    // Our custom view from the XIB file
    var view: UIView!
    var focusStateUnfocused: Bool = true
    
    
    public override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
        initProperties()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
        initProperties()
    }
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: getNibName(), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    func getNibName() -> String {
        return "NotImplementedCardView"
    }
    
    func initProperties() -> Void {
        self.view.clipsToBounds = true
        self.clipsToBounds = true
        self.layer.borderColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1.0).CGColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowOffset = CGSizeMake(1, 1);
    }
}
