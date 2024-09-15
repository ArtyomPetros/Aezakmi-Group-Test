//
//  AVAssetTrack+Extensions.swift
//  TestApp1
//
//  Created by Артём Петросян on 14.09.2024.
//

import Foundation
import AVKit
import Photos

extension AVAssetTrack {
    var fixedPreferredTransform: CGAffineTransform {
        var t = preferredTransform
        switch(t.a, t.b, t.c, t.d) {
        case (1, 0, 0, 1):
            t.tx = 0
            t.ty = 0
        case (1, 0, 0, -1):
            t.tx = 0
            t.ty = naturalSize.height
        case (-1, 0, 0, 1):
            t.tx = naturalSize.width
            t.ty = 0
        case (-1, 0, 0, -1):
            t.tx = naturalSize.width
            t.ty = naturalSize.height
        case (0, -1, 1, 0):
            t.tx = 0
            t.ty = naturalSize.width
        case (0, 1, -1, 0):
            t.tx = naturalSize.height
            t.ty = 0
        case (0, 1, 1, 0):
            t.tx = 0
            t.ty = 0
        case (0, -1, -1, 0):
            t.tx = naturalSize.height
            t.ty = naturalSize.width
        default:
            break
        }
        
        return t
    }
}
