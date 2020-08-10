//
//  Cardify.swift
//  Set Game
//
//  Created by milkyway on 02.08.2020.
//  Copyright © 2020 belotserkovtsev. All rights reserved.
//

import SwiftUI

struct Cardify: ViewModifier {
    var thickness: CGFloat
    
//    init(thickness: CGFloat) {
//        self.thickness = thickness
//    }
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5).stroke(lineWidth: thickness)
            RoundedRectangle(cornerRadius: 5).foregroundColor(.white)
    
            content
        }
    }
}

extension View {
    func cardify(thickness: CGFloat = 3) -> some View {
        self.modifier(Cardify(thickness: thickness))
    }
}
