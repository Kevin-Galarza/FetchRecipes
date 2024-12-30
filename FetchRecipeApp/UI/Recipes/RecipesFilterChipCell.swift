//
//  RecipesFilterChipCell.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/29/24.
//

import UIKit

class RecipesFilterChipCell: UICollectionViewCell {
    static let reuseIdentifier = "RecipesFilterChipCell"
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, isSelected: Bool) {
        label.text = title
        label.textColor = isSelected ? .white : .black.withAlphaComponent(0.8)
        label.font = .boldSystemFont(ofSize: 16)
        contentView.backgroundColor = isSelected ? .systemRed : UIColor(hex: "F5F5F5")
    }
}
