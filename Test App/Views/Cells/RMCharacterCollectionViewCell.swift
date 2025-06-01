//
//  RMCharacterCollectionViewCell.swift
//  Test App
//
//  Created by Surajit Shaw on 31/05/25.
//

import UIKit
class RMCharacterCollectionViewCell: UICollectionViewCell {
    static let reuseID = "RMCharacterCollectionViewCell"
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(characterImageView)
        characterImageView.addSubview(characterNameLabel) // overlay on image
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .secondarySystemBackground
        
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            characterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            characterNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with viewmodel: RMCharacterViewModel) {
        characterNameLabel.text = viewmodel.nameText
        characterImageView.loadImage(from: viewmodel.imageUrl ?? "")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    
    
