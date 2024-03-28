//
//  HouseView.swift
//  Projet_IOS_Ig4
//
//  Created by Lucas Leroy on 23/03/2024.
//

import SwiftUI

enum SelectedView {
    case festivals, events, games
}

struct HouseView: View {
    @State private var selectedView: SelectedView = .festivals

    var body: some View {
        NavigationView {
            VStack {
                Picker("Sélectionnez une vue", selection: $selectedView) {
                    Text("Festivals").tag(SelectedView.festivals)
                    Text("Événements").tag(SelectedView.events)
                    Text("Jeux").tag(SelectedView.games)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                switch selectedView {
                case .festivals:
                    HouseFestivalView()
                case .events:
                    HouseEventsView()
                case .games:
                    HouseGamesView()
                }

                Spacer()
            }
            .navigationTitle("Accueil")
        }
    }
}
