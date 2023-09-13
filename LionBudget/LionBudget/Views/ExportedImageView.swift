//
//  ExportedImageView.swift
//  LionBudget
//
//  Created by Yifan Lu on 4/12/23.
//

import SwiftUI

struct PieChartRows: View {
    var colors: [Color]
    var names: [String]
    var values: [String]
    var percents: [String]
    var color: Color
    
    var body: some View {
        VStack{
            ForEach(0..<self.values.count){ i in
                HStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(self.colors[i])
                        .frame(width: 15, height: 15)
                    Text(self.names[i])
                        .font(.system(size: 14))
                        .foregroundColor(self.colors[i])
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(self.values[i])
                            .foregroundColor(color)
                            .font(.system(size: 10))
                            .bold()
                        Text(self.percents[i])
                            .foregroundColor(Color.black)
                            .font(.system(size: 10))
                    }
                }
            }
        }
    }
}

struct CategoriesPieChartRows: View {
    var categories: [BudgetCategory]
    var color: Color
    
    var body: some View {
        let values: [String] = categories.map { "$" + String(format: "%.2f", $0.currentSpending) }
        let names: [String] = categories.map { $0.name }
        let colors: [Color] = categories.map { $0.budgetColor }
        let doubleValues: [Double] = categories.map { $0.currentSpending }
        let totalSpending: Double = doubleValues.reduce(0, +)
        let percents: [String] = categories.map { String(format: "%.0f", totalSpending > 0 ? $0.currentSpending / totalSpending * 100 : 0) + "%"}
        PieChartRows(colors: colors, names: names, values: values, percents: percents, color: color)
    }
}

struct ExportedImageView: View {
    var categories: [BudgetCategory]
    var body: some View {
        ZStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.logoColor, Color.lightLogoColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
                if categories.count == 0 {
                    Text("No spending data")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.lightLogoColor)
                        .padding()
                }
                else {
                    CategoriesPieChartRows(categories: categories, color: Color.white)
                        .padding()
                }
            }
        }
    }
}

struct ExportedImageView_Previews: PreviewProvider {
    static var previews: some View {
        ExportedImageView(categories: [BudgetCategory.sampleFoodCategory])
    }
}
