//
//  NumericDial.swift
//  NumericDial
//
//  Created by Simon Gladman on 05/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class NumericDial: UIControl
{
    let minimumValue = 0.0
    let maximumValue = 1.0
    let trackLayer = NumericDialTrack()
    let label = UILabel();
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        trackLayer.numericDial = self
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(trackLayer)
        
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
        
        drawTrack()
    }
    
    required init(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool
    {
        setCurrentValueFromLocation(touch.locationInView(self))
        
        return true
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool
    {
        setCurrentValueFromLocation(touch.locationInView(self))

        return true
    }
    
    private func setCurrentValueFromLocation(location : CGPoint)
    {
        let angle = atan2(location.x - (frame.width / 2), location.y - (frame.height / 2)) * 180/CGFloat(M_PI)
        let distance = hypot(location.x - (frame.width / 2), location.y - (frame.height / 2))
        
        if (distance > (frame.width / 2.0 * 0.6) && (angle < -45 && angle > -180) || (angle < 180 && angle > 45))
        {
            currentValue = Double(getValueFromAngle(angle))
        }
    }
    
    var currentValue : Double = 0.0
    {
        didSet
        {
            currentValue = currentValue < 0 ? 0 : currentValue
            currentValue = currentValue > 1 ? 1 : currentValue
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            sendActionsForControlEvents(.ValueChanged)
            drawTrack()
            
            CATransaction.commit()
        }
    }

    var labelFunction : (Double) -> String = NumericDial.defaultLabelFunction
    {
        didSet
        {
            label.text = labelFunction(currentValue)
        }
    }

    
    func drawTrack()
    {
        label.frame = bounds.rectByInsetting(dx: 0, dy: 0)
        label.text = labelFunction(currentValue)
        
        trackLayer.frame = bounds.rectByInsetting(dx: 0.0, dy: 0.0)
        trackLayer.setNeedsDisplay()
    }
    
    override var frame: CGRect
    {
        didSet
        {
            drawTrack()
        }
    }
    
    final func getValueFromAngle(value : CGFloat) -> CGFloat
    {
        var returnNumber : CGFloat;
        
        if (value < 0)
        {
            returnNumber = (abs(value + 45) / 135) / 2;
        }
        else
        {
            returnNumber = 0.5 + (((181 - value) / 135) / 2) ;
        }
        
        return returnNumber;
    }
    
    class func defaultLabelFunction(value : Double) -> String
    {
        return NSString(format: "%.4f", value)
    }
}
