//
//  PieceView.swift
//  Pentominoes II
//
//  Created by Yifan Lu on 2/9/23.
//

import SwiftUI

struct PieceView: View {
    @Binding var piece: Piece
    var body: some View {
        ZStack {
            PentominoShape(outline: piece.outline, widthOfUnit: piece.widthOfUnit, heightOfUnit: piece.heightOfUnit)
                .foregroundColor(piece.fillColor)
                .frame(width: (CGFloat)(piece.widthOfUnit * piece.outline.size.width), height: (CGFloat)(piece.heightOfUnit * piece.outline.size.height))
            PentominoShape(outline: piece.outline, widthOfUnit: piece.widthOfUnit, heightOfUnit: piece.heightOfUnit)
                .stroke(Color.black, lineWidth: 2)
                .frame(width: (CGFloat)(piece.widthOfUnit * piece.outline.size.width), height: (CGFloat)(piece.heightOfUnit * piece.outline.size.height))
            GridShape(width: piece.outline.size.width, height: piece.outline.size.height)
                .stroke(Color.black, lineWidth: 2)
                .frame(width: (CGFloat)(piece.widthOfUnit * piece.outline.size.width), height: (CGFloat)(piece.heightOfUnit * piece.outline.size.height))
                .clipShape(PentominoShape(outline: piece.outline, widthOfUnit: piece.widthOfUnit, heightOfUnit: piece.heightOfUnit))
        }
    }
}

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        PieceView(piece: .constant(Piece.standard))
    }
}

