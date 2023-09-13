//
//  PuzzleView.swift
//  Pentominoes II
//
//  Created by Yifan Lu on 2/9/23.
//

import SwiftUI

struct PuzzleView: View {
    let outline : PuzzleOutline
    let widthOfUnit : Int
    let heightOfUnit : Int
    var body: some View {
        ZStack {
            PuzzleShape(outline: outline, widthOfUnit: widthOfUnit, heightOfUnit: heightOfUnit)
                .fill(style: FillStyle(eoFill: true, antialiased: true))
                .foregroundColor(Color(red: 0.65098, green: 0.78431, blue: 1))
                .frame(width: (CGFloat)(widthOfUnit * outline.size.width), height: (CGFloat)(heightOfUnit * outline.size.height))
            PuzzleShape(outline: outline, widthOfUnit: widthOfUnit, heightOfUnit: heightOfUnit)
                .stroke(Color.blue, lineWidth: 2)
                .frame(width: (CGFloat)(widthOfUnit * outline.size.width), height: (CGFloat)(heightOfUnit * outline.size.height))
        }
    }
}

struct PuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleView(outline: PuzzleOutline(name: "OneHole", size: Size(width: 8, height: 8), outlines: [[Point(x: 0, y: 0), Point(x: 8, y: 0), Point(x: 8, y: 8), Point( x: 0, y: 8), Point(x: 0, y: 0)], [Point(x: 3, y: 3), Point(x: 5, y: 3), Point(x: 5, y: 5), Point(x: 3, y: 5), Point(x: 3, y: 3)]]), widthOfUnit: 20, heightOfUnit: 20)
    }
}
