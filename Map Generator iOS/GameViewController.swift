//
//  GameViewController.swift
//  QuickHull
//
//  Created by Carl Wieland on 4/20/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import SceneKit
import ConvexHull

let NUMPOINTS = 64
let radius:Float = 5.0

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameView: GameView!
    var map: Map!
    var gameController: GameController!
    
    override func viewDidLoad() {
        self.gameController = GameController(scnView: gameView, map: map)
    }

}
