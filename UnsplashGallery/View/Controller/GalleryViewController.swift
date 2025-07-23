//
//  ViewController.swift
//  SnapPayDemo
//
//  Created by Nay Lin on 2025/07/23.
//

import UIKit
import RxCocoa
import RxSwift

extension Notification.Name {
    static let didFinishRefreshing = Notification.Name("didFinishRefreshing")
}

class GalleryViewController: UIViewController, UICollectionViewDelegate, StaggeredLayoutDelegate  {
    
    
    let viewModel = GalleryViewModel()
    let photos = BehaviorRelay<[UnsplashPhoto]>(value: [])
    
    private var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Unsplash Gallery"
        // Do any additional setup after loading the view.
        let layout = StaggeredLayout()
        layout.numberOfColumns = 2
        layout.delegate = self
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.refreshControl = refreshControl
        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        view.addSubview(collectionView)
        
        bindCollectionView()
        viewModel.fetchPhotos()
        
        
        NotificationCenter.default.addObserver(forName: .didFinishRefreshing,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            self?.collectionView.refreshControl?.endRefreshing()
        }
        
    }
    
    private func bindCollectionView() {
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.refreshPhotos()
            })
            .disposed(by: disposeBag)
        
        
        // Bind data to collection view
        viewModel.photosRelay
            .bind(to: collectionView.rx.items(cellIdentifier: "PhotoCell", cellType: PhotoCell.self)) { index, photo, cell in
                cell.configure(with: photo)
            }
            .disposed(by: disposeBag)
        
        // Handle selection
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let selectedPhoto = self?.viewModel.photosRelay.value[indexPath.item]
                // Push to detail view controller
                let vc = DetailViewController(photo: selectedPhoto!)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.contentOffset
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] offset in
                guard let self = self else { return }
                
//                let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
//                let maxIndex = visibleIndexPaths.map { $0.item }.max() ?? 0
//                
//                self.viewModel.fetchMoreUsersIfNeeded(currentIndex: maxIndex)
//                
                let contentHeight = self.collectionView.contentSize.height
                let scrollViewHeight = self.collectionView.frame.size.height
                let offsetY = offset.y
                
                if offsetY > contentHeight - scrollViewHeight - 500 {
                    self.viewModel.fetchMoreUsersIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        
        
    }
    
    // Delegate for layout height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath) -> CGFloat {
        let photo = viewModel.photosRelay.value[indexPath.item]
        let ratio = CGFloat(photo.height) / CGFloat(photo.width)
            let columnWidth = collectionView.bounds.width / 2
            return columnWidth * ratio
    }
    
    
}

