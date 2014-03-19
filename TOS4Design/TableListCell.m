//
//  TableListCell.m
//  TOS4Design
//
//  Created by csnguyen on 2/19/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import "TableListCell.h"

@implementation TableListCell

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
