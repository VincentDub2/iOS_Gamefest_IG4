//
//  HousingDetailView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 20/03/2024.
//

import Foundation
import SwiftUI
import MapKit

struct HousingDetailView: View {
    var housing: Housing
    // Example property, replace with actual coordinate if available

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(housing.city)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack {
                    Text("Nombre de personne : \(housing.availability)")
                        .font(.headline)
                    Spacer()
                    if housing.isOffering {
                        Text("Offre")
                            .foregroundColor(.green)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.green.opacity(0.2))
                            .clipShape(Capsule())
                    } else {
                        Text("Request")
                            .foregroundColor(.blue)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.blue.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
                
                if let description = housing.description {
                    Text(description)
                        .font(.body)
                }
                
                Button(action: {
                    // Implement contact action
                }) {
                    Text("Conctater l'utilisateur")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationBarTitle(Text("Housing Details"), displayMode: .inline)
    }
}

/*
 // Modèle pour représenter un logement.
 struct Housing: Identifiable , Codable{
     var id: Int
     var availability: Int
     var idUser: String
     var description: String?
     var isOffering: Bool // true pour offrir, false pour demander
     var city: String
     var postalCode: String
     var country: String
     enum CodingKeys: String, CodingKey {
         case id = "idHousing"
         case availability
         case idUser
         case description
         case isOffering
         case city
         case postalCode
         case country
     
     }
 }

 */


struct HousingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let house1 = Housing(id: 1, availability: 2, idUser: "1", description: """
                             Maison situé au centre de Montpellier, proche de toutes commodités.
                             """, isOffering: true, city: "Montpellier", postalCode: "34160", country: "France")
        HousingDetailView(housing: house1)
    }
}
