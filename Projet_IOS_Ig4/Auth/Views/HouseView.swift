//
//  HouseView.swift
//  Projet_IOS_Ig4
//
//  Created by Lucas Leroy on 23/03/2024.
//

import SwiftUI

struct Festival: Codable, Identifiable {
    var id: Int { idFestival }
    let idFestival: Int
    let name: String
    let address: String
    let city: String
    let postalCode: String
    let country: String
    let isActive: Bool
    let dateDebut: Date
    let dateFin: Date
    var isUserRegistered: Bool = false

    enum CodingKeys: String, CodingKey {
        case idFestival
        case name
        case address
        case city
        case postalCode
        case country
        case isActive
        case dateDebut
        case dateFin
        // Exclut `isUserRegistered` du décodage et de l'encodage
    }
}

struct VolunteersOfFestival: Codable {
    let idUser: String
    let user: User

    struct User: Codable {
        let id: String
    }
}

struct HouseView: View {
    @State private var searchQuery = ""
    @State private var festivals = [Festival]()
    @State private var selectedFestivalId: Int? = nil
    @ObservedObject var eventViewModel = EventViewModel.shared // Pour les événements
    @ObservedObject var gameViewModel = GameViewModel()
    var festivalViewModel = FestivalViewModel.shared
    @State private var searchQueryGame: String = ""

    var filteredFestivals: [Festival] {
        if searchQuery.isEmpty {
            return festivals
        } else {
            return festivals.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
        }
    }

    var filteredGames: [Game] {
        if searchQueryGame.isEmpty {
            return gameViewModel.games
        } else {
            return gameViewModel.games.filter { $0.name.localizedCaseInsensitiveContains(searchQueryGame) }
        }
    }
    
    var body: some View {
            NavigationView {
                VStack {
                    TextField("Festivals disponibles", text: $searchQuery)
                        .padding(7)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    List(filteredFestivals) { festival in
                        VStack(alignment: .leading) {
                            Text(festival.name)
                                .font(.headline)
                                .onTapGesture {
                                    selectedFestivalId = selectedFestivalId == festival.id ? nil : festival.id
                                }
                            if self.selectedFestivalId == festival.id {
                                // Détails du festival sélectionné ici
                                VStack(alignment: .leading) {
                                    Text("Adresse: \(festival.address), \(festival.postalCode)")
                                    Text("Ville: \(festival.city)")
                                    Text("Pays: \(festival.country)")
                                    Text("Statut: \(festival.isActive ? "Actif" : "Inactif")")
                                    Text("Début: \(formatDate(festival.dateDebut))")
                                    Text("Fin: \(formatDate(festival.dateFin))")
                                }
                                    .padding(.bottom, 20)
                                    .onTapGesture {
                                        selectedFestivalId = selectedFestivalId == festival.id ? nil : festival.id
                                    }
                                if !festival.isUserRegistered {
                                    NavigationLink(destination: SignupFestivalView(festivalViewModel: festivalViewModel, festivalId: festival.id)) {
                                        Text("S'inscrire")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    Text("Prochaines Soirées")
                        .font(.headline)
                        .padding(.vertical)

                    // ScrollView horizontal pour les événements/soirées
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 10) {
                            ForEach(eventViewModel.events) { event in
                                NavigationLink(destination: EventDetailView(event: event)) {
                                    SoireeView(event: event)
                                }
                            }
                        }
                        .padding([.horizontal, .bottom])
                    }
                    .frame(height: 160)
                    Text("Jeux Disponibles")
                                        .font(.headline)
                                        .padding(.vertical)
                                    
                    // Barre de recherche pour les jeux
                            TextField("Rechercher un jeu", text: $searchQueryGame)
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
                                                        // Ici, ajoute d'autres détails si nécessaire
                                                    }
                                                    .padding()
                                                }
                                            }
                                        }
                                    }
                                    .frame(height: 120) // Ajuste cette hauteur selon tes besoins
                                }
                
                .navigationTitle("Festivals")
                .onAppear {
                    loadFestivals()
                    eventViewModel.loadUpcomingEvents()
                    gameViewModel.loadGames()
                }
            }
        }

    func loadFestivals() {
        guard let url = URL(string: "https://montpellier-game-fest-volunteers-api-vincentdub2.vercel.app/festivals") else {
            print("URL invalide")
            return
        }

        let decoder = JSONDecoder()

        // Définissez un DateFormatter personnalisé
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // Adaptez ce format au format exact de vos dates
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try decoder.decode([Festival].self, from: data)
                    DispatchQueue.main.async {
                        self.festivals = decodedResponse
                        self.checkUserRegistration(festivals: self.festivals, userId: SessionManager.shared.user!.id)
                    }
                } catch {
                    print("Échec du décodage: \(error)")
                }
            } else if let error = error {
                print("Échec du chargement des données: \(error.localizedDescription)")
            }
        }.resume()
    }


// Prévisualisation de la vue
    func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    }

extension HouseView {
    func checkUserRegistration(festivals: [Festival], userId: String) {
        for (index, festival) in festivals.enumerated() {
            let url = URL(string: "https://montpellier-game-fest-volunteers-api-vincentdub2.vercel.app/festivals/\(festival.idFestival)/volunteers")!
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        // Décoder la liste des bénévoles
                        let volunteers = try JSONDecoder().decode([VolunteersOfFestival].self, from: data)
                        // Vérifier si l'utilisateur courant est dans la liste des bénévoles
                        DispatchQueue.main.async {
                            self.festivals[index].isUserRegistered = volunteers.contains(where: { $0.user.id == userId })
                        }
                    } catch {
                        print("Erreur lors du décodage des bénévoles: \(error)")
                    }
                }
            }.resume()
        }
    }
}
