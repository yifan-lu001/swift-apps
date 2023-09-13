//
//  PlaceDetailsView.swift
//  Campus III
//
//  Created by Yifan Lu on 3/11/23.
//

import SwiftUI

struct PlaceDoneButton: View {
    @EnvironmentObject var campusManager: CampusManager
    var body: some View {
        Button(action: {
            campusManager.showDetails.toggle()
            }) {
                Text("Done")
                    .foregroundColor(.blue)
                    .padding([.bottom,.top, .trailing], 20)
        }
    }
}

struct PlaceDetailsView: View {
    @EnvironmentObject var campusManager: CampusManager
    var place : Place?
    
    private var title : String {
        guard place != nil else { return "Unknown" }
        return place!.name
    }
    
    private var isFavorite : Bool {
        guard place != nil else {return false}
        return place!.favorite
    }
    
    private var photo : String {
        guard place != nil else { return "Unknown" }
        return place!.photo!
    }
    
    @State var angle = 90.0
    var repeatingAnimation: Animation {
        Animation
            .easeInOut(duration: 2)
            .repeatForever()
    }
    
    @State var favorite : Bool = false
    
    var body: some View {
        
        return VStack {
            HStack {
                Spacer()
                PlaceDoneButton()
            }
            Image(systemName: favorite ? "star.fill" : "circle.grid.hex.fill")
                .font(.system(size:30))
                .padding()
                .rotationEffect(.degrees(angle))
                .foregroundColor(favorite ? .yellow : .blue)
            Text(title)
                .font(.system(size:30))
                .bold()
                .underline()
                .multilineTextAlignment(.center)
            Spacer()
            Image(photo == "" ? "NoImageAvailable" : photo)
                .resizable()
                .frame(width: 343.5, height: 250)
            Spacer()
            Button(favorite ? "Unfavorite" : "Favorite") {
                campusManager.toggleFavorite(place: place!)
                favorite.toggle()
            }
            .buttonStyle(.bordered)
            Spacer()
        }
        .onAppear {
            withAnimation(self.repeatingAnimation) { self.angle = -90 }
            favorite = place!.favorite
        }
    }
}

struct PlaceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailsView(place: Place.standard).environmentObject(CampusManager())
    }
}
