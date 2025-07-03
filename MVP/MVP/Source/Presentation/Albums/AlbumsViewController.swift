//
//  AlbumsViewController.swift
//  MVP
//
//  Created by 이현욱 on 6/30/25.
//

import UIKit

//protocol AlbumsView: AnyObject {
//    func showError(_ message: String)
//    func showAlbums()
//    func showAlbumDetail(with album: Album)
//}

class AlbumsViewController: UIViewController {
    private let presenter = AlbumsPresenter()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableHandlers()
        setupTableView()
        setupAction()
        presenter.viewDidLoad()
    }
    
    private func setupNavigationBar() {
        title = "Albums"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupTableHandlers() {
        self.tableView.dataSource = self
        self.tableView.delegate   = self
        self.tableView.rowHeight  = 100
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.reuseIdentifier)
    }
    
    func setupAction() {
        print("in")
        presenter.onAlbumsChanged = { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        presenter.onSelectAlbum = { [weak self] in
                    let detailVC = DetailViewController(album: $0)
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        presenter.onError = {
            print($0)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AlbumsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.count()
    }
    
    func tableView(_ tv: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell {
        guard let cell = tv.dequeueReusableCell(withIdentifier: AlbumCell.reuseIdentifier, for: ip) as? AlbumCell else { return UITableViewCell() }
        presenter.configure(cell: cell, at: ip)
        return cell
    }
    
    func tableView(_ tv: UITableView, didSelectRowAt ip: IndexPath) {
        presenter.didSelectRow(at: ip)
    }
}

// MARK: - AlbumsView
//extension AlbumsViewController: AlbumsView {
//    func showAlbumDetail(with album: Album) {
//        let detailVC = DetailViewController(album: album)
//        navigationController?.pushViewController(detailVC, animated: true)
//    }
//    
//    
//    
//    func showAlbums() {
//
//    }
//    
//    func showError(_ message: String) {
//        print(message)
//    }
//}
