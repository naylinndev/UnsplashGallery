//
//  GalleryViewModel.swift
//  SnapPayDemo
//
//  Created by Nay Lin on 2025/07/23.
//

import Foundation
import RxSwift
import Moya
import RxCocoa
import RxMoya

class GalleryViewModel {
    private(set) var photosRelay = BehaviorRelay<[UnsplashPhoto]>(value: [])
    private var isLoading = false
    private var page = 0
    
    let disposeBag = DisposeBag()
    
    func fetchInitialPhotos() {
        photosRelay.accept([])
        isLoading = true
        page = 0
    }
    
    func refreshPhotos() {
        photosRelay.accept([])
        isLoading = true
        page = 0

        fetchPhotos()
    }
    
    func fetchPhotos() {
        guard !isLoading else { return }
        isLoading = true
        netApi.rx.request(NetAPI.getPhotoLists(page: page))
            .map([UnsplashPhoto].self)
            .subscribe(onSuccess: { [weak self] (newPhotos : [UnsplashPhoto]) in
                guard let self = self else { return }
                let updated = self.photosRelay.value + newPhotos
                self.photosRelay.accept(updated)
                self.isLoading = false
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .didFinishRefreshing, object: nil)
                }
                
            },onFailure: {[weak self] (error : Error) in
                print("Error loading users: \(error.localizedDescription)")
                self?.isLoading = false
            })
            .disposed(by: disposeBag)
    }
    
    func fetchMoreUsersIfNeeded() {
        page += 1
        fetchPhotos()
    }
    
    
}
