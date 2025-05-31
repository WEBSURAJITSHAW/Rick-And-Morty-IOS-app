//
//  RMCharactersVC.swift
//  Test App
//
//  Created by wadmin on 30/05/25.
//

import UIKit

class RMCharactersVC: UIViewController {
    
    private let rmCharacterListView = RMCharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Characters"
        
        configure()
    }
    
    func configure() {
        view.addSubview(rmCharacterListView)
        rmCharacterListView.translatesAutoresizingMaskIntoConstraints = false
        
          NSLayoutConstraint.activate([
            rmCharacterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rmCharacterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            rmCharacterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rmCharacterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
          ])
    }
    

}
