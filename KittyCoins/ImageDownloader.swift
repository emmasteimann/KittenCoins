//
//  ImageDownloader.swift
//  KittyCoins
//
//  Created by Emma Steimann on 7/31/16.
//  Copyright © 2016 Emma Steimann. All rights reserved.
//

import UIKit

class ImageDownloader {
  class func loadImageFromURLString(url:String, callback:(image:UIImage, imageURL:String) -> Void) {

    if ImageCache.sharedInstance.doesImageForURLExist(url) {
      let image = ImageCache.sharedInstance.getImageForURL(url)!
      callback(image: image, imageURL: url)
      return
    }

    let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

    dispatch_async(queue, { () -> Void in
      let request:NSURLRequest = NSURLRequest(URL:NSURL(string:url)!)
      let config = NSURLSessionConfiguration.defaultSessionConfiguration()
      let session = NSURLSession(configuration: config)

      session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in

        if let error = error {

          print(error.localizedDescription)

        } else if let response = response as? NSHTTPURLResponse where 200...299 ~= response.statusCode {

          if let data = data {
            let image:UIImage = UIImage(data: data)!
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
              callback(image: image, imageURL: url)
            })
          }

        }

      }).resume()
    })
  }
}
