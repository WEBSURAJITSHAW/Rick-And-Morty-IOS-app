//
//  RMEpisodesResponse.swift
//  Test App
//
//  Created by Surajit Shaw on 01/06/25.
//

import Foundation

struct RMEpisodesResponse: Codable {
    let info: RMInfo
    let results: [RMEpisode]
}

