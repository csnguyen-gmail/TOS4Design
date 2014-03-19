//
//  ChangeTableVC.h
//  TOS4Design
//
//  Created by csnguyen on 2/23/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableModel.h"

@protocol ChangeTableVCDelegate <NSObject>
- (void)didSelectTable:(TableModel*)table;
@end


@interface ChangeTableVC : UIViewController
@property (nonatomic, weak) id<ChangeTableVCDelegate> delegate;
@property (nonatomic, strong) TableModel *initialTable;
@end
