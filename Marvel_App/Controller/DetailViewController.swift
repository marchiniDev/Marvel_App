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
    @IBOutlet var button: UIButton!
    
    var character: CharacterInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        characterImageView.image = character?.characterImage
        characterNameLabel.text = character?.characterName
        chatacterDescriptionLabel.text = character?.characterDescription
        button.titleLabel?.text = "HQ de \(character?.characterName)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func hqButtonTapped(_ sender: UIButton) {
    }
    
}
