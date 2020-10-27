//
//  CharactersCollectionVC.swift
//  Marvel_App
//
//  Created by Renan Marchini on 13/10/20.
//

import UIKit

class CharactersCollectionVC: UICollectionViewController {
    
    @IBOutlet var CharactersCollectionView: UICollectionView!
    
    var charactersCollectionManager = CharactersCollectionManager()
    var charactersData: [Results] = []
    var characters: [CharacterInfo] = []
    var i: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactersCollectionManager.delegate = self
        charactersCollectionManager.getData()
        
        
        // Register cell classes
        collectionView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellWithReuseIdentifier: K.cellIdentifier)
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return characters.count/20
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellIdentifier, for: indexPath) as! CharacterCell
        
        // Configure the cell
        cell.nameLabel.text = characters[indexPath.row].characterName
        cell.characterImageView.contentMode = .scaleAspectFit
        cell.characterImageView.image = characters[indexPath.row].characterImage
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        self.performSegue(withIdentifier: K.segueToDetail, sender: character)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueToDetail {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.character = sender as? CharacterInfo
        }
    }
    
}

// MARK: CharactersCollectionManagerDelegate

extension CharactersCollectionVC: CharactersCollectionManagerDelegate {
    
    func didUploadData(_ characterCollectionManager: CharactersCollectionManager, charactersData: [Results]) {
        DispatchQueue.main.async {
            self.charactersData = charactersData.self
            self.charactersCollectionManager.creatCharactersArray(with: charactersData)
        }
    }
    
    func didCreatArray(with charactersArray: [CharacterInfo]) {
        DispatchQueue.main.async {
            self.characters = charactersArray.self
            self.CharactersCollectionView.reloadData()
            for row in 0..<charactersArray.count {
                self.charactersCollectionManager.getImage(with: self.charactersData[row], row)
            }
        }
    }
    
    func didDownloadImage(_ characterImage: UIImage, _ row: Int) {
        DispatchQueue.main.async {
            let image = characterImage.self
            let row = row.self
            
            self.characters[row].characterImage = image
            self.CharactersCollectionView.reloadData()
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
