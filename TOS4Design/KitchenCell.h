//
//  KitchenCell.h
//  TOS4Design
//
//  Created by csnguyen on 2/24/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderTransactionModel.h"

@protocol KitchenCellDelegate <NSObject>
- (void)didSubmitTransaction:(OrderTransactionModel*)transaction;
@end

@interface KitchenCell : UICollectionViewCell
@property (nonatomic, strong) OrderTransactionModel *transaction;
@property (nonatomic, weak) id<KitchenCellDelegate> delegate;
@end
