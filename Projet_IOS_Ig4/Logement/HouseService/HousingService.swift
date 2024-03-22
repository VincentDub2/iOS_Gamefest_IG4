import Foundation
import Combine
import Alamofire

class HousingService {
    let tempoIdUser = "1"
    // Récupérer tous les posts
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
       
    
    // Créer un post
    func createHoussing(availibility : Int,description:String,city: String,postalCode: String,isOffering : Bool) -> AnyPublisher<Bool, Error> {
        let endpoint = "/housings"
        let parameters: Parameters = [
            "availibility": availibility,
            "description": description,
            "city": city,
            "postalCode": postalCode,
            "isOffering": isOffering,
            "idUser": tempoIdUser,
        ]
            
            return Future<Bool, Error> { promise in
                APIManager.requestPOST(endpoint: endpoint, parameters: parameters) { (result: Result<ResponseApi, AFError>) in
                    switch result {
                    case .success(_):
                        promise(.success(true))
                        _ = self.fetchHousing()
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    
}
