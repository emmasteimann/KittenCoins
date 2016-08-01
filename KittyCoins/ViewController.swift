//
//  ViewController.swift
//  KittyCoins
//
//  Created by Emma Steimann on 7/30/16.
//  Copyright © 2016 Emma Steimann. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, KittenDataSourceDelegate, UIGestureRecognizerDelegate {
  private var kittenDataSource = KittenDataSource()
  private let reuseIdentifier = "KittenCell"
  private var originalTouchLocation:CGPoint?
  private var originalCenter:CGPoint?
  private var currentDraggingView:KittyCoinImageView?
  private var animator:UIDynamicAnimator?
  private var superSecretPipe:UIImageView?

  override func viewDidLoad() {
    super.viewDidLoad()
    kittenDataSource.delegate = self
    self.collectionView?.allowsSelection = true

    let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongPress(_:)))
    lpgr.minimumPressDuration = 0.5
    lpgr.delegate = self
    lpgr.delaysTouchesBegan = true
    animator = UIDynamicAnimator(referenceView: self.view)
    self.collectionView?.addGestureRecognizer(lpgr)


    superSecretPipe = UIImageView(image: UIImage(named: "pipe"))
    superSecretPipe?.frame = CGRectInset(superSecretPipe!.frame, 500, 500)
    let newY = self.view.frame.height - superSecretPipe!.frame.height/2
    superSecretPipe?.center = CGPointMake(self.view.center.x, newY)
//    superSecretPipe?.hidden = true
    self.view.addSubview(superSecretPipe!)
    superSecretPipe?.layer.zPosition = 999
  }

  func allKittensFullyLoaded() {
    print("reloading grid")
    self.collectionView?.reloadData()
  }

  func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
    if gestureReconizer.state == UIGestureRecognizerState.Began {
      let p = gestureReconizer.locationInView(self.collectionView)
      let indexPath = self.collectionView!.indexPathForItemAtPoint(p)

      if let index = indexPath {
        let cell = self.collectionView!.cellForItemAtIndexPath(index) as! KittenCell
        originalTouchLocation = p
        cell.contentView
        let imageCopy = cell.imageView.image?.copy() as! UIImage
        let newImageView = KittyCoinImageView(image: imageCopy)
        let cellFrameInSuperView = self.collectionView?.convertRect(cell.frame, toView: self.view)
        newImageView.frame = cellFrameInSuperView!
        originalCenter = newImageView.center
        self.view.addSubview(newImageView)
        newImageView.layer.zPosition = 1
        currentDraggingView = newImageView
        self.kittenDataSource.deleteItemsAtIndexPaths([index])
        self.collectionView?.deleteItemsAtIndexPaths([index])
        currentDraggingView?.makeCircular()
      }
    } else if gestureReconizer.state == UIGestureRecognizerState.Changed {
      if let originalCenter = originalCenter, originalTouchLocation = originalTouchLocation, currentDraggingView = currentDraggingView {
        let p = gestureReconizer.locationInView(self.collectionView)
        let deltaFromOriginal = CGPointMake(p.x - originalTouchLocation.x, p.y - originalTouchLocation.y)

        let newCenter = CGPointMake(originalCenter.x + deltaFromOriginal.x, originalCenter.y + deltaFromOriginal.y)
          currentDraggingView.center = newCenter
      }
    } else if gestureReconizer.state == UIGestureRecognizerState.Ended {
      if let currentDraggingView = currentDraggingView {
        let gravity = UIGravityBehavior(items: [currentDraggingView])
        animator?.addBehavior(gravity)
        let collision = UICollisionBehavior(items: [currentDraggingView])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collision)
      }
    }
  }




}

extension ViewController {
  // Doesn't neccesarily make sense to separte when already loading the data source in the CVC object... oh well.. figure out later.

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print("Getting count: \(kittenDataSource.count)")
    return kittenDataSource.count
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("KittenCell", forIndexPath: indexPath) as! KittenCell

    if let kitten = kittenDataSource.kittenForItemAtIndexPath(indexPath) {
      cell.kitten = kitten
      cell.kittenURL = kitten.imageURL
      
      ImageDownloader.loadImageFromURLString(kitten.imageURL!, callback: { (image, url) in
        if cell.kittenURL == url {
          ImageCache.sharedInstance.addImageURL(url, withImage: image)
          cell.imageView.image = image
        }
      })
    }

    return cell
  }

  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! KittenCell

  }
}
