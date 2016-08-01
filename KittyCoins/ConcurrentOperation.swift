//
//  ConcurrentOperation.swift
//  KittyCoins
//
//  Created by Emma Steimann on 7/30/16.
//  Copyright © 2016 Emma Steimann. All rights reserved.
//

import Foundation

public class ConcurrentOperation: NSOperation {
  typealias CompletionHandler = (result:AnyObject?, success:Bool?)  -> Void
  var completionHandler:CompletionHandler?
  var result:AnyObject?
  var success:Bool?

  public enum State: String {
    case Ready, Executing, Finished

    private var keyPath: String {
      return "is" + rawValue
    }
  }

  public var state = State.Ready {
    willSet {
      willChangeValueForKey(newValue.keyPath)
      willChangeValueForKey(state.keyPath)
    }
    didSet {
      didChangeValueForKey(oldValue.keyPath)
      didChangeValueForKey(state.keyPath)
    }
  }

  convenience init(completionHandler:CompletionHandler) {
    self.init()
    self.completionHandler = completionHandler
  }

  func completeOperation() {
    print("I'm completing.")
    if let completionHandler = self.completionHandler {
      dispatch_async(dispatch_get_main_queue(), {
        completionHandler(result: self.result, success: self.success);
      });
    }
  }
}


extension ConcurrentOperation {
  override public var ready: Bool {
    return super.ready && state == .Ready
  }

  override public var executing: Bool {
    return state == .Executing
  }

  override public var finished: Bool {
    return state == .Finished
  }

  override public var asynchronous: Bool {
    return true
  }

  override public func start() {
    if cancelled {
      state = .Finished
      return
    }

    main()
    state = .Executing
  }

  override public func cancel() {
    state = .Finished
  }
}