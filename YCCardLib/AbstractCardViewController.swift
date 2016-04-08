//
//  AbstractCardViewController.swift
//  Tasks
//
//  Created by User on 07/04/2016.
//  Copyright © 2016 YComplex. All rights reserved.
//

import UIKit

class AbstractCardViewController: UIViewController, DraggableCardStackDataSource, DraggableCardStackDelegate {
    
    let CARD_HEIGHT: CGFloat = 400
    let CARD_WIDTH: CGFloat = 290
    let MAX_STACK_SIZE = 5
    
    var parent: AbstractCardViewController?
    var stackView:DraggableCardStackView!
    var dataModel:CardDataModel! {
        didSet {
            refreshDataModel()
            self.stackView.dataSource = self
        }
    }
    var taskZero: Bool = false
    
    var centreButton: UIButton?, leftButton:UIButton?, menuButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        }
        else {
            self.view.backgroundColor = UIColor.blackColor()
        }
        // self.dataModel = DummyDataModel()
        let draggableStackView: DraggableCardStackView = DraggableCardStackView(frame: self.view.frame)
        draggableStackView.delegate = self
        self.stackView = draggableStackView
        self.view.addSubview(draggableStackView)
        self.setupButtons()
        self.setupDataModel()
    }
    
    func setupDataModel() {
//        let app = UIApplication.sharedApplication().delegate as! AppDelegate
//        if (app.dataReady) {
//            dataModelSet()
//        } else {
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AbstractCardViewController.dataModelSet), name: AppDelegate.kDataReadyNotification, object: nil)
//        }
    }
//
//    func dataModelSet() {
//        let app = UIApplication.sharedApplication().delegate as! AppDelegate
//        self.dataModel = app.dataModel
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DraggableCardStackDataSource methods
    
    func cardCountForDraggableCardStack(_:DraggableCardStackView) -> Int
    {
        if (taskZero) {
            return 1
        }
        return dataModel.numberOfItems()
        // return exampleCardLabels.count
    }
    
    func stackSizeForDraggableCardStack(_:DraggableCardStackView) -> Int
    {
        return MAX_STACK_SIZE
    }
    
    func cardHeightForDraggableCardStack(_:DraggableCardStackView) -> CGFloat
    {
        return CARD_HEIGHT
    }
    
    func cardWidthForDraggableCardStack(_:DraggableCardStackView) -> CGFloat
    {
        return CARD_WIDTH
    }
    
    func draggableCardStack(_:DraggableCardStackView, viewForCardAtIndex index: Int) -> UIView
    {
        if (taskZero) {
            return buildTaskZeroView()
        }
        let card = dataModel.elementAt(index)
        return createViewForCard(card)
    }
    
    func createViewForCard(card: CardProtocol?) -> UIView {
        if card?.type == "example" {
            let rCardView = ExampleCardView(frame: CGRectMake(0,0,1,1))
            rCardView.imageName = card!.category
            rCardView.label.text = card!.content
            return rCardView
        } else {
            return CustomCardView(frame: CGRectMake(0,0,1,1))
        }
        
    }
    
    func buildTaskZeroView() -> UIView {
        return CardZeroCardView(frame: CGRectMake(0,0,1,1))
    }
    
    func draggableCardStack(_:DraggableCardStackView, overlayViewForCardAtIndex: Int) -> UIView {
        return OverlayView(frame: CGRectMake(0,0,100,100), leftMessage: nil, rightMessage: nil)
    }
    
    // MARK: - DraggableCardStackDelegate methods
    func draggableCardStack(stackView:DraggableCardStackView, displayingCard: UIView, atIndex index: Int) -> Void
    {
    }
    
    func draggableCardStack(_:DraggableCardStackView, swipedCard: UIView, atIndex index: Int, to: CardSwipeMode) -> Void
    {
        NSLog("Card at index %d swiped", index)
        if !taskZero {
            if (to == CardSwipeMode.CardSwipeModeRight) {
                handleSwipeRightOnCard(swipedCard, atIndex: index)
            } else {
                handleSwipeLeftOnCard(swipedCard, atIndex: index)
            }
        }
        
        if (index >= (dataModel.numberOfItems() - 1)) {
            //self.stackView.undoSwipe(times: 2)
            refreshDataModel()
            self.stackView.reloadCards()
        }
    }
    
    func handleSwipeRightOnCard(card: UIView, atIndex index: Int) {
    }
    
    func handleSwipeLeftOnCard(card: UIView, atIndex index: Int) {
    }
    
    func refreshDataModel() {
        dataModel.refreshItems()
        if (dataModel.numberOfItems() == 0) {
            taskZero = true
        } else {
            taskZero = false
        }
    }
    
    func _dropCurrentCard(index: Int) {
        stackView.dropOutCard()
        if (index == (dataModel.numberOfItems() - 1)) {
            //self.stackView.undoSwipe(times: 2)
            refreshDataModel()
            self.stackView.reloadCards()
        }
    }
    
    func reloadCard()
    {
        self.stackView.undoSwipe(times: 1)
    }
    
    // MARK: - Menu methods
    func setupButtons() -> Void {
    }
    
//    func createButtonWithIcon(icon: LineaType, action: Selector, inFrame frame:CGRect) -> UIButton {
//        let btn = createButtonWithIconHelper(icon, action: action, inFrame: frame)
//        btn.backgroundColor = ColorScheme.MAIN_BUTTON_BACKGROUNDCOLOR
//        btn.tintColor = ColorScheme.MAIN_BUTTON_COLOR
//        btn.setTitleColor(ColorScheme.MAIN_BUTTON_COLOR, forState: .Normal)
//        btn.setTitleColor(ColorScheme.MAIN_BUTTON_COLOR_CLICKED, forState: .Highlighted)
//        btn.setTitleColor(ColorScheme.MAIN_BUTTON_COLOR_DISABLED, forState: .Disabled)
//        return btn
//    }
    
//    func createButtonWithIconHelper(icon: LineaType, action: Selector, inFrame frame:CGRect) -> UIButton {
//        let btn = UIButton(frame: frame)
//        btn.setLineaIcon(icon, iconSize: frame.width * 0.6, forState: .Normal)
//        btn.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
//        btn.layer.borderColor = UIColor.whiteColor().CGColor
//        btn.layer.borderWidth = 1.0
//        btn.layer.cornerRadius = frame.width / 2.0
//        return btn
//    }
    
    func showActionButtons() -> Void {
        self.leftButton?.hidden = false
        self.centreButton?.hidden = false
        self.menuButton?.hidden = false
    }
    
    func hideActionButtons() -> Void {
        self.leftButton?.hidden = true
        self.centreButton?.hidden = true
        self.menuButton?.hidden = true
    }
    
    // MARK: - Navigation methods
    func dismissChildController() {
        self.dismissViewControllerAnimated(true) {
            NSLog("Dismissed child controller")
        }
        self.dataModel.cardFilter = nil
        self.refreshDataModel()
        self.stackView.reloadCards()
    }
    
    func backAction() {
        if let parent = self.parent {
            parent.dismissChildController()
        } else {
            self.dataModel.cardFilter = nil
            self.dismissViewControllerAnimated(true) {
                NSLog("Dismissed View Controller")
            }
        }
    }
    
}

