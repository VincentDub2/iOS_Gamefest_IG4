//
//  Post.swift
//  Projet_IOS_Ig4
//


import Foundation

// Définition d'un post dans le forum.
struct Post: Identifiable, Codable {
    var id: String
    var userId: String
    var title: String
    var body: String
    var createdAt: Date
    var likes: [Like]
    var comments: [Comment]
}
