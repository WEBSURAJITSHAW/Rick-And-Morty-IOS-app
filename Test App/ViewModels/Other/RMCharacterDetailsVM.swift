//
//  RMCharacterDetailsVM.swift
//  Test App
//
//  Created by Surajit Shaw on 01/06/25.
//

import Foundation

public struct RMCharacterDetailsVM {
     let viewmodel: RMCharacter
    
     func getTitle() -> String {
         return viewmodel.name.capitalized
    }
}
