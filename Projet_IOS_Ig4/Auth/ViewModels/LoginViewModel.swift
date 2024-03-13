//
//  LoginViewModel.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 12/03/2024.
//

import Foundation

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
                    // Stockez et/ou utilisez le token reçu
                    self?.onLoginSuccess?()
                case .failure(let error):
                    self?.onLoginFailure?(error)
                }
            }
        }
    }
}
