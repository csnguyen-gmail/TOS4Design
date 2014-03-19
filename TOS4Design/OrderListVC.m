//
//  OrderListVC.m
//  TOS4Design
//
//  Created by csnguyen on 2/20/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import "OrderListVC.h"
#import "OrderListCell.h"
#import "OrderModel.h"
#import "ItemListVC.h"
#import "QuantityListVC.h"
#import "NoteInputVC.h"
#import "DataController.h"
#import "BillVC.h"
#import "ChangeTableVC.h"

@interface OrderListVC ()<UITableViewDelegate, UITableViewDataSource, OrderListCellDelegate, ItemListVCDelegate, QuantityListVCDelegate, NoteInputVCDelegate, BillVCDelegate, ChangeTableVCDelegate>
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *changeTableBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishOrderBtn;
@property (nonatomic, weak) UIPopoverController* recentPopover;
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) OrderModel *selectedOrder;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicationView;
@end

@implementation OrderListVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [self refreshTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refreshTable {
    [self.tableView reloadData];
    
    OrderTransactionModel *lastTransation = [self.tableModel.orderTransactionList lastObject];
    if (lastTransation.orderList.count == 0) {
        self.finishOrderBtn.enabled = NO;
        self.changeTableBtn.enabled = NO;
    }
    else {
        self.finishOrderBtn.enabled = YES;
        self.changeTableBtn.enabled = YES;
        for (OrderTransactionModel *trans in self.tableModel.orderTransactionList) {
            if (trans.status != kOtsServed) {
                self.finishOrderBtn.enabled = NO;
                break;
            }
        }
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"itemSelectionPopover"]) {
        self.recentPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
        ItemListVC *itemVC = segue.destinationViewController;
        itemVC.initialItem = self.selectedOrder.item;
        itemVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"quantitySelectionPopover"]) {
        self.recentPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
        QuantityListVC *quantityVC = segue.destinationViewController;
        quantityVC.initialQuantity = self.selectedOrder.quantity;
        quantityVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"noteInputPopover"]) {
        self.recentPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
        NoteInputVC *noteInputVC = segue.destinationViewController;
        noteInputVC.initialNote = self.selectedOrder.note;
        noteInputVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"billPopover"]) {
        self.recentPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
        BillVC *billVC = segue.destinationViewController;
        billVC.table = self.tableModel;
        billVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"changeTablePopover"]) {
        self.recentPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
        ChangeTableVC *changeTableVC = segue.destinationViewController;
        changeTableVC.initialTable = self.tableModel;
        changeTableVC.delegate = self;
    }
}
#pragma mark - setter getter
- (void)setTableModel:(TableModel *)tableModel {
    _tableModel = tableModel;
    self.title = tableModel.name;
    [self refreshTable];
}
- (void)setSelectedIndex:(NSIndexPath *)selectedIndex {
    _selectedIndex = selectedIndex;
    if (_selectedIndex == nil) {
        self.selectedOrder = nil;
        return;
    }
    OrderTransactionModel *orderTransactionModel = self.tableModel.orderTransactionList[self.selectedIndex.section];
    self.selectedOrder = orderTransactionModel.orderList[self.selectedIndex.row];
}
#pragma mark - Transaction process
- (void)processTransaction:(void (^)(void))block {
    [self.indicationView startAnimating];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        block();
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.indicationView stopAnimating];
            [self refreshTable];
            [self.delegate didSubmitTable:self.tableModel];
        }];
    }];
}
- (void)submitTransaction {
    [self processTransaction:^{
        [DataController submitTransaction:[self.tableModel.orderTransactionList lastObject]];
        // TODO
    }];
}
- (void)editTransaction {
    [self processTransaction:^{
        [DataController editTransaction:[self.tableModel.orderTransactionList lastObject]];
        // TODO
    }];
}
- (void)serveTransaction {
    [self processTransaction:^{
        [DataController serveTransaction:[self.tableModel.orderTransactionList lastObject]];
        // TODO
    }];
}
- (IBAction)addOrder:(id)sender {
    OrderTransactionModel *transaction = [DataController insertNewTransactionToTable:self.tableModel];
    OrderModel *order = [[OrderModel alloc] init];
    order.quantity = 1;
    order.takeAway = NO;
    order.note = nil;
    order.item = [DataController getItemList][0];
    [transaction.orderList addObject:order];
    [self refreshTable];
}
#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableModel.orderTransactionList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OrderTransactionModel *orderTransactionModel = self.tableModel.orderTransactionList[section];
    bool haveFooter = (orderTransactionModel.orderList.count != 0) && (orderTransactionModel.status != kOtsServed) && (orderTransactionModel.status != kOtsCooking);
    return orderTransactionModel.orderList.count + (haveFooter ? 1 : 0); // add footer row
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    OrderTransactionModel *orderTransactionModel = self.tableModel.orderTransactionList[section];
    if (orderTransactionModel.orderList.count == 0) {
        return nil;
    }
    NSString *date = [self.dateFormatter stringFromDate:orderTransactionModel.lastUpdatedDate];
    NSString *status = [orderTransactionModel stringStatus];
    
    return [NSString stringWithFormat:@"%@ - %@", date, status];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderTransactionModel *orderTransactionModel = self.tableModel.orderTransactionList[indexPath.section];
    // footer cell
    if (indexPath.row == orderTransactionModel.orderList.count) {
        static NSString *CellIdentifier = @"FooterCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UIButton *button = (UIButton*)[cell.contentView viewWithTag:100];
        
        if (orderTransactionModel.status == kOtsNew) {
            [button setTitle:@"Submit" forState:UIControlStateNormal];
            [button removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(submitTransaction) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (orderTransactionModel.status == kOtsWait) {
            [button setTitle:@"Edit" forState:UIControlStateNormal];
            [button removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(editTransaction) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (orderTransactionModel.status == kOtsReady) {
            [button setTitle:@"Serve" forState:UIControlStateNormal];
            [button removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(serveTransaction) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }
    
    // normal cell
    static NSString *CellIdentifier = @"OrderCell";
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    OrderModel *orderModel = orderTransactionModel.orderList[indexPath.row];
    ItemModel *itemModel = orderModel.item;
    
    cell.delegate = self;
    [cell.nameBtn setTitle:itemModel.name forState:UIControlStateNormal];
    [cell.quantityBtn setTitle:[self.numberFormatter stringFromNumber:@(orderModel.quantity)] forState:UIControlStateNormal];
    cell.priceLbl.text = [self.numberFormatter stringFromNumber:@(itemModel.price)];
    cell.totalLbl.text = [self.numberFormatter stringFromNumber:@(orderModel.quantity * itemModel.price)];
    cell.takeawaySwitch.on = orderModel.takeAway;
    cell.noteBtn.tintColor = (orderModel.note.length != 0) ? nil : [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.1];
    
    bool enable = (orderTransactionModel.status == kOtsNew);
    cell.nameBtn.enabled = enable;
    cell.quantityBtn.enabled = enable;
    cell.takeawaySwitch.enabled = enable;
    cell.noteBtn.enabled = enable;
    cell.deleteBtn.enabled = enable;

    return cell;
}
#pragma mark - OrderListCellDelegate
- (void)didTappedItemAtCell:(UITableViewCell*)cell {
    self.selectedIndex = [self.tableView indexPathForCell:cell];
    [self performSegueWithIdentifier:@"itemSelectionPopover" sender:self];
}
- (void)didTappedQuantityAtCell:(UITableViewCell*)cell {
    self.selectedIndex = [self.tableView indexPathForCell:cell];
    [self performSegueWithIdentifier:@"quantitySelectionPopover" sender:self];
}
- (void)didChangeTakeaway:(bool)takeaway atCell:(UITableViewCell*)cell {
    self.selectedIndex = [self.tableView indexPathForCell:cell];
    self.selectedOrder.takeAway = takeaway;
}
- (void)didTappedNoteAtCell:(UITableViewCell*)cell {
    self.selectedIndex = [self.tableView indexPathForCell:cell];
    [self performSegueWithIdentifier:@"noteInputPopover" sender:self];
}
- (void)didTappedDeleteAtCell:(UITableViewCell*)cell {
    self.selectedIndex = [self.tableView indexPathForCell:cell];
    OrderTransactionModel *transaction = self.tableModel.orderTransactionList[self.selectedIndex.section];
    [transaction.orderList removeObject:self.selectedOrder];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.selectedIndex.section]
                  withRowAnimation:UITableViewRowAnimationFade];
    self.selectedIndex = nil;
}
#pragma mark - ItemListVCDelegate
- (void)didSelectItem:(ItemModel *)itemModel {
    [self.recentPopover dismissPopoverAnimated:YES];
    self.selectedOrder.item = itemModel;
    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndex] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - QuantityListVCDelegate
- (void)didSelectQuantity:(NSUInteger)quantity {
    [self.recentPopover dismissPopoverAnimated:YES];
    self.selectedOrder.quantity = quantity;
    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndex] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - NoteInputVCDelegate
- (void)didInputNote:(NSString *)note {
    [self.recentPopover dismissPopoverAnimated:YES];
    self.selectedOrder.note = note;
    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndex] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - BillVCDelegate
- (void)didTapPrintBill {
    [self.recentPopover dismissPopoverAnimated:YES];
    [self processTransaction:^{
        [DataController printBillAtTable:self.tableModel];
    }];
}
#pragma mark - ChangeTableVCDelegate
- (void)didSelectTable:(TableModel *)table {
    [self.recentPopover dismissPopoverAnimated:YES];
    [self processTransaction:^{
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            [DataController changeFromTable:self.tableModel toTable:table];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.indicationView stopAnimating];
                [self.delegate didChangeToTable:table];
            }];
        }];

    }];
}

@end
