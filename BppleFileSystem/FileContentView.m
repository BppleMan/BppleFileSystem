//
//  FileContentView.m
//  BppleFileSystem
//
//  Created by BppleMan on 17/4/28.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "FileContentView.h"

@implementation FileContentView

- (instancetype)initWithScale:(CGFloat)scale
{
    self = [super init];
    if (self)
    {
        _defaultGridSize = 200;
        _defaultFileViewSize = 150;
        _unnamedFolderCount = 0;
        _scale = scale;
        self.fileItems = [[NSMutableDictionary alloc] init];
        self.fileViews = [[NSMutableArray alloc] init];
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
        self.selectedFileViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    //    [self addCursorRect:[self bounds] cursor:[NSCursor dragCopyCursor]];
    return NSDragOperationCopy;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    //    [self discardCursorRects];
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard    *pboard = [sender draggingPasteboard];
    NSMutableArray  *list = [[NSMutableArray alloc] initWithArray:[pboard propertyListForType:NSFilenamesPboardType]];
    [self.delegate fileDidDragInto:list];
    return YES;
}

/*
 *   =================================================================
 *   关于视图
 *   =================================================================
 */

- (void)layout
{
    CGFloat selfWidth = self.frame.size.width;
    
    _gridSize = _defaultFileViewSize * _scale;
    _fileViewSize = _defaultFileViewSize * _scale;
    
    NSUInteger  fileViewCount = self.fileViews.count;
    CGFloat     top, bottom, left, right;
    
    top = bottom = left = right = 0;
    for (int i = 0; i < fileViewCount; i++)
    {
        FileView    *view = self.fileViews[i];
        NSRect      frame = NSMakeRect(left, top, _fileViewSize, _fileViewSize);
        [view setFrame:frame];
        left += _gridSize;
        if (left + _gridSize > selfWidth)
        {
            top += _gridSize;
            left = 0;
        }
    }
    [super layout];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [self.window makeFirstResponder:self];
    for (FileView *view in _fileViews)
    {
        [view setIsSelected:NO];
        [view changeFileImageLayer];
        [view setNeedsDisplay:YES];
    }
}

- (void)changScale:(CGFloat)scale
{
    _scale = scale;
    [self setNeedsLayout:YES];
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
    _rightMouseDownEvent = theEvent;
    [super rightMouseDown:theEvent];
}

/*
 *   =================================================================
 *   关于FileViewDelegate
 *   =================================================================
 */
// FileView的双击代理方法
- (void)didDoubleClicked:(FileView *)fileView
{
    [self.delegate fileDidDoubleClicked:fileView];
}

// FileView的点击代理方法
- (void)didClicked:(FileView *)fileView
{
    for (FileView *view in _fileViews)
    {
        if (view != fileView)
        {
            [view setIsSelected:NO];
            [view changeFileImageLayer];
            [view setNeedsDisplay:YES];
        }
    }
    [fileView setIsSelected:YES];
    [fileView changeFileImageLayer];
    [fileView setNeedsDisplay:YES];
    [self.window makeFirstResponder:fileView];
    [self.selectedFileViews removeAllObjects];
    [self.selectedFileViews addObject:fileView];
}

// 获得输入焦点的FileView的通知方法
- (void)didChangedTheInputFocusView:(FileView *)sender
{}

/*
 *   =================================================================
 *   关于FileViewMenuDelegate
 *   =================================================================
 */
// FileView的删除代理方法
- (void)willDelete:(FileView *)fileView
{
    [self.fileViews removeObject:fileView];
    for (id key in self.fileItems)
    {
        //        NSString *str = [self.fileItems objectForKey:key];
        if ([fileView.fileName.stringValue isEqual:key])
        {
            [self.fileItems removeObjectForKey:key];
            break;
        }
    }
    [fileView removeFromSuperview];
    [self setNeedsLayout:YES];
    [self setNeedsDisplay:YES];
    
    [self.delegate fileWillRemove:fileView];
}

// FileView的拷贝代理方法
- (void)willCopy:(FileView *)sender
{
    [self.delegate fileWillCopy:[sender.fileName stringValue]];
}

- (void)reloadViewWithFileChilds:(NSMutableArray *)childs
{
    for (FileView *view in self.fileViews)
    {
        [view removeFromSuperview];
    }
    [self.fileItems removeAllObjects];
    [self.fileViews removeAllObjects];
    for (FileNode *child in childs)
    {
        [self addNewFileViewNode:child];
    }
}

- (void)didrename:(NSString *)newName withOldName:(NSString *)oldName
{
    [self.delegate fileDidRename:newName withOldName:oldName];
}

/*
 *   =================================================================
 *   关于文件
 *   =================================================================
 */

- (void)reloadData
{
    for (FileView *view in self.fileViews)
    {
        [self willRemoveSubview:view];
    }
    for (id key in self.fileItems)
    {
        FileView *fileView = [[FileView alloc] initWithFileName:[self.fileItems objectForKey:key] WithFileType:[[self.fileItems valueForKey:key] unsignedIntegerValue]];
        [self addSubview:fileView];
        [fileView setDelegate:self];
        [fileView setMenuDelegate:self];
        [self.fileViews addObject:fileView];
    }
}

- (void)addNewFileViewNode:(FileNode *)fileNode
{
    NSString    *name = fileNode.inode.fileName;
    FileView    *fileView = [[FileView alloc] initWithFileName:name WithFileType:fileNode.inode.fileType];
    [self addSubview:fileView];
    [fileView setDelegate:self];
    [fileView setMenuDelegate:self];
    //    添加一个键－值：名称－类型
    [self.fileItems setObject:[NSNumber numberWithUnsignedInteger:fileNode.inode.fileType] forKey:name];
    [self.fileViews addObject:fileView];
}

- (NSString *)creatNewFolder
{
    NSString    *name = @"未命名文件夹";
    NSString    *result;
    if (![[self.fileItems allKeys] containsObject:name])
        result = name;
    else
    {
        for (int i = 1; i < 100; i++)
        {
            name = [NSString stringWithFormat:@"未命名文件夹%d", i];
            if (![[self.fileItems allKeys] containsObject:name])
            {
                result = name;
                break;
            }
        }
    }
    FileView *fileView = [[FileView alloc] initWithFileName:result WithFileType:BppleDirectoryType];
    [self addSubview:fileView];
    [fileView setDelegate:self];
    [fileView setMenuDelegate:self];
    //    添加一个键－值：名称－类型
    [self.fileItems setObject:[NSNumber numberWithUnsignedInteger:BppleDirectoryType] forKey:result];
    [self.fileViews addObject:fileView];
    return result;
}

- (NSString *)creatNewTextFile
{
    NSString    *name = @"空文本.txt";
    NSString    *result;
    if (![[self.fileItems allKeys] containsObject:name])
        result = name;
    else
    {
        for (int i = 1; i < 100; i++)
        {
            name = [NSString stringWithFormat:@"空文本%d.txt", i];
            if (![[self.fileItems allKeys] containsObject:name])
            {
                result = name;
                break;
            }
        }
    }
    FileView *fileView = [[FileView alloc] initWithFileName:result WithFileType:BppleTextFileType];
    [self addSubview:fileView];
    [fileView setDelegate:self];
    [fileView setMenuDelegate:self];
    //    添加一个键－值：名称－类型
    [self.fileItems setObject:[NSNumber numberWithUnsignedInteger:BppleTextFileType] forKey:result];
    [self.fileViews addObject:fileView];
    return result;
}

- (NSString *)getCopyNameWithFileName:(NSString *)fileName
{
    NSArray     *names = [fileName componentsSeparatedByString:@"."];
    NSString    *result;
    if (names.count > 1)
        result = [NSString stringWithFormat:@"%@ 副本.%@", names[0], names[1]];
    else
        result = [NSString stringWithFormat:@"%@ 副本", names[0]];
    int i = 0;
    while (YES)
    {
        BOOL flag = YES;
        for (FileView *fileView in self.fileViews)
        {
            if ([result isEqual:[fileView.fileName stringValue]])
            {
                flag = NO;
                break;
            }
        }
        if (flag)
            break;
        else
        {
            if (names.count > 1)
                result = [NSString stringWithFormat:@"%@ 副本%d.%@", names[0], ++i, names[1]];
            else
                result = [NSString stringWithFormat:@"%@ 副本%d", names[0], ++i];
        }
    }
    return result;
}

- (void)removeAllFileView
{
    for (FileView *fileView in self.fileViews)
    {
        [fileView removeFromSuperview];
    }
    [self setNeedsDisplay:YES];
}

@end
