//
//  DistanceFromBuildingView.swift
//  Campus III
//
//  Created by Yifan Lu on 3/11/23.
//

import SwiftUI

struct HeadingArrow: View {
    @EnvironmentObject var campusManager : CampusManager
    var body: some View {
        
        Image(systemName: "arrow.up")
            .resizable()
            .frame(width: 25, height: 25)
            .rotationEffect(Angle(radians: campusManager.selectedBuildingHeading))
            .foregroundColor(.white)
    }
}

struct XButton: View {
    @EnvironmentObject var campusManager : CampusManager
    var body: some View {
        Button(action: {
            campusManager.removeBottomBar()
            }) {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
        }
    }
}

struct ShowDirectionsButton: View {
    @EnvironmentObject var campusManager : CampusManager
    var body: some View {
        Button(action: {
            campusManager.showDirections = true
            }) {
                Text("Show Directions")
                    .padding(5)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(5)
        }
    }
}

struct DistanceFromBuildingView: View {
    @EnvironmentObject var campusManager : CampusManager
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .opacity(campusManager.selectedBuildingDistance == "" ? 0 : 0.5)
            VStack {
                HeadingArrow()
                    .padding(.top, 10)
                Text("Traveling to \(campusManager.selectedBuilding.name):")
                    .bold()
                    .foregroundColor(.white)
                    .padding([.leading, .trailing], 10)
                Text(campusManager.selectedBuildingDistance)
                    .foregroundColor(.white)
                    .padding([.leading, .trailing], 10)
                ShowDirectionsButton()
                    .padding([.bottom, .leading, .trailing], 10)
            }
            .opacity(campusManager.selectedBuildingDistance == "" ? 0 : 1)
            XButton()
                .opacity(campusManager.selectedBuildingDistance == "" ? 0 : 1)
                .offset(x: 170, y: -51.5)
        }
    }
}

struct DistanceFromBuildingView_Previews: PreviewProvider {
    static var previews: some View {
        DistanceFromBuildingView().environmentObject(CampusManager())
    }
}
