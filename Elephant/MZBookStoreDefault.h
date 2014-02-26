//
//  MZBookStoreDefault.h
//  Elephant
//
//  Created by mazhao on 13-11-28.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "MZBookStoreAPI.h"  // must for protocol implementation

@interface MZBookStoreDefault : NSObject <MZBookStore>

+ (MZBookStoreDefault *)instance; // singleton instance

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@end
