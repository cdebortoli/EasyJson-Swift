//
//  EasyJsonManagedObjectExtension.swift
//  EasyJsonFramework
//
//  Created by christophe on 18/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation


extension NSManagedObject {
    
    // Set property value
    func setProperty(easyJsonParameter:EasyJsonObject.EasyJsonParameterObject, fromJson jsonDict:Dictionary<String, AnyObject>) {
        if jsonDict[easyJsonParameter.jsonKey] != nil {
            if let managedObjectValue : AnyObject = getValue(easyJsonParameter, fromJsonDictionary: jsonDict) {
                setValue(managedObjectValue, forKey: easyJsonParameter.attribute)
            }
        }
    }
    
    // Get NSPropertyDescription
    func getPropertyDescription(easyJsonParameter:EasyJsonObject.EasyJsonParameterObject) -> NSPropertyDescription? {
        if let propertyDescription = self.entity.propertiesByName[easyJsonParameter.attribute] as? NSPropertyDescription {
            return propertyDescription
        }
        return nil
    }
    
    // Retrieve formated property value from json
    func getValue(easyJsonParameter:EasyJsonObject.EasyJsonParameterObject, fromJsonDictionary jsonDict:Dictionary<String, AnyObject>) -> AnyObject? {
        
        // Property Description
        var propertyDescriptionOptional = getPropertyDescription(easyJsonParameter) as NSPropertyDescription?
        
        // Get formated property value
        if let propertyDescription = propertyDescriptionOptional {
            if propertyDescription is NSAttributeDescription {

                if let jsonString = jsonDict[easyJsonParameter.jsonKey]! as? String {
                    return (propertyDescription as NSAttributeDescription).getAttributeValueForEasyJsonValue(jsonString)
                } else if let jsonNumber = jsonDict[easyJsonParameter.jsonKey]! as? NSNumber {
                    let jsonString = "\(jsonNumber)"
                    return (propertyDescription as NSAttributeDescription).getAttributeValueForEasyJsonValue(jsonString)
                }
                
            } else if propertyDescription is NSRelationshipDescription {

                if let jsonArray = jsonDict[easyJsonParameter.jsonKey]! as? Dictionary<String, AnyObject>[] {
                    return (propertyDescription as NSRelationshipDescription).getRelationshipValueForEasyJsonArray(jsonArray)
                } else if let jsonDictRelation = jsonDict[easyJsonParameter.jsonKey]! as? Dictionary<String, AnyObject> {
                    return easyJsonSharedInstance.analyzeJsonDictionary(jsonDictRelation, forClass: NSClassFromString((propertyDescription as NSRelationshipDescription).destinationEntity.managedObjectClassName))
                }
                
            }
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