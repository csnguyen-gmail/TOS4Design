//
//  OrderListCell.h
//  TOS4Design
//
//  Created by csnguyen on 2/20/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@protocol OrderListCellDelegate <NSObject>
- (void)didTappedItemAtCell:(UITableViewCell*)cell;
- (void)didTappedQuantityAtCell:(UITableViewCell*)cell;
- (void)didChangeTakeaway:(bool)takeaway atCell:(UITableViewCell*)cell;
- (void)didTappedNoteAtCell:(UITableViewCell*)cell;
- (void)didTappedDeleteAtCell:(UITableViewCell*)cell;
@end

@interface OrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIButton *quantityBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalLbl;
@property (weak, nonatomic) IBOutlet UISwitch *takeawaySwitch;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) id<OrderListCellDelegate> delegate;
@end
