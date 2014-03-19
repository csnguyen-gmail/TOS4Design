//
//  OrderSplitVC.m
//  TOS4Design
//
//  Created by csnguyen on 2/19/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import "OrderSplitVC.h"
#import "TableListVC.h"
#import "OrderListVC.h"

@interface OrderSplitVC ()<TableListVCDelegate, OrderListVCDelegate, UISplitViewControllerDelegate>
@property (weak, nonatomic) TableListVC *tableListVC;
@property (weak, nonatomic) OrderListVC *orderListVC;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation OrderSplitVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	UINavigationController *navigationCtrl = self.viewControllers[0];
    self.tableListVC = (TableListVC*)navigationCtrl.topViewController;
    self.tableListVC.delegate = self;
    
    navigationCtrl = self.viewControllers[1];
    self.orderListVC = (OrderListVC*)navigationCtrl.topViewController;
    self.orderListVC.delegate = self;
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = @"Table";
    [self.orderListVC.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.orderListVC.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - TableListVCDelegate
- (void)didSelectTable:(TableModel *)model {
    self.orderListVC.tableModel = model;
}
#pragma mark - OrderListVCDelegate
- (void)didSubmitTable:(TableModel *)table {
    [self.tableListVC refreshTable:table];
}
- (void)didChangeToTable:(TableModel *)table {
    [self.tableListVC selectTable:table];
}
@end
