//
//  ButtonShapes.swift
//  LionSpell III
//
//  Created by Yifan Lu on 1/25/23.
//

import Foundation
import SwiftUI

struct ButtonShape : Shape {
    let sides : Int
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.width, rect.height) / 2
        if sides == 4 {
            path.move(to: CGPoint(x: rect.midX + radius * cos(Double.pi/2), y: rect.midY + radius * sin(Double.pi/2)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(2*Double.pi/2), y: rect.midY + radius * sin(2*Double.pi/2)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(3*Double.pi/2), y: rect.midY + radius * sin(3*Double.pi/2)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(2*Double.pi), y: rect.midY + radius * sin(2*Double.pi)))
            path.closeSubpath()
        }
        else if sides == 5 {
            path.move(to: CGPoint(x: rect.midX + radius * cos(Double.pi/10), y: rect.midY + radius * sin(Double.pi/10)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(5*Double.pi/10), y: rect.midY + radius * sin(5*Double.pi/10)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(9*Double.pi/10), y: rect.midY + radius * sin(9*Double.pi/10)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(13*Double.pi/10), y: rect.midY + radius * sin(13*Double.pi/10)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(17*Double.pi/10), y: rect.midY + radius * sin(17*Double.pi/10)))
            path.closeSubpath()
        }
        else if sides == 6 {
            path.move(to: CGPoint(x: rect.midX + radius * cos(0), y: rect.midY + radius * sin(0)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(Double.pi/3), y: rect.midY + radius * sin(Double.pi/3)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(2*Double.pi/3), y: rect.midY + radius * sin(2*Double.pi/3)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(3*Double.pi/3), y: rect.midY + radius * sin(3*Double.pi/3)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(4*Double.pi/3), y: rect.midY + radius * sin(4*Double.pi/3)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(5*Double.pi/3), y: rect.midY + radius * sin(5*Double.pi/3)))
            path.closeSubpath()
        }
        // Used for the upside-down pentagon
        else {
            path.move(to: CGPoint(x: rect.midX + radius * cos(3*Double.pi/10), y: rect.midY + radius * sin(3*Double.pi/10)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(7*Double.pi/10), y: rect.midY + radius * sin(7*Double.pi/10)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(11*Double.pi/10), y: rect.midY + radius * sin(11*Double.pi/10)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(15*Double.pi/10), y: rect.midY + radius * sin(15*Double.pi/10)))
            path.addLine(to: CGPoint(x: rect.midX + radius * cos(19*Double.pi/10), y: rect.midY + radius * sin(19*Double.pi/10)))
            path.closeSubpath()
        }
        return path
    }
}

struct ButtonShapes_Previews: PreviewProvider {
    static var previews: some View {
        ButtonShape(sides: 2)
    }
}
