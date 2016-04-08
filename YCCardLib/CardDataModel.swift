//
//  CardDataModel.swift
//  Tasks
//
//  Created by User on 07/04/2016.
//  Copyright © 2016 YComplex. All rights reserved.
//

import Foundation

class CardDataModel {
    var cardFilter:((CardProtocol)->Bool)?
    var cardSortFunction: ((CardProtocol, CardProtocol)->Bool)?

    func performStartupTasks(callback:()->Void) {
    }
    
    func terminate() {
    }
    
    func numberOfItems() -> Int {
        return 0
    }
    
    func elementAt(index: Int) -> CardProtocol? {
        return nil
    }
    
    func updateCard(card: CardProtocol, atIndex: Int) -> Void {
        
    }
    
    func refreshItems() -> Void {
        
    }
    
    func insertCard(atIndex index: Int, type: String, category: String, content: String) {
        
    }
}