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
    func addComment(postId: String, body: String?) -> AnyPublisher<Comment, Error> {
        print("Adding comment to post \(postId)")
        print("Comment body: \(body ?? "No body")")
        let endpoint = "/forum/\(postId)/comment"
        
        // Safely unwrap the optional user ID
        guard let userId = SessionManager.shared.user?.id else {
            // Handle the error appropriately, e.g., by returning an error publisher
            return Fail(error: NSError(domain: "ForumServiceError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])).eraseToAnyPublisher()
        }
        
        guard let body = body else {
            return Fail(error: NSError(domain: "ForumServiceError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Comment body is empty"])).eraseToAnyPublisher()
        }
        
        let parameters: Parameters = [
            "message": body,
            "idUser": userId
        ]
        
        print("""
              Endpoint: \(endpoint)
              Parameters: \(parameters)
              """)
        
        return Future<Comment, Error> { promise in
            APIManager.requestPOST(endpoint: endpoint, parameters: parameters) { (result: Result<Comment, AFError>) in
                print(result)
                switch result {
                case .success(let comment):
                    promise(.success(comment))
                    self.addPostToLocalPost(id: Int(postId) ?? Int.random(in: 0..<1000), comment: comment)
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
