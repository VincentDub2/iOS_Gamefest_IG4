//
//  GameDetailView.swift
//  Projet_IOS_Ig4
//
//  Created by Lucas Leroy on 27/03/2024.
//

import Foundation

import SwiftUI

struct GameDetailView: View {
    var game: Game

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(game.name)
                    .font(.title)

            
                Text("Auteur: \(game.author)")
                Text("Éditeur: \(game.publisher)")
                Text("Nombre de joueurs: \(game.numberOfPlayers)")
                Text("Âge minimum: \(game.minAge)")
                Text("Durée: \(game.duration)")
                Text("Type: \(game.type)")
                Text("Zone de jeu: \(game.playArea)")
                Text("Zone de bénévoles: \(game.volunteerArea)")
                Text("Mécanismes: \(game.mechanisms)")
                Text("Thèmes: \(game.themes)")
                Text("Description: \(game.description)")

                if let url = URL(string: game.instructionLink) {
                    Link("Instructions", destination: url)
                }
            }
            .padding()
        }
    }
}

