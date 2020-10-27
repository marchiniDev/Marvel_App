//
//  DetailViewController.swift
//  Marvel_App
//
//  Created by Renan Marchini on 19/10/20.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var chatacterDescriptionLabel: UITextView!
    @IBOutlet weak var button: UIButton!
    
    var character: CharacterInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        characterImageView.image = character?.characterImage
        characterNameLabel.text = character?.characterName
        chatacterDescriptionLabel.text = character?.characterDescription
        button.setTitle("HQ de \(character?.characterName! ?? "HQ deste Personagem")", for: .normal)

        
    }
    

    
    // MARK: - DetailViewControllerDelegate

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueToComic {
            let destinationVC = segue.destination as! ComicsViewController
            if let id = character?.characterId {
                destinationVC.id = id
            }
        }
    }
    

    @IBAction func hqButtonTapped(_ sender: UIButton) {
    }
    
    
    
}

