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
    
    weak var delegate: RMCharacterListViewModelDelegate?
    
    private var allCharacters: [RMCharacter] = [] {
        didSet {
            for character in allCharacters {
                let viewmodel = RMCharacterViewModel(imageUrl: character.image, nameText: character.name)
                allCharacterViewModel.append(viewmodel)
            }
            onCharactersFetched?()
        }
    }
    
    private var allCharacterViewModel: [RMCharacterViewModel] = []
    
    func fetchListOfCharacters () {
        RMService.shared.execute(RMRequest.listCharactersRequests, expecting: RMAllChractersResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let allCharactersResponse):
                let allCharactersResult = allCharactersResponse.results
                self.allCharacters = allCharactersResult
            case .failure(let error):
                print(error)
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
        print("\(allCharacters[indexPath.row].name) is tapped!")
        delegate?.didSelectCharacter(allCharacters[indexPath.row])
    }
    
    
}
