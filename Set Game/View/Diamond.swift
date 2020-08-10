//
//  Diamond.swift
//  Set Game
//
//  Created by milkyway on 05.08.2020.
//  Copyright © 2020 belotserkovtsev. All rights reserved.
//

import SwiftUI

struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        
        let length = min(width, height)/2
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        
        
        if width < height {
            let a = CGPoint(x: center.x - length, y: center.y)
            let b = CGPoint(x: center.x, y: center.y - length + length / 4)
            let c = CGPoint(x: center.x + length, y: center.y)
            let d = CGPoint(x: center.x, y: center.y + length - length / 4)
            
            var p = Path()
            
            p.move(to: a)
            
            p.addLine(to: b)
            p.addLine(to: c)
            p.addLine(to: d)
            p.addLine(to: a)
            
            return p
        }
        
        else {
            let a = CGPoint(x: center.x - length + length / 4, y: center.y)
            let b = CGPoint(x: center.x, y: center.y - length)
            let c = CGPoint(x: center.x + length - length / 4, y: center.y)
            let d = CGPoint(x: center.x, y: center.y + length)
            
            var p = Path()
            
            p.move(to: a)
            
            p.addLine(to: b)
            p.addLine(to: c)
            p.addLine(to: d)
            p.addLine(to: a)
            
            return p
        }
        
        
    }
}
