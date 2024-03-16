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
                
                Button("Déconnexion") {
                    sessionManager.logout()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(10)
            } else {
                Text("Aucun utilisateur n'est connecté.")
            }
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            firstName = sessionManager.user?.firstName ?? ""
            lastName = sessionManager.user?.lastName ?? ""
        }
    }

    private func updateUserDetails() {
        guard let currentUser = sessionManager.user else { return }

        // Créez une nouvelle instance de User avec les valeurs mises à jour.
        let updatedUser = User(id: currentUser.id,
                               lastName: lastName,
                               firstName: firstName,
                               email: currentUser.email,
                               address: currentUser.address,
                               picture: currentUser.picture,
                               pictureId: currentUser.pictureId,
                               phoneNumber: currentUser.phoneNumber,
                               completed: currentUser.completed,
                               isGod: currentUser.isGod,
                               createdAt: currentUser.createdAt,
                               updatedAt: currentUser.updatedAt,
                               emailVerified: currentUser.emailVerified,
                               emailVerificationToken: currentUser.emailVerificationToken)
        
        AuthService().updateUser(user: updatedUser) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedUser):
                    // Mettez à jour l'utilisateur dans la session.
                    self.sessionManager.saveUser(updatedUser)
                    self.alertMessage = "Votre profil a été mis à jour."
                    self.showingAlert = true
                case .failure(let error):
                    self.alertMessage = "Erreur de mise à jour: \(error.localizedDescription)"
                    self.showingAlert = true
                }
            }
        }
    }

}
