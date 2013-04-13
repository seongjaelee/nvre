//
//  NVRMarkdownHighlighter.h
//  nvRe
//
//  Created by Seong Jae Lee on 4/13/13.
//  Copyright (c) 2013 Seong Jae Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NVRMarkdownHighlighter : NSObject

- (id)initWithTextView:(NSTextView *)textView;
- (void)activate;
- (void)deactivate;

@end
