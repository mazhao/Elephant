//
//  MHWCoreDataController.h
//  BookMigration
//
//  Created by Martin Hwasser on 8/26/13.
//  Copyright (c) 2013 Martin Hwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHWMigrationManager.h"

@interface MHWCoreDataController : NSObject <MHWMigrationManagerDelegate>


/**
 * singleton instance 方法
 */
+ (MHWCoreDataController *)sharedInstance;

//- (BOOL)isMigrationNeeded;
//- (BOOL)migrate:(NSError *__autoreleasing *)error;



/**
 * 判断现有CoreData数据（storeURL & storeType）根据新的模型（newModel），是否需要迁移。
 */
- (BOOL)isMigrationNeededOfStoreURL:(NSURL*) storeURL ofType:(NSString*)storeType forNewModel:(NSManagedObjectModel*) newModel;

/**
 * 把现有CoreData数据（storeURL & storeType）按照新的模型（newModel）迁移。
 */

- (BOOL)migrateOfStoreURL:(NSURL*) storeURL ofType:(NSString*)storeType forNewModel:(NSManagedObjectModel*) newModel ifError: (NSError *__autoreleasing *)error;



//- (NSURL *)sourceStoreURL;

//@property (nonatomic, readonly, strong) NSManagedObjectModel *managedObjectModel;
//@property (nonatomic, readonly, strong) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
