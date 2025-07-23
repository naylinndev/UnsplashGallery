//
//  PhotoCell.swift
//  SnapPayDemo
//
//  Created by Nay Lin on 2025/07/23.
//

import UIKit
import Kingfisher


class PhotoCell: UICollectionViewCell {
    let imageView = UIImageView()
    private let gradientLayer = CAGradientLayer()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let overlayView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add shadow to the cell
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        layer.masksToBounds = false
        layer.cornerRadius = 10
        
        // Background image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Overlay view for gradient + content
        overlayView.backgroundColor = .clear
        contentView.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        // Profile image
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 16
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.white.cgColor
        overlayView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Name label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textColor = .white
        overlayView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            overlayView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            profileImageView.leftAnchor.constraint(equalTo: overlayView.leftAnchor, constant: 8),
            profileImageView.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -8),
            profileImageView.widthAnchor.constraint(equalToConstant: 32),
            profileImageView.heightAnchor.constraint(equalToConstant: 32),
            
            nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nameLabel.rightAnchor.constraint(lessThanOrEqualTo: overlayView.rightAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Add or update gradient
        gradientLayer.frame = overlayView.bounds
//        if gradientLayer.superlayer == nil {
//            gradientLayer.colors = [UIColor.black.withAlphaComponent(0.4).cgColor,
//                                    UIColor.clear.cgColor]
//            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
//            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
//            overlayView.layer.insertSublayer(gradientLayer, at: 0)
//        }
    }
    
    func configure(with photo: UnsplashPhoto) {
        nameLabel.text = photo.user.name
        
        // Load main photo
        if let url = URL(string: photo.urls.small) {
            imageView.kf.setImage(with: url)
        }
        
        // Load profile image
        if let profileURL = URL(string: photo.user.profileImage.medium) {
            profileImageView.kf.setImage(with: profileURL)
        }
    }
    
    
}
