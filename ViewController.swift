//
//  HomeController.swift
//  CarAR
//
//  Created by Arjan Sagoo on 29/01/2019.
//  Copyright © 2019 Arjan Sagoo. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import SpriteKit
import AVFoundation
import Firebase
import SafariServices

class ViewController: UIViewController, ARSCNViewDelegate, AVAudioPlayerDelegate {
    
    // Global Variables
    
    var gridImage = "art.scnassets/grid.png"
    var carSound = AVAudioPlayer()
    var setModelScene = "art.scnassets/AventadorModel/Lambo1.scn"
    var setModelChildNode = "Lambo"
    var setSound = "LamboSound"
    var user = Auth.auth().currentUser
    var LamboSizeIncrement: Double = 0.05
    var AudiSizeIncrement: Double = 0.1
    var AstraSizeIncrement: Double = 0.05
    var newAngleY : Float = 0.0
    var currentAngleY : Float = 0.0
    //var name = Auth.auth().currentUser?.displayName;

    // Create an AR World Tracking Session configuration
    let configuration = ARWorldTrackingConfiguration()
    // Create an AR Image Tracking Configuration
    let imageConfiguration = ARImageTrackingConfiguration()
    
    var carColourNode = SCNScene(named: "art.scnassets/AventadorModel/Lambo1.scn")!.rootNode.childNode(withName: "Mesh79_032bonnet_ok1_032Group1_032Lamborghini_Aventador1_032Mod", recursively: true)
    var audiColourNode = SCNScene(named: "art.scnassets/Audi/AudiR8.scn")!.rootNode.childNode(withName: "Door_L_Plane_012", recursively: true)
    var astraColourNode = SCNScene(named: "art.scnassets/AstraRogue/Rogue2.scn")!.rootNode.childNode(withName: "HDM_01_02_hood", recursively: true)
    // Declaring models for resizing
    var sizeOfLambo = SCNScene(named: "art.scnassets/AventadorModel/Lambo1.scn")!.rootNode.childNode(withName: "Lambo", recursively: true)
    var sizeOfAudi = SCNScene(named: "art.scnassets/Audi/AudiR8.scn")!.rootNode.childNode(withName: "Audi", recursively: true)
    var sizeOfAstra = SCNScene(named: "art.scnassets/AstraRogue/Rogue2.scn")!.rootNode.childNode(withName: "AstraRogue2", recursively: true)
    
    // Outlets
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var shutterView: UIView!
    @IBOutlet var sizeSwitch: UISwitch!
    
    // Outlet Menu
    @IBOutlet var MenuOptions: [UIButton]!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var colourView: UIView!
    @IBOutlet weak var menuEmail: UILabel!
    
    @IBOutlet weak var lamboView: UIView!
    @IBOutlet weak var audiView: UIView!
    @IBOutlet weak var astraView: UIView!
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var normalSizeButton: UIButton!
    
    @IBOutlet weak var redColour: UIButton!
    @IBOutlet weak var greenColour: UIButton!
    @IBOutlet weak var blueColour: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var blueButton2: UIButton!
    
    @IBOutlet weak var minusLabel: UILabel!
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var normalLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    
    @IBOutlet weak var profileResetPassword: UIButton!
    @IBOutlet weak var checkEnvironment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting empty label inside view to current user email
        self.menuEmail.text = user?.email

        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Show animated feature points when the AR scene is active
        
        sceneView.delegate = self
        // Set the view's delegate
        
      //  requireGestures()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        
        let entryAlert = UIAlertController(title: "Welcome to AR Car", message: "Please enjoy your time with the new augmented reality experience", preferredStyle: .alert)
        
        // Allow the user to remove the message
        entryAlert.addAction(UIAlertAction(title: "Close", style: .default))
        
        self.present(entryAlert, animated: true, completion: nil)

    }

    @IBAction func setEnvironment(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            LamboSizeIncrement = 0.05
            AudiSizeIncrement = 0.1
            AstraSizeIncrement = 0.05
        }
        else if sender.selectedSegmentIndex == 1 {
            LamboSizeIncrement = 1.0
            AudiSizeIncrement = 1.0
            AstraSizeIncrement = 1.0
        }
    }
    
    @IBAction func plusButton(_ sender: UIButton) {
        
        // if statement for Lambo size
        if (LamboSizeIncrement < 1.0) {
        LamboSizeIncrement = LamboSizeIncrement + 0.05
        }
        else {
        LamboSizeIncrement = 1.0
        }
        sizeOfLambo?.scale = SCNVector3(
            x: Float(LamboSizeIncrement),
            y: Float(LamboSizeIncrement),
            z: Float(LamboSizeIncrement))
        
        // if statement for Audi size
        if (AudiSizeIncrement < 1.5) {
            AudiSizeIncrement = AudiSizeIncrement + 0.05
        }
        else {
            AudiSizeIncrement = 1.5
        }
        sizeOfAudi?.scale = SCNVector3(
            x: Float(AudiSizeIncrement),
            y: Float(AudiSizeIncrement),
            z: Float(AudiSizeIncrement))
        
        // if statement for Astra size
        if (AstraSizeIncrement < 1.0) {
            AstraSizeIncrement = AstraSizeIncrement + 0.05
        }
        else {
            AstraSizeIncrement = 1.0
        }
        sizeOfAstra?.scale = SCNVector3(
            x: Float(AstraSizeIncrement),
            y: Float(AstraSizeIncrement),
            z: Float(AstraSizeIncrement))
        
    }
    
    @IBAction func minusButton(_ sender: UIButton) {
        
        // Shrink Lambo model size
        if (setModelScene == "art.scnassets/AventadorModel/Lambo1.scn") {
        if (LamboSizeIncrement > 0.05) {
            LamboSizeIncrement = LamboSizeIncrement - 0.05
        }
        else {
            LamboSizeIncrement = 0.05
        }
        }
        else if (setModelScene == "art.scnassets/Audi/AudiR8.scn") {
        // Shrink Audi model size
        if (AudiSizeIncrement > 0.1) {
            AudiSizeIncrement = AudiSizeIncrement - 0.05
        }
        else {
            AudiSizeIncrement = 0.1
        }
    }
        else if (setModelScene == "art.scnassets/AstraRogue/Rogue2.scn") {
        // Shrink Astra model size
        if (AstraSizeIncrement > 0.05) {
            AstraSizeIncrement = AstraSizeIncrement - 0.05
        }
        else {
            AstraSizeIncrement = 0.05
        }
            
        }
        
        // Changing size of Lambo model
        sizeOfLambo?.scale = SCNVector3(
            x: Float(LamboSizeIncrement),
            y: Float(LamboSizeIncrement),
            z: Float(LamboSizeIncrement))
        
        // Changing size of Audi model
        sizeOfAudi?.scale = SCNVector3(
            x: Float(AudiSizeIncrement),
            y: Float(AudiSizeIncrement),
            z: Float(AudiSizeIncrement))
        
        // Changing size of Astra model
        sizeOfAstra?.scale = SCNVector3(
            x: Float(AstraSizeIncrement),
            y: Float(AstraSizeIncrement),
            z: Float(AstraSizeIncrement))
        
    }
    
    @IBAction func normalSizeButton(_ sender: UIButton) {
        
        LamboSizeIncrement = 1.0
        AudiSizeIncrement = 1.0
        AstraSizeIncrement = 1.0
        
        sizeOfLambo?.scale = SCNVector3(
            x: Float(LamboSizeIncrement),
            y: Float(LamboSizeIncrement),
            z: Float(LamboSizeIncrement))
        
        sizeOfAudi?.scale = SCNVector3(
            x: Float(AudiSizeIncrement),
            y: Float(AudiSizeIncrement),
            z: Float(AudiSizeIncrement))
        
        sizeOfAstra?.scale = SCNVector3(
            x: Float(AstraSizeIncrement),
            y: Float(AstraSizeIncrement),
            z: Float(AstraSizeIncrement))
    }
    
    
    @IBAction func toBlackColour(_ sender: UIButton) {
        carColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .black
        astraColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .black
        audiColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .black
    }
    
    @IBAction func toRedColour(_ sender: UIButton) {
        carColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .red
        astraColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .red
        audiColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .red
    }
    
    @IBAction func toGreenColour(_ sender: UIButton) {
        carColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .green
        astraColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .green
        audiColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .green
    }
    
    @IBAction func toPurpleColour(_ sender: UIButton) {
        carColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .purple
        astraColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .purple
        audiColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .purple
    }
    
    @IBAction func toBlueColour(_ sender: UIButton) {
        carColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .blue
        astraColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .blue
        audiColourNode?.geometry?.materials.first?.diffuse.contents = UIColor .blue
    }
    
//    private func requireGestures() {
//        let rotateGesture = UIPanGestureRecognizer(target: self, action: #selector(rotateObject))
//        self.sceneView.addGestureRecognizer(rotateGesture)
//
//    }
    
//    @objc func rotateObject(checkTouch :UIPanGestureRecognizer) {
//
//        let sceneView = checkTouch.view as! ARSCNView
//
//        if checkTouch.state == .changed {
//
//            let trackTouch = checkTouch.location(in: sceneView)
//            let trackTranslation = checkTouch.translation(in: sceneView)
//
//            let checkHit = self.sceneView.hitTest(trackTouch, options: nil)
//
//            if let hitTest = checkHit.first {
//
//                let carNode = hitTest.node
//
//
//
//
//                self.newAngleY = Float(trackTranslation.x) * (Float) (Double.pi)/180
//                self.newAngleY += self.currentAngleY
//                carNode.eulerAngles.y = self.newAngleY
//            }
//        } else if checkTouch.state == .ended {
//            self.currentAngleY = self.newAngleY
//        }
//    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let touchlocation = touch.location(in: sceneView)
            // checks the touch location on the screen in the sceneView
            
            let finalResult = sceneView.hitTest(touchlocation, types: .existingPlaneUsingExtent)
            
            if let hit = finalResult.first {
                // Create a new scene
                
                let carScene = SCNScene(named: setModelScene)!
                // The string model declared as a global variable is assigned
                carColourNode = carScene.rootNode.childNode(withName: "Mesh79_032bonnet_ok1_032Group1_032Lamborghini_Aventador1_032Mod", recursively: true)
                astraColourNode = carScene.rootNode.childNode(withName: "HDM_01_02_hood", recursively: true)
                audiColourNode = carScene.rootNode.childNode(withName: "Body_Plane_065", recursively: true)
                // A part of the model child node is assigned to change the colour of the model
                sizeOfLambo = carScene.rootNode.childNode(withName: "Lambo", recursively: true)
                sizeOfAudi = carScene.rootNode.childNode(withName: "Audi", recursively: true)
                sizeOfAstra = carScene.rootNode.childNode(withName: "AstraRogue2", recursively: true)
                // Each model is declared in its own variable because each of the models have their own specific sizes.
                sizeOfLambo?.scale = SCNVector3(
                    x: Float(LamboSizeIncrement),
                    y: Float(LamboSizeIncrement),
                    z: Float(LamboSizeIncrement))
                // The size of each model is changed based on the sizeIncrement declared as the global variable
                sizeOfAudi?.scale = SCNVector3(
                    x: Float(AudiSizeIncrement),
                    y: Float(AudiSizeIncrement),
                    z: Float(AudiSizeIncrement))
                
                sizeOfAstra?.scale = SCNVector3(
                    x: Float(AstraSizeIncrement),
                    y: Float(AstraSizeIncrement),
                    z: Float(AstraSizeIncrement))
                
                guard let carNode = carScene.rootNode.childNode(withName: setModelChildNode, recursively: true) else { return }
                    // The model selected is assigned to the position of the touch location on the plane.
                    carNode.position = SCNVector3(
                        x: hit.worldTransform.columns.3.x,
                        y: hit.worldTransform.columns.3.y,
                        z: hit.worldTransform.columns.3.z)
                
                    sceneView.scene.rootNode.addChildNode(carNode)
                    // The car node is added to the sceneView
                    sceneView.session.run(configuration, options: [.removeExistingAnchors])
                // Removing the anchors allows the grid Plane Anchor to disappear once the model has been added
                    self.sceneView.debugOptions = []
                // The feature points are set to an empty array so they stop as the user views the model displayed
                    gridImage = "art.scnassets/clearGridView.png"
                // In order to hide the grid, a clear grid image is replaced so th euser can not see it underneath the model displayed
        }
    }
}
        
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            
        if anchor is ARPlaneAnchor {
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let surface = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let surfaceNode = SCNNode()
            
            surfaceNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            surfaceNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let grid = SCNMaterial()
            
            grid.diffuse.contents = UIImage(named: gridImage)
            
            surface.materials = [grid]
            
            surfaceNode.geometry = surface
            
            surfaceNode.scale = SCNVector3(
                x: Float(0.5),
                y: Float(0.5),
                z: Float(0.5))
            
            node.addChildNode(surfaceNode)
            
        } else {
            return
        }
    }
    
    
    
    @IBAction func infoPopup(_ sender: UIButton) {
        
        // Pop up alert message appears on screen
        let infoAlert = UIAlertController(title: "Info", message: "A grid will appear when tracked a flat surface. Tap on the grid to display the selected model", preferredStyle: .alert)
        
        // Allow the user to remove the message
        infoAlert.addAction(UIAlertAction(title: "Close", style: .default))
        
        self.present(infoAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func carSoundButton(_ sender: UIButton) {
        
        do {
            let carSound1 = Bundle.main.path(forResource: setSound, ofType: "mp3")
            
            try carSound = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: carSound1!) as URL)
        }
        catch {
            print(error)
        }
        // Declaring car sound mp3 file as default when the sound button is clicked.
          carSound.play()
    }
    

    @IBAction func reset(_ sender: UIButton) {
        self.restartSession()
    }
    
    func restartSession() {
        
        self.sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "Lambo" {
                node.removeFromParentNode()
            }
            if node.name == "Audi"{
                node.removeFromParentNode()
            }
            if node.name == "AstraRogue2" {
                node.removeFromParentNode()
            }
        }
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        gridImage = "art.scnassets/grid.png"
        
        print("This reset button works!")
   }
    
    
//    func removeTracking() {
//        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//    }
    
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        Thread.sleep(forTimeInterval: 3.0)
//        // Override point for customization after application launch.
//        return true
//    }

    @IBAction func screenshotButton(_ sender: UIButton) {
        
                shutterView.alpha = 1.0
                shutterView.isHidden = false
                UIView.animate(withDuration: 1.0, animations: {
                    self.shutterView.alpha = 0.0
                }) { (finished) in
                    self.shutterView.isHidden = true
        
                    UIImageWriteToSavedPhotosAlbum(self.sceneView.snapshot(), nil, nil, nil)
                }
    }

    
    
    @IBAction func MenuSelection(_ sender: UIButton) {
        
//        menuOptions.forEach { (button) in
//            UIView.animate(withDuration: 0.3, animations: {
//                button.isHidden = !button.isHidden
//                self.view.layoutIfNeeded()
//            })
    }
    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        logOutHandler()
    }
    
    func logOutHandler() {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "logOutSegue", sender: self)
//        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func colourDrop(_ sender: UIButton) {
        
        colourView.isHidden = !colourView.isHidden

    }
    
    @IBAction func menuDropdown(_ sender: UIButton) {
        
        menuView.isHidden = !menuView.isHidden
        
        UIView.animate(withDuration: 0.5, animations: {
            self.self.menuView.alpha = 1.0
        })
    }
    
    @IBAction func lamboViewBack(_ sender: UIButton) {
        lamboView.isHidden = !lamboView.isHidden
    }
    
    
    // Lamborghini Functions for drop-down menu
    @IBAction func lamboSpec(_ sender: UIButton) {
        
        lamboView.isHidden = !lamboView.isHidden
    }
    
    
    @IBAction func lamboWebsite(_ sender: UIButton) {
        
        showSafariInApp(for: "https://www.lamborghini.com/en-en")
    }
    
// Audi R8 Functions for drop-down menu\
    
    @IBAction func audiSpec(_ sender: UIButton) {
        audiView.isHidden = !audiView.isHidden
    }
    
    @IBAction func audiBackMenu(_ sender: UIButton) {
        audiView.isHidden = !audiView.isHidden
    }
    
    
    
    @IBAction func audiSpecBack(_ sender: Any) {
        audiView.isHidden = !audiView.isHidden
    //    lamboView.isHidden = !lamboView.isHidden
    }
    
    @IBAction func audiWebsite(_ sender: UIButton) {
        showSafariInApp(for: "https://www.audi.co.uk/models/r8/r8-coupe.html")
    }

// Astra Functions for drop-down menu
    
    
    @IBAction func astraSpec(_ sender: UIButton) {
        astraView.isHidden = !astraView.isHidden
    }
    
    @IBAction func astraSpecBack(_ sender: UIButton) {
        astraView.isHidden = !astraView.isHidden
      //  lamboView.isHidden = !lamboView.isHidden
    }
    
    @IBAction func astraBackMenu(_ sender: UIButton) {
        astraView.isHidden = !astraView.isHidden
    }
    
    
    @IBAction func astraWebsite(_ sender: UIButton) {
        showSafariInApp(for: "https://www.autotrader.co.uk/car-search?sort=sponsored&radius=1500&postcode=sl44jj&onesearchad=Used&onesearchad=Nearly%20New&onesearchad=New&make=VAUXHALL&model=ASTRA&year-from=2008&year-to=2010&minimum-mileage=40000&maximum-mileage=80000&body-type=Hatchback&transmission=Manual&quantity-of-doors=3&colour=Black&keywords=sri")
    }
    
    
    
    @IBAction func hideButtons(_ sender: UIButton) {
        
        infoButton.isHidden = !infoButton.isHidden
        plusButton.isHidden = !plusButton.isHidden
        minusButton.isHidden = !minusButton.isHidden
        normalSizeButton.isHidden = !normalSizeButton.isHidden
        
        redColour.isHidden = !redColour.isHidden
        greenColour.isHidden = !greenColour.isHidden
        blueColour.isHidden = !blueColour.isHidden
        blackButton.isHidden = !blackButton.isHidden
        blueButton2.isHidden = !blueButton2.isHidden
        
        minusLabel.isHidden = !minusLabel.isHidden
        plusLabel.isHidden = !plusLabel.isHidden
        normalLabel.isHidden = !normalLabel.isHidden
        sizeLabel.isHidden = !sizeLabel.isHidden

    }
    
    @IBAction func toProfileView(_ sender: UIButton) {
        profileView.isHidden = !profileView.isHidden
    }
    
    @IBAction func profileResetPassword(_ sender: UIButton) {
        
        guard let email = user?.email else { return }
        
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            let entryAlert = UIAlertController(title: "Password Reset", message: "Password has been sent to email", preferredStyle: .alert)
            
            // Allow the user to remove the message
            entryAlert.addAction(UIAlertAction(title: "Close", style: .default))
            
            self.present(entryAlert, animated: true, completion: nil)
    }
}
    
    @IBAction func profileViewBack(_ sender: UIButton) {
        
        profileView.isHidden = !profileView.isHidden
    }
    
    
    
    func showSafariInApp(for url: String) {
        guard let url = URL(string: url) else {
            // alert
            return
        }
        
        let safari = SFSafariViewController(url: url)
        present(safari, animated: true)
    }
    
    @IBAction func createAventadorModel(_ sender: UIButton) {
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        setModelScene = "art.scnassets/AventadorModel/Lambo1.scn"
        setModelChildNode = "Lambo"
        setSound = "LamboSound"
        gridImage = "art.scnassets/grid.png"
        
        print(setModelScene)
        
    }
    @IBAction func createAudiR8Model(_ sender: UIButton) {
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        setModelScene = "art.scnassets/Audi/AudiR8.scn"
        setModelChildNode = "Audi"
        setSound = "AudiSound"
        gridImage = "art.scnassets/grid.png"
        
        print(setModelScene)
        
    }
    
    @IBAction func createVauxhallAstraModel(_ sender: UIButton) {
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        setModelScene = "art.scnassets/AstraRogue/Rogue2.scn"
        setModelChildNode = "AstraRogue2"
        setSound = "EvoSound"
        gridImage = "art.scnassets/grid.png"
        
        print(setModelScene)
    }
    
  }

