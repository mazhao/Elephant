//
//  MZDetailCell.h
//  Elephant
//
//  Created by mazhao on 13-12-3.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface MZDetailCell : UITableViewCell


@property (retain, nonatomic) IBOutlet UILabel * excerptLabel;
@property (retain, nonatomic) IBOutlet UILabel * dateTimeLabel;

@property (retain, nonatomic) IBOutlet UIImageView * imageViewId;

@property (retain, nonatomic) NSManagedObjectID * objectID;

@end
