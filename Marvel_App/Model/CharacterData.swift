//
//  CharacterData.swift
//  Marvel_App
//
//  Created by Renan Marchini on 13/10/20.
//

import Foundation

struct CharacterData: Decodable {
    let data: DataStruct
}

struct DataStruct: Decodable {
    let results: [Results]
}

struct Results: Decodable {
    let name: String?
    let description: String?
    let thumbnail: Thumbnail
    let id: Int?
}

struct Thumbnail: Decodable {
    let path: String?
    let `extension`: String?
}

