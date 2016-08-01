//
//  KittenSearchOperation.swift
//  KittyCoins
//
//  Created by Emma Steimann on 7/30/16.
//  Copyright © 2016 Emma Steimann. All rights reserved.
//

import Foundation

class KittenSearchOperation: ConcurrentOperation {
  override func main() {
    let url = NSURL(string:"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=7191c8d7912e82284267d8a7a7ae03e3&text=kitten&tags=kitten&per_page=40&format=json&nojsoncallback=1&%20extras=url_m,views&sort=interestingness-desc")
    let request = NSURLRequest(URL: url!)
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: config)
    session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in

      if let error = error {
        print(error.localizedDescription)
      } else if let response = response as? NSHTTPURLResponse where 200...299 ~= response.statusCode {
          if let data = data {
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            self.result = json
            self.success = true
            self.completeOperation()
            return
          }
      }

      self.success = false
      self.completeOperation()
      return

    }).resume()
  }
  deinit {
    print("Removing: Kitten Search Operation")
  }
}