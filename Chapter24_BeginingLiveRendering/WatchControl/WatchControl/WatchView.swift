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
    
   @IBInspectable var lineWidth: CGFloat = 1.0 // 3 expose the line width property
    
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
  }

  //MARK: Analog Watch Layering
  //Creates the watch's seconds indicator in a cirular form.
  func layoutWatchRingLayer() {
    //TODO: Implement
  }

  //Creates the second hand layer
  func layoutSecondHandLayer() {
    //TODO: Implement
  }

  //Creates the minute hand layer
  func layoutMinuteHandLayer() {
    //TODO: Implement
  }

  func layoutHourHandLayer() {
    //TODO: Implement
  }

  //MARK: didSet Property Observers
  func updateLayerProperties() {
    //TODO: Implement
    if backgroundLayer != nil {
        backgroundLayer.fillColor = backgroundLayerColor.CGColor
    }
  }

  //MARK: Hide components of the watch
  func setHideImageBackground(willHide: Bool) {
    //TODO: Implement
  }

  func setHideSecondClockHand(willHide: Bool) {
    //TODO: Implement
  }

  func setHideRingLayer(willHide: Bool) {
    //TODO: Implement
  }

  //MARK: Helper Methods
  //Insert here

  //MARK: Starting and stoping time
  func startTimeWithTimeZone(timezone: String) {
    //TODO: Implement
  }

  func endTime() {
    //TODO: Implement
  }

  //MARK: Methods to make watch tick
  //The stuff that makes the clock just tick
  func animateAnalogClock() {
    //TODO: Implement
  }
}




