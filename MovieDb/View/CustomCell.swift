//
//  CustomCell.swift
//  MovieDb
//
//  Created by Haris Fadhilah on 15/03/23.
//

import Foundation
import UIKit

class CustomCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 7
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var movieTitle: UILabel = {
        let label = UILabel()
        label.text = "The Batman"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        contentView.addSubview(moviePoster)
        contentView.addSubview(movieTitle)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            moviePoster.topAnchor.constraint(equalTo: contentView.topAnchor),
            moviePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moviePoster.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95),
            moviePoster.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.3),
            
            movieTitle.topAnchor.constraint(equalTo: moviePoster.bottomAnchor, constant: 3),
            movieTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
