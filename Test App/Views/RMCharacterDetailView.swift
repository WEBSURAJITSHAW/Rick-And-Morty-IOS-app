//
//  RMCharacterDetailView.swift
//  Test App
//
//  Created by Surajit Shaw on 01/06/25.
//

import UIKit

protocol RMCharacterDetailViewDelegate: AnyObject {
    func didSelectEpisode(_ episodeURL: String)
}

class RMCharacterDetailView: UIView {
    
    weak var delegate: RMCharacterDetailViewDelegate?
    private var episodes: [String] = []
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Header Section
    private let characterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel = RMCharacterDetailView.makeLabel(fontSize: 28, weight: .bold)
    private let statusSpeciesLabel = RMCharacterDetailView.makeLabel(fontSize: 18, weight: .medium)
    
    // Info Section
    private let infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let genderTitleLabel = RMCharacterDetailView.makeTitleLabel(text: "Gender")
    private let genderValueLabel = RMCharacterDetailView.makeValueLabel()
    
    private let originTitleLabel = RMCharacterDetailView.makeTitleLabel(text: "Origin")
    private let originValueLabel = RMCharacterDetailView.makeValueLabel()
    
    private let locationTitleLabel = RMCharacterDetailView.makeTitleLabel(text: "Location")
    private let locationValueLabel = RMCharacterDetailView.makeValueLabel()
    
    private let createdTitleLabel = RMCharacterDetailView.makeTitleLabel(text: "Created")
    private let createdValueLabel = RMCharacterDetailView.makeValueLabel()
    
    // Episodes Section
    private let episodesHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Appears in \(0) Episodes"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let episodesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 80) // Adjusted size
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(RMEpisodeCollectionViewCell.self,
                    forCellWithReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    // MARK: - Private Methods
       
   private func setupCollectionView() {
       episodesCollectionView.dataSource = self
       episodesCollectionView.delegate = self
   }
    // MARK: - Configure
    
    func configure(with character: RMCharacterDetailsVM) {
        dump(character)
        
        // Header Section
        nameLabel.text = character.viewmodel.name
        statusSpeciesLabel.text = "\(character.viewmodel.status) • \(character.viewmodel.species)"
        
        // Info Section
        genderValueLabel.text = character.viewmodel.gender.rawValue
        originValueLabel.text = character.viewmodel.origin.name
        locationValueLabel.text = character.viewmodel.location.name
        
        // Format date
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = isoFormatter.date(from: character.viewmodel.created) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            createdValueLabel.text = formatter.string(from: date)
        } else {
            createdValueLabel.text = "Unknown"
        }
        
        // Episodes Section
       episodes = character.viewmodel.episode
       episodesHeaderLabel.text = "Appears in \(episodes.count) Episodes"
       episodesCollectionView.reloadData()
        
        // Load image
        if let url = URL(string: character.viewmodel.image) {
            characterImageView.loadImage(from: url)
        }
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add all main components to contentView
        [characterImageView, nameLabel, statusSpeciesLabel,
         infoContainer, episodesHeaderLabel, episodesCollectionView].forEach {
            contentView.addSubview($0)
        }
        
        // Add info labels to info container
        [genderTitleLabel, genderValueLabel,
         originTitleLabel, originValueLabel,
         locationTitleLabel, locationValueLabel,
         createdTitleLabel, createdValueLabel].forEach {
            infoContainer.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // ScrollView fills the whole view
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Content view inside scroll view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Character image at top
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            characterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 200),
            characterImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Name below image
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Status & species
            statusSpeciesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            statusSpeciesLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusSpeciesLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // Info container
            infoContainer.topAnchor.constraint(equalTo: statusSpeciesLabel.bottomAnchor, constant: 20),
            infoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Info container content
            genderTitleLabel.topAnchor.constraint(equalTo: infoContainer.topAnchor, constant: 16),
            genderTitleLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor, constant: 16),
            genderTitleLabel.widthAnchor.constraint(equalToConstant: 80),
            
            genderValueLabel.topAnchor.constraint(equalTo: genderTitleLabel.topAnchor),
            genderValueLabel.leadingAnchor.constraint(equalTo: genderTitleLabel.trailingAnchor, constant: 8),
            genderValueLabel.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor, constant: -16),
            
            originTitleLabel.topAnchor.constraint(equalTo: genderTitleLabel.bottomAnchor, constant: 12),
            originTitleLabel.leadingAnchor.constraint(equalTo: genderTitleLabel.leadingAnchor),
            originTitleLabel.widthAnchor.constraint(equalTo: genderTitleLabel.widthAnchor),
            
            originValueLabel.topAnchor.constraint(equalTo: originTitleLabel.topAnchor),
            originValueLabel.leadingAnchor.constraint(equalTo: genderValueLabel.leadingAnchor),
            originValueLabel.trailingAnchor.constraint(equalTo: genderValueLabel.trailingAnchor),
            
            locationTitleLabel.topAnchor.constraint(equalTo: originTitleLabel.bottomAnchor, constant: 12),
            locationTitleLabel.leadingAnchor.constraint(equalTo: genderTitleLabel.leadingAnchor),
            locationTitleLabel.widthAnchor.constraint(equalTo: genderTitleLabel.widthAnchor),
            
            locationValueLabel.topAnchor.constraint(equalTo: locationTitleLabel.topAnchor),
            locationValueLabel.leadingAnchor.constraint(equalTo: genderValueLabel.leadingAnchor),
            locationValueLabel.trailingAnchor.constraint(equalTo: genderValueLabel.trailingAnchor),
            
            createdTitleLabel.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor, constant: 12),
            createdTitleLabel.leadingAnchor.constraint(equalTo: genderTitleLabel.leadingAnchor),
            createdTitleLabel.widthAnchor.constraint(equalTo: genderTitleLabel.widthAnchor),
            createdTitleLabel.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: -16),
            
            createdValueLabel.topAnchor.constraint(equalTo: createdTitleLabel.topAnchor),
            createdValueLabel.leadingAnchor.constraint(equalTo: genderValueLabel.leadingAnchor),
            createdValueLabel.trailingAnchor.constraint(equalTo: genderValueLabel.trailingAnchor),
            
            // Episodes section
            episodesHeaderLabel.topAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: 24),
            episodesHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            episodesHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            episodesCollectionView.topAnchor.constraint(equalTo: episodesHeaderLabel.bottomAnchor, constant: 12),
            episodesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            episodesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            episodesCollectionView.heightAnchor.constraint(equalToConstant: 80),
            episodesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Factory Methods
    
    private static func makeLabel(fontSize: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private static func makeTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private static func makeValueLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

// MARK: - Extensions

extension UIImageView {
    func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}


extension RMCharacterDetailView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMEpisodeCollectionViewCell else {
            fatalError("Unable to dequeue RMEpisodeCollectionViewCell")
        }
        
        let episodeURL = episodes[indexPath.row]
        cell.configure(with: episodeURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodeURL = episodes[indexPath.row]
        delegate?.didSelectEpisode(episodeURL)
    }
}

