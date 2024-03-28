//
//  PosteView.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 15/03/2024.
//

import SwiftUI

struct PosteView: View {
    @StateObject private var posteViewModel = PosteViewModel()
    var postId: String
    
    let referents = [
        ("Jean", "Dupont"),
        ("Marie", "Durand"),
        ("Luc", "Martin")
    ]
    
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            if let poste = posteViewModel.poste {
                PosteDetailsView(poste: poste)
            } else {
                ProgressView("Chargement du poste...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .onAppear {
                        posteViewModel.fetchPoste(postId: postId) // Utilisez postId ici
                    }
            }
        }
        .padding()
    }
}


struct PosteDetailsView: View {
    var poste: PosteModel

    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(poste.name)
                .font(.title)
                .fontWeight(.bold)
            Text(poste.description)
            Text("Capacité: \(poste.capacityPoste)")
            Text("Festival associé: \(poste.idFestival)")
        }
    }
}

struct PosteView_Previews: PreviewProvider {
    static var previews: some View {
        PosteView(postId: "1")
    }
}

