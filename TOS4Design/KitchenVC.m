//
//  KitchenVC.m
//  TOS4Design
//
//  Created by csnguyen on 2/24/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import "KitchenVC.h"
#import "KitchenCell.h"
#import "DataController.h"

@interface KitchenVC ()<UICollectionViewDataSource, UICollectionViewDelegate, KitchenCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *transactionList;  // array of OrderTransactionModel
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicationView;
@end

@implementation KitchenVC

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshTransactionList];
}

- (void)setTransactionList:(NSArray *)transactionList {
    _transactionList = transactionList;
    [self.collectionView reloadData];
}

- (void)refreshTransactionList {
    // DUMMY
    self.transactionList = [DataController getWaitingOrderTransactionList];
}
#pragma mark - Collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.transactionList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"KitchenCell";
    KitchenCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.transaction = self.transactionList[indexPath.row];
    cell.delegate = self;
    return cell;
}
#pragma mark - KitchenCellDelegate
- (void)didSubmitTransaction:(OrderTransactionModel *)transaction {
    [self.indicationView startAnimating];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        [DataController submitOrderTransaction:transaction];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self refreshTransactionList];
            [self.indicationView stopAnimating];
        }];
    }];
}
@end
