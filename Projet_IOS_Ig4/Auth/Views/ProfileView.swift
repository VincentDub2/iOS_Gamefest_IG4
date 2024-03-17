//
//  ProfileView.swift
//  Projet_IOS_Ig4
//
//  Created by Lucas Leroy on 15/03/2024.
//
import SwiftUI

import UIKit


struct ProfileView: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var showingAlert = false
    @State private var alertMessage: String = ""
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack {
            if let user = sessionManager.user {
                TextField("Prénom", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Nom", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                ProfileImageView(inputImage: $inputImage)
                
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
            
            sessionManager.refreshUserDetails()
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
    
    // Créez une nouvelle sous-vue pour afficher et sélectionner la photo de profil
    struct ProfileImageView: View {
        @ObservedObject private var sessionManager = SessionManager.shared // Observer pour les changements
        @Binding var inputImage: UIImage? // Image entrante depuis l'ImagePicker
        @State private var profileImage: Image? // Image SwiftUI pour l'affichage
        @State private var showingImagePicker = false
        @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
        
        var body: some View {
            VStack {
                ZStack {
                    if let profileImage = profileImage {
                        profileImage
                            .resizable()
                            .scaledToFit()
                    } else if let placeholderImage = sessionManager.user?.picture,
                              let url = URL(string: placeholderImage),
                              let imageData = try? Data(contentsOf: url),
                              let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                .onTapGesture {
                    self.showingImagePicker = true
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage, sourceType: self.sourceType)
                }
            }
        }
        
        private func loadImage() {
            guard let inputImage = inputImage else { return }
            profileImage = Image(uiImage: inputImage)
            
            // Si l'authentification est requise pour votre API, assurez-vous que l'utilisateur est connecté et a un token valide
            if let imageData = inputImage.jpegData(compressionQuality: 1) {
                AuthService.shared.uploadProfilePicture(imageData: imageData) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            print("Profile image successfully uploaded.")
                            // Vous devriez aussi rafraîchir les informations de l'utilisateur ici pour obtenir la nouvelle URL de l'image
                            sessionManager.refreshUserDetails()
                        case .failure(let error):
                            print("Error uploading profile image: \(error)")
                        }
                    }
                }
            }
        }
        
        
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }
        
    }

}
