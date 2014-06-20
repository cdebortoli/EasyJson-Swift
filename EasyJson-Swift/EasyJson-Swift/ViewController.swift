//
//  ViewController.swift
//  EasyJson-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import UIKit
import EasyJsonFramework

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        EasyJsonConfig.jsonWithEnvelope = true
        EasyJsonConfig.dateFormat = "yyyy-MM-dd"
        EasyJsonConfig.managedObjectContext = databaseManagerSharedInstance.databaseCore.managedObjectContext

        let dict = dictionaryFromService("aircraftJsonWithEnvelope")
        var a1:Aircraft? = easyJsonSharedInstance.analyzeJsonDictionary(dict, forClass:Aircraft.classForCoder()) as? Aircraft
//        println(a1)
        
        let aircraftArray = arrayFromJson("aircraftsJsonWithEnvelope")
        var aircrafts = easyJsonSharedInstance.analyzeJsonArray(aircraftArray, forClass: Aircraft.classForCoder()) as Aircraft[]
        println(aircrafts)
        
//        let customObjectDict = dictionaryFromService("customObjectJson")
//        var customObject:CustomObject? = easyJsonSharedInstance.analyzeJsonDictionary(customObjectDict, forClass: CustomObject.self) as? CustomObject

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dictionaryFromService(service:String) -> Dictionary<String,AnyObject> {
        let filepath = NSBundle.mainBundle().pathForResource(service, ofType: "json")
        let filecontent = NSData.dataWithContentsOfFile(filepath, options: nil, error: nil)
        let json = NSJSONSerialization.JSONObjectWithData(filecontent, options: NSJSONReadingOptions.MutableContainers, error: nil) as Dictionary<String, AnyObject>
        return json
    }

    func arrayFromJson(service:String) -> AnyObject[] {
        let filepath = NSBundle.mainBundle().pathForResource(service, ofType: "json")
        let filecontent = NSData.dataWithContentsOfFile(filepath, options: nil, error: nil)
        let json = NSJSONSerialization.JSONObjectWithData(filecontent, options: NSJSONReadingOptions.MutableContainers, error: nil) as AnyObject[]
        return json
    }
}

