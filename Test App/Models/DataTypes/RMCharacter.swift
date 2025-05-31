//
//  RMCharacter.swift
//  Test App
//
//  Created by wadmin on 30/05/25.
//

import Foundation

struct RMCharacter: Codable {
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
    case Alive = "Alive"
    case Dead = "Dead"
    case unknown = "unknown"
}

enum RMGender: String, Codable {
    case Male = "Male"
    case Female = "Female"
    case Genderless = "Genderless"
    case unknown = "unknown"
}
