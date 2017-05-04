//
//  ViewController.h
//  BppleFileSystem
//
//  Created by BppleMan on 17/4/28.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileContentView.h"
#import "FileSystemController.h"
#import "BppleFileSystem.h"
#import "BppleFileDocument.h"
#import "MyAccessoryViewController.h"
#import "MyWindowController.h"
#import "MyTableCellView.h"

@interface ViewController : NSViewController <NSToolbarDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource, NSOpenSavePanelDelegate, FileContentViewDelegate, NSWindowDelegate, MyTableCellViewDelegate>
{
    NSToolbar *_toolBar;
    
    NSArray *_itemsIdentifier;
    
    NSArray *_groupItem;
    
    NSArray *_collectionItem;
    
    NSMutableArray *_fileSystemItem;
    
    NSSegmentedControl *_segmentedControl;
    
    BPath *_currentPath;
    
    BPath *_tempPath;
    
    IBOutlet NSOutlineView *_sidebarOutlineView;
    
    IBOutlet NSSlider *_fileViewSizeSlider;
    
    IBOutlet NSView *_rightView;
    
    IBOutlet NSMenu *_fileContentViewMenu;
    
    FileContentView *_fileContentView;
    
    NSMutableArray *_pathStack;
    
    NSInteger _stackPoint;
}
@property (strong) MyWindowController *windowController;

@property (strong) FileSystemController *fileSystemController;

@property (strong) IBOutlet NSWindow *window;

- (IBAction)changeTheScaleValue:(id)sender;

- (IBAction)creatNewFolder:(id)sender;

- (IBAction)creatTextFile:(id)sender;

- (IBAction)paste:(id)sender;

- (IBAction)loadFileSystemDocument:(id)sender;

- (IBAction)creatFileSystemDocument:(id)sender;

- (IBAction)saveFileSystemDocument:(id)sender;

@end
