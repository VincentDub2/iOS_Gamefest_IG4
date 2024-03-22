//
//  FormView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 15/03/2024.
//

import Foundation
import SwiftUI


struct ForumView: View {
    @ObservedObject var viewModel: ForumViewModel = ForumViewModel.shared
    @State private var showingNewPostView = false
    
    
    // Définition de la configuration de la grille pour deux colonnes avec un espacement flexible
    var gridItems: [GridItem] = Array(repeating: .init(.flexible(), spacing: 20), count: 1)

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 20) {
                    ForEach(viewModel.posts) { post in
                        NavigationLink(destination: PostDetailView(post: post, viewModel: viewModel)) {
                            PostView(post: post, color: post.color,avatar: post.avatar)
                        }
                    }
                }.padding(.top,20)
                .padding(.horizontal) // Padding horizontal pour le contenu de la grille
            }
            .navigationTitle("Forum")
            .navigationBarItems(trailing: addButton)
            .sheet(isPresented: $showingNewPostView) {
                NewPostView(viewModel: viewModel)
            }
        }
    }

    private var addButton: some View {
        Button(action: {
            showingNewPostView.toggle()
        }) {
            Image(systemName: "plus.circle.fill")
                .font(.largeTitle) // Utiliser une taille de police plus grande pour l'icône
                .foregroundColor(.blue) // Changer la couleur de l'icône pour une meilleure visibilité
                .padding() // Ajoute de l'espace autour de l'icône pour une touche facile
        }
    }
}


struct ForumView_Previews: PreviewProvider {
    static var previews: some View {
            let service = ForumService()
            let viewModel = ForumViewModel(forumService: service)
            ForumView(viewModel: viewModel)
        }
}
