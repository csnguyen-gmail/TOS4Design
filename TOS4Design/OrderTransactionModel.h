//
//  OrderTransactionModel.h
//  TOS4Design
//
//  Created by csnguyen on 2/20/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum OrderTransactionStatus : NSUInteger {
    kOtsNew,
    kOtsWait,
    kOtsCooking,
    kOtsReady,
    kOtsServed
} OrderTransactionStatus;

@interface OrderTransactionModel : NSObject
@property (nonatomic, strong) NSDate *lastUpdatedDate;
@property (nonatomic, strong) NSMutableArray *orderList; // array of OrderModel
@property (nonatomic) OrderTransactionStatus status;
- (NSString*)stringStatus;
+ (NSString*)stringForStatus:(OrderTransactionStatus)status;
@end
