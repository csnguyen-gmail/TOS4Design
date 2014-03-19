//
//  KitchenCell.m
//  TOS4Design
//
//  Created by csnguyen on 2/24/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import "KitchenCell.h"
#import "OrderModel.h"
@interface KitchenCell()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end

@implementation KitchenCell

- (void)setTransaction:(OrderTransactionModel *)transaction {
    _transaction = transaction;
    [self.tableView reloadData];
    if (transaction.status == kOtsWait) {
        [self.submitBtn setTitle:@"Start cooking" forState:UIControlStateNormal];
    }
    else {
        [self.submitBtn setTitle:@"Finish" forState:UIControlStateNormal];
    }
}
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.transaction.orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"OrderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    OrderModel *order = self.transaction.orderList[indexPath.row];
    cell.textLabel.text = order.item.name;
    cell.detailTextLabel.text = [@(order.quantity) stringValue];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *date = [dateFormatter stringFromDate:self.transaction.lastUpdatedDate];
    return date;
}
-(void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass: [UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView* castView = (UITableViewHeaderFooterView*) view;
        castView.textLabel.textColor = [UIColor whiteColor];
        UIView* content = castView.contentView;
        content.backgroundColor = (self.transaction.status == kOtsWait) ? [UIColor blueColor] : [UIColor darkGrayColor];
    }
}
#pragma mark - Action handler
- (IBAction)submitTapped:(id)sender {
    [self.delegate didSubmitTransaction:self.transaction];
}

@end
