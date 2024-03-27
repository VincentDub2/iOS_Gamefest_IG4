//
//  PosteService.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 15/03/2024.
//

import Foundation
import Alamofire

class PosteService {
    
    func fetchPoste(completion: @escaping (Result<PosteModel, Error>) -> Void) {
        let endpoint = "/postes/1"
        
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

