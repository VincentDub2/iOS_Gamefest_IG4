//
//  Comment.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 15/03/2024.
//

import Foundation

// Définition d'un commentaire lié à un post.
struct Comment: Identifiable, Codable {
    var id: String
    var postId: String
    var userId: String
    var body: String
    var createdAt: Date
}
