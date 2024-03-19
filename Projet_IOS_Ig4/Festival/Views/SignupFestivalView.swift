//
//  SignupFestivalView.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 19/03/2024.
//

import SwiftUI

struct Poste {
    let id: String
    let name: String
    let description: String
    let capacity: Int
}

struct SignupFestivalView: View {
    @State private var teeShirtSize: String = "XS"
    @State private var isVegetarian: Bool = false
    let festivalName: String
    let startDate: String
    let endDate: String
    
    // Sample data for postes and creneaux
    let postes: [Poste] = [
        Poste(id: "1", name: "Animation jeux", description: "Description", capacity: 10),
        Poste(id: "2", name: "Cuisine", description: "Description", capacity: 8),
        Poste(id: "3", name: "Accueil", description: "Description", capacity: 12)
    ]
    
    let creneaux: [Creneau] = [
        Creneau(id: 1, timeStart: "8h", timeEnd: "10h", idFestival: 1),
        Creneau(id: 2, timeStart: "12h", timeEnd: "14h", idFestival: 1),
        Creneau(id: 3, timeStart: "16h", timeEnd: "18h", idFestival: 1)
    ]
    
    // Custom widths for each column
    let columnWidths: [CGFloat] = [150, 100]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Festival information
            Text(festivalName)
                .font(.title)
                .fontWeight(.bold)
            Text("Du \(startDate) au \(endDate)")
            
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
            Text("01/01/2024")
                .font(.title3)
                .fontWeight(.bold)
            ScrollView(.horizontal) {
                VStack {
                    Text("") // Empty column
                        .frame(width: columnWidths[0])
                    
                    // Header row with creneaux
                    HStack {
                        Spacer()
                        ForEach(creneaux, id: \.id) { creneau in
                            Text("\(creneau.timeStart)-\(creneau.timeEnd)")
                                .font(.headline)
                                .frame(width: columnWidths[1], alignment: .center)
                        }
                    }
                    
                    // Data rows
                    ForEach(postes, id: \.id) { poste in
                        HStack {
                            Text(poste.name)
                                .padding()
                                .frame(width: columnWidths[0]) // Width for poste name
                            
                            Spacer()
                            
                            ForEach(creneaux, id: \.id) { creneau in
                                CircularProgressView(current: 7, max: poste.capacity)
                                    .padding()
                                    .frame(width: columnWidths[1]) // Width for circular progress bar cell
                                
                                Spacer()
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
}

struct SignupFestivalView_Previews: PreviewProvider {
    static var previews: some View {
        SignupFestivalView(festivalName: "Sample Festival", startDate: "01/01/2024", endDate: "03/01/2024")
    }
}
