//
//  ContentView.swift
//  Pentominoes II
//
//  Created by Yifan Lu on 2/9/23.
//

import ConfettiSwiftUI
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pentominoesManager: PentominoesManager
    var body: some View {
        VStack {
            // Top of the board
            HStack {
                // Three puzzle shapes on the left of the grid, plus empty one
                VStack {
                    ForEach((0...3), id: \.self) {
                        PuzzleShapeButtonView(outline: pentominoesManager.game.puzzleOutlines[$0], shapeNum: $0, action: pentominoesManager.updateShape)
                    }
                }
                
                // Grid with current puzzle shape
                ZStack {
                    PuzzleView(outline: pentominoesManager.game.puzzleOutlines[pentominoesManager.shapeNum], widthOfUnit: pentominoesManager.blockSize, heightOfUnit: pentominoesManager.blockSize)
                    GridShape(width: pentominoesManager.defaultGameSize, height: pentominoesManager.defaultGameSize)
                        .stroke(Color.black, lineWidth: 3)
                        .frame(width: (CGFloat)(pentominoesManager.defaultGameSize*pentominoesManager.blockSize), height: (CGFloat)(pentominoesManager.defaultGameSize*pentominoesManager.blockSize))
                }
                
                // Four puzzle shapes on the right of the grid
                VStack {
                    ForEach((4...7), id: \.self) {
                        PuzzleShapeButtonView(outline: pentominoesManager.game.puzzleOutlines[$0], shapeNum: $0, action: pentominoesManager.updateShape)
                    }
                }
            }
            .padding(10)
            VStack {
                // First row of pentomino shapes, plus the reset and solve buttons
                HStack {
                    ActionButtonsView(buttonText: "Reset", action: pentominoesManager.pressResetButton)
                        .padding(10)
                    ZStack {
                        ForEach((0...11), id: \.self) {
                            GesturePieceView(piece: $pentominoesManager.game.pentominoPieces[$0])
                                .frame(width: 40 * CGFloat(pentominoesManager.game.pentominoPieces[$0].outline.size.width), height: 40 * CGFloat(pentominoesManager.game.pentominoPieces[$0].outline.size.height))
                                .position(x: CGFloat(pentominoesManager.game.pentominoPieces[$0].position.x), y: CGFloat(pentominoesManager.game.pentominoPieces[$0].position.y))
                                .padding(10)
                        }
                    }
                    ActionButtonsView(buttonText: "Solve", action: pentominoesManager.pressSolveButton)
                        .disabled(pentominoesManager.shapeNum == 0 || pentominoesManager.numCorrect == 12)
                        .opacity(pentominoesManager.shapeNum == 0 || pentominoesManager.numCorrect == 12 ? 0.5 : 1)
                        .padding(10)
                }
                .padding()
            }
        }
        .alert(isPresented: $pentominoesManager.solved) {
                    Alert(
                        title: Text("Congratulations!"),
                        message: Text("You solved the puzzle!")
                    )
                }
        .confettiCannon(counter: $pentominoesManager.confetti, num: 100, radius: 500)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(PentominoesManager())
    }
}
