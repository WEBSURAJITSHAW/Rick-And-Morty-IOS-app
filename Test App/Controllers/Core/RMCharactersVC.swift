//
//  RMCharactersVC.swift
//  Test App
//
//  Created by wadmin on 30/05/25.
//

import UIKit

class RMCharactersVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Characters"
        
        RMService.shared.execute(RMRequest., expecting: Character.self) { result in
            switch result {
            case .success(let characters):
                print(characters)
            case .failure(let error):
                print(error)
            }
        }
    }
    

}
