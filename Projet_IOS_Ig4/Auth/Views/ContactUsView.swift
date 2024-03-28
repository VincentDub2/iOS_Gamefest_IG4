//
//  ContactUsView.swift
//  Projet_IOS_Ig4
//
//  Created by Lucas Leroy on 23/03/2024.
//

import SwiftUI

struct DeveloperProfile {
    var name: String
    var bio: String
    var imageTEST: String // Nom de l'image dans vos Assets
    var email: String // Adresse e-mail du développeur
}

struct DeveloperBioView: View {
    var profile: DeveloperProfile

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(profile.imageTEST)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))

            Text(profile.name)
                .font(.title2)
                .fontWeight(.bold)

            Text(profile.bio)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()

            Link("Envoyer un e-mail", destination: URL(string: "mailto:\(profile.email)")!)
                .foregroundColor(.blue)
        }
        .padding()
    }
}

struct ContactUsView: View {
    let developers: [DeveloperProfile] = [
        DeveloperProfile(name: "Lucas Leroy", bio: "Élève ingénieur à Polytech Montpellier en école d'ingénieur en informatique et gestion", imageTEST: "lucas", email: "leroy.lucas.pro@gmail.com"),
        DeveloperProfile(name: "Vincent Dubuc", bio: "Élève ingénieur à Polytech Montpellier en école d'ingénieur en informatique et gestion", imageTEST: "vincent", email: "vincentdubuc2@gmail.com"),
        DeveloperProfile(name: "Bastian Albaut", bio: "Élève ingénieur à Polytech Montpellier en école d'ingénieur en informatique et gestion", imageTEST: "bastian", email: "laguerre.tribale1@gmail.com"),
    ]

    var body: some View {
            ScrollView {
                VStack {
                    Text("Rencontrez l'équipe")
                        .font(.largeTitle)
                        .padding()

                    Text("N'hésitez pas à nous contacter, nous nous ferons un plaisir de répondre à vos questions.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)

                    ForEach(developers, id: \.name) { developer in
                        DeveloperBioView(profile: developer)
                    }
                }
            }
            .navigationBarTitle("Contactez-nous", displayMode: .inline)
        }
    }


struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactUsView()
        }
    }
}
