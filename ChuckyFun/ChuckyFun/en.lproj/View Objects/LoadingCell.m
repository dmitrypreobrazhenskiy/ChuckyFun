//
//  LoadingCell.m
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 14.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import "LoadingCell.h"

@implementation LoadingCell
@synthesize loadLabel;

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

@end
