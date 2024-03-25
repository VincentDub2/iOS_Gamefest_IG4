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
        UserDefaults.standard.set(user.picture, forKey: "profilePictureURL")
    }
    
    func getUser() -> User? {
        return user
    }
    
    func saveUserDetails(_ user: User) {
        UserDefaults.standard.set(user.firstName, forKey: "firstName")
        UserDefaults.standard.set(user.lastName, forKey: "lastName")
        // Ajoutez ici d'autres détails que vous souhaitez enregistrer.
    }

    func getUserDetails() -> (firstName: String, lastName: String, pictureURL: String)? {
        if let firstName = UserDefaults.standard.string(forKey: "firstName"),
           let lastName = UserDefaults.standard.string(forKey: "lastName"),
           let pictureURL = UserDefaults.standard.string(forKey: "profilePictureURL") {
            return (firstName, lastName, pictureURL)
        } else {
            return nil
        }
    }

    func deleteUserDetails() {
        UserDefaults.standard.removeObject(forKey: "firstName")
        UserDefaults.standard.removeObject(forKey: "lastName")
        UserDefaults.standard.removeObject(forKey: "profilePictureURL")
        // Supprimez ici d'autres détails que vous avez enregistrés.
    }

    func isLoggedIn() -> Bool {
        return user != nil
    }
    
    func logout() {
        user = nil
        deleteAuthToken()
        deleteUserDetails()
        
    }
    
    func refreshUserDetails() {
        guard let authToken = getAuthToken() else { return }
        
        let url = URL(string: "https://montpellier-game-fest-volunteers-api-vincentdub2.vercel.app/users/current")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else { return }
            
            if let user = try? JSONDecoder().decode(User.self, from: data) {
                DispatchQueue.main.async {
                    self?.saveUser(user)
                    // After updating the user, also update UserDefaults with the new picture URL
                    UserDefaults.standard.set(user.picture, forKey: "profilePictureURL")
                }
            }
        }
        
        task.resume()
    }


}
