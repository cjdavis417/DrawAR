//
//  ViewController.swift
//  DrawAR
//
//  Created by Christopher Davis on 11/29/17.
//  Copyright © 2017 Christopher Davis. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var drawBtn: UIButton!
    @IBOutlet weak var btnRed: UIButton!
    @IBOutlet weak var btnOrange: UIButton!
    @IBOutlet weak var btnYellow: UIButton!
    @IBOutlet weak var btnGreen: UIButton!
    @IBOutlet weak var btnBlue: UIButton!
    @IBOutlet weak var btnPurple: UIButton!
    @IBOutlet weak var btnBlack: UIButton!
    @IBOutlet weak var btnWhite: UIButton!
    @IBOutlet weak var stkColor: UIStackView!
    
    // location and orientation information
    let configuration = ARWorldTrackingConfiguration()
    var nodeColor = UIColor.yellow
    var buttonAreHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // needed for debug purposes
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        //self.sceneView.showsStatistics = true
        
        // runs the camera configuration... location and orientation information
        self.sceneView.session.run(configuration)
        
        // calling delegate
        self.sceneView.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.hideButtons))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnUI(button: btnRed, color: "red")
        btnUI(button: btnOrange, color: "orange")
        btnUI(button: btnYellow, color: "yellow")
        btnUI(button: btnGreen, color: "green")
        btnUI(button: btnBlue, color: "blue")
        btnUI(button: btnPurple, color: "purple")
        btnUI(button: btnBlack, color: "black")
        btnUI(button: btnWhite, color: "white")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btnUI(button: UIButton, color: String) {
        button.layer.cornerRadius = button.frame.height/2
        button.setTitle(" ", for: .normal)
        
        switch color {
        case "red":
            button.backgroundColor = UIColor.red
        case "orange":
            button.backgroundColor = UIColor.orange
        case "yellow":
            button.backgroundColor = UIColor.yellow
        case "green":
            button.backgroundColor = UIColor.green
        case "blue":
            button.backgroundColor = UIColor.blue
        case "purple":
            button.backgroundColor = UIColor.purple
        case "black":
            button.backgroundColor = UIColor.black
        case "white":
            button.backgroundColor = UIColor.white
        default:
            print("error")
        }
    }
    
    
    @IBAction func resetAction(_ sender: UIButton) {
        self.resetSession()
    }
    
    @IBAction func redAction(_ sender: UIButton) {
        nodeColor = UIColor.red
    }
    @IBAction func orangeAction(_ sender: UIButton) {
        nodeColor = UIColor.orange
    }
    @IBAction func yellowAction(_ sender: UIButton) {
        nodeColor = UIColor.yellow
    }
    @IBAction func greenAction(_ sender: UIButton) {
        nodeColor = UIColor.green
    }
    @IBAction func blueAction(_ sender: UIButton) {
        nodeColor = UIColor.blue
    }
    @IBAction func purpleAction(_ sender: UIButton) {
        nodeColor = UIColor.purple
    }
    @IBAction func blackAction(_ sender: UIButton) {
        nodeColor = UIColor.black
    }
    @IBAction func whiteAction(_ sender: UIButton) {
        nodeColor = UIColor.white
    }
    
    @objc func hideButtons() {
        
        if buttonAreHidden == true {
            buttonAreHidden = false
            btnRed.isHidden = false
            btnOrange.isHidden = false
            btnYellow.isHidden = false
            btnGreen.isHidden = false
            btnBlue.isHidden = false
            btnPurple.isHidden = false
            btnBlack.isHidden = false
            btnWhite.isHidden = false
            
        } else {
            buttonAreHidden = true
            btnRed.isHidden = true
            btnOrange.isHidden = true
            btnYellow.isHidden = true
            btnGreen.isHidden = true
            btnBlue.isHidden = true
            btnPurple.isHidden = true
            btnBlack.isHidden = true
            btnWhite.isHidden = true
            
        }
        
        
    }
    
    func resetSession() {
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        
        // these two are rotation and translation of the phone relative to the root csys
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPostionOfCamera = orientation + location
        
        DispatchQueue.main.async {
            if self.drawBtn.isHighlighted == true {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = currentPostionOfCamera
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
                sphereNode.geometry?.firstMaterial?.diffuse.contents = self.nodeColor
                print("button is being pressed")
            } else {
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.name = "pointer"
                pointer.position = currentPostionOfCamera
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                })
                self.sceneView.scene.rootNode.addChildNode(pointer)
                pointer.geometry?.firstMaterial?.diffuse.contents = self.nodeColor
                
            }
        }
        
    }
    
    
}

// this adds the x, y & z to form a location matrix.  currentPostionOfCamera uses this.
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

