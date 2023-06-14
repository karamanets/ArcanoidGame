//
//  VectorBall.swift
//  ArcanoidGame
//
//  Created by Alex Karamanets on 13/06/2023.
//

import Foundation

//MARK: Vector for Ball

struct Vector {
    var a: CGPoint
    var b: CGPoint
    
    var dx: CGFloat {
        return b.x - a.x
    }
    var dy: CGFloat {
        return b.y - a.y
    }
}
