//
//  RecipesCollectionViewCell.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/23/24.
//

import UIKit

class RecipesCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "RecipesCell"
        
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    }()
    
    let cuisineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemRed
        return label
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        constructHierarchy()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with name: String, cuisine: String, image: UIImage?) {
        nameLabel.text = name
        cuisineLabel.text = cuisine
        imageView.image = image ?? UIImage(systemName: "carrot")
    }
    
    private func constructHierarchy() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(cuisineLabel)
    }
    
    private func applyConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cuisineLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: widthAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: cuisineLabel.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            cuisineLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            cuisineLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            cuisineLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12)
        ])
    }
}
