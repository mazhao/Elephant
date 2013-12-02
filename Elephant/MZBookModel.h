//
//  MZBookModel.h
//  Elephant
//
//  Created by mazhao on 13-12-2.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MZBookModel : NSManagedObject

@property (nonatomic, retain) NSString * isbn10;
@property (nonatomic, retain) NSString * isbn13;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * exerptCount;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * originTitle;
@property (nonatomic, retain) NSString * altTitle;
@property (nonatomic, retain) NSString * subTitle;
@property (nonatomic, retain) NSString * imagePathSmall;
@property (nonatomic, retain) NSString * imagePathMedium;
@property (nonatomic, retain) NSString * imagePathLarge;
@property (nonatomic, retain) NSString * publisher;
@property (nonatomic, retain) NSString * pubdate;
@property (nonatomic, retain) NSNumber * ratingMin;
@property (nonatomic, retain) NSNumber * ratingMax;
@property (nonatomic, retain) NSNumber * ratingAvg;
@property (nonatomic, retain) NSNumber * ratingCount;
@property (nonatomic, retain) NSString * binding;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * pages;
@property (nonatomic, retain) NSString * authorIntro;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSSet *authors;
@property (nonatomic, retain) NSSet *translators;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSSet *excerpts;
@end

@interface MZBookModel (CoreDataGeneratedAccessors)

- (void)addAuthorsObject:(NSManagedObject *)value;
- (void)removeAuthorsObject:(NSManagedObject *)value;
- (void)addAuthors:(NSSet *)values;
- (void)removeAuthors:(NSSet *)values;

- (void)addTranslatorsObject:(NSManagedObject *)value;
- (void)removeTranslatorsObject:(NSManagedObject *)value;
- (void)addTranslators:(NSSet *)values;
- (void)removeTranslators:(NSSet *)values;

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

- (void)addExcerptsObject:(NSManagedObject *)value;
- (void)removeExcerptsObject:(NSManagedObject *)value;
- (void)addExcerpts:(NSSet *)values;
- (void)removeExcerpts:(NSSet *)values;

@end
