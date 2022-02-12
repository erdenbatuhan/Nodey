//
//  Node.swift
//  Nodey
//
//  Created by Batuhan Erden on 8/20/16.
//  Copyright © 2016 Batuhan Erden. All rights reserved.
//

import Foundation;
import SpriteKit;

internal class Connector : SKSpriteNode {
    
    private final let thickness : CGFloat = 5;
    private var connectorName : String = "null";
    
    init() {
        super.init(texture: nil, color: UIColor.whiteColor(), size: CGSizeZero);
    }
    
    init (connectorName: String, length: CGFloat, rotation: CGFloat, nodeToConnect: Node) {
        self.connectorName = connectorName;
        
        super.init(texture: nil, color: UIColor.blackColor(), size: CGSize(width: length, height: thickness));
        anchorPoint = CGPointMake(0.0, 0.5);
        
        let pointX : CGFloat = nodeToConnect.position.x + Node.diameter * 0.5;
        let pointY : CGFloat = nodeToConnect.position.y + Node.diameter * 0.5;
        self.position = CGPoint(x: pointX, y: pointY);
        self.zRotation = rotation;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* ------------- GETTERS AND SETTERS ------------- */
    
    internal func getConnectorName() -> String {
        return connectorName;
    }
    
    internal func setConnectorName(connectorName : String) -> Void {
        self.connectorName = connectorName;
    }
}