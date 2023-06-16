//
//  BallGame.swift
//  ArcanoidGame
//
//  Created by Alex Karamanets on 13/06/2023.
//

import UIKit

//MARK: Ball
class GameBall {
    
    //MARK: Public
    public func start() { tic() }
    
    public var blocksView: [UIView] = []
    
    public var isOver: Bool = false
    
    //MARK: Init
    init(in viewParent: UIView,
         viewRocket: UIView,
         level: Int,
         ballImage: UIImageView)
    {
        self.viewParent = viewParent
        self.viewRocket = viewRocket
        self.level = level
        
        center = viewParent.center
        vector = Vector(a: CGPoint(x: 0, y: 0), b: CGPoint(x: 7, y: 7))
        
        ///Ball
        viewBall = UIView()
        viewBall.addSubview(ballImage)
        viewBall.center = center
        viewParent.addSubview(viewBall)
        
        ///Ball
        addBlocks()
    }
    
    deinit {
        print("🔥 Deinit GameBall")
    }
    
    //MARK: Private Property
    private var level: Int
    
    private var center: CGPoint
    private var vector: Vector
    
    private var viewBall: UIView
    private var viewParent: UIView
    private var viewRocket: UIView

}

//MARK: Private Methods
private extension GameBall {
 
    func tic() {
        let newCenter = CGPoint(x: center.x + vector.dx, y: center.y + vector.dy)
        
        ///📌  Hit Rocket
        if isHit(rect: viewRocket.frame, oldPosition: center, newPosition: newCenter) == .x {
            vector.b.x = -vector.b.x
            vector.b.y = -vector.b.y + CGFloat.random(in: -3...3)
            scaleRocketHit()
        }
        if isHit(rect: viewRocket.frame, oldPosition: center, newPosition: newCenter) == .y {
            vector.b.y = -vector.b.y
            vector.b.x = -vector.b.x + CGFloat.random(in: -2...2)
            scaleRocketHit()
        }
        
        ///📌  Hit Blocks
        var indexBlock: Int?
        for (index, block) in blocksView.enumerated() {
            if isHit(rect: block.frame, oldPosition: center, newPosition: newCenter) == .x {
                vector.b.x = -vector.b.x
                vector.b.y = -vector.b.y + CGFloat.random(in: -2...2)
                indexBlock = index
            }
            if isHit(rect: block.frame, oldPosition: center, newPosition: newCenter) == .y {
                vector.b.y = -vector.b.y
                vector.b.x = -vector.b.x + CGFloat.random(in: -2...2)
                indexBlock = index
            }
        }
        
        if let indexBlock = indexBlock {
            let block = blocksView[indexBlock]
            
            UIView.animate(withDuration: 0.3) {
                block.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            } completion: { _ in
                block.removeFromSuperview()
            }
            blocksView.remove(at: indexBlock)
        }
        
        ///📌 Hit border View
        center = newCenter
        viewBall.center = newCenter
        
        if newCenter.x >= viewParent.frame.width || newCenter.x <= 0 {
            vector.b.x = -vector.b.x
            
        }
        
        if newCenter.y >= viewParent.frame.height || newCenter.y <= 0 {
            vector.b.y = -vector.b.y
            
            if newCenter.y >= viewParent.frame.height {
                ///📌 Hit Bottom Reload
                    isOver = true
            }
        }
    }
    
    func addBlocks() {
        for _ in stride(from: 1, through: (level * 10), by: 1) {
            
            let insetTop = viewParent.bounds.width / 5
            
            let block = UIView(frame: CGRect(x: Int(CGFloat.random(in: 6...viewParent.bounds.size.width - 46)),
                                             y: Int(CGFloat.random(in: insetTop...viewParent.bounds.height / 3)),
                                             width: 40,
                                             height: 40))
            viewParent.addSubview(block)
            
            let image = Utility.getImage()
            let imageView = UIImageView(image: image )
            imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            block.addSubview(imageView)
            
            self.blocksView.append(block)
        }
    }
    
    func isHit(rect: CGRect, oldPosition: CGPoint, newPosition: CGPoint) -> HitTarget? {
        
        ///📌 Ball hit Left rocket
        if oldPosition.x < rect.origin.x &&
            newPosition.x >= rect.origin.x &&
            
            newPosition.y >= rect.origin.y &&
            newPosition.y <= rect.origin.y + rect.size.height {
            return .x
        }
        
        ///📌 Ball hit Right rocket
        if oldPosition.x > rect.origin.x + rect.size.width &&
            newPosition.x <= rect.origin.x + rect.size.width &&
            
            newPosition.y >= rect.origin.y &&
            newPosition.y <= rect.origin.y + rect.size.height {
            return .x
        }
        
        ///📌 Ball hit Top rocket
        if oldPosition.y < rect.origin.y &&
            newPosition.y >= rect.origin.y &&
            
            newPosition.x >= rect.origin.x &&
            newPosition.x <= rect.origin.x + rect.size.width {
            return .y
        }
        
        ///📌 Ball hit Bottom rocket
        if oldPosition.y > rect.origin.y + rect.size.height &&
            newPosition.y <= rect.origin.y + rect.size.height &&
            
            newPosition.x >= rect.origin.x &&
            newPosition.x <= rect.origin.x + rect.size.width {
            return .y
        }
        return nil
    }
    
    func scaleRocketHit() {
        Utility.updateWithAnimation(time: 0.15, task: {
            self.viewRocket.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: {
            self.viewRocket.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    enum HitTarget {
        case x
        case y
    }
}


