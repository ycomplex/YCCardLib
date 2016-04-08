//
//  CustomViewDelegate.swift
//  Soapbox
//
//  Created by User on 02/04/2016.
//  Copyright © 2016 YComplex. All rights reserved.
//

import Foundation

protocol CustomCardViewDelegate {
    func focus(_:CustomCardView) -> Void
    func unfocus(_:CustomCardView) -> Void
}
