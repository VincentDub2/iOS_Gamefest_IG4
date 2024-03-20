//
//  SignupFestivalView.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 19/03/2024.
//

import SwiftUI

struct Poste: Decodable {
    let idPoste: Int
    var name: String
    let description: String
    let capacityPoste: Int
}

struct SignupFestivalView: View {
    @StateObject var festivalViewModel = FestivalViewModel()
    @State private var postes: [Poste] = []
    @State private var creneaux: [Creneau] = []
    @State private var teeShirtSize: String = "XS"
    @State private var isVegetarian: Bool = false
    let festivalName: String
    let startDate: String
    let endDate: String
        
    // Custom widths for each column
    let columnWidths: [CGFloat] = [200, 150]
    
    private var creneauxSeparated: [(String, [Creneau])] {
        var result: [(String, [Creneau])] = []
        for creneau in creneaux {
            let date = DateUtils.formatDate(creneau.timeStart) ?? "Unknown"
            let existingIndex = result.firstIndex { $0.0 == date }
            if let index = existingIndex {
                result[index].1.append(creneau)
            } else {
                result.append((date, [creneau]))
            }
        }
        print(result)
        return result
    }
    
    var body: some View {
        if let festival = festivalViewModel.festival, !postes.isEmpty && !creneaux.isEmpty {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    // Festival information
                    Text(festival.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Du \(DateUtils.formatDate(festival.dateDebut)!) au \(DateUtils.formatDate(festival.dateFin)!)")
                    
                    // Tee shirt size selection
                    HStack() {
                        Text("Taille de t-shirt")
                        Spacer()
                        Picker("Tee Shirt Size", selection: $teeShirtSize) {
                            Text("XS").tag("XS")
                            Text("S").tag("S")
                            Text("M").tag("M")
                            Text("L").tag("L")
                            Text("XL").tag("XL")
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    // Vegetarian selection
                    Toggle("Vegetarien", isOn: $isVegetarian)
                    
                    // Postes selection
                    Text("Choix des postes")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ForEach(creneauxSeparated.indices, id: \.self) { index in
                        let tuple = creneauxSeparated[index]
                        let day = tuple.0 // Extracting the day string from the tuple
                        let creneauxForDay = tuple.1 // Extracting the array of creneaux for this day
                        
                        // Display the day of the matrix
                        Text(day)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        ScrollView(.horizontal) {
                            VStack {
                                Text("") // Empty column
                                    .frame(width: columnWidths[0])
                                
                                // Header row with creneaux
                                HStack {
                                    Spacer()
                                    ForEach(creneauxForDay, id: \.id) { creneau in
                                        Text("\(DateUtils.formatTime(creneau.timeStart) ?? "") - \(DateUtils.formatTime(creneau.timeEnd) ?? "")")
                                            .font(.headline)
                                            .frame(width: columnWidths[1], alignment: .center)
                                    }
                                }
                                
                                // Data rows
                                ForEach($postes, id: \.idPoste) { $poste in
                                    HStack {
                                        Text(poste.name)
                                            .padding()
                                            .frame(width: columnWidths[0])
                                        
                                        Spacer()
                                        
                                        ForEach(creneauxForDay, id: \.id) { creneau in
                                            CircularProgressView(current: 7, max: poste.capacityPoste)
                                                .padding()
                                                .frame(width: columnWidths[1])
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }

                    }
                    
                    // Signup button
                    Button(action: {
                        print("Signup button tapped")
                    }) {
                        Text("Je m'inscris au festival")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        } else {
            ProgressView("Chargement du festival...")
                .progressViewStyle(CircularProgressViewStyle())
                .onAppear {
                    festivalViewModel.fetchFestival()
                    fetchPostesAndCreneaux()
                }
        }
    }
    
    func fetchPostesAndCreneaux() {
            FestivalService().fetchPostesByFestival(id: "5") { result in
                switch result {
                case .success(let fetchedPostes):
                    postes = fetchedPostes
                case .failure(let error):
                    print("Failed to fetch postes: \(error)")
                }
            }
            
            FestivalService().fetchCreneauxByFestival(id: "5") { result in
                switch result {
                case .success(let fetchedCreneaux):
                    creneaux = fetchedCreneaux
                    // Evaluate creneauxSeparated and print the result
                    let separated = creneauxSeparated
                    print(separated)
                case .failure(let error):
                    print("Failed to fetch creneaux: \(error)")
                }
            }
        }

}

struct SignupFestivalView_Previews: PreviewProvider {
    static var previews: some View {
        SignupFestivalView(festivalName: "Sample Festival", startDate: "01/01/2024", endDate: "03/01/2024")
    }
}
