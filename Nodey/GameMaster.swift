//
//  GameMaster.swift
//  Nodey
//
//  Created by Batuhan Erden on 8/20/16.
//  Copyright © 2016 Batuhan Erden. All rights reserved.
//

import Foundation;
import SpriteKit;

internal class GameMaster {
    
    internal static let COLUMNS : Int = 15;
    internal static let ROWS : Int = 27;
    private final let freeNode : Node = Node(isHeader: false);
    private final let freeConnector : Connector = Connector();
    private var level : Int = 0;
    private var treeSize : Int = 0;
    private var grid : Array<Array<CGPoint>> = [];
    private var nodes : Array<Node> = [];
    private var connectors : Array<Array<Connector>> = [];
    private var gameScene : GameScene;
    
    internal init(gameScene : GameScene) {
        self.gameScene = gameScene;
        
        Node.setDiameterByScreenSize(gameScene);
    }
    
    internal func swapNodes(node : Int) -> Void {
        let parent : Int = node / 2;
        
        swap(node, j: parent);
        nodes[node].animateSwap(nodes[parent]);
    }
    
    internal func popNodes() -> Void {
        for var i in 2...treeSize {
            if (doSiblingsHaveSameColor(i)) {
                nodes[i] = freeNode;
                nodes[siblingOf(i)] = freeNode;
                
                treeSize -= 2;
            }
            
            i += 2;
        }
    }
    
    internal func buildMap() -> Void {
        var x : CGFloat = 0;
        var y : CGFloat = 0;
        
        for _ in 0...GameMaster.ROWS - 1 {
            grid.append(Array(count: GameMaster.COLUMNS, repeatedValue: CGPoint.zero));
        }
        
        for row in 0...GameMaster.ROWS - 1 {
            y = gameScene.getScreenHeight() - (Node.diameter * CGFloat(row + 1) + Node.originY);
            
            for column in 0...GameMaster.COLUMNS - 1 {
                x = Node.diameter * CGFloat(column) + Node.originX;
                grid[row][column] = CGPoint(x: x, y: y);
            }
        }
    }
    
    internal func buildNodes() -> Void {
        nodes.append(Node(isHeader: true));
        
        createNodes();
        sortNodes();
    }
    
    private func createNodes() -> Void {
        for row in 0...GameMaster.ROWS - 1 {
            for column in 0...GameMaster.COLUMNS - 1 {
                let color : String = Level.LEVEL_1[row][column];
                
                if (color != "N") {
                    let node = Node(nodeName: "\(treeSize + 1)", nodeColor: getColorOfNode(color), position: grid[row][column]);
                    
                    treeSize += 1;
                    nodes.append(node);
                }
            }
        }
    }
    
    private func getColorOfNode(color : String) -> UIColor {
        // Colors: Green, Red, Orange, Blue, Purple
        if (color == "G") {
            return UIColor.greenColor();
        } else if (color == "R") {
            return UIColor.redColor();
        } else if (color == "O") {
            return UIColor.orangeColor();
        } else if (color == "B") {
            return UIColor.blueColor();
        } else if (color == "P") {
            return UIColor.purpleColor();
        } else {
            return UIColor.blackColor();
        }
    }
    
    private func doSiblingsHaveSameColor(node : Int) -> Bool {
        let sibling : Int = siblingOf(node);
        
        if (sibling == -1) {
            return false;
        } else {
            return nodes[node].getNodeColor() == nodes[sibling].getNodeColor();
        }
    }
    
    private func siblingOf(node : Int) -> Int {
        if (node <= 1) {
            return -1;
        }
        
        let parent : Int = node / 2;
        var sibling : Int = node + 1;
        
        for _ in 0...1 {
            if (parent == (sibling / 2)) {
                return (sibling <= treeSize) ? sibling : -1;
            }
            
            sibling = node - 1;
        }
        
        return -1; /* Has no sibling!! */
    }
    
    private func sortNodes() {
        for i in 2...treeSize {
            for j in (2...i).reverse() {
                if (nodes[j].position.y > nodes[j - 1].position.y) {
                    swap(j, j: j - 1);
                } else if (nodes[j].position.y == nodes[j - 1].position.y && nodes[j].position.x < nodes[j - 1].position.x) {
                    swap(j, j: j - 1);
                }
            }
        }
    }
    
    private func swap(i : Int, j : Int) -> Void {
        let temp = nodes[i];
        nodes[i] = nodes[j];
        nodes[j] = temp;
    }
    
    internal func buildConnectors() {
        for _ in 0...treeSize {
            connectors.append(Array(count: treeSize + 1, repeatedValue: freeConnector));
        }
        
        for i in 1...treeSize {
            let leftChild       : Int = i * 2;
            let rightChild      : Int = leftChild + 1;
            var currentChild    : Int = leftChild;
            
            for _ in 0...1 {
                if (currentChild <= treeSize) {
                    if (nodes[currentChild].getNodeName() != "null") {
                        let distanceY : CGFloat  = nodes[i].position.y - nodes[currentChild].position.y;
                        let distanceX : CGFloat  = nodes[i].position.x - nodes[currentChild].position.x;
                        let hypotenuse : CGFloat = hypot(distanceY, distanceX);
                        let angle : CGFloat      = atan2(distanceY, distanceX);
                        
                        connectors[i][currentChild] = Connector(connectorName: "\(i)-\(currentChild)", length: hypotenuse, rotation: angle,
                                                                nodeToConnect: nodes[currentChild]);
                    }
                }
                
                currentChild = rightChild;
            }
        }
    }
    
    /* ------------- GETTERS AND SETTERS ------------- */
    
    internal func getLevel() -> Int {
        return level;
    }
    
    internal func setLevel(level : Int) -> Void {
        self.level = level;
    }
    
    internal func getTreeSize() -> Int {
        return treeSize;
    }
    
    internal func setTreeSize(treeSize : Int) -> Void {
        self.treeSize = treeSize;
    }
    
    internal func getGrid() -> Array<Array<CGPoint>> {
        return grid;
    }
    
    internal func setGrid(grid : Array<Array<CGPoint>>) -> Void {
        self.grid = grid;
    }
    
    internal func getNodes() -> Array<Node> {
        return nodes;
    }
    
    internal func setNodes(nodes : Array<Node>) -> Void {
        self.nodes = nodes;
    }
    
    internal func getConnectors() -> Array<Array<Connector>> {
        return connectors;
    }
    
    internal func setConnectors(connectors : Array<Array<Connector>>) -> Void {
        self.connectors = connectors;
    }
}
