//
//  EasyJsonTestHelper.swift
//  EasyJsonFramework
//
//  Created by christophe on 14/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation
import CoreData

class EasyJsonTestHelper {
    
    
    // Return NSManagedObject and EasyJsonWrap object with data loaded from json mocks
    class func getObjectParsed(bundle:NSBundle) -> AnyObject[] {
        var objectsParsed = AnyObject[]()
        for mockFilepath in self.getMockJson(bundle) {

            // Mock Data
            var errorData:NSError?
            let mockData = NSData.dataWithContentsOfFile(mockFilepath, options: nil, error: &errorData)
            if errorData == nil {
            
                // Mock Json
                var errorJson:NSError?
                let jsonDictionary = NSJSONSerialization.JSONObjectWithData(mockData, options: NSJSONReadingOptions.MutableContainers, error: &errorJson) as Dictionary<String, AnyObject>
                if errorJson == nil {
                    
                    let mockJson:AnyObject = jsonDictionary["mock"]!
                    let mockClassStrOptional = jsonDictionary["class"]! as? String
                    let mockClass:AnyClass = NSClassFromString(mockClassStrOptional!)
                    
                    // Dictionary
                    if (mockJson is Dictionary<String, AnyObject>) {
                        var objectOptional:AnyObject? = easyJsonSharedInstance.analyzeJsonDictionary(mockJson as Dictionary<String, AnyObject>, forClass:mockClass)
                        if let object : AnyObject = objectOptional {
                            objectsParsed += object
                        }
                    // Array
                    } else if (mockJson is AnyObject[]) {
                        var objects = easyJsonSharedInstance.analyzeJsonArray(mockJson as AnyObject[], forClass: mockClass)
                        objectsParsed += objects
                    }
                }
                
            }
        }
        return objectsParsed
    }
    
    // For the specified managed objects, completion closure called with an array of tuple
    // Tuple = Value parsed if exist, and attribute name
    class func testParsedObjects(objects:AnyObject[], completion: ((attributeValue:AnyObject?, attributeName:String)[]) -> ())
    {
        var completionArray:(attributeValue:AnyObject?, attributeName:String)[] = []
        
        for object:AnyObject in objects {
            // NSManagedObject
            if object.superclass() is NSManagedObject.Type {
                
                if let configObject = easyJsonSharedInstance.easyJsonDatasource[NSStringFromClass(object.classForCoder)] {
                    for parameter in configObject.parameters {
                
                        if let objectProperty = (object as NSManagedObject).getPropertyDescription(parameter) {
                            var completionTuple:(attributeValue:AnyObject?, attributeName:String)
                            completionTuple.attributeValue = nil
                            if let valueObject:AnyObject = (object as? NSManagedObject)?.valueForKey(parameter.attribute) {
                                completionTuple.attributeValue = valueObject
                            }
                            completionTuple.attributeName = parameter.attribute
                            completionArray += completionTuple
                        }
                        
                    }
                }
            // EasyJsonWrapper
            } else if object.superclass() is EasyJsonWrapper.Type {
                //                TODO When SWIFT will manage get property of optionals
            }
        }
        completion(completionArray)
    }
    
    // Search the mock files
    class func getMockJson(bundle:NSBundle) -> String[] {
        
        var filepaths = String[]()
        let testBundle = bundle.bundlePath
        let fileEnumerator = NSFileManager.defaultManager().enumeratorAtPath(testBundle)
            
        while let filepath = fileEnumerator.nextObject() as? String {
            if (filepath.pathExtension == "json") && (countElements(filepath) > 12) && (filepath.substringToIndex(12) == "EasyJsonMock") {
                filepaths += "\(testBundle)/\(filepath)"
            }
        }
        return filepaths
    }
    
}
