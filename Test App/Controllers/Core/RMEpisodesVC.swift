//
//  RMEpisodesVC.swift
//  Test App
//
//  Created by wadmin on 30/05/25.
//

import UIKit

class RMEpisodesVC: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        //        tableView.backgroundColor = .systemGroupedBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var episodes: [RMEpisode] = []
    private var viewModels: [RMEpisodeViewModel] = []
    private var apiInfo: RMInfo?
    private var isLoading = false
    
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episodes"
        setupTableView()
        fetchEpisodes()
//        setupSelectionGesture()
        
    }
    
    private func setupSelectionGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.3
        tableView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: tableView)
        
        switch gesture.state {
        case .began:
            guard let indexPath = tableView.indexPathForRow(at: location) else { return }
            selectedIndexPath = indexPath
            updateBlurForSelection()
            
        case .changed:
            // Optional: Update selection if finger moves to different cell
            guard let indexPath = tableView.indexPathForRow(at: location) else { return }
            if indexPath != selectedIndexPath {
                selectedIndexPath = indexPath
                updateBlurForSelection()
            }
            
        case .ended, .cancelled, .failed:
            // Handle selection action here if needed
            selectedIndexPath = nil
            updateBlurForSelection()
            
        default: break
        }
    }
    
    private func updateBlurForSelection() {
        tableView.visibleCells.forEach { cell in
            guard let episodeCell = cell as? EpisodeTableViewCell,
                  let indexPath = tableView.indexPath(for: cell) else { return }
            
            let shouldBlur = selectedIndexPath != nil && indexPath != selectedIndexPath
            episodeCell.setBlurred(shouldBlur)
        }
    }
    
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: EpisodeTableViewCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func fetchEpisodes(isLoadingMore: Bool = false) {
        guard !isLoading else { return }
        
        if isLoadingMore {
            guard let nextUrl = apiInfo?.next else { return }
            isLoading = true
            
            RMService.shared.execute(RMRequest(url: URL(string: nextUrl)!), expecting: RMEpisodesResponse.self) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    switch result {
                    case .success(let response):
                        self.episodes.append(contentsOf: response.results)
                        self.apiInfo = response.info
                        self.viewModels = self.episodes.map { RMEpisodeViewModel(episode: $0) }
                        self.tableView.reloadData()
                    case .failure(let error):
                        print("Error fetching more episodes: \(error)")
                    }
                }
            }
        } else {
            isLoading = true
            
            RMService.shared.execute(RMRequest.listEpisodesRequest, expecting: RMEpisodesResponse.self) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    switch result {
                    case .success(let response):
                        self.episodes = response.results
                        self.apiInfo = response.info
                        self.viewModels = self.episodes.map { RMEpisodeViewModel(episode: $0) }
                        self.tableView.reloadData()
                    case .failure(let error):
                        print("Error fetching episodes: \(error)")
                    }
                }
            }
        }
    }
}

extension RMEpisodesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeTableViewCell.reuseIdentifier, for: indexPath) as? EpisodeTableViewCell else {
            fatalError("Unable to dequeue EpisodeTableViewCell")
        }
        
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // Modify your existing willDisplay cell method:
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Update blur state when new cells appear
        if let episodeCell = cell as? EpisodeTableViewCell {
            let shouldBlur = selectedIndexPath != nil && indexPath != selectedIndexPath
            episodeCell.setBlurred(shouldBlur, animated: false)
        }
        
        // Existing pagination logic
        if indexPath.row == viewModels.count - 2 && apiInfo?.next != nil && !isLoading {
            fetchEpisodes(isLoadingMore: true)
        }
    }
}
