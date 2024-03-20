//
//  Creneau.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 14/03/2024.
//

import Foundation

/*
 {
         "idCreneau": 2,
         "timeStart": "2024-02-12T10:00:49.000Z",
         "timeEnd": "2024-02-12T12:00:49.000Z",
         "idFestival": 1
     },
 */

struct Creneau: Codable, Hashable {
    var id: Int
    var timeStart: String
    var timeEnd: String
    var idFestival: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "idCreneau"
        case timeStart = "timeStart"
        case timeEnd = "timeEnd"
        case idFestival = "idFestival"
    }
    
    
    
}
