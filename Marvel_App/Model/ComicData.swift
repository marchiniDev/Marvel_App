//
//  ComicsData.swift
//  Marvel_App
//
//  Created by Renan Marchini on 22/10/20.
//

import Foundation

struct ComicData: Decodable {
    let data: ComicStruct
}

struct ComicStruct: Decodable {
    let results: [ComicResults]
}

struct ComicResults: Decodable {
    let title: String?
    let description: String?
    let prices: [Prices]
    let thumbnail: ComicThumbnail?
}

struct Prices: Decodable {
    let price: Double?
}

struct ComicThumbnail: Decodable {
    let path: String?
    let `extension`: String?
}
