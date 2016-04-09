//
//  CardDataModel.swift
//  Tasks
//
//  Created by User on 07/04/2016.
//  Copyright © 2016 YComplex. All rights reserved.
//

import Foundation

public class CardDataModel {
    var cardFilter:((Card)->Bool)?
    var cardSortFunction: ((Card, Card)->Bool)?

    func performStartupTasks(callback:()->Void) {
    }
    
    func terminate() {
    }
    
    func numberOfItems() -> Int {
        return 0
    }
    
    func elementAt(index: Int) -> Card? {
        return nil
    }
    
    func updateCard(card: Card, atIndex: Int) -> Void {
        
    }
    
    func refreshItems() -> Void {
        
    }
    
    func insertCard(atIndex index: Int, type: String, category: String, content: String) {
        
    }
}