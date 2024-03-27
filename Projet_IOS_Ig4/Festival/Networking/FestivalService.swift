//
//  FestivalService.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 15/03/2024.
//

import Foundation
import Alamofire

struct CreneauFestivalModel: Codable, Hashable {
    var id: Int
    var timeStart: String
    var timeEnd: String
    var idFestival: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "idCreneau"
        case timeStart = "timeStart"
        case timeEnd = "timeEnd"
        case idFestival = "idFestival"
    }
}

struct CreneauEspaceUpdate: Encodable, Decodable {
    let currentCapacity: Int
}

struct InscriptionRequest: Encodable, Decodable {
    let idUser: String
    let idCreneauEspace: Int
    var isFlexible: Bool = false
}


class FestivalService {
    
    func fetchFestival(festivalId: Int, completion: @escaping (Result<FestivalModel, Error>) -> Void) {
        let endpoint = "/festivals/\(festivalId)"
        print(endpoint)

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

    func fetchCreneauxByFestival(id: String, completion: @escaping (Result<[CreneauFestivalModel], Error>) -> Void) {
        let endpoint = "/festivals/\(id)/creneaux"
        
        APIManager.requestGET(endpoint: endpoint) { (result: Result<[CreneauFestivalModel], AFError>) in
            print(result)
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
    
    func addVolunteer(data: IsVolunteer, completion: @escaping (Result<IsVolunteer, Error>) -> Void) {
        let endpoint = "/festivals/\(data.idFestival)/volunteers"
        
        APIManager.requestPOST(endpoint: endpoint, parameters: data.dictionary!) { (result: Result<IsVolunteer, AFError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func updateCreneauEspace(idCreneauEspace: Int, newCapacity: Int, completion: @escaping (Bool) -> Void) {
        let endpoint = "/creneauEspaces/\(idCreneauEspace)"
        let parameters = CreneauEspaceUpdate(currentCapacity: newCapacity)
        
        APIManager.requestPUT(endpoint: endpoint, parameters: parameters.dictionary!) { (result: Result<CreneauEspaceUpdate, AFError>) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
        }
    }

    func addInscription(data: InscriptionRequest, completion: @escaping (Bool) -> Void) {
        let endpoint = "/inscriptions"
        
        APIManager.requestPOST(endpoint: endpoint, parameters: data.dictionary!) { (result: Result<InscriptionRequest, AFError>) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
        }
    }
}
