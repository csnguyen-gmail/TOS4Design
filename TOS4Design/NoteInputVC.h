//
//  NoteInputVC.h
//  TOS4Design
//
//  Created by csnguyen on 2/21/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteInputVCDelegate <NSObject>
- (void)didInputNote:(NSString*)note;
@end


@interface NoteInputVC : UIViewController
@property (nonatomic, weak) id<NoteInputVCDelegate> delegate;
@property (nonatomic, strong) NSString *initialNote;
@end
