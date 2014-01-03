//
//  MZDetailCell.m
//  Elephant
//
//  Created by mazhao on 13-12-3.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZDetailCell.h"

@implementation MZDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize stageSize = self.contentView.bounds.size;
    self.backgroundView.frame = CGRectMake(10.0, 5.0, stageSize.width - 20.0, stageSize.height - 10.0);
    self.selectedBackgroundView.frame = CGRectMake(10.0, 5.0, stageSize.width - 20.0, stageSize.height - 10.0);
}


@end
