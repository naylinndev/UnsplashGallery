//
//  DetailViewController.swift
//  SnapPayDemo
//
//  Created by Nay Lin on 2025/07/23.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: DetailViewModel
    private let photo: UnsplashPhoto

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let cameraInfoView = CameraInfoView()
    private let tagsLabel = UILabel()
    private let buyButton = UIButton(type: .system)

    init(photo: UnsplashPhoto) {
        self.photo = photo
        self.viewModel = DetailViewModel()
        super.init(nibName: nil, bundle: nil)
        self.title = "\(photo.user.name)'s Photo"
        viewModel.fetchPhotoDetail(id: photo.id)

    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -80),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.backgroundColor = .lightGray
        stackView.addArrangedSubview(imageView)

        stackView.addArrangedSubview(cameraInfoView)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 16)
        stackView.addArrangedSubview(descriptionLabel)

        tagsLabel.font = .italicSystemFont(ofSize: 14)
        tagsLabel.numberOfLines = 0
        tagsLabel.textColor = .systemBlue
        stackView.addArrangedSubview(tagsLabel)

        buyButton.setTitle("Buy for $0.1", for: .normal)
        buyButton.backgroundColor = .black
        buyButton.setTitleColor(.white, for: .normal)
        buyButton.layer.cornerRadius = 12
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buyButton)

        NSLayoutConstraint.activate([
            buyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            buyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            buyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            buyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }

    private func bindViewModel() {
        // Load the main image
        if let url = URL(string: photo.urls.small) {
            self.imageView.kf.setImage(with: url)
        }

       
        
        viewModel.detailPhoto
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] info in
                guard let self = self else { return }
                self.cameraInfoView.bind(info: info!)
                self.descriptionLabel.text = info?.description ?? "No description"
            })
            .disposed(by: disposeBag)

        buyButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showPaymentOptions { method in
                    self?.viewModel.purchase(photoId: self!.photo.id, paymentMethod: method)
                        }
            })
            .disposed(by: disposeBag)
    }

    func showPaymentOptions(onSelect: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "Choose Payment Method", message: nil, preferredStyle: .actionSheet)

        let paymentMethods = [
            ("Konbini", "konbini"),
            ("Credit Card", "credit_card"),
            ("Bank Transfer", "bank_transfer"),
            ("Pay-easy", "payeasy")
        ]

        paymentMethods.forEach { (title, value) in
            alert.addAction(UIAlertAction(title: title, style: .default) { _ in
                onSelect(value)
            })
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            rootVC.present(alert, animated: true)
        }
    }
    
    
    

}
