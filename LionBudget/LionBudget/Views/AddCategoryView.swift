//
//  AddCategoryView.swift
//  LionBudget
//
//  Created by Yifan Lu on 4/5/23.
//

import SwiftUI

struct AddCategoryButton: View {
    @EnvironmentObject var budgetManager: BudgetManager
    @Environment(\.dismiss) private var dismiss
    var category: BudgetCategory
    var color: Color
    
    var body: some View {
        Button(action: {
            budgetManager.addCategory(category: budgetManager.createCategoryFromColor(category: category, color: color))
            dismiss()
            }) {
                Text("Add Category")
                    .foregroundColor(.red)
        }
    }
}

struct AddCategoryView: View {
    @State var category: BudgetCategory = BudgetCategory.emptyCategory
    @State var categoryColor: Color = .black
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Category Name")) {
                    TextField(text: $category.name, prompt: Text("Name")) {
                        Text("Category Name")
                    }
                }
                Section(header: Text("Maximum Spending")) {
                    NavigationLink {
                        AddItemToCategoryView($category, 0)
                    } label: {
                        Text(category.maxSpendingString)
                    }
                }
                Section(header: Text("Current Spending")) {
                    NavigationLink {
                        AddItemToCategoryView($category, 1)
                    } label: {
                        Text(category.currentSpendingString)
                    }
                }
                Section(header: Text("Color")) {
                    ColorPicker("Set the category color", selection: $categoryColor, supportsOpacity: false)
                }
                Section {
                    AddCategoryButton(category: category, color: categoryColor)
                }
            }
            .navigationTitle("\(category.name)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView()
    }
}
