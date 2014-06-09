//
//  CustomObject.swift
//  EasyJson-Swift
//
//  Created by christophe on 09/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

class CustomObject : EasyJsonWrapper {
    var attrString:String?
    var attrDate:NSDate?
    var attrData:NSData?
    var attrNumber:NSNumber?
    var attrInteger:NSInteger?
    var attrInt:Int?
    var attrFloat:Float?
    var attrDouble:Double?
    var attrBool:Bool?
    var attrArray:AnyObject[]?
//    var attrDictionary = makeDict()
    
    func makeDict<T1: Hashable, T2>(key: T1, value:T2) -> Dictionary<T1,T2> {
        return Dictionary<T1,T2>()
    }

}