//
//  ClassFactory.h
//  EasyJson-Swift
//
//  Created by christophe on 12/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//
#import <objc/runtime.h>

@interface ClassFactory:NSObject

+ (id)initObjectFromClass:(Class)classObject;
+ (objc_property_t)getPropertyFor:(Class)objectClass andPropertyName:(NSString *)propertyName;

@end