//
//  ItemListVC.m
//  TOS4Design
//
//  Created by csnguyen on 2/20/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import "ItemListVC.h"
#import "DataController.h"

@interface ItemListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *itemList; // array of ItemModel
@end

@implementation ItemListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    self.itemList = [DataController getItemList];
    
    [self.tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *selectedIndex;
    for (int i = 0; i < self.itemList.count; i++) {
        ItemModel *item = self.itemList[i];
        if ([item.name isEqualToString:self.initialItem.name]) {
            selectedIndex = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
    [self.tableView selectRowAtIndexPath:selectedIndex animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    [self.tableView scrollToRowAtIndexPath:selectedIndex atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    ItemModel *itemModel = self.itemList[indexPath.row];
    cell.textLabel.text = itemModel.name;
    cell.detailTextLabel.text = [self.numberFormatter stringFromNumber:@(itemModel.price)];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemModel *itemModel = self.itemList[indexPath.row];
    [self.delegate didSelectItem:itemModel];
}

@end
