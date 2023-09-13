//
//  LionBudgetApp.swift
//  LionBudget
//
//  Created by Yifan Lu on 3/21/23.
//

import SwiftUI

@main
struct LionBudgetApp: App {
    @StateObject var budgetManager = BudgetManager()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(budgetManager)
                .onChange(of: scenePhase) { currentPhase in
                    if currentPhase == .inactive {
                        budgetManager.encodeToFile()
                        }
                }
        }
    }
}
