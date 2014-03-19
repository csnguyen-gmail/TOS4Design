//
//  ChangeTableVC.m
//  TOS4Design
//
//  Created by csnguyen on 2/23/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import "ChangeTableVC.h"
#import "DataController.h"

@interface ChangeTableVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableList; // array of TableModel
@end

@implementation ChangeTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setInitialTable:(TableModel *)initialTable {
    _initialTable = initialTable;
    self.tableList = [NSMutableArray array];
    NSArray *tableList = [DataController getTableList];
    
    for (TableModel *table in tableList) {
        if ([table.name isEqualToString:initialTable.name]) {
            continue;
        }
        OrderTransactionModel *transaction = [table.orderTransactionList lastObject];
        if (transaction.orderList.count == 0) {
            [self.tableList addObject:table];
        }
    }
    [self.tableView reloadData];
}
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TableModel *table = self.tableList[indexPath.row];
    cell.textLabel.text = table.name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TableModel *table = self.tableList[indexPath.row];
    [self.delegate didSelectTable:table];
}

@end
