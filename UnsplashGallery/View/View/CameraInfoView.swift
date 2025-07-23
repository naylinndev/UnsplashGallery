//
//  CameraInfoView.swift
//  SnapPayDemo
//
//  Created by Nay Lin on 2025/07/24.
//
import UIKit

class CameraInfoView: UIView {

    private let titleLabel = UILabel()
    private let cameraNameView = IconLabelView(icon: UIImage(systemName: "camera"))
    private let publishedDateView = IconLabelView(icon: UIImage(systemName: "calendar"))
    private let locationView = IconLabelView(icon: UIImage(systemName: "location"))

    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        titleLabel.text = "Info"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black

        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading

        [titleLabel, cameraNameView, locationView].forEach {
            stackView.addArrangedSubview($0)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }

    func bind(info: UnsplashPhotoDetail) {
        cameraNameView.bind(text: info.exif?.name ?? "------")
        locationView.bind(text: info.location?.name ?? "------")
    }
}
