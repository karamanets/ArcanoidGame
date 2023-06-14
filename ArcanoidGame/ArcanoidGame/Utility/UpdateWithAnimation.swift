//
//  UpdateWithAnimation.swift
//  ArcanoidGame
//
//  Created by Alex Karamanets on 13/06/2023.
//

import UIKit

struct Utility {
    
    static func updateWithAnimation(task: @escaping () -> Void, completion: @escaping () -> Void ) {
        UIView.animate(withDuration: 0.5, animations: task) { _ in
            UIView.animate(withDuration: 0.5, animations: completion)
        }
    }
    
    static func getImage() -> UIImage {
        let image = [UIImage(named: "block1"),
                     UIImage(named: "block2"),
                     UIImage(named: "block3"),
                     UIImage(named: "block4"),
                     UIImage(named: "block5")].randomElement() ?? UIImage()
        return image ?? UIImage()
    }
}
