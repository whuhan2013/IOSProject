//
//  ViewController.swift
//  Dropit
//
//  Created by SchUser on 16/10/9.
//  Copyright © 2016年 SchUser. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController ,UIDynamicAnimatorDelegate{

   
    @IBOutlet weak var gameView: BezierPathView!
    
    
    
    lazy var animator:UIDynamicAnimator={
     let lazilyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazilyCreatedDynamicAnimator.delegate=self
     return lazilyCreatedDynamicAnimator
    }()
    
    let dropItBehavior=DropitBehavior()
    
    var attachment:UIAttachmentBehavior? {
        willSet{
            if attachment != nil {
            animator.removeBehavior(attachment!)
            }
            gameView.setPath(nil, named: pathNames.AttachMent)
        }
        
        didSet{
            if attachment != nil {
                
            animator.addBehavior(attachment!)
                attachment?.action={ [unowned self] in
                    if let attachedView = self.attachment?.items.first as? UIView{
                    
                        let path = UIBezierPath()
                        path.moveToPoint((self.attachment?.anchorPoint)!)
                        path.addLineToPoint(attachedView.center)
                        self.gameView.setPath(path,named: pathNames.AttachMent)
                    }
                }
                
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator.addBehavior(dropItBehavior)
       
    }
    
    struct pathNames {
        static let MiddleBarrier = "Middle Barrier"
        static let AttachMent = "Attachment"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let barrierSize=dropSize
        let barrierOrigin=CGPoint(x:gameView.bounds.midX-barrierSize.width/2,y:gameView.bounds.midY-barrierSize.height/2)
        
        let path=UIBezierPath(ovalInRect: CGRect(origin: barrierOrigin, size: barrierSize))
        dropItBehavior.addBarrier(path, named: pathNames.MiddleBarrier)
        
        gameView.setPath(path, named: pathNames.MiddleBarrier)
    }
    
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeCompletedRow()
    }
    
    
    var dropPerRow=10
    var dropSize:CGSize{
        let size = gameView.bounds.size.width/CGFloat(dropPerRow)
        return CGSize(width: size,height: size)
    }
    
    @IBAction func grabDrop(sender: UIPanGestureRecognizer) {
        
        let gesturPoint=sender.locationInView(gameView)
        
        switch sender.state {
        case .Began:
            if let viewToAttachTO = lastDropedView{
            attachment=UIAttachmentBehavior(item: viewToAttachTO, attachedToAnchor: gesturPoint)
                lastDropedView = nil
            }
        case .Changed:
            attachment?.anchorPoint=gesturPoint
        case .Ended:
            attachment = nil
        default:
            break
        }
    }
    
    var lastDropedView:UIView?
    
    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }
    
    func drop(){
        var frame=CGRect(origin: CGPointZero,size: dropSize)
        frame.origin.x=CGFloat.random(dropPerRow)*dropSize.width
        
        let dropView=UIView(frame: frame)
        dropView.backgroundColor=UIColor.random
        lastDropedView=dropView
        dropItBehavior.addDrop(dropView)
    }
    
    
    //当满行后消除方块
    func removeCompletedRow() {
        var dropsToRemove = [UIView]()
        var dropFrame = CGRect(x: 0, y: gameView.frame.maxY, width: dropSize.width, height: dropSize.height)
        
        repeat {
            dropFrame.origin.y -= dropSize.height
            dropFrame.origin.x = 0
            var dropsFound = [UIView]()
            var rowIsComplete = true
            for _ in 0 ..< dropPerRow {
                if let hitView = gameView.hitTest(CGPoint(x: dropFrame.midX, y: dropFrame.midY), withEvent: nil) {
                    if hitView.superview == gameView {
                        dropsFound.append(hitView)
                    } else {
                        rowIsComplete = false
                    }
                }
                dropFrame.origin.x += dropSize.width
            }
            if rowIsComplete {
                dropsToRemove += dropsFound
            }
        } while dropsToRemove.count == 0 && dropFrame.origin.y > 0
        
        for drop in dropsToRemove {
            dropItBehavior.removeDrop(drop)
        }
    }
    
    

}

private extension CGFloat {
    static func random(max:Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor {
    class var random:UIColor {
        switch arc4random() % 5 {
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        default: return UIColor.blackColor()
        }
    }
}

