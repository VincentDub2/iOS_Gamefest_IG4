//
//  comment.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 16/03/2024.
//

import Foundation
import RiveRuntime
import SwiftUI

struct CommentView: View {
    var text: String
    var avatar: RiveViewModel
    var name: String

    init(text: String, avatar: RiveViewModel = RiveViewModel(fileName: "avatar_pack_use_case", artboardName: "Avatar \(Int.random(in: 1...3))"), name: String) {
        self.text = text
        self.avatar = avatar
        self.name = name
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) { // Alignement en haut et espacement entre l'avatar et le texte
            avatar.view()
                .frame(width: 40, height: 40) // Taille de l'avatar
                .clipShape(Circle()) // Forme circulaire pour l'avatar
                .shadow(radius: 2) // Ombre légère pour l'avatar

            VStack(alignment: .leading, spacing: 4) { // Espacement vertical entre le nom et le texte
                Text(name)
                    .font(.headline) // Style du texte pour le nom
                    .foregroundColor(.primary) // Couleur du texte

                Text(text)
                    .font(.body) // Style du texte pour le commentaire
                    .foregroundColor(.secondary) // Couleur plus discrète pour le texte du commentaire
                    .multilineTextAlignment(.leading) // Alignement du texte à gauche
                    .fixedSize(horizontal: false, vertical: true) // Permet au texte de s'étendre sur plusieurs lignes
            }

            Spacer() // Permet de pousser le contenu à gauche
        }
        .padding() // Espacement autour de la vue de commentaire
        .background(Color(UIColor.systemBackground)) // Fond adaptatif selon le thème (clair ou sombre)
        .cornerRadius(10) // Coins arrondis pour le fond
        .shadow(radius: 3) // Légère ombre pour la carte de commentaire
        .overlay(
            RoundedRectangle(cornerRadius: 10) // Bordure légèrement visible
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}


struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(text: "Je suis a la recheche d'un", name: "Vincent")
    }
}
