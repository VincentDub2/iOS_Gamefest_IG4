//
//  PlanningService.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 14/03/2024.
//

import Foundation
import Alamofire

class PlanningService {
    static let shared = PlanningService()
    var creneau: [Creneau] = []
    /*
     private var planning: Planning?
     
     func savePlanning(_ planning: Planning) {
         self.planning = planning
     }
     
     func getPlanning() -> Planning? {
         return planning
     }
     */
    //https://montpellier-game-fest-volunteers-api-vincentdub2.vercel.app/creneaux/user/51681ba6-d39e-4bec-ba33-4f7288bf9ad2/festival/1
    let tempoUserId = "51681ba6-d39e-4bec-ba33-4f7288bf9ad2"
    let tempoFestivalId = 1
    
    func getCreneaux(completion: @escaping (Result<[Creneau], AFError>) -> Void) {
        let endpoint = "/creneaux/user/\(tempoUserId)/festival/\(tempoFestivalId)"
        
        APIManager.requestGET(endpoint: endpoint, parameters: nil) { (result: Result<[Creneau], AFError>) in
            switch result {
            case .success(let creneau):
                DispatchQueue.main.async {
                    self.creneau = creneau
                    print(creneau)
                    completion(.success(creneau)) // Informe l'appelant du succès avec les données des créneaux.
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error)) // Passe l'erreur à l'appelant.
                }
            }
        }
    }

}
