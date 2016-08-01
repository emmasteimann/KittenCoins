//
//  ImageCache.swift
//  KittyCoins
//
//  Created by Emma Steimann on 7/31/16.
//  Copyright © 2016 Emma Steimann. All rights reserved.
//

import UIKit
class ImageCache {
  let imgCache = NSCache()

  static let sharedInstance = ImageCache()

  func addImageURL(imageURL:String, withImage image: UIImage) {
    self.imgCache.setObject(image, forKey: imageURL)
  }

  func getImageForURL(imageURL: String) -> UIImage? {
    return self.imgCache.objectForKey(imageURL) as? UIImage
  }

  func doesImageForURLExist(imageURL: String) -> Bool {
    if self.imgCache.objectForKey(imageURL) == nil {
      return false
    }
    return true
  }
}
