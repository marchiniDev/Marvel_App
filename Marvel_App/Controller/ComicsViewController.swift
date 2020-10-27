//
//  HqViewController.swift
//  Marvel_App
//
//  Created by Renan Marchini on 26/10/20.
//

import UIKit

class ComicsViewController: UIViewController {
    
    @IBOutlet weak var comicDescriptionTextView: UITextView!
    @IBOutlet weak var comicPriceLabel: UILabel!
    @IBOutlet weak var comicNameLabel: UILabel!
    @IBOutlet weak var comicImageView: UIImageView!
    
    var id: Int?
    var comicsManager = ComicsManager()
    var comics: [ComicResults] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        comicsManager.delegate  = self
        
        if let characterId = id {
            comicsManager.getComics(with: characterId)
        }
    }
    
    func setUI(with comic: ComicResults, _ comicImage: UIImage) {
        comicImageView.contentMode = .scaleAspectFit
        comicImageView.image = comicImage
        comicNameLabel.text = comic.title
        let price = String(format: "%.2f", comic.prices[0].price!)
        comicPriceLabel.text = "$ \(price)"
        comicDescriptionTextView.text = comic.description
    }
}

// MARK: ComicsManagerDelegate
extension ComicsViewController: ComicsManagerDelegate {
    
    func didUploadData(_ detailManager: ComicsManager, comicsData: [ComicResults]) {
        
        DispatchQueue.main.async {
            self.comics = comicsData.self
            let numberOfComics = comicsData.count
            
            for row in 0..<numberOfComics {
                self.comicsManager.getMostExpensive(from: self.comics[row], row, numberOfComics)
            }
        }
    }
    
    func didGetMostExpensiveComic(_ theComicRow: Int) {
        DispatchQueue.main.async {
            let comic = self.comics[theComicRow]
            self.comicsManager.getComicImage(with: comic)
        }
    }
    
    func didDownloadImage(_ comicImage: UIImage, _ comic: ComicResults) {
        DispatchQueue.main.async {
            self.setUI(with: comic, comicImage)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}



