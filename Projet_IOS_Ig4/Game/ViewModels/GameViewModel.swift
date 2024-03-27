//
//  GameViewModel.swift
//  Projet_IOS_Ig4
//
//  Created by Lucas Leroy on 27/03/2024.
//

import Foundation

class GameViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var filteredGames: [Game] = []

    func loadGames() {
        guard let url = URL(string: "https://montpellier-game-fest-volunteers-api-vincentdub2.vercel.app/games") else {
            print("URL invalide")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                print("Aucune donnée en réponse: \(error?.localizedDescription ?? "Erreur inconnue")")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("StatusCode n'est pas 200; statusCode = \(httpResponse.statusCode)")
                return
            }

            do {
                let decodedGames = try JSONDecoder().decode([Game].self, from: data)
                DispatchQueue.main.async {
                    self?.games = decodedGames
                    self?.filteredGames = decodedGames
                }
            } catch {
                print("Échec du décodage: \(error)")
            }
        }.resume()
    }

    func searchGames(with query: String) {
        if query.isEmpty {
            filteredGames = games
        } else {
            filteredGames = games.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
    }
}

struct Game: Codable, Identifiable {
    var id: Int {
        return idGame
    }
    let idGame: Int
    let name: String
    let author: String
    let publisher: String
    let numberOfPlayers: String
    let minAge: String
    let duration: String
    let type: String
    let instructionLink: String
    let playArea: String
    let volunteerArea: String
    let idZone: Int
    let toAnimate: Bool
    let received: Bool
    let mechanisms: String
    let themes: String
    let tags: String
    let description: String
    let imageUrl: String
    let logoUrl: String
    let videoUrl: String
}

