//
//  Model.swift
//  RestoPick
//
//  Created by ZML on 2023/06/26.
//
import Foundation

struct Restaurant: Decodable,Identifiable {
    let id: String
    let name: String
    let address: String
    let access: String
    let open: String
    let logoImage: URL
    let photos: Photos
    let genre: Genre
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case access
        case open
        case logoImage = "logo_image"
        case photos = "photo"
        case genre
    }
    
    struct Photos: Decodable {
        let mobile: MobilePhotos
        
        struct MobilePhotos: Decodable {
            let l: URL
            let s: URL
        }
    }
}

struct Genre: Decodable {
        let point: String
        
        enum CodingKeys: String, CodingKey {
            case point = "catch"
        }
    }


struct ApiResponse: Decodable {
    let results: Results
}

struct Results: Decodable {
    let shop: [Restaurant]
}

