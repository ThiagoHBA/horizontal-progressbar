# HorizontalProgressBar

A description of this package.

### USAGE

```swift
import SpriteKit
import GameplayKit
import HorizontalProgressBar

class GameScene: SKScene {
    var progressBar: HorizontalProgressBar!
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Decrease!", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func didMove(to view: SKView) {
        progressBar = HorizontalProgressBar(
            isAscending: false,
            size: CGSize(width: view.bounds.width * 0.3, height: 35)
        )
        progressBar.foregroundTexture = SKTexture(color: .purple)
        
        addChild(progressBar)
        progressBar.initializeBarValue()
        
        self.view!.addSubview(button)
        configureConstraints()
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.view!.leadingAnchor, constant: 10),
            button.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: 10),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func buttonTapped() {
        progressBar.updateBarState()
    }
}
```
