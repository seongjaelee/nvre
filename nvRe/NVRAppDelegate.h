//
//  NVRAppDelegate.h
//  nvRe
//
//  Created by Seong Jae Lee on 4/13/13.
//  Copyright (c) 2013 Seong Jae Lee. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NVRPreferences.h"

@interface NVRAppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSUserDefaultsController *sharedUserDefaultsController;
    IBOutlet NVRPreferences *preferencesController;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextView *textView;
@property (assign) NVRPreferences *preferencesController;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;
- (IBAction)openDocument:(id)sender;

@end
