//
//  KittenDataSource.swift
//  KittyCoins
//
//  Created by Emma Steimann on 7/31/16.
//  Copyright © 2016 Emma Steimann. All rights reserved.
//

import UIKit

protocol KittenDataSourceDelegate: class {
  func readyToRemove()
  func allKittensFullyLoaded()
}

extension KittenDataSourceDelegate {
  // optional methods here
  func readyToRemove() {}
}

class KittenDataSource {
  private var kittens:[Kitten] = []
  private let opQ = NSOperationQueue()
  weak var delegate:KittenDataSourceDelegate?

  var count: Int {
    return kittens.count
  }

  init() {
    getThoseKittens()
  }

  func moveKittenAtIndexPath(indexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath) {
    if indexPath == newIndexPath {
      return
    }
    let kitten = self.kittens[indexPath.item]
    self.kittens.removeAtIndex(indexPath.item)
    self.kittens.insert(kitten, atIndex: newIndexPath.item)
  }

  func kittenForItemAtIndexPath(indexPath: NSIndexPath) -> Kitten? {
    return self.kittens[indexPath.item]
  }

  func deleteItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
    var indexes: [Int] = []
    for indexPath in indexPaths {
      indexes.append(indexPath.item)
    }
    var newKittens: [Kitten] = []
    for (index, kitten) in kittens.enumerate() {
      if !indexes.contains(index) {
        newKittens.append(kitten)
      }
    }
    kittens = newKittens
  }

  private func getThoseKittens() {
    // if you don't call unowned/weak self it creates a strong reference cycle here!
    // unowned is an implicitly unwrapped optional so it can't be nil in the block or things explode

    let kOp = KittenSearchOperation(completionHandler: { [unowned self] (result:AnyObject?, success:Bool?) in
      print("Downloaded kitten... loading...")
      if let result = result  as? [String:AnyObject] {
        if let photos = result["photos"] as? [String:AnyObject] {
          if let photo = photos["photo"] as? [AnyObject] {
            for cat in photo {
              let url = cat["url_m"] as? String
              let viewString = cat["views"] as? String
              let views = Int(viewString!)
              let title = cat["title"] as? String
              let id = cat["id"] as? String
              let kittyCat = Kitten(views: views!, title: title!, kittenId: id!)
              kittyCat.imageURL = url
              self.kittens.append(kittyCat)
            }
          }
        }
      }
      self.delegate?.allKittensFullyLoaded()
    })

    opQ.addOperation(kOp)
  }
  deinit {
    print("Removing: Data Source")
  }
}