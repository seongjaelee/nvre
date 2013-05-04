//
//  NVRPreferences.m
//  nvRe
//
//  Created by Seong Jae Lee on 4/13/13.
//  Copyright (c) 2013 Seong Jae Lee. All rights reserved.
//

#import "NVRPreferences.h"

@implementation NVRPreferences

- (id)init
{
    self = [super initWithWindowNibName:@"NVRPreferences"];
    if (self) {
        
    }
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)changeEditorFont:(id)sender
{
    if ([[self window] makeFirstResponder:nil]) {
        NSFontManager *fontManager = [NSFontManager sharedFontManager];
        [fontManager setSelectedFont:[self editorFont] isMultiple:NO];
        [fontManager orderFrontFontPanel:self];
    }
}

- (void)showWindow:(id)sender
{
    if (![[super window] isVisible]) {
		[[super window] center];
    }
	[[super window] makeKeyAndOrderFront:self];
}

- (NSFont *)editorFont {
    return [NSFont userFixedPitchFontOfSize:0.0];
}

@end
