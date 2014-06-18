//
//  ClassFactory.m
//  EasyJson-Swift
//
//  Created by christophe on 12/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyJsonClassFactory.h"

@implementation EasyJsonClassFactory
{
    
}

+ (id)initObjectFromClass:(Class)classObject
{
    return [[classObject alloc] init];
}

@end