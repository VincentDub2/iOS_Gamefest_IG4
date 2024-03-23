import Foundation
import Combine
import Alamofire

class HousingService {
    let tempoIdUser = "1"
    
    /// Récupérer tous les logements
    /// - Throws: Error
    /// - Returns: AnyPublisher<[Housing], Error>
       func fetchHousing() -> AnyPublisher<[Housing], Error> {
           let endpoint = "/housings"
           
           return Future<[Housing], Error> { promise in
               APIManager.requestGET(endpoint: endpoint) { (result: Result<[Housing], AFError>) in
                   print(result)
                   switch result {
                   case .success(let posts):
                       promise(.success(posts))
                   case .failure(let error):
                       promise(.failure(error))
                   }
               }
           }
           .eraseToAnyPublisher()
       }
       
    
    /// Créer un post
    /// - Parameters: availibility, description, city, postalCode, isOffering
    /// - Returns: Bool
    /// - Throws: Error
    func createHousing(availability : Int,description:String,city: String,postalCode: String,isOffering : Bool) -> AnyPublisher<Bool, Error> {
        let endpoint = "/housings"
        let parameters: Parameters = [
            "availibility": availability,
            "description": description,
            "city": city,
            "postalCode": postalCode,
            "isOffering": isOffering,
            "idUser": tempoIdUser,
        ]
            
            return Future<Bool, Error> { promise in
                APIManager.requestPOST(endpoint: endpoint, parameters: parameters) { (result: Result<Housing, AFError>) in
                    switch result {
                    case .success(_):
                        promise(.success(true))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    
    
    /// Supprimer un post
    /// - Parameter id: id du post à supprimer
    /// - Returns: Bool
    /// - Throws: Error
    func deleteHousing(id: Int) -> AnyPublisher<Bool, Error> {
        let endpoint = "/housings/\(id)"
        return Future<Bool, Error> { promise in
            APIManager.requestDELETE(endpoint: endpoint) { (result: Result<Housing, AFError>) in
                switch result {
                case .success(_):
                    promise(.success(true))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
}
