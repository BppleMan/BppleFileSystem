//
//  FileContentView.h
//  BppleFileSystem
//
//  Created by BppleMan on 17/4/28.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BPath.h"
#import "FileView.h"
#import "FileNode.h"

@protocol FileContentViewDelegate <NSObject>

- (void)fileWillRemove:(id)sender;

- (void)fileDidDoubleClicked:(id)sender;
@end

@interface FileContentView : NSScrollView <FileViewDelegate>
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

- (instancetype)initWithScale:(CGFloat)scale;

- (void)reloadData;

- (void)reloadViewWithFileNode:(FileNode *)fileNode;

- (void)reloadViewWithFileChilds:(NSMutableArray *)childs;

- (void)changScale:(CGFloat)scale;

- (void)addNewFolderWithFileNode:(FileNode *)fileNode;

- (NSString *)creatNewFolder;

- (NSString *)creatNewTextFile;

@end
