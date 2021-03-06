//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by milkyway on 22.07.2020.
//  Copyright © 2020 belotserkovtsev. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching element: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == element.id {
                return index
            }
        }
         return nil
    }
}
