//
//  AddItemToCategoryView.swift
//  LionBudget
//
//  Created by Yifan Lu on 3/21/23.
//

import SwiftUI

struct AddItemToCategoryView: View {
    @EnvironmentObject var budgetManager: BudgetManager
    @Environment(\.dismiss) private var dismiss
    var function: Int
    @Binding var category: BudgetCategory
    @State private var isSubtitleHidden = false
    @State private var value = 0
    
    private var numberFormatter: NumberFormatter
    
    init(numberFormatter: NumberFormatter = NumberFormatter(), _ category: Binding<BudgetCategory>, _ function: Int) {
        self.numberFormatter = numberFormatter
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.maximumFractionDigits = 2
        self._category = category
        self.function = function
    }

    var body: some View {
        VStack(spacing: 20) {
            
            if category.name.count == 0 {
                Text(function == 0 ? "Set Maximum Spending" : "Add Expense")
                    .font(.title)
                    .multilineTextAlignment(.center)
            }
            else {
                Text(function == 0 ? "Set Maximum Spending for \(category.name)" : "Add Expense to \(category.name)")
                    .font(.title)
                    .multilineTextAlignment(.center)
            }
            
            CurrencyTextField(numberFormatter: numberFormatter, value: $value)
                .padding(20)
                .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2))
                .frame(height: 100)
            
            Rectangle()
                .frame(width: 0, height: 40)
            
            Button(action: {
                if function == 0 {
                    category.maxSpending = Double(value) / 100
                }
                else {
                    category.currentSpending += (Double(value) / 100)
                    let transaction = Transaction(amount: (Double(value) / 100), time: budgetManager.getTime(), date: budgetManager.getDate())
                    category.history.append(transaction)
                }
                dismiss()
                }) {
                    Text("Add")
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
        .navigationTitle(function == 0 ? "Edit Max Spending" : "Add Expense")
    }
}


struct AddItemToCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemToCategoryView(.constant(BudgetCategory.sampleFoodCategory), 0).environmentObject(BudgetManager())
    }
}
