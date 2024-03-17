//
//  Like.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 15/03/2024.
//

import Foundation

// Définition d'un "like" pour un post ou commentaire.
struct Like: Identifiable, Codable {
    var id: Int
    var userId: String
    var postId: Int?
    enum CodingKeys: String, CodingKey {
        case id = "idLike"
        case userId = "idUser"
        case postId = "idMsgForum"
    }
}
