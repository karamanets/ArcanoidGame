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
    
    //MARK: Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        getDataLevel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        view.font = UIFont.systemFont(ofSize: 55, weight: .bold, width: .compressed)
        view.textColor = .red
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var gameOverLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 55, weight: .bold, width: .compressed)
        view.textColor = .red
        view.text = "Game Over"
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var greetingLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 35, weight: .bold, width: .compressed)
        view.textColor = .red
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var levelLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18, weight: .medium, width: .compressed)
        view.textColor = .white.withAlphaComponent(0.8)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var scoreBlocksLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18, weight: .medium, width: .compressed)
        view.textColor = .white.withAlphaComponent(0.8)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let ballImage: UIImageView = {
        let image = UIImage(named: "ball")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        return imageView
    }()
    
    private var centerRocket: CGPoint!
    
    private var ball: GameBall? = nil
    
    private var timerStart = Timer()
    
    private var gameTimer = Timer()
    
    private var countStart: Int = 0
    
    private var level: Int = 1 {
        didSet {
            saveDataLevel()
        }
    }
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
        
        view.addSubview(greetingLabel)
        NSLayoutConstraint.activate([
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height / 3)
        ])
        
        view.addSubview(levelLabel)
        NSLayoutConstraint.activate([
            levelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            levelLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            levelLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 4),
            levelLabel.heightAnchor.constraint(equalToConstant: 40)
            
        ])
        
        view.addSubview(scoreBlocksLabel)
        NSLayoutConstraint.activate([
            scoreBlocksLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scoreBlocksLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            scoreBlocksLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 4),
            scoreBlocksLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    func start() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
            guard
                let self = self,
                let ball = self.ball else { return }
            
            ball.start()
            
            ///📌 Start Level Game Labels
            self.levelLabel.text = "👑 Level: \(self.level)"
            self.scoreBlocksLabel.text = "🎖️Blocks: \(ball.blocksView.count)"
            
            ///📌 GameWin
            if ball.blocksView.count == 0 {
                
                self.level += 1
                self.gameTimer.invalidate()
                UIView.animate(withDuration: 0.5) {
                    self.rocketView.alpha = 0.0
                    UIView.animate(withDuration: 0.5, delay: 2) {
                        self.greetingLabel.alpha = 1.0
                        self.greetingLabel.text = "🏆 Level - \(self.level - 1) - passed 🏆"
                        UIView.animate(withDuration: 0.5, delay: 3) {
                            self.startButton.alpha = 1.0
                        }
                    }
                }
            }
            ///📌 GameOver
            if ball.isOver == true {
                
                //self.level = 1
                self.gameTimer.invalidate()
                UIView.animate(withDuration: 0.5) {
                    self.rocketView.alpha = 0.0
                    self.gameOverLabel.alpha = 1.0
                    UIView.animate(withDuration: 0.5, delay: 2) {
                        UIView.animate(withDuration: 0.5, delay: 2) {
                            self.startButton.alpha = 1.0
                        }
                    }
                }
            }
        }
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
        ball = GameBall(in: self.view, viewRocket: rocketView, level: level, ballImage: ballImage)
    }
    
    func startCount() {
        timerStart = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startCountAction), userInfo: nil, repeats: true)
    }
    
    func startCountAnimate() {
        DispatchQueue.main.async {
            Utility.updateWithAnimation(time: 0.5, task: {
                self.startLabel.text = "\(self.countStart)"
                self.startLabel.alpha = 1.0
            }, completion: {
                self.startLabel.alpha = 0.0
            })
        }
    }
    
    func saveDataLevel() {
        guard let data = try? JSONEncoder().encode(level) else {
            print("[⚠️] Error save Data level")
            return
        }
        UserDefaults.standard.set(data, forKey: "levelData")
    }
    
    func getDataLevel() {
        guard
            let data = UserDefaults.standard.data(forKey: "levelData"),
            let level = try? JSONDecoder().decode(Int.self, from: data) else {
            print("[⚠️] Error Decode Data level")
            return
        }
        self.level = level
    }
}

//MARK: Actions
private extension ViewController {
    
    func startButtonAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                Utility.updateWithAnimation(time: 0.5, task: {
                    if let ball = self.ball {
                        for item in ball.blocksView {
                            item.removeFromSuperview()
                        }
                    }
                    self.ball = nil
                    self.startButton.alpha = 0.0
                    self.gameOverLabel.alpha = 0.0
                    self.greetingLabel.alpha = 0.0
                    self.rocketView.alpha = 1.0
                }, completion: {
                    self.addRocket()
                    self.addBall()
                    self.startCount()
                })
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
        countStart += 1
        if countStart == 1 {
            startCountAnimate()
        } else if countStart == 2 {
            startCountAnimate()
        } else {
            startCountAnimate()
            timerStart.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.start()
                self.countStart = 0
            }
        }
    }
}
