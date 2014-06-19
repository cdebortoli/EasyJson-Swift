//
//  EasyJson.swift
//  EasyJson-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

let easyJsonSharedInstance = EasyJson()

class EasyJson {    
    let dateFormatter = NSDateFormatter()
    @lazy var easyJsonDatasource = EasyJsonConfigDatasource()
    
    init() {
        dateFormatter.dateFormat = EasyJsonConfig.dateFormat
    }
    
    // Analyze an array of Dictionary
    func analyzeJsonArray(jsonArray:AnyObject[], forClass objectClass:AnyClass) -> AnyObject[] {
        var resultArray = AnyObject[]()
        return resultArray
    }
    
    // Analyze a dDictionary
    func analyzeJsonDictionary(jsonDictionary:Dictionary<String, AnyObject>, forClass objectClass:AnyClass) -> AnyObject? {
        // 1 - Find the config object for the specified class
        let configObjectOptional = easyJsonDatasource[NSStringFromClass(objectClass)]
        if let configObject = configObjectOptional {
            
            // 2 - Json Dictionary
            var jsonFormatedDictionary = jsonDictionary
            // Envelope
            if EasyJsonConfig.envelopeFormat {
                if let dictUnwrapped = jsonDictionary[configObject.classInfo.jsonKey]! as? Dictionary<String, AnyObject> {
                    jsonFormatedDictionary = dictUnwrapped
                }
            }
            
            // 3a - NSManagedObject Parse & init
            if class_getSuperclass(objectClass) is NSManagedObject.Type {
                var managedObject = NSEntityDescription.insertNewObjectForEntityForName(NSStringFromClass(objectClass), inManagedObjectContext: EasyJsonConfig.managedObjectContext!) as NSManagedObject
                    
                for parameter in configObject.parameters {
                    managedObject.setProperty(parameter, fromJson: jsonFormatedDictionary)
                }
                return managedObject
            // 3b - CustomObject Parse & init
            } else if class_getSuperclass(objectClass) is EasyJsonWrapper.Type {
                var cobject : AnyObject! = EasyJsonClassFactory.initObjectFromClass(objectClass)
                (cobject as EasyJsonWrapper).childrenClassReference = objectClass
                    
                for parameter in configObject.parameters {
                    (cobject as EasyJsonWrapper).setParametersWith(parameter, fromJson: jsonFormatedDictionary)
                }
            }
        }
        return nil
    }
}
