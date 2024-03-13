//
//  RegisterViewModel.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 12/03/2024.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = "" // Ajoutez d'autres champs nécessaires à l'inscription

    var onRegisterSuccess: (() -> Void)?
    var onRegisterFailure: ((Error) -> Void)?
    
    private var authService: AuthService = AuthService()
    
    func register() {
        let newUser = User(username: username, password: password) // Assurez-vous que le modèle User correspond à vos besoins
        authService.register(user: newUser) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("Inscription réussie")
                    self?.onRegisterSuccess?()
                case .failure(let error):
                    print("Échec de l'inscription: \(error.localizedDescription)")
                    self?.onRegisterFailure?(error)
                }
            }
        }
    }
}
