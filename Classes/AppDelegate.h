//
//  AppDelegate.h
//  ColorPanel
//
//  Created by Gaurav Khanna on 1/23/10.
//

#import <Cocoa/Cocoa.h>
#import "WindowController.h"
#import "INAppStoreWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> 

@property WindowController *windowController;
@property (weak) IBOutlet NSMenuItem *dockFloatingMenuItem;

@end
