//
//  CardContentDeterminableProtocol.swift
//  Set Game
//
//  Created by milkyway on 02.08.2020.
//  Copyright © 2020 belotserkovtsev. All rights reserved.
//

import SwiftUI

protocol CardContentDeterminable {
    associatedtype T where T: TypeContentDeterminable
    var content: T { get }
    associatedtype C where C: TypeContentDeterminable
    var color: C { get }
    associatedtype F where F: TypeContentDeterminable
    var fill: F { get }
    
    var amount: Int { get }
}

protocol TypeContentDeterminable {
    var type: Int { get }
    
//    associatedtype T where T: View
//    var display: T { get }
}
