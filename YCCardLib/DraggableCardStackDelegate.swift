//
//  DraggableCardStackDelegate.swift
//  Soapbox
//
//  Created by User on 01/04/2016.
//  Copyright © 2016 YComplex. All rights reserved.
//

import Foundation
import UIKit

enum CardSwipeMode {
    case CardSwipeModeLeft
    case CardSwipeModeRight
}

protocol DraggableCardStackDelegate {
    func draggableCardStack(_:DraggableCardStackView, displayingCard: UIView, atIndex: Int) -> Void
    func draggableCardStack(_:DraggableCardStackView, swipedCard: UIView, atIndex: Int, to: CardSwipeMode) -> Void
}
