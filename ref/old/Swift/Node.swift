//
//  Node.swift
//  Nodey
//
//  Created by Batuhan Erden on 8/20/16.
//  Copyright © 2016 Batuhan Erden. All rights reserved.
//

import Foundation;
import SpriteKit;

internal class Node : SKShapeNode {
    
    internal static var diameter : CGFloat = 0;
    internal static var originX : CGFloat = 0;
    internal static var originY : CGFloat = 0;
    internal static let diff : CGFloat = 2;
    private var nodeName : String = "null";
    private var nodeColor : UIColor = UIColor.blackColor();
    
    internal init (isHeader : Bool) {
        super.init();
        
        if (isHeader) {
            self.nodeName = "header";
            self.position = CGPointMake(-1, -1);
        }
        
        self.fillColor = nodeColor;
    }
    
    internal init (nodeName : String, nodeColor : UIColor, position : CGPoint) {
        super.init();
        self.nodeName = nodeName;
        self.nodeColor = nodeColor;
        
        self.path = CGPathCreateWithEllipseInRect(CGRect(x: 0.0, y: 0.0, width: Node.diameter, height: Node.diameter), nil);
        self.fillColor = self.nodeColor;
        self.position = position;
    }

    internal required init?(coder aDecoder : NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal static func setDiameterByScreenSize(gameScene : GameScene) -> Void {
        Node.diameter = CGFloat(Int(gameScene.getScreenWidth() / CGFloat(GameMaster.COLUMNS)));
        
        while (true) {
            let diffX : CGFloat  = gameScene.getScreenWidth() - Node.diameter * CGFloat(GameMaster.COLUMNS);
            originX = diffX / 2;
            let diffY : CGFloat = gameScene.getScreenHeight() - Node.diameter * CGFloat(GameMaster.ROWS);
            originY = diffY / 2;
            
            if (originX > 0 && originY > 0) {
                break;
            }
            
            Node.diameter -= 1;
        }
        
        Node.diameter -= (diff * 2);
    }
    
    internal func animateSwap(nodeToSwap : Node) -> Void {
        var swapAction : SKAction = SKAction.moveTo(nodeToSwap.position, duration: 0.25);
        
        for _ in 0...1 {
            runAction(swapAction);
            swapAction = SKAction.moveTo(self.position, duration: 0.25);
        }
    }
    
    internal func animatePop(nodes : Array<Node>, treeSize : Int) -> Void {
        let ground : CGFloat = nodes[treeSize].position.y;
        let popAction : SKAction = SKAction.moveToY(-Node.diameter*1.25, duration: Double(self.position.y / ground));
        
        runAction(popAction);
    }
    
    /* ------------- GETTERS AND SETTERS ------------- */
    
    internal func getNodeName() -> String {
        return nodeName;
    }
    
    internal func setNodeName(nodeName : String) -> Void {
        self.nodeName = nodeName;
    }
    
    internal func getNodeColor() -> UIColor {
        return nodeColor;
    }
    
    internal func setNodeColor(nodeColor : UIColor) -> Void {
        self.nodeColor = nodeColor;
    }
}