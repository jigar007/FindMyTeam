//
//  CalendarThumbnailView.swift
//  Getit
//
//  Created by Federico Malesani on 19/03/2016.
//  Copyright © 2016 UniMelb. All rights reserved.
//

import Foundation
//
//  CalendarThumbnailView.swift
//  GPSTrackY
//
//  Created by Federico Malesani on 18/02/2016.
//  Copyright © 2016 UniMelb. All rights reserved.
//

import UIKit

@IBDesignable
class CalendarThumbnailView: UIView {
    
    @IBInspectable
    var topBandColor: UIColor = UIColor.red { didSet { setNeedsDisplay() } }
    @IBInspectable
    var bottomBandColor: UIColor = UIColor.white { didSet { setNeedsDisplay() } }
    @IBInspectable
    var monthTextColor: UIColor = UIColor.white { didSet { setNeedsDisplay() } }
    @IBInspectable
    var dayTextColor: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    
    var topBandRatio: Double = 2/5 { didSet { setNeedsDisplay() } }
    var bottomBandRatio: Double = 3/5 { didSet { setNeedsDisplay() } }
    
    var day: NSString = "7" { didSet { setNeedsDisplay() } }
    var month: NSString = "MAY" { didSet { setNeedsDisplay() } }
    
    //    var month: String?
    //    var day: Int?
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        //TODO: remove all magic numbers!
        // Drawing code
        let topBarPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height*(2/5)))
        topBandColor.set()
        topBarPath.fill()
        topBarPath.stroke()
        
        let bottomBarPath = UIBezierPath(rect: CGRect(x: 0, y: self.bounds.size.height*(2/5), width: self.bounds.size.width, height: self.bounds.size.height*(3/5)))
        bottomBandColor.set()
        bottomBarPath.fill()
        bottomBarPath.stroke()
        
        //let month: NSString = "MAY"
        
        // set the text color to dark gray
        //let fieldColor: UIColor = UIColor.darkGrayColor()
        
        // set the font
        //let monthFont = UIFont(name: "Helvetica Neue", size: 16)
        let monthFont = UIFont(name: "Helvetica Neue", size: self.bounds.size.height*(25/100))
        
        
        // set the paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        // set the Obliqueness to 0.1
        //let skew = 0.0
        
        let monthTextAttributes: NSDictionary = [
            //NSForegroundColorAttributeName: fieldColor,
            NSParagraphStyleAttributeName: paragraphStyle,
            //NSObliquenessAttributeName: skew,
            NSFontAttributeName: monthFont!
        ]
        
        month.draw(in: CGRect(x: 0, y: self.bounds.size.height*(9/100), width: self.bounds.size.width, height: self.bounds.size.height*(2/5)), withAttributes: (monthTextAttributes as! [String : AnyObject]))
        
        //let day: NSString = "30"
        
        // set the font
        //let dayFont = UIFont(name: "Helvetica Neue", size: 34)
        let dayFont = UIFont(name: "Helvetica Neue", size: self.bounds.size.height*(54/100))
        
        let dayTextAttributes: NSDictionary = [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: dayFont!
        ]
        
        day.draw(in: CGRect(x: 0, y: self.bounds.size.height*(2/5) - self.bounds.size.height*(8/100), width: self.bounds.size.width, height: self.bounds.size.height*(4/7)), withAttributes: (dayTextAttributes as! [String : AnyObject]))
        
        
    }
    
    //    //@IBInspectalbe
    //    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    //    //@IBInspectalbe
    //    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
    //
    //    var faceCenter: CGPoint {
    //        return convertPoint(center, fromView: superview)
    //    }
    //
    //    var faceRadius: CGFloat {
    //        return min(bounds.size.width, bounds.size.height) / 2*scale
    //    }
    //
    //    weak var dataSource: CalendarThumbnailViewDataSource?
    //
    //    func scale (gesture: UIPinchGestureRecognizer) {
    //        if gesture.state == .Changed {
    //            scale *= gesture.scale
    //            gesture.scale = 1
    //        }
    //    }
    //
    //    private struct Scaling {
    //        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
    //        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
    //        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
    //        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
    //        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
    //        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    //    }
    //
    //    private enum Eye {case Left, Right}
    //
    //    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
    //        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
    //        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
    //        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
    //
    //        var eyeCenter = faceCenter
    //        eyeCenter.y -= eyeVerticalOffset
    //        switch whichEye {
    //        case .Left: eyeCenter.x -= eyeHorizontalSeparation/2
    //        case .Right: eyeCenter.x += eyeHorizontalSeparation/2
    //        }
    //
    //        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
    //        path.lineWidth = lineWidth
    //        return path
    //    }
    //
    //    private func bezierPathForSmile (fractionOfSmile: Double) -> UIBezierPath {
    //        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
    //        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
    //        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
    //
    //        let smileHeight = CGFloat(max(min(fractionOfSmile, 1), -1)) * mouthHeight
    //        let start = CGPoint(x: faceCenter.x - mouthWidth/2, y: faceCenter.y + mouthVerticalOffset)
    //        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
    //        let cp1 = CGPoint(x: start.x + mouthWidth/3, y: start.y + smileHeight)
    //        let cp2 = CGPoint(x: end.x - mouthWidth/3, y: cp1.y)
    //
    //        let path = UIBezierPath()
    //        path.moveToPoint(start)
    //        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
    //        path.lineWidth = lineWidth
    //        return path
    //    }
    //
    //    // Only override drawRect: if you perform custom drawing.
    //    // An empty implementation adversely affects performance during animation.
    //    override func drawRect(rect: CGRect) {
    //        // Drawing code
    //        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
    //        facePath.lineWidth = lineWidth
    //        color.set()
    //        facePath.stroke()
    //
    //        bezierPathForEye(.Left).stroke()
    //        bezierPathForEye(.Right).stroke()
    //
    //        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0 //if the left part is not nil then usit, otherwise use the right part
    //        let smilePath = bezierPathForSmile(smiliness)
    //        smilePath.stroke()
    //
    //    }
    
}
