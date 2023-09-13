//
//  ButtonsView.swift
//  LionSpell III
//
//  Created by Yifan Lu on 1/25/23.
//

import SwiftUI

struct LetterButton: View {
    let l: String
    let shape: Int
    let color: Color
    var action: (String) -> Void
    var body: some View {
        Button(action: {
            action(l)
            }) {
                Text(l)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.white)
                    .background(color)
                    .clipShape(ButtonShape(sides: shape))
        }
    }
}

struct ButtonsView: View {
    @EnvironmentObject var lionSpellManager: LionSpellManager
    var body: some View {
        let letters = lionSpellManager.scramble.letters
        let action = lionSpellManager.pressALetterButton
        if letters.count == 5 {
            ZStack {
                LetterButton(l: letters[0], shape: 4, color: Color.blue, action: action)
                LetterButton(l: letters[1], shape: 4, color: Color.gray, action: action)
                    .offset(CGSize(width: 28.5, height: 28.5))
                LetterButton(l: letters[2], shape: 4, color: Color.gray, action: action)
                    .offset(CGSize(width: 28.5, height: -28.5))
                LetterButton(l: letters[3], shape: 4, color: Color.gray, action: action)
                    .offset(CGSize(width: -28.5, height: 28.5))
                LetterButton(l: letters[4], shape: 4, color: Color.gray, action: action)
                    .offset(CGSize(width: -28.5, height: -28.5))
            }
        }
        else if letters.count == 6 {
            ZStack {
                LetterButton(l: letters[0], shape: 0, color: Color.blue, action: action)
                LetterButton(l: letters[1], shape: 5, color: Color.gray, action: action)
                    .offset(CGSize(width: 43, height: 13.7))
                LetterButton(l: letters[2], shape: 5, color: Color.gray, action: action)
                    .offset(CGSize(width: 25.7, height: -36.5))
                LetterButton(l: letters[3], shape: 5, color: Color.gray, action: action)
                    .offset(CGSize(width: -25.7, height: -36.5))
                LetterButton(l: letters[4], shape: 5, color: Color.gray, action: action)
                    .offset(CGSize(width: -43, height: 13.7))
                LetterButton(l: letters[5], shape: 5, color: Color.gray, action: action)
                    .offset(CGSize(width: 0, height: 44))
            }
        }
        else {
            ZStack {
                LetterButton(l: letters[0], shape: 6, color: Color.blue, action: action)
                LetterButton(l: letters[1], shape: 6, color: Color.gray, action: action)
                    .offset(CGSize(width: 41.6, height: 24))
                LetterButton(l: letters[2], shape: 6, color: Color.gray, action: action)
                    .offset(CGSize(width: 41.6, height: -24))
                LetterButton(l: letters[3], shape: 6, color: Color.gray, action: action)
                    .offset(CGSize(width: 0, height: 47))
                LetterButton(l: letters[4], shape: 6, color: Color.gray, action: action)
                    .offset(CGSize(width: -41.6, height: 24))
                LetterButton(l: letters[5], shape: 6, color: Color.gray, action: action)
                    .offset(CGSize(width: -41.6, height: -24))
                LetterButton(l: letters[6], shape: 6, color: Color.gray, action: action)
                    .offset(CGSize(width: 0, height: -47))
            }
        }
    }
}

struct ButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonsView().environmentObject(LionSpellManager())
    }
}
