//
//  RMCharacterListView.swift
//  Test App
//
//  Created by Surajit Shaw on 31/05/25.
//

import UIKit

class RMCharacterListView: UIView {
    
     let rmCharacterListVM = RMCharacterListViewModel()
    
    private let indicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.color = .systemBlue
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let charactersCollectionView: UICollectionView = {
        
        let cvLayout = UICollectionViewFlowLayout()
        cvLayout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 15, right: 5)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cv.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.reuseID)
        cv.isHidden = true
        cv.alpha = 0
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
        indicator.startAnimating()
        rmCharacterListVM.fetchListOfCharacters()
        setUpCollectionView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCollectionView() {
        charactersCollectionView.dataSource = rmCharacterListVM
        charactersCollectionView.delegate = rmCharacterListVM
        
        rmCharacterListVM.onCharactersFetched = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.indicator.stopAnimating()
                self.charactersCollectionView.reloadData()
                self.charactersCollectionView.isHidden = false
                UIView.animate(withDuration: 0.4) {
                    self.charactersCollectionView.alpha = 1
                }
            }
        }
    }

    
    func configure() {
        addSubview(indicator)
        addSubview(charactersCollectionView)
        
        NSLayoutConstraint.activate([
            indicator.widthAnchor.constraint(equalToConstant: 100),
            indicator.heightAnchor.constraint(equalToConstant: 100),
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            charactersCollectionView.topAnchor.constraint(equalTo: topAnchor),
            charactersCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            charactersCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            charactersCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    
}

