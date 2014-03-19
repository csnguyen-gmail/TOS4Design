//
//  DataController.h
//  TOS4Design
//
//  Created by csnguyen on 2/20/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableModel.h"
#import "ItemModel.h"
#import "OrderModel.h"
#import "OrderTransactionModel.h"

@interface DataController : NSObject
+ (NSArray*)getTableList; // return array of TableModel
+ (NSArray*)getItemList; // return array of ItemList
+ (OrderTransactionModel*)insertNewTransactionToTable:(TableModel*)table;
+ (void)submitTransaction:(OrderTransactionModel*)transaction;
+ (void)editTransaction:(OrderTransactionModel*)transaction;
+ (void)serveTransaction:(OrderTransactionModel*)transaction;
+ (void)printBillAtTable:(TableModel*)table;
+ (void)changeFromTable:(TableModel*)fromTable toTable:(TableModel*)toTable;
+ (NSArray*)getWaitingOrderTransactionList; // return array of OrderTransactionModel
+ (void)submitOrderTransaction:(OrderTransactionModel*)transaction;
@end
