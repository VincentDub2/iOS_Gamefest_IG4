//
//  RegisterView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 12/03/2024.
//

import SwiftUI

// Vue pour l'inscription
struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()

    var body: some View {
        VStack {
            TextField("Nom d'utilisateur", text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Mot de passe", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                viewModel.register()
            }) {
                Text("S'inscrire")
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
            }
            .padding()
            .onAppear {
                viewModel.onRegisterSuccess = {
                    print("Inscription réussie")
                    // Naviguez vers l'écran suivant ou mettez à jour l'état de l'interface utilisateur ici
                    
                }

                viewModel.onRegisterFailure = { error in
                    print("Erreur d'inscription: \(error.localizedDescription)")
                    // Affichez une alerte ou mettez à jour l'interface utilisateur en conséquence
                }
            }
        }
        .padding()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
