//
//  LoginView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 12/03/2024.
//

import Foundation

import SwiftUI

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false // Pour indiquer l'état de chargement
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ZombieWalkingAnimationView()
                        .frame(width: 500, height: 500)
                        .padding()
                    //ProgressView()
                       // .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    SecureField("Mot de passe", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    CustomButton(title: "Connexion", action: {
                        isLoading = true // Commence le chargement
                        viewModel.login()
                    })
                    NavigationLink("Pas de compte ?  S'inscrire", destination:
                                    RegisterView().navigationTitle("Inscrition")).padding().foregroundColor(.black)
                }
            }.padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }.onAppear {
                    viewModel.onLoginSuccess = {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        // Ce code est exécuté après un délai de 2 secondes
                            isLoading = false // Arrête le chargement
                            }
                    
                        alertMessage = "Connexion réussie"
                        showingAlert = true
                        // Naviguez vers l'écran suivant ou mettez à jour l'état de l'interface utilisateur ici
                    }
                    
                    viewModel.onLoginFailure = { error in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        // Ce code est exécuté après un délai de 2 secondes
                            isLoading = false // Arrête le chargement
                            }
        
                        alertMessage = "Erreur de connexion: \(error.localizedDescription)"
                        showingAlert = true
                        // Affichez une alerte ou mettez à jour l'interface utilisateur en conséquence
                    }
                }
            
        }
    }
}
    
    
    
struct LoginView_prev: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
