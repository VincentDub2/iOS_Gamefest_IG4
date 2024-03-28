//
//  PostDetailView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 15/03/2024.
//

import Foundation
import RiveRuntime
import SwiftUI

struct PostDetailView: View {
    var post: Post
    @ObservedObject var viewModel: ForumViewModel
    @State private var newComment: String = " "
    @State var isLike = false
    var like = RiveViewModel(fileName: "light_like", stateMachineName: "State Machine 1")
    
    
    var body: some View {
        ScrollView {
            PostView(post: post, color: post.color,avatar: post.avatar,heart: false)

                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
               

                Divider()

                Text("Commentaire")
                    .font(.headline)

                // Amélioration de l'affichage des commentaires
                ForEach(post.comments) { comment in
                    CommentView(text: comment.body, name: comment.user?.firstName ?? "Anonyme")
                }

                // Champ de texte plus intuitif pour ajouter des commentaires
                CommentInputView(newComment: $newComment, placeholder: "Ajouter un commentaire") {
                            // Actions à effectuer lorsque l'utilisateur soumet un commentaire
                    ForumViewModel.shared.addComment(to: String(post.id), body: newComment)
                            print("Commentaire soumis : \(newComment)")
                            // Vous pourriez ici appeler une fonction pour sauvegarder le commentaire, par exemple
                            newComment = "" // Réinitialiser le champ après soumission
                        }
                    
            }
            .padding()
        }
        .navigationTitle("Posts du Forum")
    
    }
}


struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let service = ForumService()
        let viewModel = ForumViewModel(forumService: service)
        let User = User(id: "1", lastName: "DUBUC", firstName: "Vincent", email: "vincent",
                        address: "vincent", picture: nil, pictureId: nil, phoneNumber: nil, completed: true, isGod: true, createdAt: "vincent", updatedAt: "vincent", emailVerified: true, emailVerificationToken: "vincent")
        let post = Post(id: 5, userId: "5", title: "Avis sur le jeu de société",
                        body: """
                           Je suis à la recherche d'avis sur le jeu de société "Les Aventuriers du Rail".
                           Est-ce que vous avez des retours sur ce jeu ?
                           """,
                        createdAt: Date().ISO8601Format(), User: User, likes: [
                            Like(id: 1, userId: "1", postId: 5),
                            Like(id: 2, userId: "2", postId: 5)
                        ], comments: [
                            Comment(id: 1, postId: 5, userId: "1", body: "Je trouve ce jeu très sympa !", createdAt: Date().ISO8601Format()),
                            Comment(id: 2, postId: 5, userId: "2", body: "Je suis d'accord, c'est un jeu très fun !", createdAt: Date().ISO8601Format())])
        
        return PostDetailView(post: post, viewModel: viewModel)
    }
}
