//
//  KittyCoinImageView.swift
//  KittyCoins
//
//  Created by Emma Steimann on 8/1/16.
//  Copyright © 2016 Emma Steimann. All rights reserved.
//

import UIKit

class KittyCoinImageView: UIImageView {
  let maskLayer = CAShapeLayer()
  let circleLayer = CAShapeLayer()

  override func layoutSubviews() {
    layer.addSublayer(circleLayer)
  }

  func makeCircular() {
    print("running")
    self.layer.mask = maskLayer
    let reducedBounds = CGRectInset(bounds, (bounds.width * 0.1),(bounds.height * 0.1))
    let goldLayer = CALayer()
    goldLayer.backgroundColor = UIColor.yellowColor().CGColor
    goldLayer.opacity = 0.5
    goldLayer.frame = self.bounds

    self.layer.addSublayer(goldLayer)
    let morph = CABasicAnimation(keyPath: "path")
    let squarePath = UIBezierPath(rect: reducedBounds).CGPath
    let ovalPath = UIBezierPath(ovalInRect: reducedBounds).CGPath

    maskLayer.path = ovalPath

    morph.duration = 0.2
    morph.fromValue = squarePath
    morph.toValue = ovalPath

    maskLayer.addAnimation(morph, forKey: nil)

    circleLayer.path = UIBezierPath(ovalInRect: reducedBounds).CGPath
    circleLayer.strokeColor = UIColor.whiteColor().CGColor
    circleLayer.lineWidth = 6.0
    circleLayer.fillColor = UIColor.clearColor().CGColor
  }
}