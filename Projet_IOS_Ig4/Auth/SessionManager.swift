//
//  SessionManager.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 14/03/2024.
//
import KeychainSwift
import Foundation

class SessionManager {
    static let shared = SessionManager()
    
    let keychain = KeychainSwift()
    
    func saveAuthToken(token: String) {
        keychain.set(token, forKey: "authToken")
    }

    func getAuthToken() -> String? {
        return keychain.get("authToken")
    }

    func deleteAuthToken() {
        keychain.delete("authToken")
    }
    
    private var user: User?
    
    func saveUser(_ user: User) {
        self.user = user
        // Vous pourriez également vouloir stocker l'utilisateur dans UserDefaults ou de manière sécurisée dans Keychain, selon les détails sensibles.
    }
    
    func getUser() -> User? {
        return user
    }
    
    func isLoggedIn() -> Bool {
        return user != nil
    }
    
    func logout() {
        user = nil
        deleteAuthToken()
    }
}
