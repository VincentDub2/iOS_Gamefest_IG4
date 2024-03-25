//
//  User.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 12/03/2024.
//

import Foundation

struct UserForRegister: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var address: String
    var password: String
    
}


struct User: Codable {
    let id: String
    let lastName: String
    let firstName: String
    let email: String
    let address: String
    let picture: String?
    let pictureId: String?
    let phoneNumber: String?
    let completed: Bool
    let isGod: Bool
    let createdAt: String
    let updatedAt: String
    let emailVerified: Bool?
    let emailVerificationToken: String?
}
