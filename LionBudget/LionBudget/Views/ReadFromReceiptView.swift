//
//  ReadFromReceiptView.swift
//  LionBudget
//
//  Created by Yifan Lu on 3/21/23.
//

import SwiftUI

struct ItemRow: View {
    @EnvironmentObject var budgetManager: BudgetManager
    @State var cat: BudgetCategory?
    @State var added: Bool = false
    let price: Double
    
    var body: some View {
        HStack {
            Text("Item Price: ")
                .bold()
            Text("$\(String(format: "%.2f", price))")
                .frame(width: 85, alignment: .trailing)
            Spacer()
            Menu (cat != nil ? cat!.name : "Category") {
                ForEach(budgetManager.model.categories) { category in
                    Button(action: {
                        cat = category
                    }, label: {
                        Text("\(category.name)")
                            .frame(width: 100, alignment: .trailing)
                    })
                }
            }
            Spacer()
            if added {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
            }
            else {
                Button(action: {
                    budgetManager.addTransaction(price: price, categoryName: cat!.name)
                    added = true
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                })
                .disabled(cat == nil)
            }
        }
        .padding([.leading, .trailing], 15)
    }
}

struct ReadFromReceiptDoneButton: View {
    @EnvironmentObject var budgetManager : BudgetManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(action: {
            dismiss()
            }) {
                Text("Done")
                    .foregroundColor(.blue)
                    .bold()
        }
    }
}

struct ReadFromReceiptView: View {
    let prices: [ReceiptItem]
    var body: some View {
        VStack {
            Text("List of Items on Receipt")
                .bold()
                .underline()
                .font(.title3)
            ScrollView(.vertical) {
                ForEach(prices) { item in
                    ItemRow(price: item.amount)
                }
            }
            ReadFromReceiptDoneButton()
        }
    }
}

struct ReadFromReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ReadFromReceiptView(prices: [ReceiptItem(id: 1, amount: 6.99), ReceiptItem(id: 2, amount: 5.49), ReceiptItem(id: 3, amount: 5.99), ReceiptItem(id: 4, amount: 3.99), ReceiptItem(id: 5, amount: 5.89)])
    }
}
