//
//  ViewController.swift
//  Woander
//
//  Created by robin ustarroz on 12/03/2018.
//  Copyright © 2018 robin ustarroz. All rights reserved.
//

import UIKit
import ARKit
import CoreLocation
import SceneKit

class ARVC: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
   
    let videoURL = URL(fileURLWithPath:Bundle.main.path(forResource: "starman", ofType: "mp4")!)
    //let videoURL = URL(string: "http://downloads.4ksamples.com/downloads/[2160p]%204K-HD.Club-2013-Taipei%20101%20Fireworks%20Trailer%20(4ksamples.com).mp4")!

    struct AspectRatio {
        static let width: CGFloat = 320
        static let height: CGFloat = 240
    }
    let AspectDiv: CGFloat = 1000
    
    var selectedRampName: String?
    var selectedRamp: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "ARobject/Forward.dae")!
        sceneView.autoenablesDefaultLighting = true
        
        let node = SCNNode()
        sceneView.scene.rootNode.addChildNode(node)
        arVideoPlayer()
        let forwardScene = SCNScene(named: "goodForward.scn")!
        
        sceneView.scene.rootNode.addChildNode(forwardScene.rootNode)
        
        // Set the scene to the view
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
   
    
    private func arVideoPlayer() {
        // create AVPlayer
        let player = AVPlayer(url: videoURL)
        // place AVPlayer on SKVideoNode
        let playerNode = SKVideoNode(avPlayer: player)
        // flip video upside down
        playerNode.yScale = -1
        
        // create SKScene and set player node on it
        let spriteKitScene = SKScene(size: CGSize(width: AspectRatio.width, height: AspectRatio.height))
        spriteKitScene.scaleMode = .aspectFit
        playerNode.position = CGPoint(x: spriteKitScene.size.width/2, y: spriteKitScene.size.height/2)
        playerNode.size = spriteKitScene.size
        spriteKitScene.addChild(playerNode)
        
        // create 3D SCNNode and set SKScene as a material
        let videoNode = SCNNode()
        videoNode.geometry = SCNPlane(width: 2, height: 1)
        videoNode.geometry?.firstMaterial?.diffuse.contents = spriteKitScene
        videoNode.geometry?.firstMaterial?.isDoubleSided = true
        // place SCNNode inside ARKit 3D coordinate space
        videoNode.position = SCNVector3(x: 0, y: 0, z: -3)
        
        // create a new scene
        let scene = SCNScene()
        scene.rootNode.addChildNode(videoNode)
        // set the scene to the view
        sceneView.scene = scene
        playerNode.play()
    }

}
