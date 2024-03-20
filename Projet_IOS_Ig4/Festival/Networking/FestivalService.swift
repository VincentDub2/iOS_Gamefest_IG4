//
//  FestivalService.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 15/03/2024.
//

import Foundation
import Alamofire

class FestivalService {
    
    func fetchFestival(completion: @escaping (Result<FestivalModel, Error>) -> Void) {
        let endpoint = "/festivals/1"
        
        APIManager.requestGET(endpoint: endpoint) { (result: Result<FestivalModel, AFError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let festival):
                    completion(.success(festival))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
