//
//  Kitten.swift
//  KittyCoins
//
//  Created by Emma Steimann on 7/31/16.
//  Copyright © 2016 Emma Steimann. All rights reserved.
//

import UIKit

class Kitten {
  var imageURL:String?
  var image:UIImage?
  var views:Int
  var title:String
  var kittenId:String

  init(views:Int, title:String, kittenId:String) {
    self.views = views
    self.title = title
    self.kittenId = kittenId
  }

  deinit {
    print("Removing: Kitten")
  }
}