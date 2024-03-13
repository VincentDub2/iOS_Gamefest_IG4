//
//  RegisterView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 12/03/2024.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false // Pour indiquer l'état de chargement

    var body: some View {
        ScrollView {
            VStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    TextField("Prénom", text: $viewModel.firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Nom de famille", text: $viewModel.lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Adresse", text: $viewModel.address)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    SecureField("Mot de passe", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    CustomButton(title: "S'inscrire", action: {
                        isLoading = true
                        viewModel.register()
                    })
                }
            }.padding()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }.onAppear {
                viewModel.onRegisterSuccess = {
                    isLoading = false // Arrête le chargement
                    alertMessage = "Connexion réussie"
                    showingAlert = true
                    // Naviguez vers l'écran suivant ou mettez à jour l'état de l'interface utilisateur ici
                }
                
                viewModel.onRegisterFailure = { error in
                    isLoading = false // Arrête le chargement
                    alertMessage = "Erreur de connexion: \(error.localizedDescription)"
                    showingAlert = true
                    // Affichez une alerte ou mettez à jour l'interface utilisateur en conséquence
                }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
