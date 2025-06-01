//
//  RMCharacterDetailViewController.swift
//  Test App
//
//  Created by Surajit Shaw on 01/06/25.
//

import UIKit

class RMCharacterDetailViewController: UIViewController {
    
    private var viewmodel: RMCharacterDetailsVM
    
    private let detailView = RMCharacterDetailView(frame: .zero)
    
    init(viewmodel: RMCharacterDetailsVM) {
        
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewmodel.getTitle()
        navigationItem.largeTitleDisplayMode = .never
        
        detailView.configure(with: viewmodel)
        view.addSubview(detailView)
        addConstraint()
    }
    
    func addConstraint() {
        detailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    

}
