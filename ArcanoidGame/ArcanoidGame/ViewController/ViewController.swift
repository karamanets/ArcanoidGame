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

        let button = UIButton(configuration: configuration, primaryAction: startButtonAction())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let backgroundView: UIImageView = {
        let image = UIImage(named: "background")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
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
        view.font = UIFont.systemFont(ofSize: 55, weight: .bold, width: .condensed)
        view.textColor = .red
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var gameOverLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 55, weight: .bold, width: .condensed)
        view.textColor = .red
        view.text = "Game Over"
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var timer = Timer()
    
    private var count: Int = 0
    
    private var centerRocket: CGPoint!
    
    private var ball: GameBall!
    
    private var gameTimer = Timer()
}

//MARK: Private Methods
private extension ViewController {
    
    func initialize() {
  
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 130),
            startButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        
        view.addSubview(startLabel)
        NSLayoutConstraint.activate([
            startLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height / 3)
        ])
        
        view.addSubview(gameOverLabel)
        NSLayoutConstraint.activate([
            gameOverLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameOverLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height / 3)
        ])
        
    }
    
    func addRocket() {
        view.addSubview(rocketView)
        let startLeft = Int(view.bounds.width / 3)
        let startBottom = Int(view.frame.height) - Int(view.bounds.width / 3)
        let height = 100
        let width = 140
        
        rocketView.frame = CGRect(x: startLeft, y: startBottom, width: width, height: height)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        rocketView.gestureRecognizers = [pan]
    }
    
    func addBall() {
        ball = GameBall(in: self.view, viewRocket: rocketView)
    }
    
    func start() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.ball.start()
            
            ///📌 GameOver
            if self.ball.isOver == true {
                self.gameTimer.invalidate()
                UIView.animate(withDuration: 0.2) {
                    self.rocketView.alpha = 0.0
                    self.gameOverLabel.alpha = 1.0
                    UIView.animate(withDuration: 0.2, delay: 2) {
                        self.ball.blocksView.map({ $0.alpha = 0.0})
                        self.ball.blocksView.removeAll()
                        UIView.animate(withDuration: 0.2, delay: 2) {
                            self.startButton.alpha = 1.0
                        }
                    }
                }
            }
        }
    }
    
    func startCount() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startCountAction), userInfo: nil, repeats: true)
    }
    
    func startCountAnimate() {
        DispatchQueue.main.async {
            Utility.updateWithAnimation {
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
    
    func startButtonAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                Utility.updateWithAnimation {
                    self.startButton.alpha = 0.0
                    self.gameOverLabel.alpha = 0.0
                    self.rocketView.alpha = 1.0
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
    
    @objc func startCountAction(_ sender: UIButton) {
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
                self.count = 0
            }
        }
    }
}

