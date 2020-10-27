//
//  CharactersCollectionManager.swift
//  Marvel_App
//
//  Created by Renan Marchini on 13/10/20.
//

import Foundation
import UIKit
import CryptoKit

protocol CharactersCollectionManagerDelegate {
    func didUploadData(_ characterCollectionManager: CharactersCollectionManager, charactersData: [Results])
    func didCreatArray(with charactersArray: [CharacterInfo])
    func didDownloadImage (_ characterImage: UIImage, _ row: Int)
    func didFailWithError(error: Error)
}

struct CharactersCollectionManager {
    
    var delegate: CharactersCollectionManagerDelegate?
    
    func getData() {
        
        let ts = String(format: "%.0f", NSDate().timeIntervalSince1970.binade)
        let myString = "\(ts+K.myPrivateKey+K.myPublicKey)"
        let myHash = md5Encrypt(string: myString)
        
        let urlString = "\(K.marvelLink)?ts=\(ts)&apikey=\(K.myPublicKey)&hash=\(myHash)"
        performRequest(with: urlString)
        
    }
    
    func md5Encrypt(string: String) -> String {
        let hash = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        let myHash = hash.map {
            String(format: "%02hhx", $0)
        }.joined()
        return myHash
    }
    
    func performRequest (with urlString: String){
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let charactersData = self.parseJSON(safeData) {
                        self.delegate?.didUploadData(self, charactersData: charactersData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ siteData: Data) -> [Results]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CharacterData.self, from: siteData)
            let charactersData = decodedData.data.results
            return charactersData
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    func creatCharactersArray(with charactersData: [Results]) {
        
        let character = CharacterInfo(characterImage: UIImage(systemName: K.sfName), characterName: "name", characterDescription: "description", characterId: 0)
        var charactersArray: [CharacterInfo] = Array(repeating: character, count: charactersData.count)
        for row in 0..<charactersData.count {
            if let name = charactersData[row].name {
                charactersArray[row].characterName = name
            }
            if let description = charactersData[row].description {
                charactersArray[row].characterDescription = description
            }
            if let id = charactersData[row].id {
                charactersArray[row].characterId = id
            }
        }
        
        self.delegate?.didCreatArray(with: charactersArray)
    }
    
    func getImage(with character: Results, _ row: Int) {
        if let path = character.thumbnail.path, let `extension` = character.thumbnail.extension {
            let urlString = "\(path)/\(K.imageVariant).\(`extension`)"
            performImageRequest(with: urlString, row)
        }
    }
    
    func performImageRequest (with urlString: String, _ row: Int){
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let characterImage = UIImage(data: safeData) {
                        self.delegate?.didDownloadImage(characterImage, row)
                    }
                }
            }
            task.resume()
        }
    }
}
