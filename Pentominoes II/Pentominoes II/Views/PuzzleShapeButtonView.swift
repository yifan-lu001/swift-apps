//
//  PuzzleShapeButtonView.swift
//  Pentominoes II
//
//  Created by Yifan Lu on 2/9/23.
//

import SwiftUI

struct PuzzleShapeButtonView: View {
    let outline : PuzzleOutline
    let shapeNum : Int
    var action: (Int) -> Void
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.gray)
                .opacity(0.3)
                .frame(width: 100, height: 83)
            GridShape(width: 6, height: 6)
                .stroke(Color.white, lineWidth: 2)
                .opacity(0.7)
                .frame(width: 100, height: 100)
            PuzzleView(outline: outline, widthOfUnit: 6, heightOfUnit: 6)
            Button(action: {
                action(shapeNum)
                }) {
                    Rectangle()
                        .stroke(Color.blue, lineWidth: 2.5)
                        .frame(width: 100, height: 83)
            }
        }
    }
}

struct PuzzleShapeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleShapeButtonView(outline: PuzzleOutline(name: "OneHole", size: Size(width: 8, height: 8), outlines: [[Point(x: 0, y: 0), Point(x: 8, y: 0), Point(x: 8, y: 8), Point( x: 0, y: 8), Point(x: 0, y: 0)], [Point(x: 3, y: 3), Point(x: 5, y: 3), Point(x: 5, y: 5), Point(x: 3, y: 5), Point(x: 3, y: 3)]]), shapeNum: 4, action: {_ in })
    }
}

