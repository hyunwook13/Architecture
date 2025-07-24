//
//  AlbumsViewController.swift
//  RIBs-Study
//
//  Created by 이현욱 on 7/22/25.
//

import RIBs
import RxSwift
import UIKit

protocol AlbumsPresentableListener: AnyObject {
    func loadAlbums()
    func selectedAlbum(_ album: Album)
}

class AlbumsViewController: UIViewController, AlbumsPresentable, AlbumsViewControllable {
    
    private var albums: [Album] = []
    weak var listener: AlbumsPresentableListener?
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        print("viewdidload")
        listener?.loadAlbums()
    }
    
    func loadedData(with albums: [Album]) {
        self.albums = albums
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - AlbumsViewControllable
    func pushToDetail(viewController: ViewControllable) {
        navigationController?.pushViewController(viewController.uiviewController, animated: true)
    }
    
    private func setupNavigationBar() {
        title = "Albums"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.rowHeight  = 100
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.reuseIdentifier)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AlbumsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tv: UITableView, didSelectRowAt ip: IndexPath) {
        listener?.selectedAlbum(albums[ip.row])
//        let detailVC = DetailViewController(album: albums[ip.row])
//        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tv: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell {
        guard let cell = tv.dequeueReusableCell(withIdentifier: AlbumCell.reuseIdentifier, for: ip) as? AlbumCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        let album = albums[ip.row]
        let isFavorite = FavoritesManager.shared.isFavorite(albumID: album.id)
        
        Task {
            do {
                let urlStr = album.images.first?.url
                let img = try await APIClient.shared.getImage(with: urlStr)
                cell.setImage(img)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        cell.configure(with: album, isFavorite: isFavorite)
        return cell
    }
}

extension AlbumsViewController: AlbumCellDelegate {
    func albumCell(_ cell: AlbumCell, didToggleFavoriteFor albumID: String) {
        FavoritesManager.shared.toggleFavorite(albumID: albumID)
    }
}
