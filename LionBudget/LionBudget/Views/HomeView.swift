//
//  HomeView.swift
//  LionBudget
//
//  Created by Yifan Lu on 3/21/23.
//

import SwiftUI

struct AddCategory: View {
    @EnvironmentObject var budgetManager : BudgetManager
    var body: some View {
        NavigationLink {
            AddCategoryView()
        } label: {
            Image(systemName: "plus")
        }
    }
}

struct ViewMap: View {
    @EnvironmentObject var budgetManager: BudgetManager
    var body: some View {
        NavigationLink {
            MapView()
        } label: {
            Image(systemName: "map")
        }
    }
}

struct CreateBudget: View {
    @EnvironmentObject var budgetManager : BudgetManager
    var body: some View {
        NavigationLink {
            CreateZeroBudgetView()
        } label: {
            Image(systemName: "dollarsign.circle")
        }
    }
}

struct ReadFromCamera: View {
    @EnvironmentObject var budgetManager : BudgetManager
    var body: some View {
        NavigationLink {
            ScanReceiptView()
        } label: {
            Image(systemName: "camera.circle")
        }
    }
}

struct SharePieChart: View {
    @EnvironmentObject var budgetManager: BudgetManager
    @Environment(\.displayScale) var displayScale
    @State private var renderedImage = Image(systemName: "photo")

    var body: some View {
        ShareLink(item: renderedImage, message: Text("Check out my spending on LionBudget!"), preview: SharePreview("My Spending", image: renderedImage)) {
            Image(systemName: "square.and.arrow.up")
        }
        .onAppear { render() }
    }
    
    @MainActor func render() {
        let renderer = ImageRenderer(content: ExportedImageView(categories: budgetManager.model.categories))
        
        // make sure and use the correct display scale for this device
        renderer.scale = displayScale

        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        }
    }
}

struct ResetCategories: View {
    @EnvironmentObject var budgetManager: BudgetManager
    var body: some View {
        Button(action: {
            budgetManager.resetCategories()
        }) {
                Image(systemName: "arrow.clockwise")
                    .foregroundColor(.blue)
        }
    }
}

struct ViewAllData: View {
    var body: some View {
        NavigationLink {
            BarGraphViewTotal()
        } label: {
            Image(systemName: "chart.bar.xaxis")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.green)
        }
    }
}

struct DeleteCategoryButton: View {
    @EnvironmentObject var budgetManager: BudgetManager
    var category: BudgetCategory
    
    var body: some View {
        Button(action: {
            budgetManager.removeCategory(category: category)
        }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
        }
    }
    
}

struct CategoriesPieChartView: View {
    var categories: [BudgetCategory]
    
    var body: some View {
        let values: [Double] = categories.map { $0.currentSpending }
        let names: [String] = categories.map { $0.name }
        let colors: [Color] = categories.map { $0.budgetColor }
        PieChartViewHome(values: values, names: names, formatter: {value in String(format: "$%.2f", value)}, colors: colors, backgroundColor: .white)
    }
}

struct CategoryView: View {
    @Binding var category: BudgetCategory
    
    var body: some View {
        VStack (alignment: .leading) {
            NavigationStack {
                HStack {
                    Text(category.name)
                        .bold()
                        .foregroundColor(.black)
                    NavigationLink {
                        EditCategoryView(category: $category)
                    } label: {
                        Image(systemName: "pencil.line")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.blue)
                    }
                    NavigationLink {
                        BarGraphView(category: category)
                    } label: {
                        Image(systemName: "chart.bar.xaxis")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                    }
                    DeleteCategoryButton(category: category)
                }
            }
            RoundedRectangle(cornerRadius: 15)
                .stroke(category.budgetColor)
                .frame(width: 350, height: 25)
                .overlay (alignment: .leading, content: {
                    if category.currentSpending > category.maxSpending {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(category.budgetColor)
                            .frame(width: 350, height: 25)
                            .opacity(0.5)
                    }
                    else {
                        if category.currentSpending / category.maxSpending * 350 >= 15 {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(category.budgetColor)
                                .frame(width: category.currentSpending / category.maxSpending * 350, height: 25)
                        }
                        else {
                            let x = category.currentSpending / category.maxSpending * 350 / 30
                            Circle()
                                .trim(from: 0, to: x)
                                .foregroundColor(category.budgetColor)
                                .frame(width: 25, height: 30)
                                .rotationEffect(Angle(degrees: 180 - 180 * x))
                        }
                    }
                })
                .overlay (alignment: .center, content: {
                    Text(String(format: "$%.2f", category.currentSpending) + " / " + String(format: "$%.2f", category.maxSpending))
                        .bold()
                })
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var budgetManager: BudgetManager
    
    let addCategoryItem = ToolbarItem(placement: .navigationBarTrailing) {
        AddCategory()
    }
    
    let viewMapItem = ToolbarItem(placement: .navigationBarLeading) {
        ViewMap()
    }
    
    let createBudgetItem = ToolbarItem(placement: .navigationBarLeading) {
        CreateBudget()
    }
    
    let cameraItem = ToolbarItem(placement: .navigationBarLeading) {
        ReadFromCamera()
    }
    
    let shareItem = ToolbarItem(placement: .navigationBarTrailing) {
        SharePieChart()
    }
    
    let resetItem = ToolbarItem(placement: .navigationBarTrailing) {
        ResetCategories()
    }
    
    let allDataItem = ToolbarItem(placement: .navigationBarTrailing) {
        ViewAllData()
    }
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.logoColor]
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("LogoWhite")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .ignoresSafeArea()
                let values: [Double] = budgetManager.model.categories.map { $0.currentSpending }
                let total = values.reduce(0, +)
                if total != 0 {
                    CategoriesPieChartView(categories: budgetManager.model.categories)
                        .scaleEffect(0.7)
                        .frame(height: 60)
                        .offset(x: 35, y: -165)
                }
                else {
                    Text("No Spending Data")
                        .offset(y: -70)
                        .bold()
                        .font(.title3)
                }
                ScrollView(.vertical) {
                    VStack {
                        ForEach($budgetManager.model.categories) { category in
                            CategoryView(category: category)
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                viewMapItem
                createBudgetItem
                cameraItem
                resetItem
                shareItem
                addCategoryItem
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(BudgetManager())
    }
}
