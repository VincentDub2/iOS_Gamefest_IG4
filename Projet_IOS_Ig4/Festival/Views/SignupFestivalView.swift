//
//  SignupFestivalView.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 19/03/2024.
//

import SwiftUI

struct SignupFestivalView: View {
    @State private var teeShirtSize: String = "XS"
    @State private var isVegetarian: Bool = false
    @State private var selectedCreneau: [String: Int] = [:] // Dictionary to store selected creneaux for each poste
    
    var festivalName: String
    var startDate: String
    var endDate: String
    
    // Sample data for postes and creneaux
    let postes = ["Poste 1", "Poste 2", "Poste 3"]
    let creneaux = ["Jour 1", "Jour 2", "Jour 3"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Festival information
                Text(festivalName)
                    .font(.title)
                    .fontWeight(.bold)
                Text("Du \(startDate) au \(endDate)")
                
                // Tee shirt size selection
                Text("Taille de t-shirt")
                Picker("Tee Shirt Size", selection: $teeShirtSize) {
                    Text("XS").tag("XS")
                    Text("S").tag("S")
                    Text("M").tag("M")
                    Text("L").tag("L")
                    Text("XL").tag("XL")
                }
                .pickerStyle(MenuPickerStyle())
                
                // Vegetarian selection
                Toggle("Vegetarien", isOn: $isVegetarian)
                
                // Postes selection
                Text("Choix des postes")
                ForEach(creneaux, id: \.self) { creneau in
                    VStack(alignment: .leading) {
                        Text(creneau)
                        // Select at most one creneau for each poste
                        Picker("Select Creneau", selection: $selectedCreneau[creneau]) {
                            ForEach(postes, id: \.self) { poste in
                                Text(poste).tag(poste.hashValue)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
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
        .navigationTitle("Inscription au festival")
    }
}

struct SignupFestivalView_Previews: PreviewProvider {
    static var previews: some View {
        SignupFestivalView(festivalName: "Sample Festival", startDate: "01/01/2024", endDate: "03/01/2024")
    }
}
