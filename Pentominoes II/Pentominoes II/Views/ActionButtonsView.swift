//
//  ActionButtonsView.swift
//  Pentominoes II
//
//  Created by Yifan Lu on 2/9/23.
//

import SwiftUI

struct ActionButtonsView: View {
    let buttonText: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(buttonText)
                .foregroundColor(Color.blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(.blue, lineWidth: 2)
                        .frame(width: 90, height: 45)
                )
        }
        .padding()
    }
}

struct ActionButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonsView(buttonText: "Reset", action: {})
    }
}
