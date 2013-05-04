//
//  NVRPreferences.h
//  nvRe
//
//  Created by Seong Jae Lee on 4/13/13.
//  Copyright (c) 2013 Seong Jae Lee. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NVRPreferences : NSWindowController

- (void)showWindow:(id)sender;
- (IBAction)changeEditorFont:(id)sender;

- (NSFont *)editorFont;

@end
