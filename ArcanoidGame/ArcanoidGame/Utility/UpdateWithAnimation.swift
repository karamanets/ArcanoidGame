//
//  UpdateWithAnimation.swift
//  ArcanoidGame
//
//  Created by Alex Karamanets on 13/06/2023.
//

import UIKit

struct Utility {
    
    static func updateWithAnimation(time: Double, task: @escaping () -> Void, completion: @escaping () -> Void ) {
        UIView.animate(withDuration: time, animations: task) { _ in
            UIView.animate(withDuration: time, animations: completion)
        }
    }
    
    static func getImage() -> UIImage {
        
        let som = UIImage(systemName: "star.fill")!.withTintColor(.orange, renderingMode: .alwaysOriginal)
        
        let image = [UIImage(named: "block1"),
                     UIImage(named: "block2"),
                     UIImage(named: "block3"),
                     UIImage(named: "block4"),
                     UIImage(named: "block5")].randomElement() ?? som
        return image ?? som
    }
    
    static func getImage2() -> UIImage {
        
        let som = UIImage(systemName: "star.fill")!.withTintColor(.orange, renderingMode: .alwaysOriginal)
        
        let image = UIImage(named: "block1") ?? som
        
        return image
    }
}
