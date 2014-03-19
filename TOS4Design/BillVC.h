//
//  BillVC.h
//  TOS4Design
//
//  Created by csnguyen on 2/22/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableModel.h"

@protocol BillVCDelegate <NSObject>
- (void)didTapPrintBill;;
@end


@interface BillVC : UIViewController
@property (nonatomic, strong) TableModel *table;
@property (nonatomic, weak) id<BillVCDelegate> delegate;
@end
