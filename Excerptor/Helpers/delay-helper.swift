//
//  delay-helper.swift
//  Excerptor
//
//  Created by Chen Guo on 19/05/2015.
//  Copyright (c) 2015 guoc. All rights reserved.
//

// http://stackoverflow.com/a/24318861/3157231

func delay(delay: Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}
