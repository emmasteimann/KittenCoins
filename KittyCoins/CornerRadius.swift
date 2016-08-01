//
//  CornerRadius.swift
//  KittyCoins
//
//  Created by Emma Steimann on 7/31/16.
//  Copyright © 2016 Emma Steimann. All rights reserved.
//

import UIKit

extension UIView
{
  func addCornerRadiusAnimation(from: CGFloat, to: CGFloat, duration: CFTimeInterval)
  {
    let animation = CABasicAnimation(keyPath:"cornerRadius")
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.fromValue = from
    animation.toValue = to
    animation.duration = duration
    self.layer.addAnimation(animation, forKey: "cornerRadius")
    self.layer.cornerRadius = to
  }
}