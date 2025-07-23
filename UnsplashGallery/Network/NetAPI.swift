//
//  GitHubAPI.swift
//  TableViewWithMoya
//
//  Created by Nay Lin on 2025/07/22.
//

import Moya
import Foundation
import Alamofire
import RxSwift

enum NetAPI{
    case getPhotoLists(page : Int)
    case getPhotoDetail(id : String)
    
}


extension NetAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: Const.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getPhotoLists:
            return "/photos"
            
        case .getPhotoDetail(let id):
            return "/photos/\(id)"

        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters : [String: Any] {
        switch self {
        case .getPhotoLists(let page):
            return ["page": page,"per_page": 20,"client_id" : Const.ACCESS_KEY]
            
        case .getPhotoDetail:
            return ["client_id" : Const.ACCESS_KEY]

        }
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
    
}


class DefaultAlamofireManager: Alamofire.Session, @unchecked Sendable {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.Session.default.session.configuration.httpAdditionalHeaders
        configuration.timeoutIntervalForRequest = 20 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 20 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}

//let netApi = MoyaProvider<NetAPI>(plugins: [NetworkLoggerPlugin()])
let netApi = MoyaProvider<NetAPI>(session: DefaultAlamofireManager.sharedManager,plugins: [NetworkLoggerPlugin()])
