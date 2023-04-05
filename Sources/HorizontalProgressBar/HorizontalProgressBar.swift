//
//  ProgressBar.swift
//  ProgressBarPOC
//
//  Created by Thiago Henrique on 31/03/23.
//


import Foundation
import UIKit
import SpriteKit

final public class HorizontalProgressBar: SKNode {
    private var maxProgressWidth: CGFloat!
    private var isAscending: Bool!
    private var size: CGSize!
    private(set) var backBar: SKSpriteNode!
    private(set) var foregroundBar: SKSpriteNode!
    
    public var backTexture: SKTexture? {
        didSet {
            backBar.removeFromParent()
            createProgressBar()
            positionateBar()
        }
    }
    public var foregroundTexture: SKTexture? {
        didSet {
            foregroundBar.removeFromParent()
            createProgressBar()
            positionateBar()
        }
    }
    
    public var padding: CGFloat = 10.0 { didSet { positionateBar() } }
    public var factor: CGFloat = CGFloat(10)
    public let maxProgressValue = CGFloat(100)
    private(set) var progressValue = CGFloat(0)
    
    public init(isAscending: Bool = false, size: CGSize) {
        self.isAscending = isAscending
        self.size = size
        super.init()
        configure()
    }
    
    private func configure() {
        createProgressBar()
        positionateBar()
        initializeProgressValue()
    }
    
    private func createProgressBar() {
        backBar = SKSpriteNode(
            texture: backTexture ?? SKTexture(color: .green),
            size: size
        )
        backBar.zPosition = -1
        
        foregroundBar = SKSpriteNode(
            texture: foregroundTexture ?? SKTexture(color: .red),
            size: CGSize(width: 0, height: backBar.frame.height - 10)
        )
        
        addChild(backBar)
        addChild(foregroundBar)
    }
    
    private func positionateBar() {
        let viewBounds = UIScreen.main.bounds
        
        assert(foregroundBar != nil && backBar != nil)
        
        backBar.position = CGPoint(x: viewBounds.width * 0.5, y: viewBounds.height * 0.5)
        foregroundBar.position = CGPoint(
            x: ((viewBounds.width - backBar.frame.width) / 2) + padding,
            y: backBar.position.y
        )
        foregroundBar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        
        maxProgressWidth = (backBar.frame.width - (padding * 2))
    }
    
    private func initializeProgressValue() {
        if isAscending {
            progressValue = 0
            return
        }
        progressValue = maxProgressValue
    }
    
    private func updateProgressValue() {
        if isAscending {
            progressValue += factor
            if progressValue >= maxProgressValue {
                progressValue = maxProgressValue
            }
            return
        }
        progressValue -= factor
        if progressValue <= 0 {
            progressValue = 0
        }
    }
    
    private func resizeBar() {
        let width = CGFloat(progressValue / maxProgressValue) * maxProgressWidth
        Task {
            await foregroundBar.run(
                SKAction.resize(
                    toWidth: width,
                    duration: 1.0
                )
            )
        }
    }
    
    public func initializeBarValue() {
        resizeBar()
    }
    
    public func updateBarState() {
        assert(foregroundBar != nil)
        updateProgressValue()
        resizeBar()
    }
    
    
    required init?(coder aDecoder: NSCoder) { nil }
}

public extension SKTexture {
    convenience init(color: UIColor) {
        self.init(image: UIImage(color: color)!)
    }
}

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
