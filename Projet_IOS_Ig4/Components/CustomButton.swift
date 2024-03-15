//
//  CustomButton.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 13/03/2024.


import Foundation
import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.black))
        }
        .padding()
    }
}


#Preview {
    CustomButton(title: "Connexion", action: {})
    
}
