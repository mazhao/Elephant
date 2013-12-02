//
//  MZBookStoreDefault.m
//  Elephant
//
//  Created by mazhao on 13-11-28.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZBookStoreDefault.h"



/**
*  singleton instance - static instance variable
*/
static MZBookStoreDefault *instance = nil;


static NSString* kClientId = @"03fa8ef8efd9a4aa0befaceacf8cedfe";
static NSString* kClientSecret = @"ac6d5b2e28e4c0ce";

static NSString* kModelName = @"MZBookModel";
static NSString* kModelExtension = @"momd";
static NSString* kModelSqliteName = @"MZBookModel.sqlite";

@implementation MZBookStoreDefault


// --------------------------------------------------------------- //
// delegate call back
// !!! MUST manually synthesize properties defined in protocol !!!
@synthesize delegate =_delegate ;

// --------------------------------------------------------------- //
// singleton init
/**
 *  singleton instance - class method implementation
 *
 *  @param delegate MZBookShelfRefreshDelegate
 *
 *  @return single instance of MZBookStoreDefault
 */
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

// --------------------------------------------------------------- //
// core data context init

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;



// to check if book alread saved
-(BOOL) bookExist:(NSString *) isbn {
    
    return [self getBookSummary:isbn] != nil;
}

// add book to database.
// 1. fetch book from book.douban.com
// 2. save to book database
// 3. invoke delegate's refreshViewforNewBook
-(BOOL) fetchBook: (NSString*) isbn {
    
    NSLog(@"begin fetch book the input isbn is:%@", isbn);
    
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
            NSLog(@"error code: %d", [error code]);
            NSLog(@"error description: %@", [error description]);
        } else {
            NSString* json = [req responseString];
           // NSLog(@"response json string:\r\n%@", json);
            
            
            NSDictionary * bookDic =[json objectFromJSONString];
            MZBookModel * bookModel = [NSEntityDescription insertNewObjectForEntityForName:@"MZBookModel"
                                                                    inManagedObjectContext:self.managedObjectContext];
            if(bookModel) {
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
                for(NSDictionary * tagDic in tagSet) {
                    MZBookTagModel * tag = [NSEntityDescription insertNewObjectForEntityForName:@"MZBookTagModel"
                                                                         inManagedObjectContext:self.managedObjectContext];
                    tag.count = [tagDic objectForKey:@"count"];
                    tag.name = [tagDic objectForKey:@"name"];
                    tag.title = [tagDic objectForKey:@"title"];
                    
                    [tagSet addObject:tag];
                }
                [bookModel addTags:tagSet];
                
                NSError * savingError = nil;
                if ([self.managedObjectContext save:&savingError ] ) {
                    NSLog(@"successfully saved the context");
                    retVal = YES;
                    [self.delegate refreshViewforNewBook:bookModel];
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

//
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

-(MZBookModel *) getBookDetail: (NSString *) isbn {
    return [self getBookSummary:isbn];
}


// multiple books methods
/**
 *
 *
 *  @return Summary book store
 */
-(NSArray *) getAllBooksSummary {
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *bookModel = [NSEntityDescription entityForName:@"MZBookModel"
                                                 inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:bookModel];
    
    
    NSError * error = [[NSError alloc] init];
    NSArray * books = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    return books;    
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
NSURL *modelURL = [[NSBundle mainBundle] URLForResource: kModelName withExtension:kModelExtension];
_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
return _managedObjectModel;
}

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
if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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


@end
