//
//  UnsplashPhoto.swift
//  SnapPayDemo
//
//  Created by Nay Lin on 2025/07/23.
//

import Foundation

struct UnsplashPhoto: Codable {
    let id: String
    let slug: String
    let createdAt: String
    let updatedAt: String
    let width: Int
    let height: Int
    let color: String
    let blurHash: String?
    let description: String?
    let altDescription: String?
    let urls: PhotoURLs
    let likes: Int
    let likedByUser: Bool
    let user: User
    let sponsorship: Sponsorship?

    enum CodingKeys: String, CodingKey {
        case id, slug, width, height, color, description, urls, user, sponsorship, likes
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case blurHash = "blur_hash"
        case altDescription = "alt_description"
        case likedByUser = "liked_by_user"
    }
}

struct PhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct User: Codable {
    let id: String
    let username: String
    let name: String
    let portfolioURL: String?
    let bio: String?
    let location: String?
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case id, username, name, bio, location
        case portfolioURL = "portfolio_url"
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

struct Sponsorship: Codable {
    let tagline: String
    let taglineURL: String
    let sponsor: User

    enum CodingKeys: String, CodingKey {
        case tagline
        case taglineURL = "tagline_url"
        case sponsor
    }
}
