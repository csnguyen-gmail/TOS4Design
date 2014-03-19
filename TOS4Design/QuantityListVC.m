//
//  QuantityListVC.m
//  TOS4Design
//
//  Created by csnguyen on 2/21/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import "QuantityListVC.h"

@interface QuantityListVC () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation QuantityListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInitialQuantity:(NSUInteger)initialQuantity {
    _initialQuantity = initialQuantity;
    [self.pickerView selectRow:(self.initialQuantity - 1) inComponent:0 animated:NO];
}
#pragma mark - Picker View
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 100;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [@(row + 1) stringValue];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.delegate didSelectQuantity:(row + 1)];
}

@end
