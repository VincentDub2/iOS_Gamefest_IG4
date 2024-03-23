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
    @State private var email: String = ""
    @State private var address: String = ""
    
    @State private var showLogoOverlayView = false
    @State private var logoImage: UIImage? = nil
    @State private var showNeedHelpView = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if sessionManager.user != nil {
                    ProfileImageView(inputImage: $inputImage)
                        .padding(.vertical, 50)
                    
                    TextField("Prénom", text: $firstName)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 1)
                    
                    TextField("Nom", text: $lastName)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 1)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 1)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    TextField("Adresse", text: $address)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 1)
                    
                    Button(action: updateUserDetails) {
                        Text("Sauvegarder les modifications")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .font(.system(size: 18, weight: .bold))
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Mise à jour"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    
                    
                    
                    Button("Prendre une photo avec logo") {
                        showLogoOverlayView = true
                    }
                    .sheet(isPresented: $showLogoOverlayView) {
                        LogoOverlayView()
                    }
                    
                    Button(action: {
                        showNeedHelpView = true
                    }) {
                        Text("Besoin d'aide")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .font(.system(size: 18, weight: .bold))
                    }
                    .sheet(isPresented: $showNeedHelpView) {
                        NeedHelpView()
                    }
                    
                    Button(action: sessionManager.logout) {
                        Text("Déconnexion")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(10)
                            .font(.system(size: 18, weight: .bold))
                    }
                    
                    // Un espace supplémentaire en bas
                    Color.clear.frame(height: 100) // Vous pouvez augmenter cette valeur si plus d'espace est nécessaire
                } else {
                    Text("Aucun utilisateur n'est connecté.")
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                firstName = sessionManager.user?.firstName ?? ""
                lastName = sessionManager.user?.lastName ?? ""
                email = sessionManager.user?.email ?? ""
                address = sessionManager.user?.address ?? ""
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
                               address: address,
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
        @ObservedObject private var sessionManager = SessionManager.shared
        @Binding var inputImage: UIImage?
        @State private var profileImage: Image? // Declare profileImage here
        @State private var showingImagePicker = false
        @State private var showingActionSheet = false // Declare showingActionSheet here
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
                                self.showingActionSheet = true // set to true to show action sheet
                            }
                            .actionSheet(isPresented: $showingActionSheet) { // corrected syntax
                                ActionSheet(
                                    title: Text("Modifier la photo"),
                                    message: Text("Choisissez une action"),
                                    buttons: [
                                        .default(Text("Prendre une photo")) {
                                            self.sourceType = .camera
                                            self.showingImagePicker = true
                                        },
                                        .default(Text("Choisir une photo")) {
                                            self.sourceType = .photoLibrary
                                            self.showingImagePicker = true
                                        },
                                        .cancel()
                                    ]
                                )
                            }
                            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                                ImagePicker(image: self.$inputImage, sourceType: self.sourceType)
                            }
                        }
            .padding()
                    }
        
        private func loadImage() {
            guard let inputImage = inputImage else { return }
            profileImage = Image(uiImage: inputImage)
            
          
            if let imageData = inputImage.jpegData(compressionQuality: 0.5)  {
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



struct LogoView: View {
    @Binding var imageWithLogo: UIImage?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    let logo: UIImage = UIImage(named: "yourLogoImage")! // Remplacez par le nom de votre image de logo
    
    var body: some View {
        VStack {
            if let imageWithLogo = imageWithLogo {
                Image(uiImage: imageWithLogo)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("Prendre une photo")
            }
        }
        .onTapGesture {
            self.showingImagePicker = true
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadLogo) {
            ImagePicker(image: self.$inputImage, sourceType: .camera)
        }
    }
    
    func loadLogo() {
        guard let inputImage = inputImage else { return }
        
        // Créer une nouvelle image en superposant le logo sur l'image d'origine
        UIGraphicsBeginImageContext(inputImage.size)
        
        inputImage.draw(at: CGPoint.zero)
        
        let logoSize = CGSize(width: inputImage.size.width / 4, height: inputImage.size.width / 4)
        let logoOrigin = CGPoint(x: inputImage.size.width - logoSize.width - 20, y: inputImage.size.height - logoSize.height - 20)
        
        logo.draw(in: CGRect(origin: logoOrigin, size: logoSize))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.imageWithLogo = newImage
    }
}

struct NeedHelpView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: FAQView()) {
                    Text("FAQ")
                }
                
                NavigationLink(destination: ContactUsView()) {
                    Text("Contactez-nous")
                }
            }
            .navigationBarTitle("Besoin d'aide", displayMode: .inline)
        }
    }
}

// La vue pour la FAQ.
struct FAQView: View {
    var body: some View {
        Text("Contenu de la FAQ")
            .padding()
            .navigationBarTitle("FAQ", displayMode: .inline)
    }
}

// La vue pour Contactez-nous.
struct ContactUsView: View {
    var body: some View {
        Text("Contenu pour nous contacter")
            .padding()
            .navigationBarTitle("Contactez-nous", displayMode: .inline)
    }
}


