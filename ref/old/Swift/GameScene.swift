//
//  GameScene.swift
//  Nodey
//
//  Created by Batuhan Erden on 8/20/16.
//  Copyright © 2016 Batuhan Erden. All rights reserved.
//

import SpriteKit;

internal class GameScene : SKScene {
    
    private var screenWidth : CGFloat!;
    private var screenHeight : CGFloat!;
    private var gameMaster : GameMaster!;
    
    internal override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    }
    
    internal override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    internal override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        buildView(view);
        buildModel();
        addObjectsToScene();
    }
    
    private func buildView(view: SKView) {
        backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.0);
        
        screenWidth = view.frame.size.width;
        screenHeight = view.frame.size.height;
    }
    
    private func buildModel() {
        gameMaster = GameMaster(gameScene: self);
        
        gameMaster.buildMap();
        gameMaster.buildNodes();
        gameMaster.buildConnectors();
    }
    
    private func addObjectsToScene() -> Void {
        addConnectors();
        addNodes();
    }
    
    private func addNodes() -> Void {
        for node in gameMaster.getNodes() {
            if (node.getNodeName() != "header" && node.getNodeName() != "null") {
                addChild(node);
            }
        }
    }
    
    private func addConnectors() -> Void {
        for i in 0...gameMaster.getTreeSize() {
            for j in 0...gameMaster.getTreeSize() {
                if (gameMaster.getConnectors()[i][j].getConnectorName() != "null") {
                    addChild(gameMaster.getConnectors()[i][j]);
                }
            }
        }
    }
    
    /* ------------- GETTERS AND SETTERS ------------- */
    
    internal func getScreenWidth() -> CGFloat {
        return screenWidth;
    }
    
    internal func setScreenWidth(screenWidth : CGFloat) -> Void {
        self.screenWidth = screenWidth;
    }
    
    internal func getScreenHeight() -> CGFloat {
        return screenHeight;
    }
    
    internal func setScreenHeight(screenHeight : CGFloat) -> Void {
        self.screenHeight = screenHeight;
    }
}