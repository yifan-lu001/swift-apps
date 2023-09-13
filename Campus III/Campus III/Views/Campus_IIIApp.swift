//
//  Campus_IIIApp.swift
//  Campus III
//
//  Created by Yifan Lu on 3/11/23.
//

import SwiftUI

@main
struct Campus_IIApp: App {
    @StateObject var campusManager = CampusManager()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(campusManager)
        }
    }
}
