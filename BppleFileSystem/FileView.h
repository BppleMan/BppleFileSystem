//
//  CollectionViewItem.h
//  FileSystem
//
//  Created by BppleMan on 17/4/23.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iNode.h"

@protocol FileViewDelegate <NSObject>

- (void)willRemoveTheFileView:(id)fileView;

- (void)didDoubleClicked:(id)fileView;

- (void)didClicked:(id)fileView;
@end

@interface FileView : NSView <NSTextFieldDelegate>
{
    int     a;
    BOOL    _isFileNameEditAble;
}

@property (strong) id delegate;

@property (strong) NSView *fileNameView;

@property (strong) NSTextField *fileName;

@property (strong) NSImageView *fileImage;

@property (assign) FileType fileType;

@property (strong) NSMenu *bpmenu;

@property (readwrite) BOOL isSelected;

- (instancetype)initWithFileName:(NSString *)fileName WithFileType:(FileType)type;

- (void)changeFileImageLayer;
@end
