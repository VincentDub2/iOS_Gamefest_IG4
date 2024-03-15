//
//  FestivalView.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 15/03/2024.
//

import SwiftUI

struct FestivalView: View {
    @StateObject private var festivalViewModel = FestivalViewModel()

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            if let festival = festivalViewModel.festival {
                FestivalDetailsView(festival: festival)
            } else {
                ProgressView("Chargement du festival...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .onAppear {
                        festivalViewModel.fetchFestival()
                    }
            }
        }
        .padding()
    }
}

struct FestivalDetailsView: View {
    var festival: FestivalModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(festival.name)
                .font(.title)
                .fontWeight(.bold)
            Text("Adresse: \(festival.address)")
            Text("Code Postal: \(festival.postalCode)")
            Text("Ville: \(festival.city)")
            Text("Pays: \(festival.country)")
            Text("Festival actif: \(festival.isActive ?? false ? "Oui" : "Non")")
            Text("Date de début: \(formatDate(festival.dateDebut)!)")
            Text("Date de fin: \(formatDate(festival.dateFin)!)")
        }
    }
    
    func formatDate(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateStyle = .long
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }

}

struct FestivalView_Previews: PreviewProvider {
    static var previews: some View {
        FestivalView()
    }
}
