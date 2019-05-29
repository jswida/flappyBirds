//
//  GameScene.swift
//  ubi
//
//  Created by LilacBlue on 27/05/2019.
//  Copyright © 2019 lilacblue. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var pipe = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    var movePipesAndRemove = SKAction()
    var pipes = SKNode()
    var moving: SKNode!
    var canRestart = Bool()
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var score = NSInteger()
    var scoreLabel = SKLabelNode()

    
    override func didMove(to view: SKView) {
        canRestart = true
        
        //physic
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        self.physicsWorld.contactDelegate = self as? SKPhysicsContactDelegate
        
        //background
        let bgTexture = SKTexture(imageNamed: "bg.png")
        bgTexture.filteringMode = .nearest
        
        moving = SKNode()
        self.addChild(moving)
//        pipes = SKNode()
//        moving.addChild(pipes)
        
        let moveBG = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 4)
        let changeBG = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0)
        let animateBG = SKAction.repeatForever(SKAction.sequence([moveBG, changeBG]))
        
        var x: CGFloat = 0
        while x < 3 {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width*x, y: self.frame.midY)
            bg.size.height = self.frame.height
            bg.run(animateBG)
            bg.zPosition = -1
            moving.addChild(bg)
            x += 1
            
        }
        
        //pipes
        pipeUpTexture = SKTexture(imageNamed: "pipe1.png")
        pipeUpTexture.filteringMode = .nearest
        pipeDownTexture = SKTexture(imageNamed: "pipe2")
        pipeDownTexture.filteringMode = .nearest

        let distance = CGFloat(self.frame.width + 4.0 * pipeUpTexture.size().width)
        let movePipes = SKAction.moveBy(x: -distance, y: 0.0, duration: TimeInterval(0.01 * distance))
        let removePipe = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipe])


        let spawn = SKAction.run(spawnPipe)
        
        let delay = SKAction.wait(forDuration: TimeInterval(5.0))
        
        let spawnanddelay = SKAction.sequence([spawn, delay])
        
        let spawnforever = SKAction.repeatForever(spawnanddelay)
        
        self.run(spawnforever)
        
        //bird
        let birdTexture = SKTexture(imageNamed: "bird3.png")
        let birdTexture2 = SKTexture(imageNamed: "bird1.png")
        let birdTexture3 = SKTexture(imageNamed: "bird2.png")
        
        let animation = SKAction.animate(with: [birdTexture,birdTexture2,birdTexture3, birdTexture2], timePerFrame: 0.1)
        let animationForever = SKAction.repeatForever(animation)
        bird = SKSpriteNode(texture: birdTexture)
        
      
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bird.run(animationForever)
        self.addChild(bird)
        
        let ground = SKNode()
        ground.position = CGPoint(x:self.frame.midX, y: -self.frame.height/2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody?.isDynamic = false
        self.addChild(ground)
        
        score = 0;
        scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x:self.frame.midX, y: 3 * self.frame.size.height / 4)
        scoreLabel.zPosition = -10
        scoreLabel.text = String(score)
        self.addChild(scoreLabel)
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let birdTexture = SKTexture(imageNamed: "bird3.png")
        bird.physicsBody?.isDynamic = true
        bird.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: birdTexture.size().width, height: birdTexture.size().height))
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
        

//        let distance = CGFloat(self.frame.width + 2.0 * pipeUpTexture.size().width)
//        let movePipes = SKAction.moveBy(x: -distance, y: 0.0, duration: TimeInterval(0.01 * distance))
//        let removePipe = SKAction.removeFromParent()
//        var movePipesAndRemove = SKAction.sequence([movePipes, removePipe])
        
        
    }
   
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func spawnPipe() {

        let number = Int.random(in: 0 ..< 10)
        let pair = SKSpriteNode(texture: pipeUpTexture)
        // rand i go dodac yeah
        let positionY = (Int(pair.size.height)) - 500 - number*40
        pair.position = CGPoint(x: Int(self.frame.width) + 100, y: positionY)
        pair.physicsBody = SKPhysicsBody(rectangleOf: pair.size)
        pair.setScale(1.0)
        pair.physicsBody?.isDynamic = false
        pair.physicsBody?.affectedByGravity = false
        pair.zPosition = 1
        pair.run(movePipesAndRemove)
        moving.addChild(pair)
        
        let pairDown = SKSpriteNode(texture: pipeDownTexture)
        // rand i go dodac yeah
        let positionDown =  -1000  - number*40
        pairDown.position = CGPoint(x: Int(self.frame.width) + 100, y: positionDown)
        pairDown.physicsBody = SKPhysicsBody(rectangleOf: pair.size)
        pairDown.setScale(1.0)
        pairDown.physicsBody?.isDynamic = false
        pairDown.physicsBody?.affectedByGravity = false
        pairDown.zPosition = 1
        pairDown.run(movePipesAndRemove)
        moving.addChild(pairDown)
        
        
//        let heigth = UInt32(self.frame.size.height / 4)
//        let y = Double(arc4random_uniform(heigth) + heigth)
//
//        let pipeDown = SKSpriteNode(texture: pipeDownTexture)
//        pipeDown.setScale(2.0)
//        pipeDown.position = CGPoint(x: 0.0, y: 0)
//
//        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
//        pipeDown.physicsBody?.isDynamic = false
//        pair.addChild(pipeDown)
//
//        let pipeUp = SKSpriteNode(texture: pipeUpTexture)
//        pipeUp.setScale(2.0)
//        pipeUp.position = CGPoint(x: 0.0, y: y)
//
//        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
//        pipeUp.physicsBody?.isDynamic = false
//        pair.addChild(pipeUp)
//
//        let contactNode = SKNode()
//        contactNode.position = CGPoint(x: pipeDown.size.width + bird.size.width / 2, y: self.frame.midY)
//        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: pipeUp.size.width, height: self.frame.size.height ))
//        contactNode.physicsBody?.isDynamic = false
//        pair.addChild(contactNode)
//        pair.run(movePipesAndRemove)
//        pipes.addChild(pair)
    }

}
