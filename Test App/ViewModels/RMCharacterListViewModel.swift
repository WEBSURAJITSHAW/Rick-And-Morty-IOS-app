//
//  RMCharacterListViewModel.swift
//  Test App
//
//  Created by Surajit Shaw on 31/05/25.
//

import UIKit

final class RMCharacterListViewModel: NSObject {
    func fetchListOfCharacters () {
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

extension RMCharacterListViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        
        return CGSize(width: width, height: width * 1.5)
    }

}
