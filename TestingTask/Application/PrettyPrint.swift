//
//  PrettyPrint.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation
/** short and beautiful print */
func pp(_ object: Any?) {
    #if DEBUG
        if let object = object {
            pp("⚪️ \(object)")
        } else {
            pp("⚪️ \(String(describing: object))")
        }
    #endif
}
func pp(_ text: String, terminator: String? = nil) {
    #if DEBUG
        terminator == nil ? print(text) : print(text, terminator: terminator!)
    #endif
}
