/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import QuartzCore

@IBDesignable
class WatchView: UIView {
    

    
  @IBInspectable var enableClockSecondHand: Bool = false {
  didSet { updateLayerProperties() } // 1 toggles between seconds displayed as a ring or as a second hand.
  }

  @IBInspectable var enableColorBackground: Bool = false {
    didSet { updateLayerProperties() } // 2 toggles between a colored background and an image background.
  }

    // Base color background layer
    var backgroundLayer: CAShapeLayer! // 1 the base layer of your watch; as a CAShapeLayer
    @IBInspectable var backgroundLayerColor: UIColor = UIColor.darkGrayColor() {
        didSet {
            updateLayerProperties()
        } // 2 exposes the backgroundLayer's color attribute. lets you change the color of the background from within the Attribute Inspector.
    }
    
    var backgroundImageLayer: CALayer!
    @IBInspectable var backgroundImage: UIImage? {
        didSet { updateLayerProperties() }
    }
    
    var ringLayer: CAShapeLayer! // 1
    // Declares a ringLayer to be a CAShapeLayer object. The ring layer is a circular progress-type indicator to keep track of seconds
    @IBInspectable var ringThickness: CGFloat = 2.0 // 2
    // ringThickness controls the thickness of the ring. ringProgress keeps track of the indicator's location on the circular path.
    @IBInspectable var ringColor: UIColor = UIColor.blueColor()
    @IBInspectable var ringProgress: CGFloat = 45.0/60 {
        didSet {
            updateLayerProperties() // 3
        }
    }
    
    // Watch second 'hand'
    var secondHandLayer: CAShapeLayer!
    @IBInspectable var secondHandColor: UIColor = UIColor.redColor()
    
    // Watch minute 'hand'
    var minuteHandLayer: CAShapeLayer!
    @IBInspectable var minuteHandColor: UIColor = UIColor.whiteColor()
    
    // Watch hour 'hand'
    var hourHandLayer: CAShapeLayer!
    @IBInspectable var hourHandColor: UIColor = UIColor.whiteColor()
    
   @IBInspectable var lineWidth: CGFloat = 1.0 // 3 expose the line width property
    
    var timer = NSTimer()
    var currentTimeZone: String = "Asiz/Singapore"
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  func commonInit() {
    //Initialize whatever here.
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    createClockFace()
  }

  func createClockFace() {
    //First we create the base background layer.
    layoutBackgroundLayer()
    //Then we layout the background image if there is one.
    layoutBackgroundImageLayer()
    //Creates Analog clock
    createAnalogClock()
    //If we haven't changed any of the inspectable properties.
    updateLayerProperties()
  }

  func createAnalogClock() {
    //Lays out the minute hand.
    layoutMinuteHandLayer()
    //Lays out the hour hand.
    layoutHourHandLayer()
    
    if enableClockSecondHand == true {
      //Lays out the second hand.
      layoutSecondHandLayer()
    } else {
      //Next we lay out the ring indicator.
      layoutWatchRingLayer()
    }
  }

  //MARK: Image and background layering
  //The base circular layer.
  func layoutBackgroundLayer() {
    //TODO: Implement
    if backgroundLayer == nil {
        // 1
        // Check to see if the backgroundLayer has already been created.
        backgroundLayer = CAShapeLayer()
        // 2
        // If the background layer does not exist, the code allocates memory for a CAShapeLayer object
        layer.addSublayer(backgroundLayer)
        // 3
        // add the backgroundLayer to the view's sublayer.
        let rect = CGRectInset(bounds, lineWidth / 2.0, lineWidth / 2.0)
        // 4
        // create a CGRect variable with insets; ensures your circle won't clip the view
        let path = UIBezierPath(ovalInRect: rect) // 5
        // Create a curcular UIBezierPath
        backgroundLayer.path = path.CGPath // 6
        // Apply the circular path to the backgroundLayer's path, so the background layer is now circular instead of rectangular
        backgroundLayer.fillColor = backgroundLayerColor.CGColor // 7
        // will reflected in the object in IB
        backgroundLayer.lineWidth = lineWidth // 8
    }
    backgroundLayer.frame = layer.bounds // 9
    // ensures the layer's frame always within the super view's layer's bounds
  }

  //Creates the background image layer
  func layoutBackgroundImageLayer() {
    //TODO: Implement
    if backgroundImageLayer == nil {
        let maskLayer = CAShapeLayer() // 1
        let dx = lineWidth + 3.0
        let insetBounds = CGRectInset(self.bounds, dx, dx)
        let innerPath = UIBezierPath(ovalInRect: insetBounds)
        maskLayer.path = innerPath.CGPath
        maskLayer.fillColor = UIColor.blackColor().CGColor
        maskLayer.frame = self.bounds
        
        backgroundImageLayer = CAShapeLayer()
        backgroundImageLayer.mask = maskLayer // 2
        // make the layer to circle
        backgroundImageLayer.frame = self.bounds
        backgroundImageLayer.contentsGravity = kCAGravityResizeAspectFill
        layer.addSublayer(backgroundImageLayer)
        
        
    }
  }

  //MARK: Analog Watch Layering
  //Creates the watch's seconds indicator in a cirular form.
  func layoutWatchRingLayer() {
    //TODO: Implement
    // 1 
    // Checks to see if the ring progress is equal to zero. If so, sets the ringLayer's stroke to zero. This animates the stroke of the circular layer counter-clockwise all the way back to the 12 o'clock mark.
    if ringProgress == 0 {
        if ringLayer != nil {
            ringLayer.strokeEnd = 0.0
        }
    }
    // 2
    // Checks to see if a layer already exists. If it doesn't exist, it creates a circular CAShapeLayer.
    if ringLayer == nil {
        ringLayer = CAShapeLayer()
        layer.addSublayer(ringLayer)
        let dx = ringThickness / 2.0
        let rect = CGRectInset(bounds, dx, dx)
        let path = UIBezierPath(ovalInRect: rect)
        // 3
        // This transforms the layer so the starting position will be at the 12 o'clock mark instead of the 3 o'clock mark
        ringLayer.transform = CATransform3DMakeRotation(CGFloat(-(M_PI/2)), 0, 0, 1)
        ringLayer.strokeColor = ringColor.CGColor
        ringLayer.path = path.CGPath
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringThickness
        ringLayer.strokeStart = 0.0
    }
    // 4
    // kicks off the animation. Since strokeEnd is an animation property, changing its value causes CAShapeLayer to animate the progress indicator
    ringLayer.strokeEnd = ringProgress / 60.0
    ringLayer.frame = layer.bounds
  }

  //Creates the second hand layer
  func layoutSecondHandLayer() {
    //TODO: Implement
    if secondHandLayer == nil {
        secondHandLayer = createClockHand(CGPointMake(0.5, 1.0), handLength: 20.0, handWidth: 4.0, handAlpha: 1.0, handColor: secondHandColor)
        layer.addSublayer(secondHandLayer)
    }
  }

  //Creates the minute hand layer
  func layoutMinuteHandLayer() {
    //TODO: Implement
    if minuteHandLayer == nil {
        minuteHandLayer = createClockHand(CGPointMake(0.5, 1.0), handLength: 26.0, handWidth: 7.0, handAlpha: 1.0, handColor: minuteHandColor)
        layer.addSublayer(minuteHandLayer)
    }
  }
    
    // Create the hour hand layer

  func layoutHourHandLayer() {
    //TODO: Implement
    if hourHandLayer == nil {
        hourHandLayer = createClockHand(CGPointMake(0.5, 1.0), handLength: 52.0, handWidth: 7.0, handAlpha: 1.0, handColor: hourHandColor)
        layer.addSublayer(hourHandLayer)
    }
  }

  //MARK: didSet Property Observers
  func updateLayerProperties() {
    //TODO: Implement
    if backgroundLayer != nil {
        backgroundLayer.fillColor = backgroundLayerColor.CGColor
    }
    
    // update the image layer.
    if backgroundImageLayer != nil {
        if let image = backgroundImage {
            backgroundImageLayer.contents = image.CGImage
        }
    }
    
    // update the ring layer.
    if ringLayer != nil {
        ringLayer.strokeEnd = ringProgress / 60.0
    }
    
    // If user toggles between second hand and ring progress indicator
    if enableClockSecondHand == true {
        setHideSecondClockHand(false)
        setHideRingLayer(true)
    } else if enableClockSecondHand == false {
        setHideSecondClockHand(true)
        setHideRingLayer(false)
    } else {
        setHideRingLayer(true)
        setHideSecondClockHand(true)
    }
    
    // Handles toggling between color background and image background
    if enableColorBackground == true {
        setHideImageBackground(true)
    } else {
        setHideImageBackground(false)
    }
  }

  //MARK: Hide components of the watch
  func setHideImageBackground(willHide: Bool) {
    //TODO: Implement
    if backgroundImageLayer != nil {
        backgroundImageLayer.hidden = willHide
    }
  }

  func setHideSecondClockHand(willHide: Bool) {
    //TODO: Implement
    if secondHandLayer != nil {
        secondHandLayer.hidden = willHide
    }
  }

  func setHideRingLayer(willHide: Bool) {
    //TODO: Implement
    if ringLayer != nil {
        ringLayer.hidden = willHide
    }
  }

  //MARK: Helper Methods
  //Insert here
    // Helper function that creates clock hands of different length and sizes or what not!
    func createClockHand(anchorPoint: CGPoint, handLength: CGFloat, handWidth: CGFloat, handAlpha: CGFloat, handColor: UIColor) -> CAShapeLayer {
        let handLayer = CAShapeLayer()
        let path = UIBezierPath()
        //creates two points (one at the center of the clock face, and the other at handLength distance from that point) and draws a line between them.
        path.moveToPoint(CGPointMake(1.0, handLength))
        path.addLineToPoint(CGPointMake(1.0, bounds.size.height / 2.0))
        handLayer.bounds = CGRectMake(0.0, 0.0, 1.0, bounds.size.height / 2.0)
        handLayer.anchorPoint = anchorPoint
        handLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        handLayer.lineWidth = handWidth
        handLayer.opacity = Float(handAlpha)
        handLayer.strokeColor = handColor.CGColor
        handLayer.path = path.CGPath
        handLayer.lineCap = kCALineCapRound
        return handLayer
    }
    
  //MARK: Starting and stoping time
  func startTimeWithTimeZone(timezone: String) {
    //TODO: Implement
    endTime()       // 1 ends the previous time in case anything is running
    currentTimeZone = timezone  // 2 Sets the time zone to the passed-in time zone
    // 3
    // Starts a timer to perform animations related to analog design components.
    timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "animateAnalogClock", userInfo: nil, repeats: true)
  }

  func endTime() {
    //TODO: Implement
    timer.invalidate()
  }

  //MARK: Methods to make watch tick
    func grabDateComponents(dateString: String) -> [String] {
        let dateArray = dateString.componentsSeparatedByString(":")
        return dateArray
    }
  //The stuff that makes the clock just tick
  func animateAnalogClock() {
    //TODO: Implement
    // Get today's time
    let now = NSDate()
    // Create a date formatter. and set the time zone selected by the user
    // 2
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.timeZone = NSTimeZone(name: currentTimeZone)
    dateFormatter.dateFormat = "hh:mm:ss"
    
    // Extract the hour, minute, and second from the date string
    let dateComponents = grabDateComponents(dateFormatter.stringFromDate(now))
    // 6
    let hours = dateComponents[0].toInt()
    let minutes = dateComponents[1].toInt()
    let seconds = dateComponents[2].toInt()
    // Calculate percentage to rotate clock hands by.
    let minutesIntoDay = CGFloat(hours!) * 60 + CGFloat(minutes!)
    let pminutesIntoDay = CGFloat(minutesIntoDay) / (12.0 * 60.0)
    let minutesIntoHour = CGFloat(minutes!) / 60.0
    let secondsIntoMinute = CGFloat(seconds!) / 60.0
    
    // 8
    if enableClockSecondHand == true {
        if secondHandLayer != nil {
            secondHandLayer.transform = CATransform3DMakeRotation(CGFloat(M_PI * 2.0) * secondsIntoMinute , 0, 0, 1)
        }
    } else {
        // 9 
        if ringLayer != nil {
            ringProgress = CGFloat(seconds!)
        }
    }
    // 10
    if minuteHandLayer != nil {
        minuteHandLayer.transform = CATransform3DMakeRotation(CGFloat(M_PI * 2), 0, 0, 1)
    }
    // 11
    if hourHandLayer != nil {
        hourHandLayer.transform = CATransform3DMakeRotation(CGFloat(M_PI * 2) * pminutesIntoDay, 0, 0, 1)
    }
  }
}




