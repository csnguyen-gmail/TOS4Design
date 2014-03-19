//
//  OrderTransactionModel.m
//  TOS4Design
//
//  Created by csnguyen on 2/20/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import "OrderTransactionModel.h"

@implementation OrderTransactionModel
+ (NSString*)stringForStatus:(OrderTransactionStatus)status {
    NSString *result;
    
    if (status == kOtsNew) {
        result = @"New";
    }
    if (status == kOtsWait) {
        result = @"Wait for cooking";
    }
    else if (status == kOtsCooking) {
        result = @"Cooking";
    }
    else if (status == kOtsReady) {
        result = @"Ready to serve";
    }
    else if (status == kOtsServed) {
        result = @"Served";
    }
    
    return result;
}
- (NSString *)stringStatus {
    return [OrderTransactionModel stringForStatus:self.status];
}
@end
