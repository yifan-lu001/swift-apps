//
//  EditCategoryView.swift
//  LionBudget
//
//  Created by Yifan Lu on 3/21/23.
//

import SwiftUI

struct DoneButton: View {
    @EnvironmentObject var budgetManager : BudgetManager
    @Environment(\.dismiss) private var dismiss
    var category: BudgetCategory
    var color: Color
    
    var body: some View {
        Button(action: {
            budgetManager.updateCategoryColor(category: category, color: color)
            dismiss()
            }) {
                Text("Save")
                    .foregroundColor(.blue)
                    .bold()
        }
    }
}

struct DeleteCategory: View {
    @EnvironmentObject var budgetManager: BudgetManager
    @Environment(\.dismiss) private var dismiss
    var category: BudgetCategory
    
    var body: some View {
        Button(action: {
            budgetManager.removeCategory(category: category)
            dismiss()
            }) {
                Text("Delete Category")
                    .foregroundColor(.red)
        }
    }
}

struct EditCategoryView: View {
    @Binding var category: BudgetCategory
    @State var categoryColor: Color = .blue
    
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
                Section(header: Text("History")) {
                    NavigationLink {
                        CategoryHistoryView(category: $category)
                    } label: {
                        Text("View your spending history")
                    }
                }
                Section(header: Text("Color")) {
                    ColorPicker("Set the category color", selection: $categoryColor, supportsOpacity: false)
                }
                Section {
                    DeleteCategory(category: category)
                }
            }
            .navigationTitle("\(category.name)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    DoneButton(category: category, color: categoryColor)
                }
            }
            .onAppear {
                categoryColor = Color(red: category.r, green: category.g, blue: category.b)
            }
        }
    }
}

struct EditCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        EditCategoryView(category: .constant(BudgetCategory.sampleFoodCategory))
    }
}
