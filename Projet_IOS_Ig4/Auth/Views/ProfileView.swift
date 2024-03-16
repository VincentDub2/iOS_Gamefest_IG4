//
//  ProfileView.swift
//  Projet_IOS_Ig4
//
//  Created by Lucas Leroy on 15/03/2024.
//
import SwiftUI

struct ProfileView: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var showingAlert = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack {
            if let user = sessionManager.user {
                TextField("Prénom", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Nom", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Sauvegarder les modifications") {
                    updateUserDetails()
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Mise à jour"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            } else {
                Text("Aucun utilisateur n'est connecté.")
            }
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Initialiser les champs avec les valeurs actuelles de l'utilisateur
            self.firstName = sessionManager.user?.firstName ?? ""
            self.lastName = sessionManager.user?.lastName ?? ""
        }
    }

    private func updateUserDetails() {
        // Appeler la fonction pour mettre à jour le nom et le prénom de l'utilisateur
        guard let user = sessionManager.user else { return }
        
        let updatedUser = User(id: user.id,
                               lastName: lastName,
                               firstName: firstName,
                               email: user.email,
                               address: user.address,
                               picture: user.picture,
                               pictureId: user.pictureId,
                               phoneNumber: user.phoneNumber,
                               completed: user.completed,
                               isGod: user.isGod,
                               createdAt: user.createdAt,
                               updatedAt: user.updatedAt,
                               emailVerified: user.emailVerified,
                               emailVerificationToken: user.emailVerificationToken)
        
        AuthService().updateUser(user: updatedUser) { result in
            switch result {
            case .success(let updatedUser):
                self.sessionManager.user = updatedUser
                self.alertMessage = "Votre profil a été mis à jour."
            case .failure(let error):
                self.alertMessage = "Erreur de mise à jour: \(error.localizedDescription)"
            }
            self.showingAlert = true
        }
    }
}
