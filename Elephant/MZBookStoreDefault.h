//
//  MZBookStoreDefault.h
//  Elephant
//
//  Created by mazhao on 13-11-28.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

#import "MZBookStoreAPI.h"
#import "MZBook.h"
#import "MZBookModel.h"
#import "MZBookWriterModel.h"
#import "MZBookExcerptModel.h"
#import "MZBookTagModel.h"

@interface MZBookStoreDefault : NSObject <MZBookStore>

/**
 *  singleton instance - class method declaration
 */

+ (MZBookStoreDefault *)instance:(id <BookShelfRefreshDelegate>)delegate;

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator* persistentStoreCoordinator;


@end
