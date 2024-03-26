//  PostView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 16/03/2024.
//
import SwiftUI
import RiveRuntime

struct PostView: View {
    @State var isLike = false
    @State var like: RiveViewModel
    
    var post: Post
    var color: Color
    var avatar: Int
    
    init(post: Post, color: Color,avatar : Int){
        self.post = post
        self.like = RiveViewModel(fileName: "light_like", stateMachineName: "State Machine 1")
    
        if color == .clear {
            self.color = Color(hue: Double.random(in: 0...1), saturation: 0.5, brightness: 0.8)
        } else {
            self.color = color
        }
        self.avatar = avatar
        
        post.likes.forEach { like in
            if like.userId == SessionManager.shared.getUser()?.id ?? "96ac88b2-dee8-47f6-945b-3bbef421b96b" {
                self.isLike = true
                self.like.setInput("Hover", value: true)
                self.like.setInput("Pressed", value: true)
            }
        }
    }
    
    func toogle () {
        if isLike {
           ForumViewModel.shared.addLike(to : post.id)
        }
        self.isLike.toggle()
        self.like.setInput("Hover", value: true)
        self.like.setInput("Pressed", value: isLike)
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 16) {
                AnimateAvatar(number:self.avatar)
                Text(post.title)
                        .font(.headline)
                        .foregroundColor(.white)
                Spacer()
                Button(action: {
                    toogle()
                }) {
                    like.view()
                        .frame(width: 50, height: 50)
                }
            }
        
            Text(post.body)
                        .font(.subheadline)
                        .opacity(0.7)
                        // Supprimez la limite de lignes ou réglez-la sur nil pour permettre un affichage illimité des lignes.
                        .lineLimit(nil)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
        
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [color, color.opacity(0.6)]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(0.5), lineWidth: 2)
        )
        .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 10)
        .padding(.horizontal, 10)
    }
}

struct Post_Previews: PreviewProvider {
    static var previews: some View {
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
        
     PostView(post: post ,color: .clear, avatar: 1)
    }
}
