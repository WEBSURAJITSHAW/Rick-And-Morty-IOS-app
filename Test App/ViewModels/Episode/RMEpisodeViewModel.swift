//
//  RMEpisodeViewModel.swift
//  Test App
//
//  Created by Surajit Shaw on 01/06/25.
//

import Foundation

struct RMEpisodeViewModel {
    let episode: RMEpisode
    
    var name: String {
        return episode.name
    }
    
    var airDate: String {
        return "Aired: \(episode.airDate)"
    }
    
    var episodeCode: String {
        return episode.episode
    }
    
    var characterCount: String {
        return "Characters: \(episode.characters.count)"
    }
}
