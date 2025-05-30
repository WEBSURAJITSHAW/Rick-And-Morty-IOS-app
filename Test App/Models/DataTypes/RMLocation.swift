//
//  RMLocation.swift
//  Test App
//
//  Created by wadmin on 30/05/25.
//

import Foundation

struct RMLocation: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url:String
    let created:String
    
}
