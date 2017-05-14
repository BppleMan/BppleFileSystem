//
//  MyWindowController.m
//  BppleFileSystem
//
//  Created by BppleMan on 17/5/1.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "MyWindowController.h"

@interface MyWindowController ()

@end

@implementation MyWindowController

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.textView setDelegate:self];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.textView setTextColor:[NSColor whiteColor]];
    [self.textView setFont:[NSFont fontWithName:@"Menlo" size:16]];
    [self.textView setAllowsUndo:YES];
}

@end
