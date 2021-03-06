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
    
    func testEasyJson() {
        
        EasyJsonTestHelper.checkMocksFromBundle(NSBundle(forClass: self.dynamicType), {(completion:(attributeValue: AnyObject?, attributeName: String)) -> () in
            if completion.attributeValue is NSSet {
                XCTAssert((completion.attributeValue as NSSet).count > 0, "Check relation : \(completion.attributeName)")
            } else {
                XCTAssertNotNil(completion.attributeValue, "Check attributeKey : \(completion.attributeName)")
            }
        })
        
        
    }
    
}
