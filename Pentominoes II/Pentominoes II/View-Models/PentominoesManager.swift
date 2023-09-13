//
//  PentominoesManager.swift
//  Pentominoes II
//
//  Created by Yifan Lu on 2/9/23.
//

import Foundation
import SwiftUI

class PentominoesManager : ObservableObject {
    // The Model
    @Published var game : PentominoesGame = PentominoesGame()
    
    @Published var numCorrect : Int = 0 {
        didSet {
            if numCorrect == 12 {
                solved = true
                confetti = confetti + 1
            }
        }
    }
    
    @Published var solved : Bool = false
    
    let blockSize : Int = 40
    
    let defaultGameSize : Int = 14
        
    @Published var shapeNum : Int = 0
    
    let posDict : [Int:Position] = [0: Position(x: 60, y: 56), 1: Position(x: 200, y: 56), 2: Position(x: 380, y: 56), 3: Position(x: 540, y: 56), 4: Position(x: 60, y: 216), 5: Position(x: 220, y: 196), 6: Position(x: 380, y: 216), 7: Position(x: 540, y: 216), 8: Position(x: 40, y: 396), 9: Position(x: 200, y: 396), 10: Position(x: 360, y: 396), 11: Position(x: 500, y: 416)]
    
    @Published var confetti: Int = 0
        
    // Updates the shape
    func updateShape(newShapeNum: Int) -> Void {
        shapeNum = newShapeNum
        pressResetButton()
    }
    
    // Gets solution from the given problem
    func getSolution() -> PentominoShapes {
        switch shapeNum {
        case 1:
            return game.solutions.the6X10
        case 2:
            return game.solutions.the5X12
        case 3:
            return game.solutions.oneHole
        case 4:
            return game.solutions.fourNotches
        case 5:
            return game.solutions.fourHoles
        case 6:
            return game.solutions.the13Holes
        case 7:
            return game.solutions.flower
        default:
            return game.solutions.the6X10
        }
    }
    
    // Gets the correct position from the given piece
    func getCorrectPosition(name: String, solution: PentominoShapes) -> Position {
        switch name {
        case "X":
            return solution.x
        case "I":
            return solution.i
        case "Y":
            return solution.y
        case "Z":
            return solution.z
        case "L":
            return solution.l
        case "T":
            return solution.t
        case "U":
            return solution.u
        case "F":
            return solution.f
        case "N":
            return solution.n
        case "V":
            return solution.v
        case "W":
            return solution.w
        case "P":
            return solution.p
        default:
            return solution.x
        }
    }
    
    // Checks if a given piece is in the correct  spot
    func validatePiece(piece: Piece) -> Bool {
        if shapeNum == 0 {
            return false
        }
        
        // Correct positions
        let correctPosition = getCorrectPosition(name: piece.outline.name, solution: getSolution())
        
        // Check x-coordinate
        if [Orientation.up, Orientation.down, Orientation.upMirrored, Orientation.downMirrored].contains(piece.position.orientation) {
            let adjustedXPos = correctPosition.x * 40 + 20 * piece.outline.size.width
            if adjustedXPos != piece.position.x {
                return false
            }
        }
        else {
            let adjustedXPos = correctPosition.x * 40 + 20 * piece.outline.size.height
            if adjustedXPos != piece.position.x {
                return false
            }
        }
        
        // Check y-coordinate
        if [Orientation.up, Orientation.down, Orientation.upMirrored, Orientation.downMirrored].contains(piece.position.orientation) {
            let adjustedYPos = -604 + 20 * piece.outline.size.height + 40 * correctPosition.y
            if adjustedYPos != piece.position.y {
                return false
            }
        }
        else {
            let adjustedYPos = -604 + 20 * piece.outline.size.width + 40 * correctPosition.y
            if adjustedYPos != piece.position.y {
                return false
            }
        }
        if piece.position.orientation != correctPosition.orientation {
            return false
        }
        return true
    }
    
    // Function for reset button
    func pressResetButton() {
        numCorrect = 0
        solved = false
        for i in 0...game.pentominoPieces.count-1 {
            withAnimation (.easeInOut(duration: 1)) {
                game.pentominoPieces[i].setPos(x: posDict[i]!.x, y: posDict[i]!.y)
            }
            game.pentominoPieces[i].resetRotation()
        }
    }
    
    // Function for solve button
    func pressSolveButton() {
        for i in 0...game.pentominoPieces.count-1 {
            let correctPosition = getCorrectPosition(name: game.pentominoPieces[i].outline.name, solution: getSolution())
            var adjustedXPos = 0
            var adjustedYPos = 0
            if [Orientation.up, Orientation.down, Orientation.upMirrored, Orientation.downMirrored].contains(correctPosition.orientation) {
                adjustedXPos = correctPosition.x * 40 + 20 * game.pentominoPieces[i].outline.size.width
            }
            else {
                adjustedXPos = correctPosition.x * 40 + 20 * game.pentominoPieces[i].outline.size.height
            }
            if [Orientation.up, Orientation.down, Orientation.upMirrored, Orientation.downMirrored].contains(correctPosition.orientation) {
                adjustedYPos = -604 + 20 * game.pentominoPieces[i].outline.size.height + 40 * correctPosition.y
            }
            else {
                adjustedYPos = -604 + 20 * game.pentominoPieces[i].outline.size.width + 40 * correctPosition.y
            }
            withAnimation (.easeInOut(duration: 1)) {
                game.pentominoPieces[i].setPos(x: adjustedXPos, y: adjustedYPos)
            }
            game.pentominoPieces[i].solveRotate(orientation: correctPosition.orientation)
        }
    }
}
