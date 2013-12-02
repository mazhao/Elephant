//
//  MZBook.h
//  Elephant
//
//  Created by mazhao on 13-11-28.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZBookSummary.h"

@interface MZBook : MZBookSummary

    // isbn  !!! move to parent class !!!
    //@property NSString * isbn10;
    //@property NSString * isbn13;

    // title
    @property NSString * title;
    @property NSString * originTitle;
    @property NSString * altTitle;
    @property NSString * subTitle;

    // image path
    // !!! move to parent class !!!
    //@property NSString * imagePath;

    @property NSString * imagePathSmall;
    @property NSString * imagePathMedium;
    @property NSString * imagePathLarge;

    // author & translator name array
    @property NSArray * authors;
    @property NSArray * translators;

    // publisher
    @property NSString * publisher;
    @property NSString * pubdate;

    // rating
    @property NSNumber * ratingMin;
    @property NSNumber * ratingMax;
    @property NSNumber * ratingAvg;
    @property NSNumber * ratingCount;

    // tags
    // { tagName => tagBookCount }
    @property NSDictionary * tags;

    // binding
    // 平装、精装
    @property NSString * binding;

    @property NSNumber * price;
    @property NSNumber * pages;

    // long descriptions

    @property NSString * authorIntro;
    @property NSString * summary;


@end
