//
//  DataQueue.swift
//  Tick
//
//  Created by Nick Walker on 1/24/15.
//  Copyright (c) 2015 Nick Walker. All rights reserved.
//

import Foundation

public protocol TrickleQueueDelegate{
    func processQueuedData(data: NSData)
}
@objc public class TrickleQueue {
    private var data = [NSData]()
    private var lastProcessed: NSDate?
    private var processingTimer: NSTimer?
    var delegate: TrickleQueueDelegate?

    init(){

    }
    public func add(newData: NSData){
        data.append(newData)
        //If there's a timer going, it'll get to some data eventually.
        //Otherwise...
        if processingTimer == nil {
            let timeoutPassed: Bool = {
                if self.lastProcessed == nil {
                    return true
                }
                let currentTime = NSDate()
                let targetTime = self.lastProcessed!.dateByAddingTimeInterval(0.15)
                return currentTime.compare(targetTime) == NSComparisonResult.OrderedDescending
            }()

            if timeoutPassed {
                timerTriggered()
            }
            else {
                processingTimer = NSTimer.scheduledTimerWithTimeInterval(0.15, target: self, selector: Selector("timerTriggered"), userInfo: nil, repeats: false)
            }
        }
    }

    public func timerTriggered(){
        processingTimer = nil
        delegate?.processQueuedData(data[0])
        data.removeAtIndex(0)
        lastProcessed = NSDate()
        if data.count != 0 {
            processingTimer = NSTimer.scheduledTimerWithTimeInterval(0.15, target: self, selector: Selector("timerTriggered"), userInfo: nil, repeats: false)
        }
    }

}