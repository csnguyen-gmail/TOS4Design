//
//  OrderListVC.h
//  TOS4Design
//
//  Created by csnguyen on 2/20/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableModel.h"

@protocol OrderListVCDelegate <NSObject>
- (void)didSubmitTable:(TableModel*)table;
- (void)didChangeToTable:(TableModel*)table;
@end

@interface OrderListVC : UIViewController
@property (nonatomic, strong) TableModel *tableModel;
@property (nonatomic, weak) id<OrderListVCDelegate> delegate;
@end
