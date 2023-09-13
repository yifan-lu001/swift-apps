//
//  BuildingListView.swift
//  Campus III
//
//  Created by Yifan Lu on 3/11/23.
//

import SwiftUI

struct BuildingListButton: View {
    @EnvironmentObject var campusManager: CampusManager
    var body: some View {
        Button(action: {
            campusManager.showBuildings.toggle()
            }) {
                Image(systemName: "building.2.crop.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
        }
    }
}

struct BuildingDoneButton: View {
    @EnvironmentObject var campusManager: CampusManager
    var body: some View {
        Button(action: {
            campusManager.showBuildings.toggle()
            }) {
                Text("Done")
                    .foregroundColor(.blue)
                    .padding([.bottom,.top, .trailing], 20)
        }
    }
}

struct WhichBuildingsButton: View {
    @EnvironmentObject var campusManager: CampusManager
    let text : String
    let num : Int
    var body: some View {
        Button(text) {
            if num == 2 {
                campusManager.updateNearby()
            }
            campusManager.whichBuildings = num
        }
        .buttonStyle(.bordered)
    }
}

struct BuildingListView: View {
    @EnvironmentObject var campusManager: CampusManager
    @Binding var selection : Set<Building>
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    WhichBuildingsButton(text: "All", num: 0)
                        .padding(.leading)
                    WhichBuildingsButton(text: "Favorites", num: 1)
                    WhichBuildingsButton(text: "Nearby", num: 2)
                    Spacer()
                    BuildingDoneButton()
                }
                if campusManager.whichBuildings == 0 {
                    List(campusManager.campusModel.buildings, id: \.self, selection: $selection) { building in
                        Text(building.name)
                    }
                    .environment(\.editMode, Binding.constant(EditMode.active))
                }
                else if campusManager.whichBuildings == 1 {
                    List(campusManager.campusModel.favoriteBuildings, id: \.self, selection: $selection) { building in
                        Text(building.name)
                    }
                    .environment(\.editMode, Binding.constant(EditMode.active))
                }
                else if campusManager.whichBuildings == 2 {
                    List(campusManager.campusModel.nearbyBuildings, id: \.self, selection: $selection) { building in
                        Text(building.name)
                    }
                    .environment(\.editMode, Binding.constant(EditMode.active))
                }
            }
            .background(Color(red: 0.9569, green: 0.9451, blue: 0.97))
        }
    }
}

struct BuildingListView_Previews: PreviewProvider {
    static var previews: some View {
        BuildingListView(selection: .constant(Set(arrayLiteral: Building.sampleBuilding))).environmentObject(CampusManager())
    }
}
