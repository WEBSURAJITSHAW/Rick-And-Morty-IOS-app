//
//  RMSingleChracterResponse.swift
//  Test App
//
//  Created by wadmin on 30/05/25.
//

import Foundation

struct RMAllChractersResponse: Codable {
    
    let info: RMInfo
    let results: [RMCharacter]
    
}
    

struct RMInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
  }
