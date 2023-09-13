//
//  CategoryHistoryView.swift
//  LionBudget
//
//  Created by Yifan Lu on 4/5/23.
//

import SwiftUI

struct DeleteButton: View {
    @Binding var category: BudgetCategory
    var transaction: Transaction
    var body: some View {
        Button(action: {
            let i = category.history.firstIndex(of: transaction)
            category.history.remove(at: i!)
            category.currentSpending = category.currentSpending - transaction.amount
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
        }
    }
}

struct CategoryHistoryView: View {
    @Binding var category: BudgetCategory
    
    var body: some View {
        VStack {
            HStack {
                Text(" Amount")
                    .bold()
                    .font(.headline)
                    .frame(width: 75, alignment: .leading)
                Text("Time")
                    .bold()
                    .font(.headline)
                    .frame(width: 100, alignment: .leading)
                Text("Date")
                    .bold()
                    .font(.headline)
                    .frame(width: 160, alignment: .leading)
                DeleteButton(category: $category, transaction: Transaction.sampleTransaction1)
                    .opacity(0)
                    .disabled(true)
            }
            Divider()
            ForEach(category.history) { transaction in
                HStack {
                    Text("\(transaction.amountString)")
                        .frame(width: 75, alignment: .trailing)
                    Text("\(transaction.time)")
                        .frame(width: 100, alignment: .trailing)
                    Text("\(transaction.date)")
                        .frame(width: 160, alignment: .leading)
                    DeleteButton(category: $category, transaction: transaction)
                }
            }
            Spacer()
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct CategoryHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHistoryView(category: .constant(BudgetCategory.sampleFoodCategory))
    }
}
