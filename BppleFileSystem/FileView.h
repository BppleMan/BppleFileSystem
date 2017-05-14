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

- (void)didDoubleClicked:(id)fileView;

- (void)didClicked:(id)fileView;

- (void)didChangedTheInputFocusView:(id)sender;

- (void)didrename:(NSString *)newName withOldName:(NSString *)oldName;

@end

@protocol FileViewMenuDelegate <NSObject>

- (void)willDelete:(id)sender;

- (void)willCopy:(id)sender;

@end

@interface FileView : NSView <NSTextFieldDelegate>
{
    BOOL        _isFileNameEditAble;
    NSString    *_oldName;
}

@property (strong) id delegate;

@property (strong) id menuDelegate;

@property (strong) NSView *fileNameView;

@property (strong) NSTextField *fileName;

@property (strong) NSImageView *fileImage;

@property (assign) FileType fileType;

@property (strong) NSMenu *bpmenu;

@property (readwrite) BOOL isSelected;

- (instancetype)initWithFileName:(NSString *)fileName WithFileType:(FileType)type;

- (void)changeFileImageLayer;

- (IBAction)deleteFile:(id)sender;

- (IBAction)copyFile:(id)sender;

@end
