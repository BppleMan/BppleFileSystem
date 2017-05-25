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
#import "MyAccessoryViewController.h"
#import "MyWindowController.h"
#import "MyTableCellView.h"

@interface ViewController : NSViewController <NSToolbarDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource, NSOpenSavePanelDelegate, NSWindowDelegate, NSSplitViewDelegate,
FileContentViewDelegate, MyTableCellViewDelegate>
{
    NSToolbar *_toolBar;
    
    NSArray *_itemsIdentifier;
    
    NSArray *_groupItem;
    
    NSArray *_collectionItem;
    
    NSMutableArray *_fileSystemItem;
    
    NSSegmentedControl *_segmentedControl;
    
    BPath *_currentPath;
    
    BPath *_tempPath;
    
    BPath *_copyPath;
    
    IBOutlet NSOutlineView *_sidebarOutlineView;
    
    IBOutlet NSSlider *_fileViewSizeSlider;
    
    IBOutlet NSView *_leftView;
    
    IBOutlet NSView *_rightView;
    
    IBOutlet NSMenu *_fileContentViewMenu;
    
    FileContentView *_fileContentView;
    
    NSMutableArray *_pathStack;
    
    NSInteger _stackPoint;
    
    IBOutlet NSTextField *_pathLabel;
}
@property (strong) MyWindowController *windowController;

@property (strong) FileSystemController *fileSystemController;

@property (strong) IBOutlet NSWindow *window;

- (IBAction)changeTheScaleValue:(id)sender;

- (IBAction)creatNewFolder:(id)sender;

- (IBAction)creatTextFile:(id)sender;

- (IBAction)copy:(id)sender;

- (IBAction)paste:(id)sender;

- (IBAction)loadFileSystemDocument:(id)sender;

- (IBAction)creatFileSystemDocument:(id)sender;

- (IBAction)saveFileSystemDocument:(id)sender;

@end
