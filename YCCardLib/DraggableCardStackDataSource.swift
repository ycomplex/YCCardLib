//
//  DraggableCardStackDataSource.swift
//  Soapbox
//
//  Created by User on 01/04/2016.
//  Copyright © 2016 YComplex. All rights reserved.
//

import Foundation
import UIKit

public protocol DraggableCardStackDataSource {
    func cardCountForDraggableCardStack(_:DraggableCardStackView) -> Int
    func stackSizeForDraggableCardStack(_:DraggableCardStackView) -> Int
    func cardHeightForDraggableCardStack(_:DraggableCardStackView) -> CGFloat
    func cardWidthForDraggableCardStack(_:DraggableCardStackView) -> CGFloat
    func draggableCardStack(_:DraggableCardStackView, viewForCardAtIndex: Int) -> UIView
    func draggableCardStack(_:DraggableCardStackView, overlayViewForCardAtIndex: Int) -> UIView
    
//    func draggableCardStack(_:DraggableCardStackView, leftButtonInFrame: CGRect) -> UIButton?
//    func draggableCardStack(_:DraggableCardStackView, rightButtonInFrame: CGRect) -> UIButton?
//    func draggableCardStack(_:DraggableCardStackView, centreButtonInFrame: CGRect) -> UIButton?
}
