//
//  ProfileView.swift
//  Projet_IOS_Ig4
//
//  Created by Lucas Leroy on 15/03/2024.
//
import SwiftUI

struct ProfileView: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    
    var body: some View {
        VStack {
            if let user = sessionManager.getUser() {
                Text("Nom : \(user.lastName)")
                Text("Prénom : \(user.firstName)")
                // Ajoutez d'autres détails de l'utilisateur que vous souhaitez afficher.
            } else {
                Text("Aucun utilisateur n'est connecté.")
            }
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
