//
//  CharacterInfo.swift
//  Marvel_App
//
//  Created by Renan Marchini on 20/10/20.
//

import Foundation
import UIKit

class CharacterInfo {
    var characterImage: UIImage
    var characterName: String
    var characterDescription: String
    
    init(image: UIImage, name: String, description: String) {
        self.characterImage = image
        self.characterName = name
        self.characterDescription = description
    }
}
