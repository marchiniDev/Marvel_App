//
//  DetailManager.swift
//  Marvel_App
//
//  Created by Renan Marchini on 22/10/20.
//

import Foundation
import UIKit
import CryptoKit

protocol ComicsManagerDelegate {
    
    func didUploadData(_ comicsManager: ComicsManager, comicsData: [ComicResults])
    func didGetMostExpensiveComic(_ theComicRow: Int)
    func didDownloadImage(_ comicImage: UIImage, _ comic: ComicResults)
    func didFailWithError(error: Error)
    
}

struct ComicsManager {
    
    var delegate: ComicsManagerDelegate?
    var highestPrince: Double = 0.00
    var theComicRow: Int = 0 // row of de most expensive comic
    var i: Int = 0 // counter
    
    
    func getComics(with characterId: Int) {
        
        let ts = String(format: "%.0f", NSDate().timeIntervalSince1970.binade)
        let myString = "\(ts+K.myPrivateKey+K.myPublicKey)"
        let myHash = md5Encrypt(string: myString)
        
        let urlString = "\(K.marvelLink)/\(characterId.self)/comics?ts=\(ts)&apikey=\(K.myPublicKey)&hash=\(myHash)"
        performRequest(with: urlString)
    }
    
    func md5Encrypt(string: String) -> String {
        let hash = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        let myHash = hash.map {
            String(format: "%02hhx", $0)
        }.joined()
        return myHash
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, reponse, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let comicsData = self.parseJSON(safeData) {
                        self.delegate?.didUploadData(self, comicsData: comicsData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ siteData: Data) -> [ComicResults]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ComicData.self, from: siteData)
            let comicsData = decodedData.data.results
            return comicsData
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    mutating func getMostExpensive(from comic: ComicResults, _ row: Int, _ numberOfComics: Int) {
        if let comicPrice = comic.prices[0].price {
            if comicPrice > highestPrince {
                highestPrince = comicPrice
                theComicRow = row
            }
            
            i += 1
            
            if i == numberOfComics {
                self.delegate?.didGetMostExpensiveComic(theComicRow)
            }
        }
    }
    
    func getComicImage(with comic: ComicResults) {
        if let path = comic.thumbnail?.path, let `extension` = comic.thumbnail?.extension {
            let urlString = "\(path).\(`extension`)"
            performImageRequest(with: comic, urlString)
        }
    }
    
    func performImageRequest (with comic: ComicResults, _ urlString: String){
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let comicImage = UIImage(data: safeData) {
                        self.delegate?.didDownloadImage(comicImage, comic)
                    }
                }
            }
            task.resume()
        }
    }
}
    

