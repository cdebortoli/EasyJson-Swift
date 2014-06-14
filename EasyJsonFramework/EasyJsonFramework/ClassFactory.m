//
//  ClassFactory.m
//  EasyJson-Swift
//
//  Created by christophe on 12/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassFactory.h"

@implementation ClassFactory
{
    
}

+ (id)initObjectFromClass:(Class)classObject
{
    return [[classObject alloc] init];
}

+ (objc_property_t)getPropertyFor:(Class)objectClass andPropertyName:(NSString *)propertyName
{
    objc_property_t propertyResult = nil;
    propertyResult = class_getProperty(objectClass, [propertyName UTF8String]);
    return propertyResult;
}
@end