//
//  MyTableCellView.h
//  BppleFileSystem
//
//  Created by BppleMan on 17/5/4.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol MyTableCellViewDelegate <NSObject>

- (void)unmountButtonDidClick:(id)sender;

@end

@interface MyTableCellView : NSTableCellView

@property (strong) IBOutlet NSButton *imageButton;

@property (strong) NSString *item;

@property (strong) id delegate;

- (IBAction)didClick:(id)sender;

@end
