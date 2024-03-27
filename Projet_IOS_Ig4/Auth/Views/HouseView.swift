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

    var filteredFestivals: [Festival] {
        if searchQuery.isEmpty {
            return festivals
        } else {
            return festivals.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Barre de recherche
                TextField("Rechercher un festival", text: $searchQuery)
                    .padding(7)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                List(filteredFestivals) { festival in
                    VStack {
                        Button(action: {
                            if selectedFestivalId == festival.id {
                                selectedFestivalId = nil
                            } else {
                                selectedFestivalId = festival.id
                            }
                        }) {
                            HStack {
                                Text(festival.name)
                                    .font(.headline)
                                Spacer()
                                if festival.isUserRegistered {
                                    Text("Inscrit").foregroundColor(.green)
                                } else {
                                    Button("S'inscrire") {
                                        
                                    }
                                    .foregroundColor(.blue)
                                }
                            }

                        }
                        if selectedFestivalId == festival.id {
                            VStack(alignment: .leading) {
                                Text("Adresse: \(festival.address), \(festival.postalCode)")
                                Text("Ville: \(festival.city)")
                                Text("Pays: \(festival.country)")
                                Text("Statut: \(festival.isActive ? "Actif" : "Inactif")")
                                Text("Début: \(formatDate(festival.dateDebut))")
                                Text("Fin: \(formatDate(festival.dateFin))")
                            }
                            .padding(.leading, 20)
                            .transition(.slide)
                        }
                    }
                }
            }
            .navigationTitle("Festivals")
            .onAppear {
                loadFestivals()
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

    struct HouseView_Previews: PreviewProvider {
        static var previews: some View {
            HouseView()
        }
    }
