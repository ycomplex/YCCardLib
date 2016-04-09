//
//  DraggableView.swift
//  Soapbox
//
//  Created by User on 31/03/2016.
//  Copyright © 2016 YComplex. All rights reserved.
//

import Foundation
import UIKit

let ACTION_MARGIN: Float = 120      //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
let SCALE_STRENGTH: Float = 4       //%%% how quickly the card shrinks. Higher = slower shrinking
let SCALE_MAX:Float = 0.93          //%%% upper bar for how much the card shrinks. Higher = shrinks less
let ROTATION_MAX: Float = 1         //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
let ROTATION_STRENGTH: Float = 320  //%%% strength of rotation. Higher = weaker rotation
let ROTATION_ANGLE: Float = 3.14/8  //%%% Higher = stronger rotation angle

public protocol DraggableViewDelegate {
    func cardSwipedLeft(card: UIView) -> Void
    func cardSwipedRight(card: UIView) -> Void
}

public class DraggableView: UIView {
    var delegate: DraggableViewDelegate!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var originPoint: CGPoint!
    var overlayView: OverlayView?
    var xFromCenter: Float!
    var yFromCenter: Float!
    var cardView: UIView!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var dragEnabled:Bool = true
    
    public init(frame: CGRect, view: UIView, overlay: OverlayView?) {
        super.init(frame: frame)
        
        self.setupView()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DraggableView.beingDragged(_:)))
        
        self.addGestureRecognizer(panGestureRecognizer)
        //self.addSubview(information)
        
        view.frame = self.bounds
        view.updateConstraintsIfNeeded()
        self.cardView = view
        self.addSubview(view)
        
        if let overlay = overlay {
            // print("Adding Overlay View")
            let overlayWidth = overlay.frame.width
            let overlayHeight = overlay.frame.height
            overlay.frame = CGRectMake(self.frame.size.width/2-overlayWidth/2, self.frame.size.height/2-overlayHeight/2, overlayWidth, overlayHeight)
            overlayView = overlay// OverlayView(frame: CGRectMake(self.frame.size.width/2-50, self.frame.size.height/2-50, 100, 100))
            overlayView!.alpha = 0.0
            self.addSubview(overlayView!)
        }
        self.clipsToBounds = true
        
        xFromCenter = 0
        yFromCenter = 0
        
        loadViewFromNib()
    }
    
    func updateFrame(newFrame: CGRect) {
        self.frame = newFrame;
        cardView.frame = self.bounds
        //cardView.updateConstraintsIfNeeded()
    }
    
    func setupView() -> Void {
        self.layer.cornerRadius = 4;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeMake(1, 1);
    }
    
    func beingDragged(gestureRecognizer: UIPanGestureRecognizer) -> Void {
        if (dragEnabled) {
            xFromCenter = Float(gestureRecognizer.translationInView(self).x)
            yFromCenter = Float(gestureRecognizer.translationInView(self).y)
            
            switch gestureRecognizer.state {
            case UIGestureRecognizerState.Began:
                self.originPoint = self.center
            case UIGestureRecognizerState.Changed:
                let rotationStrength: Float = min(xFromCenter/ROTATION_STRENGTH, ROTATION_MAX)
                let rotationAngle = ROTATION_ANGLE * rotationStrength
                let scale = max(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)
                
                self.center = CGPointMake(self.originPoint.x + CGFloat(xFromCenter), self.originPoint.y + CGFloat(yFromCenter))
                
                let transform = CGAffineTransformMakeRotation(CGFloat(rotationAngle))
                let scaleTransform = CGAffineTransformScale(transform, CGFloat(scale), CGFloat(scale))
                self.transform = scaleTransform
                self.updateOverlay(CGFloat(xFromCenter))
            case UIGestureRecognizerState.Ended:
                self.afterSwipeAction()
            case UIGestureRecognizerState.Possible:
                fallthrough
            case UIGestureRecognizerState.Cancelled:
                fallthrough
            case UIGestureRecognizerState.Failed:
                fallthrough
            default:
                break
            }
        }
        
    }
    
    func updateOverlay(distance: CGFloat) -> Void {
        if distance > 0 {
            overlayView?.setMode(SBOverlayViewMode.SBOverlayViewModeRight)
        } else {
            overlayView?.setMode(SBOverlayViewMode.SBOverlayViewModeLeft)
        }
        overlayView?.alpha = CGFloat(min(fabsf(Float(distance))/100, 0.4))
    }
    
    func afterSwipeAction() -> Void {
        let floatXFromCenter = Float(xFromCenter)
        if floatXFromCenter > ACTION_MARGIN {
            self.rightAction()
        } else if floatXFromCenter < -ACTION_MARGIN {
            self.leftAction()
        } else {
            UIView.animateWithDuration(0.3, animations: {() -> Void in
                self.center = self.originPoint
                self.transform = CGAffineTransformMakeRotation(0)
                self.overlayView?.alpha = 0 
            })
        }
    }
    
    func rightAction() -> Void {
        let finishPoint: CGPoint = CGPointMake(500, 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animateWithDuration(0.5,
                                   animations: {
                                    self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedRight(cardView)
    }
    
    func leftAction() -> Void {
        let finishPoint: CGPoint = CGPointMake(-500, 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animateWithDuration(0.5,
                                   animations: {
                                    self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(cardView)
    }
    
    func rightClickAction() -> Void {
        let finishPoint = CGPointMake(600, self.center.y)
        UIView.animateWithDuration(0.5,
                                   animations: {
                                    self.center = finishPoint
                                    self.transform = CGAffineTransformMakeRotation(1)
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedRight(cardView)
    }
    
    func leftClickAction() -> Void {
        let finishPoint: CGPoint = CGPointMake(-600, self.center.y)
        UIView.animateWithDuration(0.5,
                                   animations: {
                                    self.center = finishPoint
                                    self.transform = CGAffineTransformMakeRotation(-1)
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(cardView)
    }
    
    func dropOutFromView() -> Void {
        // See http://stackoverflow.com/questions/25050309/swift-random-float-between-0-and-1
        
        let finishPoint = CGPointMake(self.center.x, self.center.y + 500)
        UIView.animateWithDuration(0.5,
                                   animations: {
                                    self.center = finishPoint
                                    self.transform = CGAffineTransformMakeRotation(0.5 + CGFloat(Float(arc4random()) / 0xFFFFFFFF) * ((arc4random_uniform(2) == 0) ? 1.0 : -1.0))
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
    }
    
    func loadViewFromNib() {
    }
}