//
//  PosteService.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 15/03/2024.
//

import Foundation
import Alamofire

class PosteService {
    func fetchPoste(postId: String, completion: @escaping (Result<PosteModel, Error>) -> Void) {
        let endpoint = "/postes/\(postId)" // Utilisez postId dans l'endpoint
        
        APIManager.requestGET(endpoint: endpoint) { (result: Result<PosteModel, AFError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let poste):
                    completion(.success(poste))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
