//
//  AuthService.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 12/03/2024.
//
import Foundation
import Alamofire


struct AuthResponse: Codable {
    let token: String
}

enum AuthError: Error {
    case noData
    case failedRequest
    case invalidCredentials
}

struct RegisterResponse: Codable {
    let message: String
    let user: User
}

class AuthService {
    
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
            let endpoint = "/login"
            let credentials = ["email": email, "password": password]
            
            // Utilisation de APIManager pour la requête POST.
            APIManager.requestPOST(endpoint: endpoint, parameters: credentials) { (result: Result<AuthResponse, AFError>) in
                switch result {
                case .success(let authResponse):
                    // Sauvegardez le token dans la session.
                    SessionManager.shared.saveAuthToken(token: authResponse.token)
                    completion(.success(authResponse.token))
                case .failure(let error):
                    // Transformez l'erreur d'Alamofire en AuthError si nécessaire.
                    completion(.failure(self.mapError(error)))
                }
            }
        }
        
    func register(userDetails: UserForRegister, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = "/register"
        
        guard let parameters = userDetails.dictionary else {
            print("Failed to create parameters")
            completion(.failure(AuthError.failedRequest)) // ou une erreur plus spécifique
            return
        }
        
        APIManager.requestPOST(endpoint: endpoint, parameters: parameters) { (result: Result<RegisterResponse, AFError>) in
                switch result {
                    case .success(let registerResponse):
                        // Ici, vous pouvez accéder à registerResponse.user et le sauvegarder
                        SessionManager.shared.saveUser(registerResponse.user)
                        completion(.success(true))
                    case .failure(let error):
                        print(error)
                        completion(.failure(self.mapError(error)))
                }
            }
    }

    private func mapError(_ error: AFError) -> AuthError {
        // Votre logique de mappage d'erreurs ici, par exemple :
        switch error {
        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode(let code) where code == 400:
                return .invalidCredentials
            default:
                return .failedRequest
            }
        default:
            return .failedRequest
        }
    }

}
