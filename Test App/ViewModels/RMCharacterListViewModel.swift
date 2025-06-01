//
//  RMCharacterListViewModel.swift
//  Test App
//
//  Created by Surajit Shaw on 31/05/25.
//

import UIKit


protocol RMCharacterListViewModelDelegate: AnyObject {
    func didSelectCharacter(_ character: RMCharacter)
}

final class RMCharacterListViewModel: NSObject {
    
    var onCharactersFetched: (() -> Void)?
    
    var onLoadingMore: ((Bool) -> Void)?
    var isLoadingMoreCharacters = false
    var apiInfo: RMInfo? = nil
    
    
    weak var delegate: RMCharacterListViewModelDelegate?
    private var allCharacters: [RMCharacter] = [] {
        didSet {
            // Clear the view models when we get new base data
            if !isLoadingMoreCharacters {
                allCharacterViewModel.removeAll()
            }
            
            // Create view models for all current characters
            allCharacterViewModel = allCharacters.map {
                RMCharacterViewModel(imageUrl: $0.image, nameText: $0.name)
            }
            
            onCharactersFetched?()
        }
    }
    
    private var allCharacterViewModel: [RMCharacterViewModel] = []
    
    func fetchListOfCharacters(isLoadingMore: Bool = false) {
        if isLoadingMore {
            guard !isLoadingMoreCharacters, let nextUrlString = apiInfo?.next else { return }
            isLoadingMoreCharacters = true
            onLoadingMore?(true)
            
            guard let url = URL(string: nextUrlString) else {
                isLoadingMoreCharacters = false
                onLoadingMore?(false)
                return
            }
            
            let request = RMRequest(url: url)
            fetchCharacters(with: request, isLoadingMore: true)
        } else {
            let request = RMRequest.listCharactersRequests
            fetchCharacters(with: request, isLoadingMore: false)
        }
    }
    
    private func fetchCharacters(with request: RMRequest, isLoadingMore: Bool) {
            RMService.shared.execute(request, expecting: RMAllChractersResponse.self) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if isLoadingMore {
                        self.isLoadingMoreCharacters = false
                        self.onLoadingMore?(false)
                    }
                    
                    switch result {
                    case .success(let response):
                        let newCharacters = response.results
                        self.apiInfo = response.info
                        
                        if isLoadingMore {
                            self.allCharacters.append(contentsOf: newCharacters)
                        } else {
                            self.allCharacters = newCharacters
                        }
                        
                    case .failure(let error):
                        print("Failed to fetch characters: \(error)")
                        if isLoadingMore {
                            self.isLoadingMoreCharacters = false
                            self.onLoadingMore?(false)
                        }
                    }
                }
            }
        }
    
    // Expose data for the view
    func viewModel(at index: Int) -> RMCharacterViewModel {
        return allCharacterViewModel[index]
    }
    
    func numberOfItems() -> Int {
        return allCharacterViewModel.count
    }
}










extension RMCharacterListViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.reuseID, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported Cell")
        }
        cell.backgroundColor = .secondarySystemBackground
        let viewmodel = allCharacterViewModel[indexPath.row]
        cell.configure(with: viewmodel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCharacterViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          collectionView.deselectItem(at: indexPath, animated: true)
          guard indexPath.row < allCharacters.count else {
              print("Index out of range for character selection")
              return
          }
          let character = allCharacters[indexPath.row]
          print("\(character.name) is tapped!")
          delegate?.didSelectCharacter(character)
      }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            guard kind == UICollectionView.elementKindSectionFooter,
                  let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                    for: indexPath
                  ) as? RMFooterLoadingCollectionReusableView else {
                fatalError("Unsupported")
            }
            footer.startAnimating()
            return footer
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            guard let apiInfo = apiInfo, apiInfo.next != nil, !allCharacterViewModel.isEmpty else {
                return .zero
            }
            return CGSize(width: collectionView.frame.width, height: 100)
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard let apiInfo = apiInfo, apiInfo.next != nil,
                  !isLoadingMoreCharacters,
                  !allCharacterViewModel.isEmpty else {
                return
            }
            
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let scrollViewHeight = scrollView.frame.size.height
            
            if offsetY > contentHeight - scrollViewHeight - 120 {
                fetchListOfCharacters(isLoadingMore: true)
            }
        }
    
    
}
