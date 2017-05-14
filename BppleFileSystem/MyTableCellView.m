//
//  MyTableCellView.m
//  BppleFileSystem
//
//  Created by BppleMan on 17/5/4.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "MyTableCellView.h"

@implementation MyTableCellView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (IBAction)didClick:(id)sender
{
    [self.delegate unmountButtonDidClick:self.item];
}

@end
