//
//  ScanReceiptView.swift
//  LionBudget
//
//  Created by Yifan Lu on 4/11/23.
//

import SwiftUI
import VisionKit

struct ScanReceiptView: View {
    @EnvironmentObject var budgetManager: BudgetManager
    
    @State private var startScanning = false
    @State private var scanText = ""
    
    var body: some View {
        
        VStack(spacing: 0) {
            DataScanner(startScanning: $startScanning, scanText: $scanText)
                .frame(height: 400)
            
            ReadFromReceiptView(prices: budgetManager.parseText(text: scanText))
                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                    .padding([.top, .bottom], 10)

        }
        .task {
            if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                startScanning.toggle()
            }
        }

    }
}

struct ScanReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ScanReceiptView().environmentObject(BudgetManager())
    }
}
