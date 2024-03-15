//
//  FestivalView.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 15/03/2024.
//

import SwiftUI

struct FestivalView: View {
    @StateObject private var festivalViewModel = FestivalViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            if let festival = festivalViewModel.festival {
                Text("Name: \(festival.name)")
                Text("Address: \(festival.address)")
                Text("Postal Code: \(festival.postalCode)")
                Text("City: \(festival.city)")
                Text("Country: \(festival.country)")
                Text("Active: \(festival.isActive ?? false ? "Yes" : "No")")
                Text("Start Date: \(festival.dateDebut)")
                Text("End Date: \(festival.dateFin)")
            } else {
                Text("Loading festival...")
                    .onAppear {
                        festivalViewModel.fetchFestival()
                    }
            }
        }
    }
}

struct FestivalView_Previews: PreviewProvider {
    static var previews: some View {
        FestivalView()
    }
}
