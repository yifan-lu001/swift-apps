//
//  PentominoShape.swift
//  Pentominoes II
//
//  Created by Yifan Lu on 2/9/23.
//

import Foundation
import SwiftUI

struct PentominoShape: Shape {
    let outline : PentominoOutline
    let widthOfUnit : Int
    let heightOfUnit : Int
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let mX = rect.midX - CGFloat(Double(outline.size.width) / 2) * CGFloat(widthOfUnit)
        let mY = rect.midY - CGFloat(Double(outline.size.height) / 2) * CGFloat(heightOfUnit)
        path.move(to: CGPoint(x: mX + (CGFloat)(outline.outline[0].x * widthOfUnit), y: mY + (CGFloat)(outline.outline[0].y * heightOfUnit)))
        for i in outline.outline {
            path.addLine(to: CGPoint(x: mX + (CGFloat)(i.x * widthOfUnit), y: mY + (CGFloat)(i.y * heightOfUnit)))
        }
        path.closeSubpath()
        return path
    }
}

struct PentominoShape_Previews: PreviewProvider {
    static var previews: some View {
        PentominoShape(outline: PentominoOutline(name: "X", size: Size(width: 3, height: 3), outline: [Point(x: 1, y: 0), Point(x: 2, y: 0), Point(x: 2, y: 1), Point(x: 3, y: 1), Point(x: 3, y: 2), Point(x: 2, y: 2), Point(x: 2, y: 3), Point(x: 1, y: 3), Point(x: 1, y: 2), Point(x: 0, y: 2), Point(x: 0, y: 1), Point(x: 1, y: 1), Point(x: 1, y: 1)]), widthOfUnit: 50, heightOfUnit: 50)
            .stroke(Color.black, lineWidth: 5)
    }
}
