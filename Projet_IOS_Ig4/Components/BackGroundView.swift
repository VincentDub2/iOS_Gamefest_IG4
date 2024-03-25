//
//  BackGroundView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 25/03/2024.
//

import Foundation
import SwiftUI

struct BackgroundView: View {
    @Binding var showNextView: Bool

        var body: some View {
            ZStack {
                VideoBackgroundView(videoName: "backgroundVideo", videoType: "mp4") // Assurez-vous que le fichier vidéo est dans votre bundle
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                // Opacity of the background image

            VStack {
                Spacer()
               
                // Button to enter
                Button(action: {
                    self.showNextView = true
                }) {
                    Text("C'est parti !")
                        .font(.custom("Pacifico", size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(Color.black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .shadow(radius: 10)
                }
                .padding(.bottom, 100)
               
            }
        }
    }
}
