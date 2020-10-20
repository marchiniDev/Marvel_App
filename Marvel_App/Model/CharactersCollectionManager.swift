//
//  CharactersCollectionManager.swift
//  Marvel_App
//
//  Created by Renan Marchini on 13/10/20.
//

import Foundation
import UIKit

protocol CharactersCollectionManagerDelegate {
    func didUploadData(_ characterCollectionManager: CharactersCollectionManager, charactersData: [Results])
    func didFailWithError(error: Error)
    func didDownloadImage (_ characterImage: UIImage, _ row: Int)
}

struct CharactersCollectionManager {
    
    var delegate:CharactersCollectionManagerDelegate?
    
    func getData() {
        let ts = "15091989"
        let myHash = "69186c6c94afa20163bfad892c45faf6"
        
        let urlString = "\(K.marvelLink)ts=\(ts)&apikey=\(K.myPublicKey)&hash=\(myHash)"
        performRequest(with: urlString)
        
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
    
    func getImage(with character: Results, _ row: Int) {
        let urlString = "\(character.thumbnail.path)/\(K.imageVariant).\(character.thumbnail.extension)"
        performImageRequest(with: urlString, row)
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
