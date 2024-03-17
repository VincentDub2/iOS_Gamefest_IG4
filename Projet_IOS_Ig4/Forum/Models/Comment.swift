//
//  Comment.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 15/03/2024.
//

import Foundation

// Définition d'un commentaire lié à un post.
struct Comment: Identifiable, Codable {
    var id: Int
    var postId: Int
    var userId: String
    var name: String = "Anonyme"
    var body: String
    var createdAt: String
    enum CodingKeys: String, CodingKey {
        case id = "idComment"
        case postId = "idMsgForum"
        case userId = "idUser"
        case body = "message"
        case createdAt = "createdAt"
    }
    
}
