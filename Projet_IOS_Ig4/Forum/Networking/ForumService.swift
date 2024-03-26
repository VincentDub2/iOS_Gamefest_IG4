//
//  ForumService.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 15/03/2024.
//

import Foundation
import Combine
import Alamofire

struct ResponseApi : Codable {
    let idMsgForum: Int
    let idUser: String
    let title: String
    let message: String
    let createdAt: String
}

struct ForumService {
    
    // Créer un post
    func createPost(title: String, body: String) -> AnyPublisher<Bool, Error> {
        let endpoint = "/forum"
        let parameters: Parameters = [
            "title": title,
            "message": body,
            "idUser": SessionManager.shared.user!.id,
        ]
            
            return Future<Bool, Error> { promise in
                APIManager.requestPOST(endpoint: endpoint, parameters: parameters) { (result: Result<ResponseApi, AFError>) in
                    switch result {
                    case .success(_):
                        promise(.success(true))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    
    // Récupérer tous les posts
       func fetchPosts() -> AnyPublisher<[Post], Error> {
           let endpoint = "/forum"
           
           return Future<[Post], Error> { promise in
               APIManager.requestGET(endpoint: endpoint) { (result: Result<[Post], AFError>) in
                   print(result)
                   switch result {
                   case .success(let posts):
                       promise(.success(posts))
                   case .failure(let error):
                       promise(.failure(error))
                   }
               }
           }
           .eraseToAnyPublisher()
       }
       
    
    // Ajouter un like à un post /forum/:id/like
    func addLike(postId: String) -> AnyPublisher<Like, Error> {
        let endpoint = "/forum/\(postId)/like"
        let parameters: Parameters = [
            "idUser": SessionManager.shared.user!.id,
        ]
        
        return Future<Like, Error> { promise in
            APIManager.requestPOST(endpoint: endpoint, parameters: parameters) { (result: Result<Like, AFError>) in
                switch result {
                case .success(let like):
                    promise(.success(like))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Ajouter un commentaire à un post
        func addComment(postId: String, body: String) -> AnyPublisher<Comment, Error> {
            let endpoint = "/forum/\(postId)/comment"
            let parameters: Parameters = [
                "message": "body",
                "idUser": SessionManager.shared.user!.id,
        
            ]
            
            return Future<Comment, Error> { promise in
                APIManager.requestPOST(endpoint: endpoint, parameters: parameters) { (result: Result<Comment, AFError>) in
                    switch result {
                    case .success(let comment):
                        promise(.success(comment))
                        addPostToLocalPost(id: Int(postId)!, comment: comment)
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    //Permet d'ajouter le commentaire au post sans refetch l'api
    func addPostToLocalPost(id: Int, comment: Comment) {
        for i in 0..<ForumViewModel.shared.posts.count {
            if ForumViewModel.shared.posts[i].id == id {
                ForumViewModel.shared.posts[i].comments.append(comment)
                break
            }
        }
    }
}
