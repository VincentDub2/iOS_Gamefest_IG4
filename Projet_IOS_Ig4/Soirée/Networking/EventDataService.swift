//
//  EventDataService.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 22/03/2024.
//

import Foundation
import Alamofire
import Combine
// EventDataService.swift


class EventDataService {
    
    
    func fetchUpcomingEvents() -> AnyPublisher<[Soiree], Error> {
        let endpoint = "/events"
        
        return Future<[Soiree], Error> { promise in
            APIManager.requestGET(endpoint: endpoint) { (result: Result<[Soiree], AFError>) in
                print(result)
                switch result {
                case .success(let soirees):
                    promise(.success(soirees))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    

}
