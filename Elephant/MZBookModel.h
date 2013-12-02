//
//  MZBookModel.h
//  Elephant
//
//  Created by mazhao on 13-12-2.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MZBookExcerptModel, MZBookTagModel, MZBookWriterModel;

@interface MZBookModel : NSManagedObject

@property (nonatomic, retain) NSString * isbn10;
@property (nonatomic, retain) NSString * isbn13;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSNumber * exerptCount;
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
@property (nonatomic, retain) NSString * ratingAvg;
@property (nonatomic, retain) NSNumber * ratingCount;
@property (nonatomic, retain) NSString * binding;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * pages;
@property (nonatomic, retain) NSString * authorIntro;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * alt;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * catalog;
@property (nonatomic, retain) NSSet *authors;
@property (nonatomic, retain) NSSet *translators;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSSet *excerpts;
@end

@interface MZBookModel (CoreDataGeneratedAccessors)

- (void)addAuthorsObject:(MZBookWriterModel *)value;
- (void)removeAuthorsObject:(MZBookWriterModel *)value;
- (void)addAuthors:(NSSet *)values;
- (void)removeAuthors:(NSSet *)values;

- (void)addTranslatorsObject:(MZBookWriterModel *)value;
- (void)removeTranslatorsObject:(MZBookWriterModel *)value;
- (void)addTranslators:(NSSet *)values;
- (void)removeTranslators:(NSSet *)values;

- (void)addTagsObject:(MZBookTagModel *)value;
- (void)removeTagsObject:(MZBookTagModel *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

- (void)addExcerptsObject:(MZBookExcerptModel *)value;
- (void)removeExcerptsObject:(MZBookExcerptModel *)value;
- (void)addExcerpts:(NSSet *)values;
- (void)removeExcerpts:(NSSet *)values;

@end
