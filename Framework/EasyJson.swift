//
//  EasyJson.swift
//  EasyJson-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

var easyJsonSharedInstance:EasyJson = EasyJson()

class EasyJson {
    
    // Properties
    let dateFormatter = NSDateFormatter()
    @lazy var easyJsonDatasource = EasyJsonConfigDatasource()
    
    // Init
    init() {
        dateFormatter.dateFormat = easyJsonDateFormat
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
            if easyJsonEnvelopeFormat {
                if let dictUnwrapped = jsonDictionary[configObject.classInfo.jsonKey]! as? Dictionary<String, AnyObject> {
                    jsonFormatedDictionary = dictUnwrapped
                }
            }

            // 3a - ManagedObject
            if class_getName(NSManagedObject.classForCoder()) == class_getName(class_getSuperclass(objectClass)) {
                var managedObject = NSEntityDescription.insertNewObjectForEntityForName(NSStringFromClass(objectClass), inManagedObjectContext: databaseManagerSharedInstance.databaseCore.managedObjectContext) as NSManagedObject
                
                for parameter in configObject.parameters {
                    managedObject.setPropertyWithEasyJsonParameter(parameter, fromJson: jsonFormatedDictionary)
                }
                return managedObject
            }
            
            // 3b - CustomObject
        }
        
        return nil
    }
    

}

extension NSManagedObject {
    func setPropertyWithEasyJsonParameter(parameter:EasyJsonObject.EasyJsonParameterObject, fromJson jsonDict:Dictionary<String, AnyObject>) {
        if jsonDict[parameter.jsonKey] != nil {
            
            if let managedObjectValue : AnyObject = getValueFromJson(jsonDict, withParameter: parameter) {
                setValue(managedObjectValue, forKey: parameter.attribute)
            }
        }
    }
    
    func getValueFromJson(jsonDict:Dictionary<String,AnyObject>, withParameter parameter:EasyJsonObject.EasyJsonParameterObject) -> AnyObject? {
        
        if let propertyDescription = self.getPropertyDescriptionForEasyJsonParameter(parameter) {
            
            if propertyDescription is NSAttributeDescription {
                
                if let jsonString = jsonDict[parameter.jsonKey]! as? String {
                    return (propertyDescription as NSAttributeDescription).getAttributeValueForEasyJsonValue(jsonString)
                }
                
            } else if propertyDescription is NSRelationshipDescription {
                
                if let jsonArray = jsonDict[parameter.jsonKey]! as? Dictionary<String, AnyObject>[] {
                    return (propertyDescription as NSRelationshipDescription).getRelationshipValueForEasyJsonArray(jsonArray)
                }
                
            }
        }
        return nil
    }
    
    func getPropertyDescriptionForEasyJsonParameter(parameter: EasyJsonObject.EasyJsonParameterObject) -> NSPropertyDescription? {
        if let propertyDescription = self.entity.propertiesByName[parameter.attribute] as? NSPropertyDescription {
            return propertyDescription
        }
        return nil
    }
  
}


extension NSAttributeDescription {
    func getAttributeValueForEasyJsonValue(jsonValue:String) -> AnyObject? {
        
        switch(self.attributeType){
            case .DateAttributeType:
                return easyJsonSharedInstance.dateFormatter.dateFromString(jsonValue)
            case .StringAttributeType:
                return jsonValue
            case .DecimalAttributeType,.DoubleAttributeType:
                return NSNumber.numberWithDouble((jsonValue as NSString).doubleValue)
            case .FloatAttributeType:
                return (jsonValue as NSString).floatValue
            case .Integer16AttributeType,.Integer32AttributeType,.Integer64AttributeType:
                return (jsonValue as NSString).integerValue
            case .BooleanAttributeType:
                return (jsonValue as NSString).boolValue
            default:
                return nil
        }
    }
}

extension NSRelationshipDescription {
    func getRelationshipValueForEasyJsonArray(jsonArray:Dictionary<String, AnyObject>[]) -> NSMutableSet {
        var relationshipSet = NSMutableSet()
        for jsonValue in jsonArray  {
            relationshipSet.addObject(easyJsonSharedInstance.analyzeJsonDictionary(jsonValue, forClass: NSClassFromString(self.destinationEntity.managedObjectClassName)))
        }
        return relationshipSet
    }
}


class EasyJsonConfigDatasource {
    var easyJsonObjects = EasyJsonObject[]()

    init() {
        easyJsonObjects = parseConfigObjectsFromConfigFile()
        println("EasyJsonConfigDatasource init")
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
