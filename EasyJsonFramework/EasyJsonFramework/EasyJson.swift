//
//  EasyJson.swift
//  EasyJson-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

let easyJsonSharedInstance = EasyJson()

// ------ EasyJson ------
class EasyJson {
    
    // Properties
    let dateFormatter = NSDateFormatter()
    @lazy var easyJsonDatasource = EasyJsonConfigDatasource()
    
    // Init
    init() {
        dateFormatter.dateFormat = EasyJsonConfig.dateFormat
        println("EasyJson init")
    }
    
    // Analyze methods
    func analyzeJsonArray(jsonArray:AnyObject[], forClass objectClass:AnyClass) -> AnyObject[] {
        var resultArray = AnyObject[]()
        return resultArray
    }
    
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
            
            // 3 - Parse & init
            if class_getSuperclass(objectClass) is NSManagedObject.Type {
                var managedObject = NSEntityDescription.insertNewObjectForEntityForName(NSStringFromClass(objectClass), inManagedObjectContext: EasyJsonConfig.managedObjectContext!) as NSManagedObject
                    
                for parameter in configObject.parameters {
                    managedObject.setPropertyWithEasyJsonParameter(parameter, fromJson: jsonFormatedDictionary)
                }
                return managedObject
            // 3b - CustomObject
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

// ------ ConfigDatasource ------

