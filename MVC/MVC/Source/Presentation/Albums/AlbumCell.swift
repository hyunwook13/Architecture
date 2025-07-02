//
//  AlbumCell.swift
//  MVC
//
//  Created by 이현욱 on 6/30/25.
//

protocol AlbumCellDelegate: AnyObject {
    func albumCell(_ cell: AlbumCell, didToggleFavoriteFor albumID: String)
}

import UIKit

final class AlbumCell: UITableViewCell {
    static let reuseIdentifier = "AlbumCell"
    
    private let cellView = AlbumCellView()
    weak var delegate: AlbumCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setAction()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellView.reset()
    }
    
    func configure(with album: Album, isFavorite: Bool) {
        cellView.configure(with: album, isFavorite: isFavorite)
    }
    
    func setImage(_ image: UIImage) {
        cellView.setImage(image)
    }
    
    private func setup() {
        contentView.addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
        
        cellView.backgroundColor = .white
        cellView.layer.cornerRadius = 12
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.1
        cellView.layer.shadowOffset = .init(width: 0, height: 1)
        cellView.layer.shadowRadius = 4
        selectionStyle = .none
    }
    
    private func setAction() {
        cellView.favoriteToggled = {
            self.delegate?.albumCell(self, didToggleFavoriteFor: $0)
        }
    }
}
