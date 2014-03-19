//
//  TableListVC.h
//  TOS4Design
//
//  Created by csnguyen on 2/19/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableModel.h"

@protocol TableListVCDelegate <NSObject>
- (void)didSelectTable:(TableModel*)model;
@end

@interface TableListVC : UIViewController
@property (weak, nonatomic)id<TableListVCDelegate> delegate;
- (void)selectTableAtRow:(NSUInteger)row;
- (void)refreshTable:(TableModel*)table;
- (void)selectTable:(TableModel*)table;
@end
