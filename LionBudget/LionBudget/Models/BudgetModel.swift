//
//  BudgetModel.swift
//  LionBudget
//
//  Created by Yifan Lu on 3/21/23.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation
import Charts

/*----- Budgeting Model -----*/

// Struct for a transaction
struct Transaction : Codable, Identifiable, Equatable, Hashable {
    var id : UUID = UUID()
    var amount: Double
    var time: String
    var date: String
    
    static let sampleTransaction1 = Transaction(amount: 49.99, time: "11:20:14 AM", date: "September 30, 2022")
    static let sampleTransaction2 = Transaction(amount: 5.15, time: "3:20:14 PM", date: "January 16, 2021")
}

// Computed properties for Transaction
extension Transaction {
    var amountString: String { String(format: "$%.2f", amount) }
    var dateTime: String { date + " " + time }
}

// Struct for the global bar chart
struct HistoryType : Codable, Identifiable, Equatable, Hashable {
    var id : UUID = UUID()
    var category: BudgetCategory
    var data: [Transaction]
}

// Struct for an item read from receipt
struct ReceiptItem: Identifiable {
    var id: Int
    var amount: Double
    
    static let sampleReceiptItem = ReceiptItem(id: 0, amount: 40.00)
}


// Struct for a budget category
struct BudgetCategory : Codable, Identifiable, Comparable, Hashable {
    static func < (lhs: BudgetCategory, rhs: BudgetCategory) -> Bool {
        return lhs.name < rhs.name
    }
    
    var id : UUID = UUID()
    var name : String
    var maxSpending : Double
    var currentSpending : Double
    var r: Double
    var g: Double
    var b: Double
    var history: [Transaction]
        
    static let sampleFoodCategory = BudgetCategory(name: "Food", maxSpending: 500, currentSpending: 0, r: 0, g: 0, b: 1, history: [])
    static let sampleHousingCategory = BudgetCategory(name: "Housing", maxSpending: 500, currentSpending: 0, r: 0, g: 1, b: 0, history: [])
    static let sampleSuppliesCategory = BudgetCategory(name: "School Supplies", maxSpending: 500, currentSpending: 0, r: 0.5, g: 0.5, b: 0.5, history: [])
    static let sampleTransportationCategory = BudgetCategory(name: "Transportation", maxSpending: 500, currentSpending: 0, r: 1, g: 165/255, b: 0, history: [])
    static let sampleEntertainmentCategory = BudgetCategory(name: "Entertainment", maxSpending: 500, currentSpending: 0, r: 1, g: 0, b: 0, history: [])
    static let sampleMiscellaneousCategory = BudgetCategory(name: "Miscellaneous", maxSpending: 500, currentSpending: 0, r: 1, g: 192/255, b: 203/255, history: [])
    static let emptyCategory = BudgetCategory(name: "", maxSpending: 0, currentSpending: 0, r: 0, g: 0, b: 0, history: [])
}

// Computed properties for BudgetCategory
extension BudgetCategory {
    var maxSpendingString : String { String(format: "$%.2f", maxSpending) }
    var currentSpendingString : String { String(format: "$%.2f", currentSpending) }
    var budgetColor : Color { Color(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b)) }
}

/*----- Map Model -----*/

// represents a coordinate
struct Coord {
    var latitude : Double
    var longitude : Double
}

// Bundle extension to decode JSON file
extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the project.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) in the project.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) in the project.")
        }
        
        return loadedData
    }
    
    func decodeWithString<T: Decodable>(contents: String) -> T {
        let data = contents.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode the String in the project.")
        }
        
        return loadedData
    }
    
    func decodeWithData<T: Decodable>(data: Data) -> T {
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode the data in the project.")
        }
        
        return loadedData
    }
}

struct BudgetModel {
    var categories : [BudgetCategory]
    var centerCoord: Coord
    
    init() {
        func getData() -> [BudgetCategory] {
            var categories : [BudgetCategory] = []
            let fm = FileManager.default
            let containerURL = fm.containerURL(forSecurityApplicationGroupIdentifier: "group.edu.psu.yjl5480.MyGroup")
            var fileURL = containerURL!.appendingPathComponent("categories")
            fileURL = fileURL.appendingPathExtension("json")
            do {
                try categories = Bundle.main.decodeWithString(contents: String(contentsOf: fileURL))
            }
            catch {
                // print(error)
            }
            return categories
        }
        
        func defaultData() -> [BudgetCategory] {
            return [BudgetCategory.sampleFoodCategory, BudgetCategory.sampleHousingCategory, BudgetCategory.sampleSuppliesCategory, BudgetCategory.sampleTransportationCategory, BudgetCategory.sampleEntertainmentCategory, BudgetCategory.sampleMiscellaneousCategory]
        }
        categories = getData()
        if categories.count == 0 {
            categories = defaultData()
        }
        centerCoord = Coord(latitude: 40.7964685139719, longitude: -77.8628317618596)
    }
}
