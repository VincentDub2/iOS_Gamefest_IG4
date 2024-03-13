//
//  AuthService.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 12/03/2024.
//
import Foundation


struct AuthResponse: Codable {
    let token: String
}

enum AuthError: Error {
    case noData
    case failedRequest
    case invalidCredentials
}

class AuthService {
    let baseUrlString = "https://montpellier-game-fest-volunteers-api-vincentdub2.vercel.app"
    
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
            guard let url = URL(string: "\(baseUrlString)/login") else {
                completion(.failure(AuthError.failedRequest))
                return
            }

            let credentials = ["email": email, "password": password]
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: [])
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? AuthError.failedRequest))
                    return
                }
                
                guard let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
                    completion(.failure(AuthError.invalidCredentials))
                    return
                }
                
                completion(.success(authResponse.token))
            }
            
            task.resume()
        }
    
    func register(userDetails: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrlString)/register") else {
            completion(.failure(AuthError.failedRequest))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(userDetails)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201, let _ = data else {
                completion(.failure(error ?? AuthError.failedRequest))
                return
            }

            completion(.success(true))
        }

        task.resume()
    }

}
