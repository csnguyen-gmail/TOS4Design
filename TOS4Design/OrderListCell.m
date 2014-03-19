//
//  OrderListCell.m
//  TOS4Design
//
//  Created by csnguyen on 2/20/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import "OrderListCell.h"

@interface OrderListCell()

@end

@implementation OrderListCell

#pragma mark - action
- (IBAction)itemTapped:(UIButton*)sender {
    [self.delegate didTappedItemAtCell:self];
}

- (IBAction)quantityTapped:(UIButton*)sender {
    [self.delegate didTappedQuantityAtCell:self];
}

- (IBAction)takeawayTapped:(UISwitch*)sender {
    [self.delegate didChangeTakeaway:sender.on atCell:self];
}

- (IBAction)noteTapped:(UIButton*)sender {
    [self.delegate  didTappedNoteAtCell:self];
}

- (IBAction)deleteTapped:(UIButton*)sender {
    [self.delegate didTappedDeleteAtCell:self];
}

@end
