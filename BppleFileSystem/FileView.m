//
//  CollectionViewItem.m
//  FileSystem
//
//  Created by BppleMan on 17/4/23.
//  Copyright © 2017年 BppleMan. All rights reserved.
//

#import "FileView.h"

@interface FileView ()

@end

@implementation FileView

- (instancetype)initWithFileName:(NSString *)fileName WithFileType:(FileType)type
{
    self = [super init];
    if (self)
    {
        self.fileType = type;
        [self initViewWithFileName:fileName WithFileType:type];
        [self initMenu];
    }
    return self;
}

/*
 *   =================================================================
 *   关于View
 *   =================================================================
 */
- (void)initViewWithFileName:(NSString *)fileName WithFileType:(FileType)type
{
    /**
     *   初始化fileImage
     */
    self.fileImage = [[NSImageView alloc] init];
    [self.fileImage setImageScaling:NSImageScaleProportionallyUpOrDown];
    switch (type)
    {
        case BppleDirectoryType:
            [self.fileImage setImage:[NSImage imageNamed:NSImageNameFolder]];
            break;
        case BppleTextFileType:
            [self.fileImage setImage:[NSImage imageNamed:@"Image"]];
            break;
    }
    [self addSubview:self.fileImage];
    
    //    /**
    //     *   初始化fileNameView
    //     */
    //    self.fileNameView = [[NSView alloc] init];
    //    [self.fileNameView setWantsLayer:YES];
    //    //    [self.fileNameView.layer setBackgroundColor:[[NSColor blueColor] CGColor]];
    //    [self addSubview:self.fileNameView];
    
    /**
     *   初始化fileName
     */
    self.fileName = [[NSTextField alloc] init];
    
    [self.fileName setStringValue:fileName];
    [self.fileName setBordered:NSNoBorder];
    [self.fileName setAlignment:NSTextAlignmentCenter];
    [self.fileName setFont:[NSFont systemFontOfSize:16]];
    [self.fileName setSelectable:NO];
    [self.fileName sizeToFit];
    [[self.fileName cell] setUsesSingleLineMode:NO];
    [self.fileName setDelegate:self];
    [[self.fileName cell] setLineBreakMode:NSLineBreakByWordWrapping];
    [self addSubview:self.fileName];
    
    //    初始化selceted值
    [self setIsSelected:NO];
}

- (void)viewWillDraw
{
    [super viewWillDraw];
    
    /**
     *  添加约束自动布局
     */
    self.fileName.translatesAutoresizingMaskIntoConstraints = NO;
    self.fileImage.translatesAutoresizingMaskIntoConstraints = NO;
    self.fileNameView.translatesAutoresizingMaskIntoConstraints = NO;
    [self autoLayoutFileImageButton];
    //    [self autoLayoutFileNameView];
    [self autoLayoutFileName];
}

- (void)autoLayoutFileName
{
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:self.fileName
                               attribute   :NSLayoutAttributeTop
                               relatedBy   :NSLayoutRelationEqual
                               toItem      :self.fileImage
                               attribute   :NSLayoutAttributeBottom
                               multiplier  :1.0
                               constant    :0];
    [self addConstraint:top];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:self.fileName
                                  attribute   :NSLayoutAttributeBottom
                                  relatedBy   :NSLayoutRelationEqual
                                  toItem      :self
                                  attribute   :NSLayoutAttributeBottom
                                  multiplier  :1.0
                                  constant    :0];
    [self addConstraint:bottom];
    
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:self.fileName
                                attribute   :NSLayoutAttributeLeft
                                relatedBy   :NSLayoutRelationEqual
                                toItem      :self
                                attribute   :NSLayoutAttributeLeft
                                multiplier  :1.0
                                constant    :0];
    [self addConstraint:left];
    
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:self.fileName
                                 attribute   :NSLayoutAttributeRight
                                 relatedBy   :NSLayoutRelationEqual
                                 toItem      :self
                                 attribute   :NSLayoutAttributeRight
                                 multiplier  :1.0
                                 constant    :0];
    [self addConstraint:right];
}

- (void)autoLayoutFileImageButton
{
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:self.fileImage
                               attribute   :NSLayoutAttributeTop
                               relatedBy   :NSLayoutRelationEqual
                               toItem      :self
                               attribute   :NSLayoutAttributeTop
                               multiplier  :1.0
                               constant    :10];
    [self addConstraint:top];
    
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:self.fileImage
                                attribute   :NSLayoutAttributeLeft
                                relatedBy   :NSLayoutRelationEqual
                                toItem      :self
                                attribute   :NSLayoutAttributeLeft
                                multiplier  :1.0
                                constant    :10];
    [self addConstraint:left];
    
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:self.fileImage
                                 attribute   :NSLayoutAttributeRight
                                 relatedBy   :NSLayoutRelationEqual
                                 toItem      :self
                                 attribute   :NSLayoutAttributeRight
                                 multiplier  :1.0
                                 constant    :-10];
    [self addConstraint:right];
    
    NSLayoutConstraint *height = [NSLayoutConstraint
                                  constraintWithItem:self.fileImage
                                  attribute   :NSLayoutAttributeHeight
                                  relatedBy   :NSLayoutRelationEqual
                                  toItem      :self
                                  attribute   :NSLayoutAttributeHeight
                                  multiplier  :2.0 / 3.0
                                  constant    :0];
    [self addConstraint:height];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[%@]", self.fileName.stringValue];
}

/*
 *   =================================================================
 *   关于Menu
 *   =================================================================
 */

- (void)initMenu
{
    self.bpmenu = [[NSMenu alloc] init];
    NSMenuItem *deleteItem = [[NSMenuItem alloc] init];
    [deleteItem setTitle:@"删除"];
    [deleteItem setAction:@selector(deleteFile:)];
    [self.bpmenu insertItem:deleteItem atIndex:0];
    [self setMenu:self.bpmenu];
}

/*
 *   =================================================================
 *   关于Action
 *   =================================================================
 */

- (void)deleteFile:(id)sender
{
    [self.delegate willRemoveTheFileView:self];
}

- (void)changeFileImageLayer
{
    if (self.isSelected)
    {
        [self.fileImage setWantsLayer:YES];
        [self.fileImage.layer setBackgroundColor:[[NSColor grayColor] CGColor]];
        [self.fileImage.layer setCornerRadius:5.0];
    }
    else
    {
        [self.fileImage setWantsLayer:NO];
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    //    [self setIsSelected:YES];
    //    [self changeFileImageLayer];
    //    [self setNeedsDisplay:YES];
    //    [self.window makeFirstResponder:self];
    [self.delegate didClicked:self];
    if ([theEvent clickCount] == 2)
    {
        [self.delegate didDoubleClicked:self];
    }
}

- (void)keyDown:(NSEvent *)theEvent
{
    //    [self interpretKeyEvents:[NSArray arrayWithObjects:theEvent, nil]];
    if ((theEvent.keyCode == 36) && self.isSelected)
    {
        [self.delegate didChangedTheKeyView:self];
        [self.fileName setSelectable:YES];
        [self.fileName setEditable:YES];
        [self.window makeFirstResponder:self.fileName];
    }
}

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
    return self.isSelected;
}

- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    [self.fileName setSelectable:NO];
    [self.window makeFirstResponder:self];
}

- (BOOL)dragFile:(NSString *)filename fromRect:(NSRect)rect slideBack:(BOOL)aFlag event:(NSEvent *)event
{
    NSLog(@"%@", filename);
    return YES;
}

@end
