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
        
        RMService.shared.execute(RMRequest.listCharactersRequests, expecting: RMAllChractersResponse.self) { result in
            switch result {
            case .success(let allCharactersResponse):
                print(allCharactersResponse.results.count)
                print(allCharactersResponse.results)
            case .failure(let error):
                print(error)
            }
        }
    }
    

}
