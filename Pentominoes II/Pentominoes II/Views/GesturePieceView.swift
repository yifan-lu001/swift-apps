//
//  GesturePieceView.swift
//  Pentominoes II
//
//  Created by Yifan Lu on 2/11/23.
//

import SwiftUI

struct GesturePieceView: View {
    @EnvironmentObject var pentominoesManager: PentominoesManager
    @Binding var piece: Piece
    @State private var offset = CGSize.zero
    var body: some View {
        let move = DragGesture()
            .onChanged { value in
                piece.beingDragged = true
                withAnimation(.spring()) {
                    offset = value.translation
                }
            }
            .onEnded { value in
                piece.beingDragged = false
                //withAnimation(.spring()) {
                    piece.move(by: value.translation.size)
                    offset = CGSize.zero
                    if pentominoesManager.validatePiece(piece: piece) {
                        piece.setCorrectPosition()
                        pentominoesManager.numCorrect = pentominoesManager.numCorrect + 1
                    }
                //}
            }
        PieceView(piece: $piece)
                .offset(offset)
                .gesture(move)
                .rotationEffect(.degrees(piece.rotation))
                .scaleEffect(piece.beingDragged ? 1.2 : 1.0)
                .shadow(
                    color: piece.fillColor.opacity(piece.beingDragged ? 0.7 : 0),
                    radius: 8,
                    x: 8,
                    y: 8
                )
                .animation(.linear(duration: 0.25), value: piece.rotation)
                .rotation3DEffect(.degrees(piece.flipped), axis: (x: 0, y: 1, z: 0))
                .animation(.linear(duration: 0.25), value: piece.flipped)
                .onTapGesture {
                    piece.rotate()
                    if pentominoesManager.validatePiece(piece: piece) {
                        piece.setCorrectPosition()
                        pentominoesManager.numCorrect = pentominoesManager.numCorrect + 1
                    }
                }
                .disabled(piece.correctPosition)
                .onLongPressGesture {
                piece.flip()
                if pentominoesManager.validatePiece(piece: piece) {
                    piece.setCorrectPosition()
                    pentominoesManager.numCorrect = pentominoesManager.numCorrect + 1
                    }
                }
                .disabled(piece.correctPosition)
                .opacity(piece.correctPosition ? 0.5 : 1)
    }
}

struct GesturePieceView_Previews: PreviewProvider {
    static var previews: some View {
        GesturePieceView(piece: .constant(Piece.standard))
    }
}
