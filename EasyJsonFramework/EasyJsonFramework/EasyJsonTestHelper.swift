//
//  EasyJsonTestHelper.swift
//  EasyJsonFramework
//
//  Created by christophe on 14/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

class EasyJsonTestHelper {
    
    
    
    
    func getMockJson() -> AnyObject[] {
        
        var filepaths = String[]()
        for bundle in NSBundle.allBundles() as NSBundle[] {
            
            println("LE BUNDLE EST LE SUIVANT : \(bundle)")
            let testBundle = bundle.bundlePath
            println("LE BUNDLE PATH EST LE SUIVANT : \(testBundle)")
            
            let fileEnumerator = NSFileManager.defaultManager().enumeratorAtPath(testBundle)
            
            while let filepath = fileEnumerator.nextObject() as? String {
                println("FIIIIIIIIICHIER \(filepath)")
                if (filepath.pathExtension == "plist") && (countElements(filepath) > 12) && (filepath.substringToIndex(12) == "EasyJsonMock") {
                    filepaths += "\(testBundle)/\(filepath)"
                }
            }
        }
        return filepaths
    }
    
}
