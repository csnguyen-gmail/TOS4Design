//
//  NoteInputVC.m
//  TOS4Design
//
//  Created by csnguyen on 2/21/14.
//  Copyright (c) 2014 csnguyen. All rights reserved.
//

#import "NoteInputVC.h"

@interface NoteInputVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *noteTV;

@end

@implementation NoteInputVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.noteTV becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInitialNote:(NSString *)initialNote {
    _initialNote = initialNote;
    self.noteTV.text = initialNote;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.delegate didInputNote:textView.text];
}
@end
