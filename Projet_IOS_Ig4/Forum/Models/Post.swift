//
//  Post.swift
//  Projet_IOS_Ig4
//


import Foundation
import SwiftUI

// Définition d'un post dans le forum.
struct Post: Identifiable, Codable {
    var id: Int
    var userId: String
    var title: String
    var body: String
    var createdAt: String
    var User: User
    var avatar : Int = Int.random(in: 1...10)
    var color : Color = Color(hue: Double.random(in: 0...1), saturation: 0.5, brightness: 0.8)
    var likes: [Like]
    var comments: [Comment]
    enum CodingKeys: String, CodingKey {
        case id = "idMsgForum"
        case userId = "idUser"
        case title = "title"
        case body = "message"
        case createdAt = "createdAt"
        case likes = "like"
        case comments = "comments"
        case User = "user"
    }
}
