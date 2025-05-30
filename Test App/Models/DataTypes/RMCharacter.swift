//
//  RMCharacter.swift
//  Test App
//
//  Created by wadmin on 30/05/25.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let status: RMStatus
    let species: String
    let type: String
    let gender: RMGender
    let origin: RMOrigin
    let location: RMCharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
}

struct RMCharacterLocation: Codable {
    let name: String
    let url: String
}

struct RMOrigin: Codable {
    let name: String
    let url: String
}

enum RMStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "Unknown"
}

enum RMGender: String, Codable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "Unknown"
}
