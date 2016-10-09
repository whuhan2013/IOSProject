//
//  BezierPathView.swift
//  Dropit
//
//  Created by SchUser on 16/10/9.
//  Copyright © 2016年 SchUser. All rights reserved.
//

import UIKit

class BezierPathView: UIView {
    
    private var bezierpath = [String:UIBezierPath]()
    
    
    func setPath(path:UIBezierPath?,named name:String){
        bezierpath[name]=path
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        for (_,path) in bezierpath{
            path.stroke()
        }
    }

}
