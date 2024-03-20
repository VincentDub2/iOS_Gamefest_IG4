//
//  Poste.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 15/03/2024.
//

import Foundation

struct PosteModel: Decodable {
    var idPoste: Int
    var name: String
    var description: String
    var capacityPoste: Int
    var idFestival: Int
}
