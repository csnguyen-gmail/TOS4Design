//
//  DataController.m
//  TOS4Design
//
//  Created by csnguyen on 2/20/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import "DataController.h"
#import "OrderModel.h"
#import <stdlib.h>

@interface DataController()
@end

@implementation DataController

+ (NSArray *)getItemList {
    NSMutableArray *itemList;
    
    // DUMMY DATA
    itemList = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        ItemModel *model = [[ItemModel alloc] init];
        model.name = [NSString stringWithFormat:@"Item_%02d", i];
        model.price = (i + 1) * 10000;
        [itemList addObject:model];
    }
    return itemList;
}

+ (NSArray *)getTableList {
    // DUMMY DATA
    static NSMutableArray *sharedTableList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // DUMMY DATA
        sharedTableList = [NSMutableArray array];
        NSArray *itemList = [DataController getItemList];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        
        for (int i = 0; i < 10; i++) {
            TableModel *table = [[TableModel alloc] init];
            table.name = [NSString stringWithFormat:@"Table_%02d", i];
            
            if (i == 0) {
                
            }
            else if (i == 1) {
                table.orderTransactionList = [NSMutableArray array];
                
                OrderTransactionModel *orderTransaction = [[OrderTransactionModel alloc] init];
                orderTransaction.status = kOtsReady;
                orderTransaction.orderList = [NSMutableArray array];
                orderTransaction.lastUpdatedDate = [dateformatter dateFromString:@"24/02/2014 18:30:00"];
                for (int j = 0; j < 2; j++) {
                    OrderModel *order = [[OrderModel alloc] init];
                    order.quantity = arc4random() % 10 + 1;
                    order.takeAway = (j % 3);
                    order.note = (!(j % 2)) ? nil : @"This is note";
                    order.item = itemList[arc4random() % itemList.count];
                    [orderTransaction.orderList addObject:order];
                }
                [table.orderTransactionList addObject:orderTransaction];
            }
            else if (i == 2) {
                table.orderTransactionList = [NSMutableArray array];
                
                OrderTransactionModel *orderTransaction1 = [[OrderTransactionModel alloc] init];
                orderTransaction1.status = kOtsServed;
                orderTransaction1.orderList = [NSMutableArray array];
                orderTransaction1.lastUpdatedDate = [dateformatter dateFromString:@"24/02/2014 09:30:00"];
                for (int j = 0; j < 4; j++) {
                    OrderModel *order = [[OrderModel alloc] init];
                    order.quantity = arc4random() % 10 + 1;
                    order.takeAway = (j % 2);
                    order.note = (!(j % 3)) ? nil : @"This is note";
                    order.item = itemList[arc4random() % itemList.count];
                    [orderTransaction1.orderList addObject:order];
                }
                [table.orderTransactionList addObject:orderTransaction1];
                
                OrderTransactionModel *orderTransaction2 = [[OrderTransactionModel alloc] init];
                orderTransaction2.status = kOtsServed;
                orderTransaction2.orderList = [NSMutableArray array];
                orderTransaction2.lastUpdatedDate = [dateformatter dateFromString:@"24/02/2014 09:45:00"];
                for (int j = 0; j < 3; j++) {
                    OrderModel *order = [[OrderModel alloc] init];
                    order.quantity = arc4random() % 10 + 1;
                    order.takeAway = (j % 3);
                    order.note = (!(j % 2)) ? nil : @"This is note";
                    order.item = itemList[arc4random() % itemList.count];
                    [orderTransaction2.orderList addObject:order];
                }
                [table.orderTransactionList addObject:orderTransaction2];
            }
//            else {
//                table.orderTransactionList = [NSMutableArray array];
//                
//                OrderTransactionModel *orderTransaction = [[OrderTransactionModel alloc] init];
//                orderTransaction.status = kOtsWait;
//                orderTransaction.orderList = [NSMutableArray array];
//                orderTransaction.lastUpdatedDate = [NSDate date];
//                for (int j = 0; j < 20; j++) {
//                    OrderModel *order = [[OrderModel alloc] init];
//                    order.quantity = arc4random() % 10 + 1;
//                    order.takeAway = (j % 3);
//                    order.note = (!(j % 2)) ? nil : @"This is note";
//                    order.item = itemList[arc4random() % itemList.count];
//                    [orderTransaction.orderList addObject:order];
//                }
//                [table.orderTransactionList addObject:orderTransaction];
//            }
            
            [sharedTableList addObject:table];
        }
    });
    return sharedTableList;
}

+ (OrderTransactionModel*)insertNewTransactionToTable:(TableModel*)table {
    // DUMMY
    if (table.orderTransactionList == nil) {
        table.orderTransactionList = [NSMutableArray array];
    }
    
    OrderTransactionModel *transaction = [table.orderTransactionList lastObject];
    
    if ((transaction == nil) ||
        (transaction.status == kOtsServed) ||
        (transaction.status == kOtsReady) ||
        (transaction.status == kOtsCooking)) {
        transaction = [[OrderTransactionModel alloc] init];
        transaction.lastUpdatedDate = [NSDate date];
        transaction.status = kOtsNew;
        transaction.orderList = [NSMutableArray array];
        [table.orderTransactionList addObject:transaction];
    }
    else if (transaction.status == kOtsWait) {
        transaction.status = kOtsNew;
    }
   
    return transaction;
}

+ (void)submitTransaction:(OrderTransactionModel*)transaction {
    // DUMMY
    transaction.lastUpdatedDate = [NSDate date];
    transaction.status = kOtsWait;
    sleep(1);
}

+ (void)editTransaction:(OrderTransactionModel *)transaction {
    // DUMMY
    transaction.lastUpdatedDate = [NSDate date];
    transaction.status = kOtsNew;
    sleep(1);
}

+ (void)serveTransaction:(OrderTransactionModel*)transaction {
    // DUMMY
    transaction.lastUpdatedDate =[NSDate date];
    transaction.status = kOtsServed;
    sleep(1);
}

+ (void)printBillAtTable:(TableModel *)table {
    // DUMMY
    table.orderTransactionList = nil;
    sleep(1);
}

+ (void)changeFromTable:(TableModel *)fromTable toTable:(TableModel *)toTable {
    // DUMMY
    toTable.orderTransactionList = fromTable.orderTransactionList;
    fromTable.orderTransactionList = nil;
    sleep(1);
}

+(NSArray *)getWaitingOrderTransactionList {
    // DUMMY
    NSMutableArray *transactionList = [NSMutableArray array];
    NSArray *tableList = [DataController getTableList];
    
    for (TableModel *table in tableList) {
        for (OrderTransactionModel *transaction in table.orderTransactionList) {
            if ((transaction.status == kOtsWait) || (transaction.status == kOtsCooking)){
                [transactionList addObject:transaction];
            }
        }
    }
    
    [transactionList sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"lastUpdatedDate" ascending:YES]]];
    
    return transactionList;
}

+ (void)submitOrderTransaction:(OrderTransactionModel *)transaction {
    // DUMMY
    if (transaction.status == kOtsWait) {
        transaction.status = kOtsCooking;
    }
    else if (transaction.status == kOtsCooking) {
        transaction.status = kOtsReady;
    }
    sleep(1);
}
@end
