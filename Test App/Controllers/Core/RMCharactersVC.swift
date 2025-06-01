//
//  RMCharactersVC.swift
//  Test App
//
//  Created by wadmin on 30/05/25.
//

import UIKit

class RMCharactersVC: UIViewController {
    
    private let rmCharacterListView = RMCharacterListView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Characters"
        
        configure()
//        setupSearchController()
//        setupBindings()
        rmCharacterListView.rmCharacterListVM.delegate = self
    }
    
    private func configure() {
        view.addSubview(rmCharacterListView)
        rmCharacterListView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rmCharacterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rmCharacterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            rmCharacterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rmCharacterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        searchController.searchBar.searchBarStyle = .minimal
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Customize search bar appearance if needed
        searchController.searchBar.tintColor = .systemBlue
        searchController.searchBar.autocapitalizationType = .none
    }
    
    // In your view controller setup:
    private func setupBindings() {
        rmCharacterListView.rmCharacterListVM.onCharactersFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.rmCharacterListView.charactersCollectionView.reloadData()
            }
        }
    }
}

extension RMCharactersVC: RMCharacterListViewModelDelegate {
    func didSelectCharacter(_ character: RMCharacter) {
        let characterDetailVC = RMCharacterDetailViewController(viewmodel: RMCharacterDetailsVM(viewmodel: character))
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(characterDetailVC, animated: true)
        }
    }
}

extension RMCharactersVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Ensure we're on the main thread
        DispatchQueue.main.async {
            guard let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces).lowercased() else {
                self.rmCharacterListView.rmCharacterListVM.resetSearch()
                self.rmCharacterListView.charactersCollectionView.reloadData()
                return
            }
            
            if searchText.isEmpty {
                self.rmCharacterListView.rmCharacterListVM.resetSearch()
            } else {
                self.rmCharacterListView.rmCharacterListVM.filterCharacters(with: searchText)
            }
            
            // Force immediate UI update
            self.rmCharacterListView.charactersCollectionView.reloadData()
        }
    }
}
