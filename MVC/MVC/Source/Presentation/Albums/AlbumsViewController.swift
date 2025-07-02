//
//  AlbumsViewController.swift
//  MVC
//
//  Created by 이현욱 on 6/30/25.
//

import UIKit

class AlbumsViewController: UIViewController {
    private var albums: [Album] = []
    private var albumsView: AlbumsView { view as! AlbumsView }

    override func loadView() {
        view = AlbumsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableHandlers()
        loadData()
    }

    private func setupNavigationBar() {
        title = "Albums"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    private func setupTableHandlers() {
        albumsView.tableView.dataSource = self
        albumsView.tableView.delegate   = self
        albumsView.tableView.rowHeight  = 100
    }

    private func loadData() {
        Task {
            do {
                let response = try await APIClient.shared.fetchAlbums()
                albums = response.albums.items
                albumsView.tableView.reloadData()
            } catch let tokenError as TokenError {
                print("TokenError 발생:", tokenError.debugDescription)
            } catch {
                print("fetchAlbums 실패:", error)
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AlbumsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }

    func tableView(_ tv: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell {
        guard let cell = tv.dequeueReusableCell(withIdentifier: AlbumCell.reuseIdentifier, for: ip) as? AlbumCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        let album = albums[ip.row]
        let isFavorite = FavoritesManager.shared.isFavorite(albumID: album.id)
        
        cell.configure(with: album, isFavorite: isFavorite)
        return cell
    }

    func tableView(_ tv: UITableView, didSelectRowAt ip: IndexPath) {
        let detailVC = DetailViewController(album: albums[ip.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension AlbumsViewController: AlbumCellDelegate {
    func albumCell(_ cell: AlbumCell, didToggleFavoriteFor albumID: String) {
        FavoritesManager.shared.toggleFavorite(albumID: albumID)
    }
}
