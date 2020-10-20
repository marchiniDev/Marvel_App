//
//  CharacterCell.swift
//  Marvel_App
//
//  Created by Renan Marchini on 14/10/20.
//

import UIKit

class CharacterCell: UICollectionViewCell {

    
    @IBOutlet weak var characterCell: UIView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
