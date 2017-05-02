//
//  ViewController.m
//  BppleFileSystem
//
//  Created by BppleMan on 17/4/28.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initToolBar];
    [self initOutlineView];
    [self initFileContentView];
    [self initPathStack];
    [self loadFileSystemControllerWithPath:[NSURL fileURLWithPath:@"/Users/BppleMan/Desktop/FileSystem/未命名.bpfs"]];
}

/*
 *   =================================================================
 *   关于ToolBar
 *   =================================================================
 */

/**
 *  初始化后退前进按钮和Item标识符
 */
- (void)initSegmentedControlAndItemIdentifier
{
    _itemsIdentifier = [NSArray arrayWithObjects:@"GoBackForwardItem", @"NSToolbarSpaceItem", @"NSToolbarFlexibleSpaceItem", nil];
    
    _segmentedControl = [[NSSegmentedControl alloc]initWithFrame:NSMakeRect(0, 0, 60, 60)];
    [_segmentedControl setSegmentCount:2];
    [_segmentedControl setTrackingMode:NSSegmentSwitchTrackingMomentary];
    [_segmentedControl setSegmentStyle:NSSegmentStyleSeparated];
    [_segmentedControl setImage:[NSImage imageNamed:NSImageNameGoLeftTemplate] forSegment:0];
    [_segmentedControl setImage:[NSImage imageNamed:NSImageNameGoRightTemplate] forSegment:1];
    [_segmentedControl setAction:@selector(clickTheBackOrForward:)];
    [_segmentedControl setTarget:self];
}

/**
 *  初始化ToolBar
 */
- (void)initToolBar
{
    [self initSegmentedControlAndItemIdentifier];
    _toolBar = [[NSToolbar alloc]initWithIdentifier:@"My Toolbar"];
    [_toolBar setVisible:YES];
    [_toolBar setSizeMode:NSToolbarSizeModeDefault];
    [_toolBar setDisplayMode:NSToolbarDisplayModeIconOnly];
    [_toolBar setAutosavesConfiguration:YES];
    [_toolBar setAllowsUserCustomization:YES];
    [_toolBar setDelegate:self];
    [_window setToolbar:_toolBar];
}

/**
 *  重写toolbar允许的Item标识符
 *
 *  @param toolbar
 *
 *  @return 一个NSString的数组
 */
- (NSArray <NSString *> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    return _itemsIdentifier;
}

/**
 *  重写toolbar默认加入的item
 *
 *  @param toolbar
 *  @param itemIdentifier
 *  @param flag
 *
 *  @return 返回item
 */

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *result = nil;
    if ([itemIdentifier isEqual:[_itemsIdentifier objectAtIndex:0]])
    {
        result = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        [result setTarget:self];
        [result setMaxSize:NSMakeSize(60, 60)];
        [result setMinSize:NSMakeSize(60, 60)];
        [result setView:_segmentedControl];
        [result setLabel:@"后退前进"];
    }
    else
    {
        result = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    }
    return result;
}

/**
 *  重写toolbar默认的item标识符
 *
 *  @param toolbar
 *
 *  @return 返回标识符数组
 */
- (NSArray <NSString *> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    NSArray *defaultIden = [NSArray arrayWithObjects:_itemsIdentifier[0], _itemsIdentifier[2], nil];
    return defaultIden;
}

/**
 *  计算toolbar的高度
 *
 *  @param window
 *
 *  @return 高度
 */
- (float)toolbarHeightForWindow:(NSWindow *)window
{
    NSToolbar   *toolbar;
    float       toolbarHeight = 0.0;
    NSRect      windowFrame;
    
    toolbar = [window toolbar];
    
    if (toolbar && [toolbar isVisible])
    {
        windowFrame = [NSWindow contentRectForFrameRect:[window frame]
                                              styleMask:[window styleMask]];
        toolbarHeight = NSHeight(windowFrame)
        - NSHeight([[window contentView] frame]);
    }
    return toolbarHeight;
}

/*
 *   =================================================================
 *   关于Source List
 *   =================================================================
 */

- (void)initItemIdentifier
{
    // The array determines our order
    _groupItem = [NSArray arrayWithObjects:@"个人收藏", @"文件系统", nil];
    
    // The data is stored ina  dictionary. The objects are the nib names to load.
    _collectionItem = [NSArray arrayWithObjects:@"应用程序", @"桌面", @"文稿", @"下载", @"影片", @"音乐", @"图片", @"HOME", nil];
    _fileSystemItem = [[NSMutableArray alloc] init];
    //    [_childrenDictionary setObject:[NSArray arrayWithObjects:@"ContentView2", nil] forKey:@"Mailboxes"];
    //    [_childrenDictionary setObject:[NSArray arrayWithObjects:@"ContentView1", @"ContentView1", @"ContentView1", @"ContentView1", @"ContentView2", nil] forKey:@"A Fourth Group"];
}

- (void)initOutlineView
{
    [self initItemIdentifier];
    // The basic recipe for a sidebar. Note that the selectionHighlightStyle is set to NSTableViewSelectionHighlightStyleSourceList in the nib
    [_sidebarOutlineView sizeLastColumnToFit];
    [_sidebarOutlineView reloadData];
    [_sidebarOutlineView setFloatsGroupRows:NO];
    [_sidebarOutlineView setDelegate:self];
    [_sidebarOutlineView setDataSource:self];
    
    // NSTableViewRowSizeStyleDefault should be used, unless the user has picked an explicit size. In that case, it should be stored out and re-used.
    [_sidebarOutlineView setRowSizeStyle:NSTableViewRowSizeStyleDefault];
    
    // Expand all the root items; disable the expansion animation that normally happens
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0];
    [_sidebarOutlineView expandItem:nil expandChildren:YES];
    [NSAnimationContext endGrouping];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    //    if ([_sidebarOutlineView selectedRow] != -1)
    //    {
    NSString *item = [_sidebarOutlineView itemAtRow:[_sidebarOutlineView selectedRow]];
    if ([item isEqual:_fileSystemItem[0]])
    {
        _currentPath = [[BPath alloc] initWithNSString:@"root"];
        [self pushToStack:_currentPath];
        NSMutableArray *childs = [_fileSystemController showFilesChildsWith:_currentPath];
        [_fileContentView reloadViewWithFileChilds:childs];
    }
    else if ([_collectionItem containsObject:item])
    {
        _currentPath = [[BPath alloc] initWithNSString:[NSString stringWithFormat:@"root/%@", item]];
        [self pushToStack:_currentPath];
        NSMutableArray *childs = [_fileSystemController showFilesChildsWith:_currentPath];
        [_fileContentView reloadViewWithFileChilds:childs];
    }
}

/**
 *  根据组名返回对应组的子对象数组
 *
 *  @param item 组名
 *
 *  @return 返回子对象数组
 */
- (NSArray *)_childrenForItem:(id)item
{
    NSArray *children;
    if (item == nil)
    {
        children = _groupItem;
    }
    else if (item == _groupItem[0])
    {
        children = _collectionItem;
    }
    else if (item == _groupItem[1])
    {
        children = _fileSystemItem;
    }
    return children;
}

/**
 *  根据返回的子对象数组，通过下标返回子对象
 *
 *  @param outlineView
 *  @param index       下标
 *  @param item        父对象名
 *
 *  @return 返回子对象名
 */
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    return [[self _childrenForItem:item] objectAtIndex:index];
}

/**
 *  根据对象名确定selectable
 *
 *  @param outlineView
 *  @param item        对象名
 *
 *  @return 返回是一个BOOL值
 */
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([outlineView parentForItem:item] == nil)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    if ([_groupItem containsObject:item])
        return NO;
    else
        return YES;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    return [[self _childrenForItem:item] count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return [_groupItem containsObject:item];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    // For the groups, we just return a regular text view.
    if ([_groupItem containsObject:item])
    {
        NSTextField *result = [outlineView makeViewWithIdentifier:@"HeaderTextField" owner:self];
        // Uppercase the string value, but don't set anything else. NSOutlineView automatically applies attributes as necessary
        NSString *value = [item uppercaseString];
        [result setStringValue:value];
        return result;
    }
    NSTableCellView *result = [outlineView makeViewWithIdentifier:@"MainCell" owner:self];
    [result.textField setStringValue:item];
    if ([_collectionItem containsObject:item])
    {
        //        _childrenDictionary = [NSArray arrayWithObjects:@"应用程序", @"桌面", @"文稿", @"下载", @"影片", @"音乐", @"图片", @"HOME", nil];
        // The cell is setup in IB. The textField and imageView outlets are properly setup.
        // Special attributes are automatically applied by NSTableView/NSOutlineView for the source list
        if (item == _collectionItem[7])
            result.imageView.image = [NSImage imageNamed:NSImageNameHomeTemplate];
        else
            result.imageView.image = [NSImage imageNamed:NSImageNameFolder];
    }
    else if ([_fileSystemItem containsObject:item])
    {
        result.imageView.image = [NSImage imageNamed:NSImageNameComputer];
    }
    return result;
}

/*
 *   =================================================================
 *   关于File Content View
 *   =================================================================
 */

- (void)initFileContentView
{
    _fileContentView = [[FileContentView alloc] initWithScale:_fileViewSizeSlider.integerValue / 100.0];
    [_rightView addSubview:_fileContentView];
    [self autoLayoutFileContentView];
    [_fileContentView setMenu:_fileContentViewMenu];
    [_fileContentView setDelegate:self];
    [self.window setInitialFirstResponder:_fileContentView];
}

- (void)autoLayoutFileContentView
{
    [_fileContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:_fileContentView
                               attribute   :NSLayoutAttributeTop
                               relatedBy   :NSLayoutRelationEqual
                               toItem      :_rightView
                               attribute   :NSLayoutAttributeTop
                               multiplier  :1.0
                               constant    :0];
    [_rightView addConstraint:top];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:_fileContentView
                                  attribute   :NSLayoutAttributeBottom
                                  relatedBy   :NSLayoutRelationEqual
                                  toItem      :_rightView
                                  attribute   :NSLayoutAttributeBottom
                                  multiplier  :1.0
                                  constant    :0];
    [_rightView addConstraint:bottom];
    
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:_fileContentView
                                attribute   :NSLayoutAttributeLeft
                                relatedBy   :NSLayoutRelationEqual
                                toItem      :_rightView
                                attribute   :NSLayoutAttributeLeft
                                multiplier  :1.0
                                constant    :0];
    [_rightView addConstraint:left];
    
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:_fileContentView
                                 attribute   :NSLayoutAttributeRight
                                 relatedBy   :NSLayoutRelationEqual
                                 toItem      :_rightView
                                 attribute   :NSLayoutAttributeRight
                                 multiplier  :1.0
                                 constant    :0];
    [_rightView addConstraint:right];
}

//删除代理
- (void)fileWillRemove:(FileView *)sender
{
    BPath *path = [BPath pathWithPath:_currentPath];
    [path appendenPathWithString:[sender.fileName stringValue]];
    [_fileSystemController removeFileWithPath:path];
}

// 双击代理
- (void)fileDidDoubleClicked:(FileView *)sender
{
    switch (sender.fileType)
    {
        case BppleTextFileType:
        {
            if (!self.windowController)
            {
                self.windowController = [[MyWindowController alloc] initWithWindowNibName:@"MyWindowController"];
                [self.windowController.window setDelegate:self];
                [self.windowController.window makeKeyWindow];
            }
            else
            {
                [self.windowController showWindow:self];
            }
            _tempPath = [BPath pathWithPath:_currentPath];
            [_tempPath appendenPathWithString:sender.fileName.stringValue];
            NSString *string = [_fileSystemController readTheTextFile:_tempPath];
            [self.windowController.textView setString:string];
            
            break;
        }
        case BppleDirectoryType:
        {
            [_currentPath appendenPathWithString:sender.fileName.stringValue];
            NSMutableArray *childs = [_fileSystemController showFilesChildsWith:_currentPath];
            [_fileContentView reloadViewWithFileChilds:childs];
            [self pushToStack:_currentPath];
            break;
        }
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    NSString *string = [self.windowController.textView string];
    [_fileSystemController writeTheTextFile:_tempPath With:string];
    [self.window makeKeyWindow];
}

/*
 *   =================================================================
 *   关于File System Controller
 *   =================================================================
 */

- (void)creatFileSystemControllerWithPath:(NSURL *)url WithSize:(NSUInteger)size WithClusterSize:(NSUInteger)cluster
{
    self.fileSystemController = [[FileSystemController alloc] initWithFileSystemPath:[url path] WithSize:size WithClusterSize:cluster];
}

- (void)loadFileSystemControllerWithPath:(NSURL *)url
{
    [_fileSystemItem addObject:[url lastPathComponent]];
    [_sidebarOutlineView reloadData];
    self.fileSystemController = [[FileSystemController alloc] initWithFileSystemPath:[url path]];
}

/*
 *   =================================================================
 *   关于路径栈，通过压栈和出栈的方式控制当前路径，以此reload ContentView
 *   =================================================================
 */

/**
 *   前进只有在前一次操作是后退的情况下才能进行
 *   后退只有在栈中有元素的情况下才能进行
 *   当前进的时候需要判断栈指针的下一个element是否存在
 *   当打开一个新路径的时候需要入栈 且必须清空cache
 */
- (void)initPathStack
{
    //    路径栈
    _pathStack = [[NSMutableArray alloc] init];
    
    /**
     *   栈指针 初始时处于栈底
     *   栈指针++表示前进 --表示后退
     *   出栈时并不移除栈顶元素
     *   自栈指针开始至数组最后一个元素为止的element作为cache
     */
    _stackPoint = 0;
}

// 新的路径入栈
- (void)pushToStack:(BPath *)path
{
    if (_stackPoint > 0)
    {
        //        如果栈非空 则清空cache
        [_pathStack removeObjectsInRange:NSMakeRange(_stackPoint, _pathStack.count - _stackPoint)];
        [_segmentedControl setSelected:NO forSegment:1];
    }
    [_pathStack addObject:[BPath pathWithPath:path]];
    _stackPoint++;
}

// 路径出栈
- (BPath *)peekFromStack
{
    //    如果栈空则直接返回空
    if ((_stackPoint == 0) || (_stackPoint == 1))
        return nil;
    _stackPoint--;
    return [_pathStack objectAtIndex:_stackPoint - 1];
}

// 取出cache
- (BPath *)takeFromCache
{
    //    如果cache空则直接返回空
    if (_stackPoint == _pathStack.count)
        return nil;
    _stackPoint++;
    return [_pathStack objectAtIndex:_stackPoint - 1];
}

/*
 *   =================================================================
 *   关于Action
 *   =================================================================
 */

- (IBAction)changeTheScaleValue:(id)sender
{
    CGFloat scale = _fileViewSizeSlider.integerValue / 100.0;
    [_fileContentView changScale:scale];
}

- (IBAction)creatNewFolder:(id)sender
{
    NSString    *dirName = [_fileContentView creatNewFolder];
    BPath       *path = [BPath pathWithPath:_currentPath];
    [path appendenPathWithString:dirName];
    [_fileSystemController creatNewFolderWithPath:path];
}

- (IBAction)creatTextFile:(id)sender
{
    NSString    *fileName = [_fileContentView creatNewTextFile];
    BPath       *path = [BPath pathWithPath:_currentPath];
    [path appendenPathWithString:fileName];
    [_fileSystemController creatNewTextFileWithPath:path];
}

- (IBAction)loadFileSystemDocument:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    //    [openPanel setAllowsMultipleSelection:YES]; // 设置多选模式
    NSArray *allowedTypes = [NSArray arrayWithObjects:@"com.bppleman.bpplefilesystem.bpfs", nil];
    [openPanel setAllowedFileTypes:allowedTypes];
    
    [openPanel setMessage:@"选择需要挂载的文件系统"];
    [openPanel beginSheetModalForWindow:[NSApp mainWindow] completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton)
        {
            NSURL *url = [openPanel URL];
            
            [self loadFileSystemControllerWithPath:url];
        }
    }];
}

- (IBAction)creatFileSystemDocument:(id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    NSArray     *allowedTypes = [NSArray arrayWithObjects:@"com.bppleman.bpplefilesystem.bpfs", nil];
    [savePanel setAllowedFileTypes:allowedTypes];
    MyAccessoryViewController *controller = [[MyAccessoryViewController alloc] initWithNibName:@"MyAccessoryViewController" bundle:[NSBundle mainBundle]];
    [savePanel setAccessoryView:controller.view];
    
    [savePanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton)
        {
            NSUInteger size = [controller.sizeText.stringValue integerValue];
            NSString *str = [NSString stringWithString:[controller.clusterCombox objectValueOfSelectedItem]];
            NSUInteger cluster = [str integerValue];
            switch (controller.unitCombox.indexOfSelectedItem)
            {
                case 0:
                    size *= pow(2.0, 10);
                    break;
                case 1:
                    size *= pow(2.0, 20);
                    break;
                case 2:
                    size *= pow(2, 30);
                    break;
            }
            NSURL *url = [savePanel URL];
            [self creatFileSystemControllerWithPath:url WithSize:size WithClusterSize:cluster];
        }
    }];
}

- (IBAction)saveFileSystemDocument:(id)sender
{
    [_fileSystemController saveFileSystem];
}

/**
 *  当前进后退按钮被点击时的触发行为
 *
 *  @param sender 被点击的对象指针
 */
- (void)clickTheBackOrForward:(id)sender
{
    switch ([_segmentedControl selectedSegment])
    {
        case 0:
        {
            BPath *path = [self peekFromStack];
            if (path)
            {
                _currentPath = [path copy];
                NSMutableArray *childs = [_fileSystemController showFilesChildsWith:path];
                [_fileContentView reloadViewWithFileChilds:childs];
            }
            break;
        }
        case 1:
        {
            BPath *path = [self takeFromCache];
            if (path)
            {
                _currentPath = [path copy];
                NSMutableArray *childs = [_fileSystemController showFilesChildsWith:path];
                [_fileContentView reloadViewWithFileChilds:childs];
            }
            break;
        }
    }
}

@end
