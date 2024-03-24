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
        let endpoint = "/festivals/2"
        
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
    
    func fetchPostesByFestival(id: String, completion: @escaping (Result<[Poste], Error>) -> Void) {
        let endpoint = "/festivals/\(id)/postes"
        
        APIManager.requestGET(endpoint: endpoint) { (result: Result<[Poste], AFError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let postes):
                    completion(.success(postes))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchCreneauxByFestival(id: String, completion: @escaping (Result<[Creneau], Error>) -> Void) {
        let endpoint = "/festivals/\(id)/creneaux"
        
        APIManager.requestGET(endpoint: endpoint) { (result: Result<[Creneau], AFError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let creneaux):
                    completion(.success(creneaux))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchCreneauEspaceByCreneau(id: String, completion: @escaping (Result<[CreneauEspace], Error>) -> Void) {
        let endpoint = "/creneauEspaces/creneau/\(id)"
        
        APIManager.requestGET(endpoint: endpoint) { (result: Result<[CreneauEspace], AFError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let creneauEspace):
                    completion(.success(creneauEspace))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

}
