//
//  RegisterViewModel.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 12/03/2024.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var firstName: String = ""
        @Published var lastName: String = ""
        @Published var address: String = ""
        @Published var email: String = ""
        @Published var password: String = ""

    var onRegisterSuccess: (() -> Void)?
    var onRegisterFailure: ((Error) -> Void)?
    
    private var authService: AuthService = AuthService()
    
    func register() {
        let newUser = UserForRegister(firstName: firstName, lastName: lastName, email: email, address: "r", password: password);
        authService.register(userDetails: newUser) { [weak self] result in
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
