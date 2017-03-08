//
//  CustomToolbarView.m
//  ColorPanel
//
//  Created by Gaurav Khanna on 1/6/13.
//  Copyright (c) 2013 Khanna Enterprises Inc. All rights reserved.
//

#import "CustomToolbarView.h"

@interface CustomPatternView : NSView

@end

@implementation CustomPatternView

- (BOOL)isOpaque {
    return NO;
}

- (void)drawRect:(NSRect)dirtyRect {
    NSColor *imageColor = [NSColor colorWithPatternImage:[NSImage imageNamed:@"toolbar_bg"]];
    [imageColor setFill];
    NSRectFill(dirtyRect);
}

@end

@implementation CustomToolbarView

- (id)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (BOOL)isOpaque {
    return NO;
}

- (void)setup {
    //self.autoresizesSubviews = YES;
    //NSView *pattern = [[CustomPatternView alloc] initWithFrame:self.bounds];
    //[pattern setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    //NSColor *imageColor = [NSColor colorWithPatternImage:[NSImage imageNamed:@"toolbar_bg"]];
//    pattern.layer.backgroundColor = imageColor.CGColor;
//[self.patternView setAlphaValue:0.8];

    //[self addSubview:pattern];
//self.layer.backgroundColor = imageColor.CGColor;
}



- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // set any NSColor for filling, say white:
    //[[NSColor blackColor] setFill];
    NSColor *imageColor = [NSColor colorWithPatternImage:[NSImage imageNamed:@"toolbar_bg"]];
    //NSColor *alphaColor = [imageColor colorWithAlphaComponent:.08];
    //[alphaColor set];

    [imageColor setFill];
    NSRectFill(dirtyRect);
    //NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);

}

@end
