//
//  Singleton.swift
//  EasyJson-Swift
//
//  Created by christophe on 09/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

let singleton = Singleton()

class Singleton {
    @lazy var databaseManagerSharedInstance = DatabaseManager()
}