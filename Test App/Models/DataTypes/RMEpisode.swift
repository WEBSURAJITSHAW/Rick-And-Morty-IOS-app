//
//  RMEpisode.swift
//  Test App
//
//  Created by wadmin on 30/05/25.
//

import Foundation

struct RMEpisode: Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
