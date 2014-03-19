//
//  QuantityListVC.h
//  TOS4Design
//
//  Created by csnguyen on 2/21/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuantityListVCDelegate <NSObject>
- (void)didSelectQuantity:(NSUInteger)quantity;
@end

@interface QuantityListVC : UIViewController
@property (nonatomic, weak) id<QuantityListVCDelegate> delegate;
@property (nonatomic) NSUInteger initialQuantity;
@end
