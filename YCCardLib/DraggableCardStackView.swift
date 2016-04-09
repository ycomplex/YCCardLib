//
//  DraggableCardViewContainer.swift
//  Soapbox
//
//  Created by User on 31/03/2016.
//  Copyright © 2016 YComplex. All rights reserved.
//

import Foundation
import UIKit

public class DraggableCardStackView: UIView, DraggableViewDelegate {
    var cardHeight:CGFloat!, cardWidth:CGFloat!, stackSize:Int!
    
    var currentCardIndex:Int = 0
    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]! = []
    var menuButton: UIButton!
    var messageButton: UIButton!
//    var checkButton: UIButton!
//    var xButton: UIButton!
//    var reloadButton: UIButton!
    
    var dataSource:DraggableCardStackDataSource? {
        didSet {
            if let dataSource = dataSource {
                cardHeight = dataSource.cardHeightForDraggableCardStack(self)
                cardWidth = dataSource.cardWidthForDraggableCardStack(self)
                stackSize = dataSource.stackSizeForDraggableCardStack(self)
                self._loadCards()
            }
        }
    }
    
    var delegate: DraggableCardStackDelegate?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
    }
    
    public func cardSwipedLeft(oldCard: UIView) -> Void {
        let swipedCard = currentCardIndex
        _cardSwiped(oldCard);
        delegate?.draggableCardStack(self, swipedCard: oldCard, atIndex: swipedCard, to: .CardSwipeModeLeft)
    }
    
    public func cardSwipedRight(oldCard: UIView) -> Void {
        let swipedCard = currentCardIndex
        _cardSwiped(oldCard);
        delegate?.draggableCardStack(self, swipedCard: oldCard, atIndex: swipedCard, to: .CardSwipeModeRight)
    }
    
    func undoSwipe(times t:Int = 1) -> Void {
        for _ in 0 ..< t {
            if (currentCardIndex > 0) {
                currentCardIndex -= 1;
                let newCard: DraggableView = self._createDraggableViewWithDataAtIndex(currentCardIndex, inPosition: 0)
                loadedCards.insert(newCard, atIndex: 0)
                self._insertCard(newCard, belowCard: nil, withAnimation: true)
                
                if (loadedCards.count > stackSize) {
                    if let removedCard:DraggableView = loadedCards.popLast() {
                        removedCard.removeFromSuperview()
                        cardsLoadedIndex = cardsLoadedIndex - 1;
                    }
                }
                
                for i in 0 ..< loadedCards.count {
                    let card = loadedCards[i]
                    if (i == 0) {
                        delegate?.draggableCardStack(self, displayingCard: card.cardView, atIndex: currentCardIndex)
                    }
                    UIView.animateWithDuration(0.2, animations: {
                        //card.frame = self.buildFrameForCardInPosition(i)
                        let newFrame = self._buildFrameForCardInPosition(i)
                        card.updateFrame(newFrame)
                    })
                }
            }
        }
    }
    
    func focusCurrentCard() {
        if (loadedCards.count > 0) {
            let contentInsets = UIEdgeInsetsMake(20, 2, 2, 2);
            let newFrame = UIEdgeInsetsInsetRect(self.bounds, contentInsets);
            
            // let newFrame = CGRectInset(self.bounds, 5, 15)
            self.loadedCards[0].updateFrame(newFrame)
            self.loadedCards[0].dragEnabled = false
        }
    }
    
    func unfocusCurrentCard() {
        if (loadedCards.count > 0) {
            let newFrame = self._buildFrameForCardInPosition(0)
            self.loadedCards[0].updateFrame(newFrame)
            self.loadedCards[0].dragEnabled = true
        }
    }
    
    func reloadCards(fromIndex: Int = 0) {
        for i in 0 ..< loadedCards.count {
            loadedCards[i].dropOutFromView()
        }
        self._loadCards(fromIndex)
    }
    
    func insertedCard(atIndex index: Int) -> Void {
        if (index < currentCardIndex) {
            currentCardIndex = currentCardIndex + 1
            cardsLoadedIndex = cardsLoadedIndex + 1
        } else if (index == currentCardIndex) {
            currentCardIndex = currentCardIndex + 1
            cardsLoadedIndex = cardsLoadedIndex + 1
            undoSwipe()
        } else if (index >= cardsLoadedIndex) {
            if (loadedCards.count < stackSize) {
                // We should load this new card
                _loadNextCard()
            }
        } else {
            let positionOfNewCard = index - currentCardIndex
            let newCard: DraggableView = self._createDraggableViewWithDataAtIndex(index, inPosition: positionOfNewCard)
            loadedCards.insert(newCard, atIndex: positionOfNewCard)
            _insertCard(newCard, belowCard: loadedCards[positionOfNewCard - 1], withAnimation: true)
            
            if (loadedCards.count > stackSize) {
                let removedCard:DraggableView = loadedCards.popLast()!;
                removedCard.removeFromSuperview()
            } else {
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
            
            for i in positionOfNewCard ..< loadedCards.count {
                let card = loadedCards[i]
                UIView.animateWithDuration(0.2, animations: {
                    let newFrame = self._buildFrameForCardInPosition(i)
                    card.updateFrame(newFrame)
                })
            }
            
        }
    }
    
    func forceRightSwipe() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView?.setMode(SBOverlayViewMode.SBOverlayViewModeRight)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView?.alpha = 1
        })
        dragView.rightClickAction()
    }
    
    func forceLeftSwipe() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView?.setMode(SBOverlayViewMode.SBOverlayViewModeLeft)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView?.alpha = 1
        })
        dragView.leftClickAction()
    }
    
    func dropOutCard() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.dropOutFromView()
        _cardSwiped(dragView.cardView);
    }
    
    // HELPERS
    func _buildFrameForCardInPosition(position: Int) -> CGRect {
        let actualPos = position < stackSize ? position : (stackSize - 1)
        let actualWidth = cardWidth - CGFloat(actualPos * 5)
        let xPos = (self.frame.size.width - actualWidth)/2
        return CGRectMake(xPos, (self.frame.size.height - self.cardHeight)/2 - (CGFloat(actualPos) * 10), actualWidth, self.cardHeight);
    }
    
    func _createDraggableViewWithDataAtIndex(index: Int, inPosition: Int) -> DraggableView {
        let cardView = self.dataSource?.draggableCardStack(self, viewForCardAtIndex: index)
        let overlayView:OverlayView? = self.dataSource?.draggableCardStack(self, overlayViewForCardAtIndex: index) as? OverlayView
        let draggableView = DraggableView(frame: self._buildFrameForCardInPosition(inPosition), view: cardView!, overlay: overlayView)
        draggableView.delegate = self
        return draggableView
    }
    
    func _cardSwiped(oldCard: UIView) -> Void {
        loadedCards.removeAtIndex(0)
        currentCardIndex += 1
        for i in 0 ..< loadedCards.count {
            let card = loadedCards[i]
            if (i == 0) {
                delegate?.draggableCardStack(self, displayingCard: card.cardView, atIndex: currentCardIndex)
            }
            
            // Slide down existing cards
            UIView.animateWithDuration(0.2, animations: {
                let newFrame = self._buildFrameForCardInPosition(i)
                card.updateFrame(newFrame)
            })
        }
        
        self._loadNextCard()
    }
    
    func _loadNextCard() -> Void {
        let currentLoadedCount = loadedCards.count
        if cardsLoadedIndex < self.dataSource!.cardCountForDraggableCardStack(self) {
            if (currentLoadedCount < stackSize) {
                let newCard: DraggableView = self._createDraggableViewWithDataAtIndex(cardsLoadedIndex, inPosition: currentLoadedCount)
                loadedCards.append(newCard)
                cardsLoadedIndex = cardsLoadedIndex + 1
                let earlierCard:UIView? = currentLoadedCount > 0 ? loadedCards[currentLoadedCount - 1] : nil
                self._insertCard(newCard, belowCard: earlierCard, withAnimation: true)
            }
        }
    }
    
    func _loadCards(fromIndex: Int = 0) -> Void {
        loadedCards = []
        cardsLoadedIndex = fromIndex
        currentCardIndex = fromIndex
        let cardCount:Int = self.dataSource!.cardCountForDraggableCardStack(self)
        if cardCount > 0 {
            for i in 0 ..< cardCount {
                let cardsLoaded = loadedCards.count
                if i >= fromIndex && cardsLoaded < stackSize && i < cardCount {
                    _loadNextCard()
                    if (cardsLoaded == 0) {
                        delegate?.draggableCardStack(self, displayingCard: loadedCards[cardsLoaded].cardView, atIndex: currentCardIndex)
                    }
                }
            }
        }
    }
    
    func _insertCard(card: UIView, belowCard earlierCard: UIView?, withAnimation: Bool) {
        let originalFrame = card.frame
        if (withAnimation) {
            card.frame = CGRectOffset(originalFrame, 0, -1 * (self.frame.size.height + cardHeight)/2)
            card.alpha = 0.5
        }
        if earlierCard != nil {
            self.insertSubview(card, belowSubview: earlierCard!)
        } else {
            self.addSubview(card)
        }
        if (withAnimation) {
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {
                card.frame = originalFrame
                card.alpha = 1.0
                }, completion: { (foo) in
                    
            })
        }
    }
}