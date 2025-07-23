//
//  IconLabelView.swift
//  SnapPayDemo
//
//  Created by Nay Lin on 2025/07/24.
//
import UIKit

class IconLabelView: UIView {
    private let iconImageView = UIImageView()
    private let textLabel = UILabel()

    init(icon: UIImage?) {
        super.init(frame: .zero)
        setup(icon: icon)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(icon: nil)
    }

    private func setup(icon: UIImage?) {
        iconImageView.image = icon
        iconImageView.tintColor = .gray
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        textLabel.font = .systemFont(ofSize: 14)
        textLabel.textColor = .darkGray
        textLabel.numberOfLines = 1

        let hStack = UIStackView(arrangedSubviews: [iconImageView, textLabel])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center

        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func bind(text: String) {
        textLabel.text = text
    }
}
