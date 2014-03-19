//
//  OrderModel.h
//  TOS4Design
//
//  Created by csnguyen on 2/20/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemModel.h"

@interface OrderModel : NSObject
@property (nonatomic, strong) ItemModel *item;
@property (nonatomic) NSUInteger quantity;
@property (nonatomic) bool takeAway;
@property (nonatomic) NSString *note;
@end
