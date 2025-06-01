//
//  RMEpisodeCollectionViewCell.swift
//  Test App
//
//  Created by Surajit Shaw on 01/06/25.
//

import UIKit

class RMEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMEpisodeCollectionViewCell"
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let episodeNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(episodeNumberLabel)
        stackView.addArrangedSubview(episodeTitleLabel)
        
        // Add visual feedback when cell is tapped
        let tapFeedback = UIImpactFeedbackGenerator(style: .soft)
        tapFeedback.prepare()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with episodeURL: String) {
        // Extract episode number from URL
        if let episodeNumber = episodeURL.split(separator: "/").last {
            episodeNumberLabel.text = "EP \(episodeNumber)"
            
            // Set different colors based on season (just for visual variety)
            let season = Int(episodeNumber) ?? 0
            let color: UIColor
            switch season {
            case 1...10: color = .systemBlue
            case 11...20: color = .systemPurple
            case 21...30: color = .systemOrange
            case 31...40: color = .systemGreen
            default: color = .systemPink
            }
            
            containerView.backgroundColor = color.withAlphaComponent(0.1)
            episodeNumberLabel.textColor = color
        }
        
        // Default title - you could fetch actual episode names if available
        episodeTitleLabel.text = "Rick and Morty"
    }
    
    // MARK: - Selection Effects
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
                self.containerView.alpha = self.isHighlighted ? 0.8 : 1.0
            }
        }
    }
}
