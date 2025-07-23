//
//  DetailViewModel.swift
//  SnapPayDemo
//
//  Created by Nay Lin on 2025/07/23.
//

import RxSwift
import RxMoya
import Moya
import RxRelay
import Foundation

class DetailViewModel {
    private(set) var detailPhoto = BehaviorRelay<UnsplashPhotoDetail?>(value: nil)
    private var isLoading = false
    private var page = 0
    
    let disposeBag = DisposeBag()
   
   
    
    func fetchPhotoDetail(id : String) {
        guard !isLoading else { return }
        isLoading = true
        netApi.rx.request(NetAPI.getPhotoDetail(id: id))
            .flatMap { response -> Single<UnsplashPhotoDetail> in
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decoded = try decoder.decode(UnsplashPhotoDetail.self, from: response.data)
                        return .just(decoded)
                    } catch {
                        // 🔥 Print the raw JSON for inspection
                        if let jsonString = String(data: response.data, encoding: .utf8) {
                            print("❌ Decoding failed. Raw response:")
                            print(jsonString)
                        }
                        // 🔍 Print decoding error details
                        print("❌ Decoding error: \(error)")
                        return .error(error)
                    }
                }
            .subscribe(onSuccess: { [weak self] (newPhoto : UnsplashPhotoDetail) in
                guard let self = self else { return }
                self.detailPhoto.accept(newPhoto)
                self.isLoading = false
                
            },onFailure: {[weak self] (error : Error) in
                print("Error loading users: \(error.localizedDescription)")
                
                self?.isLoading = false
            })
            .disposed(by: disposeBag)
    }
    
    
    func purchase(photoId: String, paymentMethod: String) {
//        let request = KomojuPaymentRequest(
//            amount: 100, // or actual price
//            currency: "JPY",
//            paymentMethod: paymentMethod,
//            photoId: photoId
//        )

//        netApi.rx.request(.createPayment(request))
//            .subscribe(onSuccess: { response in
//                print("Success:", response.statusCode)
//            }, onFailure: { error in
//                print("Payment Error:", error.localizedDescription)
//            })
//            .disposed(by: disposeBag)
    }
    

}
