//
//  HouseGamesView.swift
//  Projet_IOS_Ig4
//
//  Created by Vincent on 28/03/2024.
//

import Foundation
import SwiftUI

struct HouseGamesView: View {
    @ObservedObject var gameViewModel = GameViewModel()
    var festivalViewModel = FestivalViewModel.shared
    @State private var searchQueryGame: String = ""

    var filteredGames: [Game] {
        if searchQueryGame.isEmpty {
            return gameViewModel.games
        } else {
            return gameViewModel.games.filter { $0.name.localizedCaseInsensitiveContains(searchQueryGame) }
        }
    }

    var body: some View {
        VStack {
            Text("Jeux Disponibles")
                .font(.title2)
                .padding(.vertical)
                .fontWeight(.bold)
            
            // Barre de recherche pour les jeux
            TextField("Rechercher un jeu...", text: $searchQueryGame)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .onChange(of: searchQueryGame) { newValue in
                    gameViewModel.searchGames(with: newValue)
                }
            
            ScrollView {
                LazyVStack {
                    ForEach(gameViewModel.filteredGames) { game in
                        NavigationLink(destination: GameDetailView(game: game)) {
                            VStack(alignment: .leading) {
                                Text(game.name)
                                    .font(.headline)
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .onAppear {
            gameViewModel.loadGames()
        }
    }
}
