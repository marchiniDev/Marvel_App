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
    var characterImage: [UIImage] = []
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
        return charactersData.count/20
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellIdentifier, for: indexPath) as! CharacterCell
        
        // Configure the cell
        cell.nameLabel.text = charactersData[indexPath.row].name
        charactersCollectionManager.getImage(with: charactersData[indexPath.row], indexPath.row)
        cell.characterImageView.contentMode = .scaleAspectFit
        if characterImage.count != 0 {
            cell.characterImageView.image = characterImage[indexPath.row]
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = CharactersCollectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: K.segueToDetail, sender: character)
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
            self.characterImage = Array(repeating: UIImage(systemName: K.sfName)!, count: charactersData.count)
            self.CharactersCollectionView.reloadData()
        }
    }
    
    func didDownloadImage (_ characterImage: UIImage, _ row: Int) {
        DispatchQueue.main.async {
            let image = characterImage.self
            let row = row.self
            
            self.characterImage[row] = image
            self.i += 1

            if self.i == self.charactersData.count {
                self.CharactersCollectionView.reloadData()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
