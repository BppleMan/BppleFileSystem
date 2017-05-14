//
//  FileContentView.h
//  BppleFileSystem
//
//  Created by BppleMan on 17/4/28.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileView.h"
#import "FileNode.h"

@protocol FileContentViewDelegate <NSObject>

@required
- (void)fileWillRemove:(id)sender;

- (void)fileDidDoubleClicked:(id)sender;

- (void)fileDidDragInto:(NSMutableArray *)sender;

- (void)fileDidRename:(NSString *)newName withOldName:(NSString *)oldName;

- (void)fileWillCopy:(NSString *)fileName;

@end

@interface FileContentView : NSScrollView <FileViewDelegate, FileViewMenuDelegate>
{
    CGFloat _gridSize;
    CGFloat _defaultGridSize;
    CGFloat _fileViewSize;
    CGFloat _defaultFileViewSize;
    CGFloat _scale;
    
    NSEvent     *_rightMouseDownEvent;
    NSUInteger  _unnamedFolderCount;
}

@property (strong) id delegate;

@property (strong) NSMutableDictionary *fileItems;

@property (strong) NSMutableArray *fileViews;

@property (strong) NSMutableArray *selectedFileViews;

- (instancetype)initWithScale:(CGFloat)scale;

- (void)reloadData;

- (void)reloadViewWithFileChilds:(NSMutableArray *)childs;

- (void)changScale:(CGFloat)scale;

- (NSString *)creatNewFolder;

- (NSString *)creatNewTextFile;

- (NSString *)getCopyNameWithFileName:(NSString *)fileName;

- (void)removeAllFileView;

@end
