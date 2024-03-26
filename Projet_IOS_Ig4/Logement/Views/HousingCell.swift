//
//  HousingCell.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 22/03/2024.
//

import Foundation

import SwiftUI

struct HousingCell: View {
    var housing: Housing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(housing.city)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                //Mettre un icon de personne pour le nombre de place dispo
                Label("\(housing.availability)", systemImage: "person.fill")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if housing.isOffering {
                Label("Offre", systemImage: "house.fill")
                    .font(.caption)
                    .foregroundColor(.green)
            } else {
                Label("Recherche", systemImage: "magnifyingglass")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            if let description = housing.description {
                Text(description)
                    .font(.body)
                    .lineLimit(3)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}
