//
//  EasyJsonObject.swift
//  EasyJson-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

class EasyJsonObject {
    
    class EasyJsonParameterObject {
        let attribute:String
        let objectType:String?
        let jsonKey:String
        
        init(attribute:String, jsonKey:String, objectType:String?) {
            self.attribute = attribute
            self.jsonKey = jsonKey
            self.objectType = objectType
        }
        
        convenience init(attribute:String, jsonKey:String) {
            self.init(attribute: attribute, jsonKey: jsonKey, objectType: nil)
        }
        
    }
    
    var classInfo:EasyJsonParameterObject
    var parameters = EasyJsonParameterObject[]()
    
    
    init(classInfo:EasyJsonParameterObject) {
        self.classInfo = classInfo
    }
    
    subscript(index: Int) -> EasyJsonParameterObject {
        get {
            return parameters[index]
        }
        set {
           parameters[index] = newValue
        }
    }
    
}

