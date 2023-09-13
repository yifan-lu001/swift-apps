//
//  GridShape.swift
//  Pentominoes II
//
//  Created by Yifan Lu on 2/9/23.
//

import Foundation
import SwiftUI

struct GridShape: Shape {
    let width : Int
    let height : Int
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for i in 0...width {
            path.move(to: CGPoint(x: rect.width * (CGFloat)(Double (i) / Double(width)), y: rect.minY))
            path.addLine(to: CGPoint(x: rect.width * (CGFloat)(Double (i) / Double(width)), y: rect.maxY))
        }
        for i in 0...height {
            path.move(to: CGPoint(x: rect.minX, y: rect.height * (CGFloat)(Double (i) / Double(height))))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.height * (CGFloat)(Double (i) / Double(height))))
        }
        path.closeSubpath()
        return path
    }
}

struct GridShape_Previews: PreviewProvider {
    static var previews: some View {
        GridShape(width: 5, height: 5)
            .stroke(Color.purple, lineWidth: 5)
            .padding()
    }
}
