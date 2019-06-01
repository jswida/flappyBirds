//
//  GameScene.swift
//  ubi
//
//  Created by LilacBlue on 27/05/2019.
//  Copyright © 2019 lilacblue. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var pipe = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    var movePipesAndRemove = SKAction()
    var RemoveBirdAction = SKAction()
    var pipes = SKNode()
    var moving: SKNode!
    var canRestart = Bool()
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var score = NSInteger()
    var scoreLabel = SKLabelNode()
    var goS = SKSpriteNode()
    var go = SKTexture()
    
    
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
        
//        score = 0;
//        scoreLabel = SKLabelNode()
//        scoreLabel.position = CGPoint(x:self.frame.midX, y: 3 * self.frame.size.height / 4)
//        scoreLabel.zPosition = -10
//        scoreLabel.text = String(score)
//        self.addChild(scoreLabel)
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let birdTexture = SKTexture(imageNamed: "bird3.png")
        bird.physicsBody?.isDynamic = true
        bird.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: birdTexture.size().width, height: birdTexture.size().height))
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
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
        
        pairDown.physicsBody!.contactTestBitMask = pairDown.physicsBody!.collisionBitMask
        pair.physicsBody!.contactTestBitMask = pair.physicsBody!.collisionBitMask
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        collisionBetween(bir: contact.bodyA.node!, pillar: contact.bodyB.node!)
    }
    
    func collisionBetween(bir: SKNode, pillar: SKNode) {
        bird.removeFromParent()
        go = SKTexture(imageNamed: "gameOver.png")
        goS = SKSpriteNode(texture: go)
        goS.position = CGPoint(x: 0, y: 0)
        goS.setScale(0.5)
        goS.zPosition = 1000
        moving.addChild(goS)
        
    }
}
