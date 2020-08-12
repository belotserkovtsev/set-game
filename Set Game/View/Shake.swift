//
// Created by milkyway on 12.08.2020.
// Copyright (c) 2020 belotserkovtsev. All rights reserved.
//

import SwiftUI

struct Shake: GeometryEffect {

    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
                CGAffineTransform(
                        translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                        y: 0
                )
        )
    }

}

extension View {
    func shake(data: CGFloat) -> some View {
        self.modifier(Shake(animatableData: data))
    }
}
