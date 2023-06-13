//
//  ViewController.swift
//  ArcanoidGame
//
//  Created by Alex Karamanets on 13/06/2023.
//

import UIKit

class ViewController: UIViewController {

    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    //MARK: Private Property
    private lazy var startButton: UIButton = {
        var configuration = UIButton.Configuration.bordered()
        configuration.cornerStyle = .large
        configuration.baseBackgroundColor = .orange
        configuration.baseForegroundColor = .white
        configuration.background.strokeColor = .white
        configuration.background.strokeWidth = 0.5
 
        var attribute = AttributeContainer()
        attribute.font = UIFont.systemFont(ofSize: 30, weight: .semibold, width: .compressed)
        configuration.attributedTitle = AttributedString("Start", attributes: attribute)

        let button = UIButton(configuration: configuration, primaryAction: buttonAction())
        return button
    }()
    
    private let backgroundView: UIImageView = {
        let image = UIImage(named: "background")
        let view = UIImageView(image: image)
        return view
    }()
    
    private let rocketView: UIView = {
        let view = UIView()
        let image = UIImage(named: "rocket")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: -10, y: -10, width: 170, height: 120)
        view.addSubview(imageView)
        return view
    }()
    
    private var startLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 45, weight: .bold, width: .condensed)
        view.textColor = .white
        view.alpha = 0.0
        return view
    }()
    
    private var timer = Timer()
    
    private var count: Int = 0
    
    private var centerRocket: CGPoint!
    
    private var ball: GameBall!
}

//MARK: Private Methods
private extension ViewController {
    
    func initialize() {
        ///View
        view.backgroundColor = .white
        backgroundView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(backgroundView)
        
        startButton.frame = CGRect(x: 0, y: 0, width: 130, height: 40)
        startButton.center = view.center
        view.addSubview(startButton)
        
        startLabel.frame = CGRect(x: view.bounds.width / 2, y: (view.bounds.height / 2) - 75 , width: 130, height: 65)
        view.addSubview(startLabel)
    }
    
    func addRocket() {
        rocketView.frame = CGRect(x: 30, y: Int(view.frame.height) - 120, width: 140, height: 100)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        rocketView.gestureRecognizers = [pan]
        view.addSubview(rocketView)
    }
    
    func addBall() {
        ball = GameBall(in: self.view, viewRocket: rocketView)
    }
    
    func start() {
        Timer.scheduledTimer(withTimeInterval: 0.012, repeats: true) { [weak self] _ in
            self?.ball.start()
        }
    }
    
    func updateWithAnimation(task: @escaping () -> Void, completion: @escaping () -> Void ) {
        UIView.animate(withDuration: 0.5, animations: task) { _ in
            UIView.animate(withDuration: 0.5, animations: completion)
        }
    }
    
    func startCount() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startCountAction), userInfo: nil, repeats: true)
    }
    
    func startCountAnimate() {
        DispatchQueue.main.async {
            self.updateWithAnimation {
                self.startLabel.text = "\(self.count)"
                self.startLabel.alpha = 1.0
            } completion: {
                self.startLabel.alpha = 0.0
            }
        }
    }
}

//MARK: Actions
private extension ViewController {
    
    func buttonAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateWithAnimation {
                    self.startButton.alpha = 0.0
                } completion: {
                    self.addRocket()
                    self.addBall()
                    self.startCount()
                }
            }
        }
        return action
    }
    
    @objc func panAction(_ sender: UIPanGestureRecognizer) {
        if sender .state == .began {
            centerRocket = rocketView.center
        }
        let x = sender.translation(in: view).x
        let newCenter = CGPoint(x: centerRocket.x + x, y: centerRocket.y)
        rocketView.center = newCenter
    }
    
    @objc func startCountAction() {
        count += 1
        if count == 1 {
            startCountAnimate()
        } else if count == 2 {
            startCountAnimate()
        } else {
            startCountAnimate()
            timer.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.start()
            }
        }
    }
}

