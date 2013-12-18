//
//  MZBookStoreDefault.h
//  Elephant
//
//  Created by mazhao on 13-11-28.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

// output api header
#import "MZBookStoreAPI.h"

// dto & core data model header
#import "MZBookModel.h"
#import "MZBookWriterModel.h"
#import "MZBookExcerptModel.h"
#import "MZBookTagModel.h"

// douban header
#import <libDoubanApiEngine/DOUService.h>
#import <libDoubanApiEngine/DOUQuery.h>
#import <libDoubanApiEngine/DOUHttpRequest.h>
#import <libDoubanApiEngine/DOUAPIConfig.h>

// json kit
#import "JSONKit.h"


@interface MZBookStoreDefault : NSObject <MZBookStore>

/**
 *  singleton instance - class method declaration
 */

// + (MZBookStoreDefault *)instance:(id <BookShelfRefreshDelegate>)delegate;


+ (MZBookStoreDefault *)instance;


@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator* persistentStoreCoordinator;



@end
