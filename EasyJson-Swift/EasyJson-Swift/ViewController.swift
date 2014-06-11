//
//  ViewController.swift
//  EasyJson-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()

        for object:EasyJsonObject in easyJsonSharedInstance.easyJsonDatasource.easyJsonObjects {
            println("------------------")
            println("Class Attribute \(object.classInfo.attribute)")
            println("Class json \(object.classInfo.jsonKey)")
            for parameter:EasyJsonObject.EasyJsonParameterObject in object.parameters {
                println("Parameter attribute \(parameter.attribute)")
                println("Parameter json \(parameter.jsonKey)")
                println("Parameter Type \(parameter.objectType)")
            }
        }

        let dict = loadService("aircraftJson")
        var a1:Aircraft? = easyJsonSharedInstance.analyzeJsonDictionary(dict, forClass:Aircraft.classForCoder()) as? Aircraft
        println(a1)
        
       var customObject:CustomObject? = easyJsonSharedInstance.analyzeJsonDictionary(dict, forClass: CustomObject.getClass()) as? CustomObject

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadService(service:String) -> Dictionary<String,AnyObject> {
        let filepath = NSBundle.mainBundle().pathForResource(service, ofType: "json")
        let filecontent = NSData.dataWithContentsOfFile(filepath, options: nil, error: nil)
        let json = NSJSONSerialization.JSONObjectWithData(filecontent, options: NSJSONReadingOptions.MutableContainers, error: nil) as Dictionary<String, AnyObject>
        return json
    }

}

