//
//  PentominoesModel.swift
//  Pentominoes II
//
//  Created by Yifan Lu on 2/9/23.
//

import Foundation
import SwiftUI


// Mark:- Shapes models
struct Point : Codable {
    let x : Int
    let y : Int
}

struct Size : Codable {
    var width : Int
    var height : Int
}

typealias Outline = [Point]

struct PentominoOutline : Codable {
    let name : String
    var size : Size
    let outline : Outline
    
    static let allPentominoOutlines: [PentominoOutline] = Bundle.main.decode(file: "PentominoOutlines.json")
    static let samplePentominoOutline: PentominoOutline = allPentominoOutlines[0]
}

struct PuzzleOutline : Codable {
    let name : String
    let size : Size
    let outlines : [Outline]
    
    static let allPuzzleOutlines: [PuzzleOutline] = Bundle.main.decode(file: "PuzzleOutlines.json")
    static let samplePuzzleOutline: PuzzleOutline = allPuzzleOutlines[0]
}

struct Solutions: Codable {
    let the6X10, the5X12, oneHole, fourNotches: PentominoShapes
    let fourHoles, the13Holes, flower: PentominoShapes

    enum CodingKeys: String, CodingKey {
        case the6X10 = "6x10"
        case the5X12 = "5x12"
        case oneHole = "OneHole"
        case fourNotches = "FourNotches"
        case fourHoles = "FourHoles"
        case the13Holes = "13Holes"
        case flower = "Flower"
    }
    
    static let allSolutions: Solutions = Bundle.main.decode(file: "Solutions.json")
}

struct PentominoShapes: Codable, Hashable {
    let x, i, y, z: Position
    let l, t, u, f: Position
    let n, v, w, p: Position

    enum CodingKeys: String, CodingKey {
        case x = "X"
        case i = "I"
        case y = "Y"
        case z = "Z"
        case l = "L"
        case t = "T"
        case u = "U"
        case f = "F"
        case n = "N"
        case v = "V"
        case w = "W"
        case p = "P"
    }
}

enum Orientation: String, Codable {
    case up = "up"
    case left = "left"
    case down = "down"
    case right = "right"
    case upMirrored = "upMirrored"
    case leftMirrored = "leftMirrored"
    case downMirrored = "downMirrored"
    case rightMirrored = "rightMirrored"
}

// Mark:- Pieces Model

// specifies the complete position of a piece using unit coordinates
struct Position : Hashable, Codable {
    var x : Int = 0
    var y : Int = 0
    var orientation: Orientation = Orientation.up
}

// a Piece is the model data that the view uses to display a pentomino
struct Piece : Hashable {
    var fillColor : Color
    var position : Position = Position()
    var outline : PentominoOutline
    var widthOfUnit : Int
    var heightOfUnit : Int
    var rotation = 0.0
    var flipped = 0.0
    var correctPosition = false
    var beingDragged = false
    
    static let standard = Piece(fillColor: Color.purple, position: Position(x: 200, y: 200, orientation: Orientation.up), outline: PentominoOutline(name: "X", size: Size(width: 3, height: 3), outline: [Point(x: 1, y: 0), Point(x: 2, y: 0), Point(x: 2, y: 1), Point(x: 3, y: 1), Point(x: 3, y: 2), Point(x: 2, y: 2), Point(x: 2, y: 3), Point(x: 1, y: 3), Point(x: 1, y: 2), Point(x: 0, y: 2), Point(x: 0, y: 1), Point(x: 1, y: 1), Point(x: 1, y: 1)]), widthOfUnit: 40, heightOfUnit: 40)
    
    // Set correct position
    mutating func setCorrectPosition() {
        correctPosition = true
    }
    
    // Change orientation
    mutating func rotate() {
        let nextDict: [Orientation:Orientation] = [Orientation.up: Orientation.right, Orientation.right: Orientation.down, Orientation.down: Orientation.left, Orientation.left: Orientation.up, Orientation.upMirrored: Orientation.leftMirrored, Orientation.leftMirrored: Orientation.downMirrored, Orientation.downMirrored: Orientation.rightMirrored, Orientation.rightMirrored: Orientation.upMirrored]
        position.orientation = nextDict[position.orientation]!
        rotation = rotation + 90
    }
    
    // Reset rotation
    mutating func resetRotation() {
        rotation = 0
        flipped = 0
        correctPosition = false
        position.orientation = Orientation.up
    }
    
    // Flip piece along vertical axis
    mutating func flip() {
        let flipDict: [Orientation:Orientation] = [Orientation.up: Orientation.upMirrored, Orientation.right: Orientation.leftMirrored, Orientation.down: Orientation.downMirrored, Orientation.left: Orientation.rightMirrored, Orientation.upMirrored: Orientation.up, Orientation.rightMirrored: Orientation.left, Orientation.downMirrored: Orientation.down, Orientation.leftMirrored: Orientation.right]
        position.orientation = flipDict[position.orientation]!
        flipped = flipped + 180
    }
    
    // Change orientation (WITH PARAMETER)
    mutating func solveRotate(orientation: Orientation) {
        position.orientation = orientation
        if orientation == Orientation.up || orientation == Orientation.upMirrored {
            rotation = 0
        }
        else if orientation == Orientation.down || orientation == Orientation.downMirrored {
            rotation = 180
        }
        else if orientation == Orientation.right || orientation == Orientation.leftMirrored {
            rotation = 90
        }
        else {
            rotation = 270
        }
        if [Orientation.upMirrored, Orientation.downMirrored, Orientation.rightMirrored, Orientation.leftMirrored].contains(orientation) {
            flipped = 180
        }
    }
    
    // Set the position of the piece
    mutating func setPos(x: Int, y: Int) {
        position.x = x
        position.y = y
    }
    
    // Move the piece
    mutating func move(by size: Size) {
        switch position.orientation {
        case Orientation.up:
            let roundedX = Int(round(Double(size.width + position.x)/40) * 40)
            let roundedY = Int(round(Double(size.height + position.y)/40) * 40) - 4
            if outline.size.width % 2 == 1 {
                if (size.width + position.x) < roundedX {
                    position.x = roundedX - 20
                }
                else {
                    position.x = roundedX + 20
                }
            }
            else {
                position.x = roundedX
            }
            if outline.size.height % 2 == 1 {
                if (size.height + position.y) < roundedY {
                    position.y = roundedY - 20
                }
                else {
                    position.y = roundedY + 20
                }
            }
            else {
                position.y = roundedY
            }
        case Orientation.down:
            let roundedX = Int(round(Double(-size.width + position.x)/40) * 40)
            let roundedY = Int(round(Double(-size.height + position.y)/40) * 40) - 4
            if outline.size.width % 2 == 1 {
                if (-size.width + position.x) < roundedX {
                    position.x = roundedX - 20
                }
                else {
                    position.x = roundedX + 20
                }
            }
            else {
                position.x = roundedX
            }
            if outline.size.height % 2 == 1 {
                if (-size.height + position.y) < roundedY {
                    position.y = roundedY - 20
                }
                else {
                    position.y = roundedY + 20
                }
            }
            else {
                position.y = roundedY
            }
        case Orientation.right:
            let roundedX = Int(round(Double(-size.height + position.x)/40) * 40)
            let roundedY = Int(round(Double(size.width + position.y)/40) * 40) - 4
            if outline.size.height % 2 == 1 {
                if (-size.height + position.x) < roundedX {
                    position.x = roundedX - 20
                }
                else {
                    position.x = roundedX + 20
                }
            }
            else {
                position.x = roundedX
            }
            if outline.size.width % 2 == 1 {
                if (size.width + position.y) < roundedY {
                    position.y = roundedY - 20
                }
                else {
                    position.y = roundedY + 20
                }
            }
            else {
                position.y = roundedY
            }
        case Orientation.left:
            let roundedX = Int(round(Double(size.height + position.x)/40) * 40)
            let roundedY = Int(round(Double(-size.width + position.y)/40) * 40) - 4
            if outline.size.height % 2 == 1 {
                if (size.height + position.x) < roundedX {
                    position.x = roundedX - 20
                }
                else {
                    position.x = roundedX + 20
                }
            }
            else {
                position.x = roundedX
            }
            if outline.size.width % 2 == 1 {
                if (-size.width + position.y) < roundedY {
                    position.y = roundedY - 20
                }
                else {
                    position.y = roundedY + 20
                }
            }
            else {
                position.y = roundedY
            }
        case Orientation.upMirrored:
            let roundedX = Int(round(Double(-size.width + position.x)/40) * 40)
            let roundedY = Int(round(Double(size.height + position.y)/40) * 40) - 4
            if outline.size.width % 2 == 1 {
                if (-size.width + position.x) < roundedX {
                    position.x = roundedX - 20
                }
                else {
                    position.x = roundedX + 20
                }
            }
            else {
                position.x = roundedX
            }
            if outline.size.height % 2 == 1 {
                if (size.height + position.y) < roundedY {
                    position.y = roundedY - 20
                }
                else {
                    position.y = roundedY + 20
                }
            }
            else {
                position.y = roundedY
            }
        case Orientation.downMirrored:
            let roundedX = Int(round(Double(size.width + position.x)/40) * 40)
            let roundedY = Int(round(Double(-size.height + position.y)/40) * 40) - 4
            if outline.size.width % 2 == 1 {
                if (size.width + position.x) < roundedX {
                    position.x = roundedX - 20
                }
                else {
                    position.x = roundedX + 20
                }
            }
            else {
                position.x = roundedX
            }
            if outline.size.height % 2 == 1 {
                if (-size.height + position.y) < roundedY {
                    position.y = roundedY - 20
                }
                else {
                    position.y = roundedY + 20
                }
            }
            else {
                position.y = roundedY
            }
        case Orientation.rightMirrored:
            let roundedX = Int(round(Double(-size.height + position.x)/40) * 40)
            let roundedY = Int(round(Double(-size.width + position.y)/40) * 40) - 4
            if outline.size.height % 2 == 1 {
                if (-size.height + position.x) < roundedX {
                    position.x = roundedX - 20
                }
                else {
                    position.x = roundedX + 20
                }
            }
            else {
                position.x = roundedX
            }
            if outline.size.width % 2 == 1 {
                if (-size.width + position.y) < roundedY {
                    position.y = roundedY - 20
                }
                else {
                    position.y = roundedY + 20
                }
            }
            else {
                position.y = roundedY
            }
        case Orientation.leftMirrored:
            let roundedX = Int(round(Double(size.height + position.x)/40) * 40)
            let roundedY = Int(round(Double(size.width + position.y)/40) * 40) - 4
            if outline.size.height % 2 == 1 {
                if (size.height + position.x) < roundedX {
                    position.x = roundedX - 20
                }
                else {
                    position.x = roundedX + 20
                }
            }
            else {
                position.x = roundedX
            }
            if outline.size.width % 2 == 1 {
                if (size.width + position.y) < roundedY {
                    position.y = roundedY - 20
                }
                else {
                    position.y = roundedY + 20
                }
            }
            else {
                position.y = roundedY
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }
    static func == (lhs: Piece, rhs: Piece) -> Bool {
        return lhs.position.x == rhs.position.x && lhs.position.y == rhs.position.y
    }
}

// Bundle extension to decode JSON file
extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the project.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) in the project.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) in the project.")
        }
        return loadedData
    }
}

extension CGSize {
    var size : Size {Size(width: Int(self.width), height: Int(self.height))}
}

// The Model for a Pentominoes Game
struct PentominoesGame {
    var puzzleOutlines : [PuzzleOutline]
    var pentominoPieces : [Piece]
    var solutions : Solutions
    init() {
        // Color extension to color pentominoes pieces
        func pickColor(num: Int) -> Color {
            let colorDict : [Int:Color] = [0: Color(red: 1, green: 45/255, blue: 85/255), 1: Color(red: 50/255, green: 173/255, blue: 230/255), 2: Color(red: 254/255, green: 60/255, blue: 48/255), 3: Color(red: 2/255, green: 199/255, blue: 190/255), 4: Color(red: 175/255, green: 82/255, blue: 222/255), 5: Color(red: 253/255, green: 204/255, blue: 2/255), 6: Color(red: 88/255, green: 86/255, blue: 214/255), 7: Color(red: 254/255, green: 149/255, blue: 0/255), 8: Color(red: 52/255, green: 199/255, blue: 89/255), 9: Color(red: 48/255, green: 176/255, blue: 200/255), 10: Color(red: 162/255, green: 132/255, blue: 94/255), 11: Color(red: 37/255, green: 122/255, blue: 1)]
            return colorDict[num]!
        }
        
        // Function to set intiial positions
        func setPosition(num: Int) -> Position {
            let posDict : [Int:Position] = [0: Position(x: 60, y: 56), 1: Position(x: 200, y: 56), 2: Position(x: 380, y: 56), 3: Position(x: 540, y: 56), 4: Position(x: 60, y: 216), 5: Position(x: 220, y: 196), 6: Position(x: 380, y: 216), 7: Position(x: 540, y: 216), 8: Position(x: 40, y: 396), 9: Position(x: 200, y: 396), 10: Position(x: 360, y: 396), 11: Position(x: 500, y: 416)]
            return posDict[num]!
        }
        puzzleOutlines = PuzzleOutline.allPuzzleOutlines
        // Add the empty shape to the array
        puzzleOutlines.insert(PuzzleOutline(name: "empty", size: Size(width: 0, height: 0), outlines: []), at: 0)
        pentominoPieces = []
        for i in 0...PentominoOutline.allPentominoOutlines.count-1 {
            pentominoPieces.append(Piece(fillColor: pickColor(num: i), position: setPosition(num: i), outline: PentominoOutline.allPentominoOutlines[i], widthOfUnit: 40, heightOfUnit: 40))
        }
        solutions = Solutions.allSolutions
    }
}




