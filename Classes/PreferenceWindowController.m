//
//  PreferenceWindowController.m
//  ColorPanel
//
//  Created by Gaurav Khanna on 10/17/12.
//  Copyright (c) 2012 Khanna Enterprises Inc. All rights reserved.
//

#import "PreferenceWindowController.h"

@implementation PreferenceWindowController

//- (id)initWithWindow:(NSWindow *)window
//{
//    self = [super initWithWindow:window];
//    if (self) {
//        // Initialization code here.
//    }
//    
//    return self;
//}
//
//- (void)windowDidLoad
//{
//    [super windowDidLoad];
//    
//    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
//}

- (IBAction)fillCurrentSizeButton:(id)sender {
    [[GKAppDelegate windowController] setWindowSizeAsDefaultSize];
}
@end
