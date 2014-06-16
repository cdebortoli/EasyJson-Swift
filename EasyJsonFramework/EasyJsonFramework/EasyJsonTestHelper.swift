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
        for object:AnyObject in objects {
            if NSStringFromClass(object.superclass()) == NSStringFromClass(NSManagedObject.classForCoder()) {

//                completion([(attributeValue:"tmp",attributeName:"tmp")])
            } else if NSStringFromClass(object.superclass()) == NSStringFromClass(EasyJsonWrapper.classForCoder()) {
//                TODO When SWIFT will manage get property of optionals
            }
        }
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
