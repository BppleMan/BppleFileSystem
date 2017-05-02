//
//  MyAccessoryViewController.h
//  BppleFileSystem
//
//  Created by BppleMan on 17/4/29.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyAccessoryViewController : NSViewController

@property (strong) IBOutlet NSTextField *sizeText;

@property (strong) IBOutlet NSComboBox *unitCombox;

@property (strong) IBOutlet NSComboBox *clusterCombox;
@end
