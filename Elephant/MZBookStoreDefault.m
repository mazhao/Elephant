//
//  MZBookStoreDefault.m
//  Elephant
//
//  Created by mazhao on 13-11-28.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZBookStoreDefault.h"


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


/**
 *  singleton instance - static instance variable
 */
static MZBookStoreDefault *instance = nil;


static NSString* kClientId = @"03fa8ef8efd9a4aa0befaceacf8cedfe";
static NSString* kClientSecret = @"ac6d5b2e28e4c0ce";

static NSString* kModelName = @"MZBookModel";
static NSString* kModelExtension = @"momd";
static NSString* kModelSqliteName = @"MZBookModel.sqlite";


// each time to migrate
//static NSString* sourceVersion = @"";
//static NSString* targetVersion = @""; // 1_0_0

@implementation MZBookStoreDefault


- (NSString*)modelName {
    return kModelName;
}
- (NSString*)modelExtension {
    return kModelExtension;
}
- (NSString*)modelSqliteName {
    return kModelSqliteName;
}



// --------------------------------------------------------------- //
// delegate call back
// !!! MUST manually synthesize properties defined in protocol !!!
//@synthesize delegate =_delegate ;

// --------------------------------------------------------------- //
// singleton init
/**
 *  singleton instance - class method implementation
 *
 *  @param delegate MZBookShelfRefreshDelegate
 *
 *  @return single instance of MZBookStoreDefault
 */
/*
+(MZBookStoreDefault *) instance: (id<BookShelfRefreshDelegate> ) delegate {
    if(!instance) {
        instance = [[MZBookStoreDefault alloc] init];
        [instance setDelegate:delegate];
        
        
        DOUService * doubanService = [DOUService sharedInstance];
        doubanService.clientId = kClientId;
        doubanService.clientSecret = kClientSecret;
        if ([doubanService isValid]) {
            doubanService.apiBaseUrlString =  kHttpsApiBaseUrl;
        }
        else {
            doubanService.apiBaseUrlString = kHttpApiBaseUrl;
        }
        
    }
    
    return instance;
}
*/
+ (MZBookStoreDefault *)instance {
    if(!instance) {
        instance = [[MZBookStoreDefault alloc] init];

        DOUService * doubanService = [DOUService sharedInstance];
        doubanService.clientId = kClientId;
        doubanService.clientSecret = kClientSecret;
        if ([doubanService isValid]) {
            doubanService.apiBaseUrlString =  kHttpsApiBaseUrl;
        } else {
            doubanService.apiBaseUrlString = kHttpApiBaseUrl;
        }
    }
    return instance;
}

// --------------------------------------------------------------- //
// core data context init

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Book Section

/**
 *  Check book existance.
 *
 *  @param isbn isbn13 for book to be checked
 *
 *  @return YES for exist NO for not exist
 */
-(BOOL) bookExist:(NSString *) isbn {
    return [self getBookSummary:isbn] != nil;
}

/**
 *  convert book from NSDictionary to MZBookModel
 *
 *  @param bookDic   book NSDictionary
 *  @param bookModel MZBookModel
 */
- (void)convertDictionaryl:(NSDictionary *)bookDic toBookModel:(MZBookModel *)bookModel {
    bookModel.price = [bookDic objectForKey:@"price"];
    bookModel.summary = [bookDic objectForKey:@"summary"];
    bookModel.authorIntro = [bookDic objectForKey:@"author_intro"];
    bookModel.altTitle = [bookDic objectForKey:@"alt_title"];
    bookModel.url = [bookDic objectForKey:@"url"];
    bookModel.title = [bookDic objectForKey:@"title"];
    bookModel.isbn10 = [bookDic objectForKey:@"isbn10"];
    bookModel.isbn13 = [bookDic objectForKey:@"isbn13"];
    bookModel.publisher = [bookDic objectForKey:@"publisher"];
    bookModel.id = [bookDic objectForKey:@"id"];
    bookModel.alt = [bookDic objectForKey:@"alt"];
    
    bookModel.imagePathSmall = [((NSDictionary*)[bookDic objectForKey:@"images"]) objectForKey:@"small"];
    bookModel.imagePathMedium = [((NSDictionary*)[bookDic objectForKey:@"images"]) objectForKey:@"medium"];
    bookModel.imagePathLarge = [((NSDictionary*)[bookDic objectForKey:@"images"]) objectForKey:@"large"];
    bookModel.imagePath =[bookDic objectForKey:@"image"];
    
    bookModel.pages =[bookDic objectForKey:@"pages"];
    bookModel.catalog =[bookDic objectForKey:@"catalog"];
    
    bookModel.binding  =[bookDic objectForKey:@"binding"];
    bookModel.originTitle  =[bookDic objectForKey:@"origin_title"];
    
    bookModel.pubdate =[bookDic objectForKey:@"pubdate"];
    
    bookModel.subTitle =[bookDic objectForKey:@"subtitle"];
    
    
    bookModel.ratingMax = [((NSDictionary*)[bookDic objectForKey:@"rating"]) objectForKey:@"max"];
    bookModel.ratingMin = [((NSDictionary*)[bookDic objectForKey:@"rating"]) objectForKey:@"min"];
    bookModel.ratingAvg = [((NSDictionary*)[bookDic objectForKey:@"rating"]) objectForKey:@"average"];
    bookModel.ratingCount = [((NSDictionary*)[bookDic objectForKey:@"rating"]) objectForKey:@"numRaters"];
    
    
    NSArray * transferArray =[bookDic objectForKey:@"translator"];
    NSMutableSet * translatorSet = [[NSMutableSet alloc] init];
    for (NSString* translator in transferArray) {
        MZBookWriterModel * writer = [NSEntityDescription insertNewObjectForEntityForName:@"MZBookWriterModel"
                                                                   inManagedObjectContext:self.managedObjectContext];
        writer.name = translator;
        [translatorSet addObject: writer ];
    }
    [bookModel addTranslators:translatorSet];
    
    transferArray =[bookDic objectForKey:@"author"];
    NSMutableSet * authorSet = [[NSMutableSet alloc] init];
    for (NSString* translator in transferArray) {
        MZBookWriterModel* writer = [NSEntityDescription insertNewObjectForEntityForName:@"MZBookWriterModel"
                                                                  inManagedObjectContext:self.managedObjectContext];
        writer.name = translator;
        [authorSet addObject:writer];
    }
    [bookModel addAuthors:authorSet];
    
    transferArray = [bookDic objectForKey:@"tags"];
    NSMutableSet * tagSet = [[NSMutableSet alloc]init];
    for(NSDictionary * tagDic in transferArray) {
        MZBookTagModel * tag = [NSEntityDescription insertNewObjectForEntityForName:@"MZBookTagModel"
                                                             inManagedObjectContext:self.managedObjectContext];
        tag.count = [tagDic objectForKey:@"count"];
        tag.name = [tagDic objectForKey:@"name"];
        tag.title = [tagDic objectForKey:@"title"];
        
        [tagSet addObject:tag];
    }
    [bookModel addTags:tagSet];
    
    
    // add current date time
   NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
   [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    NSString * dateString = [formatter stringFromDate:[NSDate date]];
    bookModel.addDateTime = dateString;
}

/**
 *  add book to database.
 *  1. fetch book from book.douban.com
 *  2. save to book database
 *  3. invoke delegate's refreshViewforNewBook
 *
 *  @param isbn isbn of book to be fetched
 *
 *  @return YES for fetch success, NO for fetch failed
 */
-(BOOL) fetchBook: (NSString*) isbn {
    
    NSLog(@"begin fetch book, the input isbn is:%@", isbn);
    
    __block BOOL retVal = NO;
    // get book from douban book api then save it to the core data store
    
    // 1st: fetch
    
    DOUService * service = [DOUService sharedInstance];
    
    NSString *subPath = [NSString stringWithFormat:@"/v2/book/isbn/%@", isbn];
    DOUQuery *query = [[DOUQuery alloc] initWithSubPath:subPath parameters:nil];
    
    query.apiBaseUrlString = service.apiBaseUrlString;
    
    [service get:query callback:^(DOUHttpRequest * req) {
        NSError *error = [req doubanError];
        if(error) {
            NSLog(@"       error code: %ld", (long)[error code]);
            NSLog(@"error description: %@", [error description]);
        } else {
            NSString* json = [req responseString];
            
            NSDictionary * bookDic =[json objectFromJSONString];
            MZBookModel * bookModel = [NSEntityDescription insertNewObjectForEntityForName:@"MZBookModel"
                                                                    inManagedObjectContext:self.managedObjectContext];
            if(bookDic && bookModel) {
                NSLog(@"fetch book:%@", bookDic);
                [self convertDictionaryl:bookDic toBookModel:bookModel];
                
                NSError * savingError = nil;
                if ([self.managedObjectContext save:&savingError ] ) {
                    NSLog(@"successfully saved the context");
                    retVal = YES;
                    // [self.delegate refreshViewforNewBook:bookModel];
                    
                } else {
                    NSLog(@"failed to create the new person");
                }
            } else {
                NSLog(@"Can not create MZBookModel description");
            }
        }
    }];
    
    return retVal;
}


/**
 *  <#Description#>
 *
 *  @param isbn <#isbn description#>
 *
 *  @return <#return value description#>
 */
-(MZBookModel *) getBookSummary: (NSString *) isbn {
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *bookModel = [NSEntityDescription entityForName:@"MZBookModel"
                                                 inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:bookModel];
    
    NSString * propName = nil;
    
    if([isbn length] == 10) {
        propName = @"isbn10";
    } else {
        propName = @"isbn13";
    }
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"%K like %@", propName
                               , isbn]; // string value with like
    [request setPredicate:predicate];
    
    
    NSError * error = [[NSError alloc] init];
    NSArray * books = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if( books == nil || [books count] <= 0) {
        NSLog(@"get book failed");
        return nil;
    } else {
        NSLog(@"get book success");
        return [books objectAtIndex:0];
    }
    
    
    return nil;
}

/**
 *  <#Description#>
 *
 *  @param isbn <#isbn description#>
 *
 *  @return <#return value description#>
 */
-(MZBookModel *) getBookDetail: (NSString *) isbn {
    return [self getBookSummary:isbn];
}



/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
-(NSArray *) getAllBooksSummary {
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *bookModel = [NSEntityDescription entityForName:@"MZBookModel"
                                                 inManagedObjectContext:self.managedObjectContext];
    [request setEntity:bookModel];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"addDateTime" ascending:NO];
    [request setSortDescriptors: [NSArray arrayWithObject:sortByName]];
    
    NSError * error = [[NSError alloc] init];
    NSArray * books = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    // sort by last excerpt add date
    // @TODO:
    
    
    return books;
}

/**
 *  <#Description#>
 *
 *  @param isbn <#isbn description#>
 *
 *  @return <#return value description#>
 */
- (BOOL) deleteBook:(NSString*) isbn {
    MZBookModel * model = [self getBookDetail:isbn];
    [self.managedObjectContext deleteObject:model];
    
    NSError * error = nil;
    if ( ![self.managedObjectContext save: &error] ){
        NSLog(@"can not delete book with error code:%ld error message:%@", (long)error.code, error.debugDescription);
    }

    
    return YES;
}

#pragma mark - Excerpt Section

- (BOOL) saveExpert:(NSString *) excerpt withImageData:(NSData*) imgData ofBoook:(NSString*) isbn13 {
    
    NSLog(@"for book:%@ excerpt:%@", isbn13, excerpt);
    
    MZBookModel * bookModel = [self getBookDetail:isbn13];
    
    MZBookExcerptModel * excerptModel = [NSEntityDescription insertNewObjectForEntityForName:@"MZBookExcerptModel"
                                                                      inManagedObjectContext:self.managedObjectContext];
    
    excerptModel.text = excerpt;
    excerptModel.image = imgData;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    excerptModel.datetime = [formatter stringFromDate:[NSDate date]];
    
    [bookModel addExcerptsObject:excerptModel];
    
    NSError * error = nil;
    if ( ![self.managedObjectContext save: &error] ){
        NSLog(@"can not save excerpt with error code:%d error message:%@", error.code, error.debugDescription);
    }
    
    return YES;
}



- (BOOL) updateExpert:(NSString *) excerpt withImageData:(NSData *) imgData withExcerptId:(NSManagedObjectID *)objectID ofBoook:(NSString*) isbn13{
    MZBookModel * bookModel = [self getBookDetail:isbn13];
    
    for (MZBookExcerptModel * excerptModel in bookModel.excerpts) {
        if (objectID == [excerptModel objectID]) {
            excerptModel.text = excerpt;
            excerptModel.image = imgData;
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
            excerptModel.datetime = [formatter stringFromDate:[NSDate date]];
        }
    }
    
    NSError * error = nil;
    if ( ![self.managedObjectContext save: &error] ){
        NSLog(@"can not update excerpt with error code:%d error message:%@", error.code, error.debugDescription);
        return NO;
    }
    
    return YES;
    
}

- (BOOL) deleteExpert:(NSManagedObjectID *) objectID forBook:(NSString*) isbn13 {
    MZBookModel * bookModel = [self getBookDetail:isbn13];
    MZBookExcerptModel * tobeDeleteExcerptModel = nil;
    for (MZBookExcerptModel * excerptModel in bookModel.excerpts) {
        if (objectID == [excerptModel objectID]) {
            tobeDeleteExcerptModel = excerptModel;
        }
    }
    
    [bookModel removeExcerptsObject:tobeDeleteExcerptModel];
    
    NSError * error = nil;
    if ( ![self.managedObjectContext save: &error] ){
        NSLog(@"can not update excerpt with error code:%d and error message:%@", error.code, error.debugDescription);
        
        return NO;
    }
    
    
    return NO;
}


- (BOOL) deleteAllExpert:(NSString*) isbn  {
    MZBookModel * model = [self getBookDetail:isbn];
    
    [model removeExcerpts:model.excerpts];
    
    NSError * error = nil;
    if ( ![self.managedObjectContext save: &error] ){
        NSLog(@"can not delete book with error:%d and error message:%@", error.code, error.debugDescription);
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Core Data Stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
//    NSString * targetURL = [kModelName stringByAppendingString:targetVersion];
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource: kModelName withExtension:kModelExtension];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// !!!for migration only !!!
//- (NSManagedObjectModel *)managedObjectModelSource
//{
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    
//    NSString * sourceURL = [kModelName stringByAppendingString:sourceVersion];
//    
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource: sourceURL withExtension:kModelExtension];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kModelSqliteName];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


//- (BOOL)migrateStore:(NSURL *)storeURL toVersionTwoStore:(NSURL *)dstStoreURL error:(NSError **)outError {
//    
//    NSUrl * storeURL = 
//    
//    // Try to get an inferred mapping model.
//    NSMappingModel *mappingModel =
//    [NSMappingModel inferredMappingModelForSourceModel: [self managedObjectModelSource]
//                                      destinationModel:[self managedObjectModel] error:outError];
//    
//    // If Core Data cannot create an inferred mapping model, return NO.
//    if (!mappingModel) {
//        return NO;
//    }
//    
//    // Create a migration manager to perform the migration.
//    NSMigrationManager *manager = [[NSMigrationManager alloc]
//                                   initWithSourceModel:[self managedObjectModelSource] destinationModel:[self managedObjectModel]];
//    
//    BOOL success = [manager migrateStoreFromURL:storeURL type:NSSQLiteStoreType
//                                        options:nil withMappingModel:mappingModel toDestinationURL:dstStoreURL
//                                destinationType:NSSQLiteStoreType destinationOptions:nil error:outError];
//    
//    return success;
//}

@end
