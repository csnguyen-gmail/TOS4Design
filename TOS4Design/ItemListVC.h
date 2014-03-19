//
//  ItemListVC.h
//  TOS4Design
//
//  Created by csnguyen on 2/20/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"
@protocol ItemListVCDelegate <NSObject>
- (void)didSelectItem:(ItemModel*)itemModel;
@end


@interface ItemListVC : UIViewController
@property (nonatomic, weak) id<ItemListVCDelegate> delegate;
@property (nonatomic, strong) ItemModel *initialItem;
@end
