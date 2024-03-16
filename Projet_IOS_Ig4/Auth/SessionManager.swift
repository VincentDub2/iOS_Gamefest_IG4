import Foundation
import KeychainSwift
import Combine

class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    let keychain = KeychainSwift()
    
    @Published var user: User?
    
    func saveAuthToken(token: String) {
        keychain.set(token, forKey: "authToken")
    }

    func getAuthToken() -> String? {
        return keychain.get("authToken")
    }

    func deleteAuthToken() {
        keychain.delete("authToken")
    }

    func saveUser(_ user: User) {
        self.user = user
        // Sauvegardez ici l'utilisateur dans UserDefaults ou Keychain, si nécessaire.
    }
    
    func getUser() -> User? {
        return user
    }
    
    func saveUserDetails(_ user: User) {
        UserDefaults.standard.set(user.firstName, forKey: "firstName")
        UserDefaults.standard.set(user.lastName, forKey: "lastName")
        // Ajoutez ici d'autres détails que vous souhaitez enregistrer.
    }

    func getUserDetails() -> (firstName: String, lastName: String)? {
        if let firstName = UserDefaults.standard.string(forKey: "firstName"),
           let lastName = UserDefaults.standard.string(forKey: "lastName") {
            return (firstName, lastName)
        } else {
            return nil
        }
    }

    func deleteUserDetails() {
        UserDefaults.standard.removeObject(forKey: "firstName")
        UserDefaults.standard.removeObject(forKey: "lastName")
        // Supprimez ici d'autres détails que vous avez enregistrés.
    }

    func isLoggedIn() -> Bool {
        return user != nil
    }
    
    func logout() {
        user = nil
        deleteAuthToken()
        // Supprimez également les détails de l'utilisateur de UserDefaults ou Keychain, si vous les avez sauvegardés là.
    }
}