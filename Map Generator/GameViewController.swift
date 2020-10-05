//
//  GameViewController.swift
//  Map Generator
//
//  Created by v.prusakov on 10/5/20.
//  Copyright © 2020 Carl Wieland. All rights reserved.
//

import AppKit
import SceneKit

class GameViewController: NSViewController {
    
    @IBOutlet weak var scnGameView: SCNView!
    var map: Map!
    var gameController: GameController!
    
    override func viewDidLoad() {
        self.gameController = GameController(scnView: scnGameView, map: map)
    }

}
