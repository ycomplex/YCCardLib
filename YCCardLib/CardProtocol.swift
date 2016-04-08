//
//  CardProtocol.swift
//  Tasks
//
//  Created by User on 07/04/2016.
//  Copyright © 2016 YComplex. All rights reserved.
//

import Foundation

@objc protocol CardProtocol {
    var type: String? {get set}
    var content: String? {get set}
    var completed: NSDate? {get set}
    var category: String? {get set}
    var deferTill: NSDate? {get set}
    var created: NSDate? {get set}
    var modified: NSDate? {get set}
    var trash: NSDate? {get set}
    var isCompleted: Bool {get set}
    var isTrash: Bool {get set}
    func getStringAttribute(name: String) -> String?
    func setStringAttribute(name: String, value: String?) -> Void
}