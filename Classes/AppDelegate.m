//
//  AppDelegate.m
//  ColorPanel
//
//  Created by Gaurav Khanna on 1/23/10.
//

#import "AppDelegate.h"
#import <ScriptingBridge/ScriptingBridge.h>

@interface NSColor(NSColorHexadecimalValue)
-(NSString *)hexadecimalValueOfAnNSColor;
@end

@implementation NSColor(NSColorHexadecimalValue)

-(NSString *)hexadecimalValueOfAnNSColor
{
    CGFloat redFloatValue, greenFloatValue, blueFloatValue;
    int redIntValue, greenIntValue, blueIntValue;
    NSString *redHexValue, *greenHexValue, *blueHexValue;
    
    //Convert the NSColor to the RGB color space before we can access its components
    NSColor *convertedColor=[self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    
    if(convertedColor)
    {
        // Get the red, green, and blue components of the color
        [convertedColor getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:NULL];
        
        // Convert the components to numbers (unsigned decimal integer) between 0 and 255
        redIntValue=redFloatValue*255.99999f;
        greenIntValue=greenFloatValue*255.99999f;
        blueIntValue=blueFloatValue*255.99999f;
        
        // Convert the numbers to hex strings
        redHexValue=[NSString stringWithFormat:@"%02x", redIntValue];
        greenHexValue=[NSString stringWithFormat:@"%02x", greenIntValue];
        blueHexValue=[NSString stringWithFormat:@"%02x", blueIntValue];
        
        // Concatenate the red, green, and blue components' hex strings together with a "#"
        return [NSString stringWithFormat:@"#%@%@%@", redHexValue, greenHexValue, blueHexValue];
    }
    return nil;
}
@end


@implementation AppDelegate

// Setup hotkey for [colorPanel _magnify:nil];

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSLog(@"%@", NSColorPanelColorDidChangeNotification);
    NSLog(@"%@", NSStringPboardType);
    NSLog(@"%@", NSRGBColorSpaceModel);
    int x = 'A';
    int *data = &x;
    NSData *dataData = [NSData dataWithBytes:data length:sizeof(data)];
    NSLog(@"data = %@", dataData);

//    if (!AXAPIEnabled()) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"assiactivator" ofType:@"scpt"];
//        NSURL *url = [NSURL fileURLWithPath:path];
//        NSDictionary *error = nil;
//        NSAppleScript *scpt = [[NSAppleScript alloc] initWithContentsOfURL:url error:&error];
//        if (scpt) {
//            // act on it
//            NSDictionary *error2 = nil;
//            NSAppleEventDescriptor *event = [scpt executeAndReturnError:&error2];
//            if (!event) {
//                // failure
//                return;
//            }
//        } else {
//            // failrure
//            return;
//        }
//    }
//
//    if ([NSDef boolForKey:HotkeysEnabled]) {
//        [GKHotKeyCenter sharedCenter];
//    }

//    NSArray *mainObjects = nil;
//    BOOL loadWindow = [[NSBundle mainBundle] loadNibNamed:@"CustomWindow" owner:self topLevelObjects:&mainObjects];
//    CustomWindow *window = nil;
//    if (loadWindow) {
//        for (id obj in mainObjects) {
//            if ([obj isKindOfClass:[CustomWindow class]]) {
//                window = obj;
//            }
//        }
//    } else {
//        NSLog(@" FAILED TO LOAD CUSTOM WINDOW FROM NIB FILE");
//        exit(13);
//    }

    //INAppStoreWindow *window = [[INAppStoreWindow alloc] initWithContentRect:CGRectZero styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO];
    
    

    //self.windowController = [[WindowController alloc] initWithWindow:window];
    //self.windowController = [[WindowController alloc] initWithWindowNibName:@"CustomWindow"];

    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:.15f];

    // Sync up the currently working FloatingEnabled property with launch prefs
    BOOL defaultFloating = [NSDef boolForKey:DefaultFloatingEnabled];
    [NSDef setBool:defaultFloating forKey:FloatingEnabled];
    [self.windowController setWindowFloating:defaultFloating animated:FALSE];

    // Sync up the currently working DefaultWidth/Height property with launch prefs
    if ([NSDef boolForKey:DefaultSizeEnabled]) {
        NSRect windowFrame = self.windowController.window.frame;
        windowFrame.size = NSMakeSize([NSDef floatForKey:DefaultWidth], [NSDef floatForKey:DefaultHeight]);
        [self.windowController.window setFrame:windowFrame display:YES animate:YES];
    }

    //[self.windowController showWindow:self];
    [self.windowController.window makeKeyAndOrderFront:nil];

    [NSAnimationContext endGrouping];

    //[[NSApplication sharedApplication] orderFrontColorPanel:self];

//    [NSEvent addGlobalMonitorForEventsMatchingMask:(NSKeyUp | NSFlagsChangedMask) handler:^(NSEvent *e) {
//        DLogFunc();
//        DLogObject(e);
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorPanelColorDidChange:) name:NSColorPanelColorDidChangeNotification object:nil];

}

- (void)colorPanelColorDidChange:(NSNotification*)notif {
    NSColor *color = [NSColorPanel sharedColorPanel].color;
    NSLog(@"color changed: %@", color );
    NSWorkspace *sharedWorkspace = [NSWorkspace sharedWorkspace];
    NSArray *activeApps = sharedWorkspace.runningApplications;
    for (NSUInteger i = 0;i<activeApps.count;i++) {
        NSRunningApplication * app = activeApps[i];
        if (app.isActive && [app.bundleIdentifier hasPrefix:@"com.google.Chrome"]) {
            //SBApplication *control = [SBApplication applicationWithBundleIdentifier:app.bundleIdentifier];
            //NSLog(@"%@", )
            NSString* path = [[NSBundle mainBundle] pathForResource:@"pasteToChrome" ofType:@"scpt"];
            NSURL* url = [NSURL fileURLWithPath:path];
            NSDictionary* errors = [NSDictionary dictionary];
            NSAppleScript* appleScript = [[NSAppleScript alloc] initWithContentsOfURL:url error:&errors];
            [appleScript executeAndReturnError:nil];
        }
        //NSLog(@"app bundle %@", app);
    }
    //NSLog(@"hex: %@", [color hexadecimalValueOfAnNSColor]);
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    [self.windowController.window makeKeyAndOrderFront:self];
    return NO;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [NSDef synchronize];
}

@end