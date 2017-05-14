//
//  MyWindowController.h
//  BppleFileSystem
//
//  Created by BppleMan on 17/5/1.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyWindowController : NSWindowController <NSTextViewDelegate>

@property (strong) IBOutlet NSTextView *textView;

@end
