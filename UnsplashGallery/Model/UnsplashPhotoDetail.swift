//
//  UnsplashPhoto.swift
//  SnapPayDemo
//
//  Created by Nay Lin on 2025/07/23.
//

import Foundation

struct UnsplashPhotoDetail: Codable {
    let id: String
    let slug: String
    let createdAt: String?
    let updatedAt: String?
    let width: Int
    let height: Int
    let color: String
    let blurHash: String?
    let description: String?
    let altDescription: String?
    let urls: PhotoURLs
    let likes: Int
    let sponsorship: Sponsorship?
    let tags: [Tag]
    let relatedCollection: RelatedCollection?
    let exif: Exif?
    let location: Location?

    enum CodingKeys: String, CodingKey {
        case id, slug, width, height, color, description, urls, sponsorship, likes, tags,exif,location
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case blurHash = "blur_hash"
        case altDescription = "alt_description"
        case relatedCollection = "related_collections"
        
    }
}


struct Tag: Codable {
    let type: String
    let title: String
    
}

struct RelatedCollection: Codable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct Exif: Codable {
    let make: String?
    let model: String?
    let name: String?
    let aperture: String?
    
    enum CodingKeys: String, CodingKey {
        case make, model, name, aperture
    }
}

struct Location: Codable {
    let name: String?
    
}
