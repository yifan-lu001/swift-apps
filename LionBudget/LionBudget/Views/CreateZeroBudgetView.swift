//
//  CreateZeroBudgetView.swift
//  LionBudget
//
//  Created by Yifan Lu on 4/6/23.
//

import SwiftUI

struct CreateZeroBudgetView: View {
    @EnvironmentObject var budgetManager: BudgetManager
    @Environment(\.dismiss) private var dismiss
    @State private var isSubtitleHidden = false
    @State private var value = 0
    
    private var numberFormatter: NumberFormatter
    
    init(numberFormatter: NumberFormatter = NumberFormatter()) {
        self.numberFormatter = numberFormatter
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.maximumFractionDigits = 2
    }

    var body: some View {
        VStack(spacing: 20) {
            
            Text("Set Total Income")
                .font(.title)
                .multilineTextAlignment(.center)
            
            CurrencyTextField(numberFormatter: numberFormatter, value: $value)
                .padding(20)
                .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2))
                .frame(height: 100)
            
            Rectangle()
                .frame(width: 0, height: 40)
            
            Button(action: {
                budgetManager.createZeroBudget(total: Double(value) / 100)
                dismiss()
                }) {
                    Text("Set")
                        .fontWeight(.bold)
                        .padding(30)
                        .frame(width: 180, height: 50)
                        .background(Color.logoColor)
                        .cornerRadius(20)
                        .foregroundColor(.white)
            }
            Spacer()
        }
        .padding(.top, 60)
        .padding(.horizontal, 20)
        .navigationTitle("Set Income")
    }
}

struct CreateZeroBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        CreateZeroBudgetView().environmentObject(BudgetManager())
    }
}
