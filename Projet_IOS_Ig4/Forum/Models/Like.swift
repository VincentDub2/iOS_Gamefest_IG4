//
//  Like.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 15/03/2024.
//

import Foundation

// Définition d'un "like" pour un post ou commentaire.
struct Like: Identifiable, Codable {
    var id: String
    var userId: String
    var postId: String?
    var commentId: String?
}
