//
//  FaceView.swift
//  Happiness
//
//  Created by SchUser on 16/10/4.
//  Copyright © 2016年 SchUser. All rights reserved.
//

import UIKit

protocol FaceViewDataSource:class {
    func smilnessForFaceView(sender:FaceView)->Double?
    
}

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var lineWidth:CGFloat=5{didSet{setNeedsDisplay()}}
    @IBInspectable
    var color:UIColor = UIColor.orangeColor(){didSet{setNeedsDisplay()}}
    @IBInspectable
    var scale:CGFloat=0.9 {didSet{
        
        setNeedsDisplay()
        }
    }
    
    var faceCenter:CGPoint{
        return convertPoint(center, fromView: superview)
    }
    
    var faceRadius:CGFloat{
         return min(bounds.size.width, bounds.size.height)/2*scale
    }
    
    weak var dataSource:FaceViewDataSource?
    
    func scale(gesture:UIPinchGestureRecognizer){
        if gesture.state == .Changed{
            
            scale*=gesture.scale
            
            gesture.scale=1
        }
    }
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        //大圆半径(face半径)与小圆半径(eye半径)的比率,次数越小,小圆越大.因为 下面bezierPathForEye的方法中定义 eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        //大圆与小圆的偏移率,此数越大,小圆的圆心距大圆越近
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        //两个小圆之间在大圆内的分离比率
        static let FaceRadiusToEyeMounthWidthRatio: CGFloat = 1
        static let FaceRadiusToEyeMounthHeightRatio: CGFloat = 3
        static let FaceRadiusToEyeMounthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye {
        case Left , Right
    }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
        //此处定义的方法为设置一只眼睛的位置,上面定义了左右眼的枚举,可通过调用.Left.Right来实现两个位置的设定
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        //定义小圆半径是大圆半径的几分之几,此处因为FaceRadiusToEyeRadiusRatio: CGFloat = 10 故为十分之一
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        //小圆的垂直偏距
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        //小圆的水平距离
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        //此处相当于是用大圆圆心的y坐标减去小圆圆心的y坐标,故小圆圆心在大圆圆心之上.若为加,则在下
        switch whichEye {
        case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
        //相当于大圆圆心的x坐标减去(小圆圆心的x坐标除以2),即在大圆圆心的左侧
        case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
            //此处加,即在右侧
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true) //画圆
        path.lineWidth = lineWidth //设定线宽
        return path
    }
    
    
    private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath {
        let mouthWidth = faceRadius / Scaling.FaceRadiusToEyeMounthWidthRatio
        //大圆半径与线宽的比率,此处线宽=大圆半径
        let mouthHeight = faceRadius / Scaling.FaceRadiusToEyeMounthHeightRatio
        //mouthHeight即线的中点到圆心的距离
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeMounthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        //此处max(min(fractionOfMaxSmile, 1), -1)限定了笑脸指数只能在-1到1之间,fractionOfMaxSmile这个参数可以自行设定,如果设定的大于1,则只取1,设定小于-1,则只取-1
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)  //设置起点
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)  //设置终点
        let cp1 = CGPoint(x: start.x + mouthWidth / 3 , y: start.y + smileHeight) //设置曲线点1,此处mouthWidth / 3用于调节曲线的弧度
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)  //设置曲线点2
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }

    
    override func drawRect(rect: CGRect) {
        let facePath=UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth=lineWidth
        color.set()
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        let smiliness = dataSource?.smilnessForFaceView(self) ?? 0.0
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }
}
