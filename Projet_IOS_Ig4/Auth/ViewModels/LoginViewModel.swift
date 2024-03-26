//
//  LoginViewModel.swift
//  Projet_IOS_Ig4
//
//  Created by  DUBUC on 12/03/2024. et lucas leroy eh !
//

//  LoginViewModel.swift


// LoginViewModel.swift

import Foundation
import Alamofire

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    // Callbacks pour la mise à jour de l'UI
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((Error) -> Void)?
    
    private var authService: AuthService = AuthService()
    
    // Fonction pour tenter la connexion
    func login() {
        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    // Sauvegardez le token
                    SessionManager.shared.saveAuthToken(token: token)
                    
                    // Maintenant, récupérez les détails de l'utilisateur avec le token obtenu
                    self?.fetchUserDetails(token: token) { userDetailsResult in
                        switch userDetailsResult {
                        case .success(let user):
                            // Sauvegardez les détails de l'utilisateur
                            SessionManager.shared.saveUser(user)
                            // Callback pour indiquer un succès de connexion
                            self?.onLoginSuccess?()
                        case .failure(let error):
                            // En cas d'échec, gérez l'erreur
                            self?.onLoginFailure?(error)
                        }
                    }
                case .failure(let error):
                    // Callback pour gérer l'échec de la connexion
                    self?.onLoginFailure?(error)
                }
            }
        }
    }
    
    // Fonction pour récupérer les détails de l'utilisateur après avoir obtenu un token
    func fetchUserDetails(token: String, completion: @escaping (Result<User, Error>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let url = "https://montpellier-game-fest-volunteers-api-vincentdub2.vercel.app/users/current" // Utilisez l'endpoint pour l'utilisateur actuel
        
        // Exécutez la requête pour obtenir les détails de l'utilisateur
        AF.request(url, method: .get, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                    return
                }
                do {
                    // Essayez de décoder la réponse en utilisant le modèle User
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(user))
                } catch {
                    // Si le décodage échoue, imprimez l'erreur et le contenu de la réponse pour le débogage
                    print("Decoding error: \(error)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("JSON String: \(jsonString)")
                    }
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

