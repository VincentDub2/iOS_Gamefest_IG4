//
//  NewPostView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 15/03/2024.
//

import Foundation
import SwiftUI

struct NewPostView: View {
    @ObservedObject var viewModel: ForumViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom title input
                HStack {
                    Text("Titre")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                
                TextField("Entrer le titre de votre post ici ", text: $title)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    .padding(.horizontal)
                    .padding(.top, 5)
                
                // Custom content input
                HStack {
                    Text("Corps du texte")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                
                TextEditor(text: $content)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    .padding(.horizontal)
                    .padding(.top, 5)
                
                Spacer()
            }
            .navigationBarTitle("Nouveau Post", displayMode: .inline)
            .navigationBarItems(leading: Button("Quitter") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Publier") {
                viewModel.addPost(title: title, body: content)
                print("Post ajouté")
                presentationMode.wrappedValue.dismiss()
            }.disabled(title.isEmpty || content.isEmpty))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView(viewModel: ForumViewModel(forumService: ForumService()))
    }
}
