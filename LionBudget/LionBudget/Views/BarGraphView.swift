//
//  BarGraphView.swift
//  LionBudget
//
//  Created by Yifan Lu on 4/11/23.
//

import SwiftUI
import Charts

struct BarGraphViewTotal: View {
    @EnvironmentObject var budgetManager: BudgetManager
    
    var body: some View {
        let history = budgetManager.getAllHistory()

        VStack {
            GroupBox ( "Total Spending") {
                Chart(history, id: \.category) { history in
                    ForEach(history.data) {
                        BarMark(
                            x: .value("Week Day", $0.dateTime),
                            y: .value("Step Count", $0.amount)
                        )
                        .foregroundStyle(history.category.budgetColor)
                    }
                }
            }
            .frame(height: 500)
            Spacer()
            ScrollView(.vertical) {
                CategoriesPieChartRows(categories: budgetManager.model.categories, color: Color.black)
            }
        }
        .padding()
    }
}

struct BarGraphView: View {
    let category: BudgetCategory
    
    var body: some View {
        VStack {
            GroupBox ( "\(category.name) Spending") {
                Chart(category.history) {
                    BarMark(
                        x: .value("Week Day", $0.dateTime),
                        y: .value("Step Count", $0.amount)
                    )
                    .foregroundStyle(category.budgetColor)
                }
            }
            .frame(height: 500)
            
            Spacer()
        }
        .padding()
    }
}

struct BarGraphView_Previews: PreviewProvider {
    static var previews: some View {
        BarGraphView(category: BudgetCategory.sampleFoodCategory)
    }
}
