//
//  PuzzleShape.swift
//  Pentominoes II
//
//  Created by Yifan Lu on 2/9/23.
//

import Foundation
import SwiftUI

struct PuzzleShape: Shape {
    let outline : PuzzleOutline
    let widthOfUnit : Int
    let heightOfUnit : Int
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for i in outline.outlines {
            path.move(to: CGPoint(x: rect.minX + (CGFloat)(i[0].x * widthOfUnit), y: rect.minX + (CGFloat)(i[0].y * heightOfUnit)))
            for j in i {
                path.addLine(to: CGPoint(x: rect.minX + (CGFloat)(j.x * widthOfUnit), y: rect.minX + (CGFloat)(j.y * heightOfUnit)))
            }
        }
        path.closeSubpath()
        return path
    }
}

struct PuzzleShape_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleShape(outline: PuzzleOutline(name: "OneHole", size: Size(width: 8, height: 8), outlines: [[Point(x: 0, y: 0), Point(x: 8, y: 0), Point(x: 8, y: 8), Point( x: 0, y: 8), Point(x: 0, y: 0)], [Point(x: 3, y: 3), Point(x: 5, y: 3), Point(x: 5, y: 5), Point(x: 3, y: 5), Point(x: 3, y: 3)]]), widthOfUnit: 20, heightOfUnit: 20)
            .fill(style: FillStyle(eoFill: true, antialiased: true))
    }
}
