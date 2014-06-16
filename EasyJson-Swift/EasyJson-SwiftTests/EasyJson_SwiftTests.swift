//
//  EasyJson_SwiftTests.swift
//  EasyJson-SwiftTests
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import XCTest
import EasyJsonFramework

class EasyJson_SwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEasyJson() {
//        for parsedObject : AnyObject in EasyJsonTestHelper.getObjectParsed(NSBundle(forClass: self.classForCoder)) {
//            println("--------\(parsedObject)")
//            
//        }
        
        let parsedObjects = EasyJsonTestHelper.getObjectParsed(NSBundle(forClass: self.classForCoder))
        EasyJsonTestHelper.testParsedObjects(parsedObjects, {(completion:(attributeValue: AnyObject?, attributeName: String)[]) -> () in
           println("Test \(completion[0].attributeName) \(completion[0].attributeValue)")
        })
        
        
    }
    
}
