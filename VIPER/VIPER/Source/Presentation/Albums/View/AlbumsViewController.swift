//
//  AlbumsViewController.swift
//  VIPER
//
//  Created by 이현욱 on 6/30/25.
//

import UIKit

final class AlbumsViewController: UIViewController {
    var presenter: AlbumsViewOutput!
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableHandlers()
        setupTableView()
        presenter.viewDidLoad()
    }

    private func setupNavigationBar() {
        title = "Albums"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    private func setupTableHandlers() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
    }

    private func setupTableView() {
        view.addSubview(tableView)
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
}

extension AlbumsViewController: AlbumsViewInput {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func showError(_ message: String) {
        print("Error: \(message)")
    }
}

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
