//
//  TableListVC.m
//  TOS4Design
//
//  Created by csnguyen on 2/19/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import "TableListVC.h"
#import "TableListCell.h"
#import "DataController.h"

@interface TableListVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tableList; // array of TableModel
@property (nonatomic) NSUInteger currentSelection;
@end

@implementation TableListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableList = [DataController getTableList];
    [self.delegate didSelectTable:self.tableList[0]];
    self.currentSelection = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self selectTable:self.tableList[self.currentSelection]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectTableAtRow:(NSUInteger)row {
    if (row < self.tableList.count) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (NSString*)buildStatusFromTable:(TableModel*)table {
    NSString *status = @"Empty";
    
    OrderTransactionModel *transaction = [table.orderTransactionList lastObject];
    if ((transaction.status == kOtsNew) && (transaction.orderList.count != 0)) {
        status = @"Ordering";
    }
    else if ((transaction.status == kOtsWait) || (transaction.status == kOtsCooking)) {
        status = @"Waiting";
    }
    else if (transaction.status == kOtsReady) {
        status = @"Need serve";
    }
    else if (transaction.status == kOtsServed) {
        status = @"All done";
    }
    
    return status;
}
- (void)refreshTable:(TableModel*)table {
    NSIndexPath *index = [NSIndexPath indexPathForRow:[self.tableList indexOfObject:table] inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
}
- (void)selectTable:(TableModel *)table {
    [self.tableView reloadData];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:[self.tableList indexOfObject:table] inSection:0];
    [self.tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self.delegate didSelectTable:table];
}
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TableCell";
    TableListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TableModel *table = self.tableList[indexPath.row];
    
    cell.nameLbl.text = table.name;
    cell.statusLbl.text = [self buildStatusFromTable:table];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentSelection = indexPath.row;
    TableModel *model = self.tableList[indexPath.row];
    [self.delegate didSelectTable:model];
}
@end
