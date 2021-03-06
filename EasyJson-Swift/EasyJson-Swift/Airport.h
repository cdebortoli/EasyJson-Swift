//
//  Airport.h
//  EasyJson-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Aircraft;

@interface Airport : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * primaryKey;
@property (nonatomic, retain) NSSet *aircrafts;
@end

@interface Airport (CoreDataGeneratedAccessors)

- (void)addAircraftsObject:(Aircraft *)value;
- (void)removeAircraftsObject:(Aircraft *)value;
- (void)addAircrafts:(NSSet *)values;
- (void)removeAircrafts:(NSSet *)values;

@end
