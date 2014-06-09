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
        
//        println(easyJsonSharedInstance.dateFormatter.dateFormat)
//        sleep(4)

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
//        var aircraft:Aircraft = NSEntityDescription.insertNewObjectForEntityForName("Aircraft", inManagedObjectContext: databaseManagerSharedInstance.databaseCore.managedObjectContext) as Aircraft
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

