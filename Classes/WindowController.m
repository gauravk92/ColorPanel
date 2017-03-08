//
//  WindowController.m
//  ColorPicker
//
//  Created by Gaurav Khanna on 2/28/10.
//

#import "WindowController.h"

NSString * const DefaultFloatingEnabled = @"DefaultFloatingEnabled";
NSString * const FloatingEnabled = @"FloatingEnabled";
NSString * const DefaultSizeEnabled = @"DefaultSizeEnabled";
NSString * const DefaultWidth = @"DefaultWidth";
NSString * const DefaultHeight = @"DefaultHeight";
NSString * const HotkeysEnabled = @"HotkeysEnabled";

@implementation WindowController

#pragma mark - Object lifecycle

//- (id)initWithWindow:(NSWindow *)window {
//    if(self = [super initWithWindow:window]) {
//        if (!_isSetup) {
//            [self setup];
//            _isSetup = YES;
//        }
//    }
//    return self;
//}
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    if (!_isSetup) {
//        [self setup];
//        _isSetup = YES;
//    }
//}

// Cannot call self.window here with any certainty
- (void)setup {
    //[self becomeFirstResponder];
    NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];

//  BFColorPickerPopover ViewController example

#if CUSTOM_WINDOW
    //self.colorPanel = colorPanel;

    CGRect bounds = CGRectMake(100.0f, 0.0f, 150.0f, 400.0f);

    //NSView *view = [[NSView alloc] initWithFrame:bounds];
    //self.view = view;

    // If the shared color panel is visible, close it, because we need to steal its views.
    if ([NSColorPanel sharedColorPanelExists] && [[NSColorPanel sharedColorPanel] isVisible]) {
        [[NSColorPanel sharedColorPanel] orderOut:self];
        //[NSColorWell deactivateAll];
    }

    self.colorPanel = [NSColorPanel sharedColorPanel];
    self.colorPanel.showsAlpha = YES;

    // Steal the color panel's toolbar icons ...
    NSMutableArray *tabbarItems = [[NSMutableArray alloc] initWithCapacity:6];
    NSToolbar *toolbar = self.colorPanel.toolbar;
    NSUInteger selectedIndex = 0;
    for (NSUInteger i = 0; i < toolbar.items.count; i++) {
        NSToolbarItem *toolbarItem = toolbar.items[i];
        NSImage *image = toolbarItem.image;

        //            BFIconTabBarItem *tabbarItem = [[BFIconTabBarItem alloc] initWithIcon:image tooltip:toolbarItem.toolTip];
        //            [tabbarItems addObject:tabbarItem];

        if ([toolbarItem.itemIdentifier isEqualToString:toolbar.selectedItemIdentifier]) {
            selectedIndex = i;
        }
    }

    // ... and put them into a custom toolbar replica.
    //        self.tabbar = [[BFIconTabBar alloc] init];
    //        self.tabbar.delegate = self;
    //        self.tabbar.items = tabbarItems;
    //        self.tabbar.frame = CGRectMake(0.0f, view.bounds.size.height - tabbarHeight, view.bounds.size.width, tabbarHeight);
    //        self.tabbar.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
    //        [self.tabbar selectIndex:selectedIndex];
    //        [view addSubview:self.tabbar];

    // Add the color picker view.
    self.colorPanelView = self.colorPanel.contentView;
    self.colorPanelView.frame = self.contentView.bounds; // CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height); //- tabbarHeight);
    self.colorPanelView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.contentView addSubview:self.colorPanelView];

    // Find and remove the color swatch resize dimple, because it crashes if used outside of a panel.
    NSArray *panelSubviews = [NSArray arrayWithArray:self.colorPanelView.subviews];
    for (NSView *subview in panelSubviews) {
        if ([subview isKindOfClass:NSClassFromString(@"NSColorPanelResizeDimple")]) {
            [subview removeFromSuperview];
        }
    }

    if (self.isWindowLoaded) {
        [self.window setTitleBarHeight:40.0];
        [self.window setCenterFullScreenButton:YES];
        [self.contentView addSubview:self.view];
#if TRANSLUCENT_WINDOW
        [self.window setOpaque:NO];
        [self.window setBackgroundColor:[NSColor clearColor]];
#endif
        //[self.window setContentView:self.view];
        //[self.window.contentView addSubview:self.view];
    }
    //[self.window setContentView:self.view];
#else
    [self setWindow:colorPanel];
    [colorPanel setDelegate:self];
    [colorPanel makeKeyWindow];
#endif
    //        NSView *contentView = colorPanel.contentView;
    //        NSSplitView *viewBox = [[NSSplitView alloc] initWithFrame:contentView.bounds];
    //        [viewBox setVertical:YES];
    //
    //        CustomToolbarView *toolbarView = [[CustomToolbarView alloc] initWithFrame:NSMakeRect(0, 0, 100, 200)];
    //        [viewBox addSubview:toolbarView];
    //
    //        NSRect frameRect = [[colorPanel contentView] bounds];
    //        [[colorPanel contentView] removeFromSuperview];
    //        [viewBox addSubview:[colorPanel contentView]];
    //        [colorPanel setContentView:viewBox];
    //        [[colorPanel contentView] addSubview:toolbarView];
    //        [[colorPanel contentView] dump];

    // HACK: autosave interferes with setting window size on startup
    //[self setWindowFrameAutosaveName:( [NSDef boolForKey:DefaultSizeEnabled] ? @"" : @"ColorPanelAppWindow" )];

    //[self.window setHidesOnDeactivate:NO];

    //[NSDef setBool:[NSDef boolForKey:DefaultFloatingEnabled] forKey:FloatingEnabled];
    //[self setWindowFloating:[NSDef boolForKey:DefaultFloatingEnabled] animated:TRUE];

    [NSDef addObserver:self forKeyPath:DefaultFloatingEnabled options:NSKeyValueObservingOptionNew context:NULL];
    [NSDef addObserver:self forKeyPath:FloatingEnabled options:NSKeyValueObservingOptionNew context:NULL];
    [NSDef addObserver:self forKeyPath:DefaultSizeEnabled options:NSKeyValueObservingOptionNew context:NULL];
    [NSDef addObserver:self forKeyPath:DefaultWidth options:NSKeyValueObservingOptionNew context:NULL];
    [NSDef addObserver:self forKeyPath:DefaultHeight options:NSKeyValueObservingOptionNew context:NULL];
    [NSDef addObserver:self forKeyPath:HotkeysEnabled options:NSKeyValueObservingOptionNew context:NULL];

    // TODO: [colorPanel setTitle:@"ColorPanel"];

}

// http://stackoverflow.com/questions/2427889/pointer-to-nswindow-xib-after-loading-it
// this is a simple override of -showWindow: to ensure the window is always centered
//- (IBAction)showWindow:(id)sender
//{
//    [self.window center];
//    [super showWindow:sender];
//
//    //CGRect bounds = CGRectMake(0.0f, 0.0f, 250.0f, 400.0f);
//    //[self.view setFrame:bounds];
//    //[self.colorPanelView setFrame:bounds];
//
//    
//}

- (void)dealloc {
    [NSDef removeObserver:self forKeyPath:DefaultFloatingEnabled];
    [NSDef removeObserver:self forKeyPath:FloatingEnabled];
    [NSDef removeObserver:self forKeyPath:DefaultSizeEnabled];
    [NSDef removeObserver:self forKeyPath:DefaultWidth];
    [NSDef removeObserver:self forKeyPath:DefaultHeight];
    [NSDef removeObserver:self forKeyPath:HotkeysEnabled];
}

#pragma mark - NSWindow class hacks

// HACK: autosave interferes with setting window size on startup
- (id)windowFrameAutosaveName {
    return ( [NSDef boolForKey:DefaultSizeEnabled] ? @"" : @"ColorPanelAppWindow" );
}

#pragma mark - Window logic

//- (void)windowWillLoad {
//    [super windowWillLoad];
//    DLogFunc();
//    DLogObject([self windowNibName]);
//}
//

- (void)loadWindow {
    [super loadWindow];
    //DLogFunc();
    [self setup];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window.contentView dump];
}

//- (void)windowWillLoad {
//    DLogFunc();
//    DLogObject(self.window);
//}
//
//- (void)windowDidLoad {
//    DLogFunc();
//    NSView *viewBox = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 300, 300)];
//    NSArray *viewsArr = [NSArray arrayWithArray:[self.window.contentView subviews]];
//    [viewsArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        if ([obj respondsToSelector:@selector(removeFromSuperview)]) {
//            [obj performSelector:@selector(removeFromSuperview)];
//            [viewBox addSubview:obj];
//        }
//    }];
//    [self.window setContentView:viewBox];
//    DLogObject(self.window);
//}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    DLogFunc();
    DLogObject(displayName);
    return @"ColorPanel";
}

- (void)windowWillClose:(NSNotification *)aNotification {
    [NSApp terminate:self];
}

- (void)setWindowSizeAsDefaultSize {
    NSSize windowSize = self.window.frame.size;
    [NSDef setFloat:windowSize.width forKey:DefaultWidth];
    [NSDef setFloat:windowSize.height forKey:DefaultHeight];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([DefaultFloatingEnabled isEqualToString:keyPath]) {
        [NSDef setBool:[NSDef boolForKey:DefaultFloatingEnabled] forKey:FloatingEnabled];
    }

    if ([FloatingEnabled isEqualToString:keyPath]) {
        [self setWindowFloating:[NSDef boolForKey:FloatingEnabled] animated:TRUE];
    }

    /*if ([DefaultSizeEnabled isEqualToString:keyPath]) {
        [self setWindowFrameAutosaveName:( [NSDef boolForKey:DefaultSizeEnabled] ? @"" : @"ColorPanelAppWindow" )];
        //[self setWindowSizeAsDefaultSize];
    }*/

    if ([DefaultWidth isEqualToString:keyPath] && [NSDef boolForKey:DefaultSizeEnabled]) {
        NSRect windowFrame = self.window.frame;
        windowFrame.size = NSMakeSize([NSDef floatForKey:DefaultWidth], windowFrame.size.height);
        [self.window setFrame:windowFrame display:YES];
    }

    if ([DefaultHeight isEqualToString:keyPath] && [NSDef boolForKey:DefaultSizeEnabled]) {
        NSRect windowFrame = self.window.frame;
        windowFrame.size = NSMakeSize(windowFrame.size.width, [NSDef floatForKey:DefaultHeight]);
        [self.window setFrame:windowFrame display:YES];
    }
    
    if ([HotkeysEnabled isEqualToString:keyPath]) {
        
    }

    [NSDef synchronize];
}

#define NSFloatingWindowMask 1 << 4

- (void)setWindowFloating:(BOOL)floating animated:(BOOL)animated {
    if (animated) {
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:.15f];
    }

    NSRect originalWindowFrame = [self.window frame];

    [self.window setLevel:( floating ? NSFloatingWindowLevel : NSNormalWindowLevel )];
    [self.window setStyleMask:NSTitledWindowMask
     | NSClosableWindowMask
     | NSMiniaturizableWindowMask
     | NSResizableWindowMask];
    // | ( floating ? NSFloatingWindowMask : 0 )

    // BUG: the fullscreen arrow is incorrectly positioned and unuseable in floating mode with an NSPanel subclass
    [self.window setCollectionBehavior:NSWindowCollectionBehaviorManaged
     | NSWindowCollectionBehaviorFullScreenAuxiliary
     | NSWindowCollectionBehaviorFullScreenPrimary ];
     //| ( floating ? 0 : NSWindowCollectionBehaviorFullScreenPrimary )];

    // HACK: keep the window frame the same size by accounting for height difference between floating and regular
    originalWindowFrame.size.height -= ( floating ? 16.0 : 28.0 );
    NSRect fixedWindowFrame = [NSWindow frameRectForContentRect:originalWindowFrame styleMask:self.window.styleMask];
    
    [( animated ? self.window.animator : self.window) setFrame:fixedWindowFrame display:YES];

    if (animated) {
        [NSAnimationContext endGrouping];
    }
}

#pragma mark - Table View Data Source / Delegate methods

//- (NSUInteger)numberOfSectionsInTableView:(MDSectionedTableView *)aTableView
//{
//    return 1;
//    //return 1414; // 1 000 000 rows!!!
//}
//
//- (NSUInteger)tableView:(MDSectionedTableView *)aTableView numberOfRowsInSection:(NSUInteger)section
//{
//    return 8;
//}
//
//- (CustomTableViewCell *)tableView:(MDSectionedTableView *)aTableView cellForRow:(NSUInteger)row inSection:(NSUInteger)section
//{
//    static NSString *cellId = @"ToolbarCell";
//    CustomTableViewCell *cell = (CustomTableViewCell*)[aTableView dequeueReusableCellWithIdentifier:cellId];
//
//    if (!cell) {
//        cell = [CustomTableViewCell cellWithReuseIdentifier:cellId];
//    }
//
//    cell.text = [NSString stringWithFormat:@"Row %d of Section %d", row+1, section+1];
//
//    return cell;
//}
//
//- (CustomTableViewCell *)tableView:(MDSectionedTableView *)aTableView cellForHeaderOfSection:(NSUInteger)section
//{
//    static NSString *cellId = @"CustomHeaderCell";
//    CustomTableViewCell *cell = (CustomTableViewCell *)[aTableView dequeueReusableCellWithIdentifier:cellId];
//
//    if (!cell) {
//        cell = [CustomTableViewCell cellWithReuseIdentifier:cellId];
//    }
//
//    cell.text = [NSString stringWithFormat:@"Section Header %d", section+1];
//
//    return cell;
//}
//
//- (void)tableView:(MDSectionedTableView *)tableView didSelectRow:(NSUInteger)row inSection:(NSUInteger)section
//{
//    //[status setStringValue:[NSString stringWithFormat:@"Selected Row %lu in Section %lu", row+1, section+1]];
//}
//
//- (void)tableView:(MDSectionedTableView *)tableView didDoubleClickRow:(NSUInteger)row inSection:(NSUInteger)section
//{
//    //[status setStringValue:[NSString stringWithFormat:@"Double Clicked Row %lu in Section %lu", row+1, section+1]];
//}

@end
