//
//  APIManager.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 14/03/2024.
//

import Foundation
import Alamofire

/// Structure pour centraliser la configuration de l'API.
struct APIConfiguration {
    static let baseURL = "https://montpellier-game-fest-volunteers-api-vincentdub2.vercel.app"
    //static let baseURL = "http://localhost:8080"
}

/// Manager pour simplifier l'utilisation des requêtes Alamofire.
class APIManager {
    
    /// Réalise une requête GET.
    /// - Parameters:
    ///   - endpoint: Point de terminaison de l'API spécifique.
    ///   - parameters: Paramètres de la requête.
    ///   - completion: Bloc de completion appelé avec le résultat.
    static func requestGET<T: Decodable>(endpoint: String, parameters: Parameters? = nil, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<T, AFError>) -> Void) {
        let url = APIConfiguration.baseURL + endpoint
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseDecodable (decoder: decoder) { (response: DataResponse<T, AFError>) in
            completion(response.result)
        }
    }
    /*
     Exemple utilisation :
     APIManager.requestGET(endpoint: "/users", parameters: nil) { (result: Result<User, AFError>) in
     switch result {
     case .success(let user):
     print(user)
     case .failure(let error):
     print(error)
     }
     }
     */
    /// Réalise une requête POST.
    /// - Parameters:
    ///  - endpoint: Point de terminaison de l'API spécifique.
    /// - parameters: Paramètres de la requête.
    /// - completion: Bloc de completion appelé avec le résultat.
    static func requestPOST<T: Decodable>(endpoint: String, parameters: Parameters, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = APIConfiguration.baseURL + endpoint
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    /// Réalise une requête PUT.
    /// - Parameters:
    ///   - endpoint: Point de terminaison de l'API spécifique.
    ///   - parameters: Paramètres de la requête.
    ///   - completion: Bloc de completion appelé avec le résultat.
    static func requestPUT<T: Decodable>(endpoint: String, parameters: Parameters, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = APIConfiguration.baseURL + endpoint
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default).validate().responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    /// Réalise une requête DELETE.
    /// - Parameters:
    ///   - endpoint: Point de terminaison de l'API spécifique.
    ///   - parameters: Paramètres de la requête (facultatif).
    ///   - completion: Bloc de completion appelé avec le résultat.
    static func requestDELETE<T: Decodable>(endpoint: String, parameters: Parameters? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = APIConfiguration.baseURL + endpoint
        AF.request(url, method: .delete, parameters: parameters).validate().responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }

}


extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}


