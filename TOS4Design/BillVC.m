//
//  BillVC.m
//  TOS4Design
//
//  Created by csnguyen on 2/22/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import "BillVC.h"
#import "OrderModel.h"

@interface BillVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* orders; // array of OrderModel
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (nonatomic) NSUInteger total;
@end

@implementation BillVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTable:(TableModel *)table {
    _table = table;
    self.total = 0;
    self.orders = [NSMutableArray array];
    for (OrderTransactionModel *transation in table.orderTransactionList) {
        for (OrderModel *order in transation.orderList) {
            // TODO: elimnate duplicate Order
            [self.orders addObject:order];
            self.total += order.item.price * order.quantity;
        }
    }
    [self.tableView reloadData];
}
- (IBAction)printBill:(id)sender {
    [self.delegate didTapPrintBill];
}

#pragma mark - table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count + 2; // plus footer & header
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"FirstCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UILabel *dateLbl = (UILabel*)[cell.contentView viewWithTag:100];
        dateLbl.text = [self.dateFormatter stringFromDate:[NSDate date]];
    }
    else if (indexPath.row == self.orders.count + 1) {
        static NSString *CellIdentifier = @"LastCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UILabel *sum = (UILabel*)[cell.contentView viewWithTag:100];
        sum.text = [self.numberFormatter stringFromNumber:@(self.total)];
    }
    else {
        static NSString *CellIdentifier = @"ContentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        OrderModel *order = self.orders[indexPath.row - 1];
        UILabel *itemLbl = (UILabel*)[cell.contentView viewWithTag:100];
        itemLbl.text = order.item.name;
        UILabel *priceLbl = (UILabel*)[cell.contentView viewWithTag:101];
        priceLbl.text = [self.numberFormatter stringFromNumber:@(order.item.price)];
        UILabel *quantityLbl = (UILabel*)[cell.contentView viewWithTag:102];
        quantityLbl.text = [self.numberFormatter stringFromNumber:@(order.quantity)];
        UILabel *totalLbl = (UILabel*)[cell.contentView viewWithTag:103];
        totalLbl.text = [self.numberFormatter stringFromNumber:@(order.item.price * order.quantity)];
    }
    
    return cell;
}
@end
