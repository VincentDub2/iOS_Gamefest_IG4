//
//  LogoOverlayView.swift
//  Projet_IOS_Ig4
//
//  Created by Lucas Leroy on 20/03/2024.
//

// LogoOverlayView.swift

import SwiftUI

struct LogoOverlayView: View {
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var imageWithLogo: UIImage? // Utilisez cet état pour stocker l'image avec le logo
    let logoImage: UIImage = UIImage(named: "Logo")! // Assurez-vous que le nom de l'image est correct

    var body: some View {
        VStack {
            if let imageWithLogo = imageWithLogo {
                // Afficher l'image avec le logo
                Image(uiImage: imageWithLogo)
                    .resizable()
                    .scaledToFit()
                
                // Bouton pour sauvegarder l'image
                Button("Sauvegarder l'image") {
                    saveImageToPhotoAlbum(image: imageWithLogo)
                }
            } else {
                Text("Prendre une photo")
                    .onTapGesture {
                        self.showingImagePicker = true
                    }
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: addLogoToImage) {
            ImagePicker(image: self.$inputImage, sourceType: .camera)
        }
    }

    func addLogoToImage() {
        guard let inputImage = inputImage else { return }

        UIGraphicsBeginImageContextWithOptions(inputImage.size, false, 0)
        inputImage.draw(at: CGPoint.zero)

        // Définir la taille du logo pour qu'elle soit égale à celle de l'image
        let logoSize = CGSize(width: inputImage.size.width, height: inputImage.size.height)
        // Placer le logo pour qu'il couvre toute l'image
        let logoOrigin = CGPoint(x: 0, y: 0)

        logoImage.draw(in: CGRect(origin: logoOrigin, size: logoSize))

        let newImageWithLogo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.imageWithLogo = newImageWithLogo
    }

    func saveImageToPhotoAlbum(image: UIImage?) {
        guard let imageToSave = image else { return }
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
    }
}
