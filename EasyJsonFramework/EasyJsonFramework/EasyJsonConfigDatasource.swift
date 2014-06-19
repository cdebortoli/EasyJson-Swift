//
//  EasyJsonConfigDatasource.swift
//  EasyJsonFramework
//
//  Created by christophe on 18/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

class EasyJsonConfigDatasource {
    var easyJsonObjects = EasyJsonObject[]()
    
    init() {
        easyJsonObjects = parseConfigObjectsFromConfigFile()
    }
    
    subscript(attributeType: String) -> EasyJsonObject? {
        get {
            return getConfigForType(attributeType)
        }
    }
    
    func getConfigForType(attributeType:String) -> EasyJsonObject? {
        for easyJsonObject in easyJsonObjects {
            if easyJsonObject.classInfo.attribute == attributeType {
                return easyJsonObject
            }
        }
        return nil
    }
    
    func parseConfigObjectsFromConfigFile() -> EasyJsonObject[] {
        var configObjects = EasyJsonObject[]()
        if let data = readConfigFile() {
            
            let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error:nil) as AnyObject[]
            
            for configOccurenceOpt : AnyObject in jsonArray {
                if let configOccurence = configOccurenceOpt as? NSDictionary {
                    
                    // Class
                    var configClass = configOccurence["class"]! as NSDictionary
                    let configClassAttribute = configClass["attribute"]! as String
                    let configClassJsonKey = configClass["json"]! as String
                    
                    var newClassInfo:EasyJsonObject.EasyJsonParameterObject = EasyJsonObject.EasyJsonParameterObject(attribute: configClassAttribute, jsonKey: configClassJsonKey)
                    var newEasyJsonObject = EasyJsonObject(classInfo: newClassInfo)
                    
                    // Attributes
                    for configParameter in configOccurence["parameters"]! as NSDictionary[] {
                        let parameterAttribute = configParameter["attribute"]! as String
                        let parameterJsonKey = configParameter["json"]! as String
                        var parameterType = configParameter["type"] as? String
                        
                        var newConfigParameter:EasyJsonObject.EasyJsonParameterObject = EasyJsonObject.EasyJsonParameterObject(attribute: parameterAttribute, jsonKey: parameterJsonKey, objectType: parameterType)
                        newEasyJsonObject.parameters += newConfigParameter
                    }
                    configObjects += newEasyJsonObject
                }
            }
        }
        
        return configObjects
    }
    
    func readConfigFile() -> NSData? {
        let configFilepath:String? = NSBundle.mainBundle().pathForResource("EasyJsonConfig", ofType: "json")
        if let filepath = configFilepath {
            var errorFilepath:NSError?
            return NSData.dataWithContentsOfFile(filepath, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &errorFilepath)
        }
        return nil
    }
}