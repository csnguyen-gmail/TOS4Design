//
//  TableModel.h
//  TOS4Design
//
//  Created by csnguyen on 2/19/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderTransactionModel.h"

@interface TableModel : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *orderTransactionList; // array of OrderTransactionModel
@end
