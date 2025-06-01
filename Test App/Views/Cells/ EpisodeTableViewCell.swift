//
//  File.swift
//  Test App
//
//  Created by Surajit Shaw on 01/06/25.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "EpisodeTableViewCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let charactersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectionBlurView: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        blur.alpha = 0
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur.layer.cornerRadius = 12
        blur.clipsToBounds = true
        return blur
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(episodeLabel)
        cardView.addSubview(airDateLabel)
        cardView.addSubview(charactersLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            episodeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            episodeLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            airDateLabel.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor, constant: 8),
            airDateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            airDateLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            
            charactersLabel.centerYAnchor.constraint(equalTo: episodeLabel.centerYAnchor),
            charactersLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
        
        // Add selection blur view (behind content)
        //       insertSubview(selectionBlurView, at: 0)
        //       selectionBlurView.frame = cardView.bounds
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.2) {
            self.cardView.transform = highlighted ? CGAffineTransform(scaleX: 0.90, y: 0.90) : .identity
        }
    }
    
    func setBlurred(_ blurred: Bool, animated: Bool = true) {
        let targetAlpha: CGFloat = blurred ? 1 : 0
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.selectionBlurView.alpha = targetAlpha
            }
        } else {
            selectionBlurView.alpha = targetAlpha
        }
    }
    
    func configure(with viewModel: RMEpisodeViewModel) {
        nameLabel.text = viewModel.name
        episodeLabel.text = viewModel.episodeCode
        airDateLabel.text = viewModel.airDate
        charactersLabel.text = viewModel.characterCount
    }
}
