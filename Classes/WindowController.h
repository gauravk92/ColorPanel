//
//  WindowController.h
//  ColorPicker
//
//  Created by Gaurav Khanna on 2/28/10.
//

#import <Cocoa/Cocoa.h>
#import "ColorPanel.h"
#import "CustomToolbarView.h"
//#import "MDSectionedTableView.h"
//#import "CustomWindow.h"

#define TRANSLUCENT_WINDOW 0
#define CUSTOM_WINDOW 0

//  NSUserDefaults preferences key paths

extern NSString * const DefaultFloatingEnabled;
extern NSString * const FloatingEnabled;
extern NSString * const DefaultSizeEnabled;
extern NSString * const DefaultWidth;
extern NSString * const DefaultHeight;
extern NSString * const HotkeysEnabled;


@interface WindowController : NSWindowController <NSWindowDelegate> {
    BOOL _isSetup;
}

@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSView *toolbarView;
@property NSColorPanel *colorPanel;
@property (weak) NSView *colorPanelView;
@property NSView *view;

- (ColorPanel*)window;
- (void)setWindowSizeAsDefaultSize;
- (void)setWindowFloating:(BOOL)floating animated:(BOOL)animated;

@end
