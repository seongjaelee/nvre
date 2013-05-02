//
//  NVRMarkdownHighlighter.m
//  nvRe
//
//  Created by Seong Jae Lee on 4/13/13.
//  Copyright (c) 2013 Seong Jae Lee. All rights reserved.
//

#import "NVRMarkdownHighlighter.h"
#import "NVRPreferencesWindowController.h"
#import "NVRDefaultsKeys.h"

@interface NVRMarkdownHighlighter ()
{
	NSTextView *targetTextView;
}
@end

@implementation NVRMarkdownHighlighter

- (id)init
{
	if (!(self = [super init])) {
		return nil;
    }
    
	targetTextView = nil;
	
	return self;
}

- (id)initWithTextView:(NSTextView *)textView
{
	if (!(self = [self init])) {
		return nil;
    }
    
	targetTextView = textView;
    
	return self;
}

- (void)dealloc
{
	targetTextView = nil;
	
    [super dealloc];
}

#pragma mark -

- (void)highlight
{
    // - todo. we can only highlight the visible area.
    
    [[targetTextView textStorage] beginEditing];
    
    NSString *text = [targetTextView string];
    NSMutableAttributedString *attributedText = [targetTextView textStorage];
    
    //NSFont *font = [[NVRPreferences defaultPreferences] editorFont];
    NSFont *font = [NSFont fontWithName:@"Menlo" size:12.0f];
    //[font maximumAdvancement].width;    
    
    // clear
    [attributedText applyFontTraits:NSUnboldFontMask|NSUnitalicFontMask range:NSMakeRange(0, [text length])];
    [attributedText removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, [text length])];
    [attributedText removeAttribute:NSBackgroundColorAttributeName range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [text length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    float lineHeight = [[NSUserDefaults standardUserDefaults] floatForKey:TextEditorLineHeightKey];
    //[paragraphStyle setLineHeightMultiple:lineHeight];
    [targetTextView setDefaultParagraphStyle:paragraphStyle];

    // headings애    
    // - todo. indent leading tags
    // - todo. support settext-style
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^([#]{1,6}).+$" options:NSRegularExpressionAnchorsMatchLines error:NULL];
        NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
        for (NSTextCheckingResult *match in matches) {
            NSRegularExpression *regexA = [NSRegularExpression regularExpressionWithPattern:@"^[#]{1,6}" options:0 error:NULL];
            NSRange rangeA = [[regexA firstMatchInString:text options:0 range:[match range]] range];
            [attributedText addAttribute:NSForegroundColorAttributeName value:[NSColor grayColor] range:rangeA];
            
            NSRegularExpression *regexC = [NSRegularExpression regularExpressionWithPattern:@"[#]{1,6}$" options:0 error:NULL];
            NSRange rangeC = [[regexC firstMatchInString:text options:0 range:[match range]] range];
            [attributedText addAttribute:NSForegroundColorAttributeName value:[NSColor grayColor] range:rangeC];
            
            NSRange rangeB = NSMakeRange([match range].location + rangeA.length, [match range].length - rangeC.length - rangeA.length);
            [attributedText applyFontTraits:NSBoldFontMask range:rangeB];
        }
    }
    
    // quotation
    // - todo. use paragraph background color instead of highlight
    // - todo. consider the text line below with leading spaces if possible. however, there are few text editors that can do that
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^>.+$" options:NSRegularExpressionAnchorsMatchLines error:NULL];
        NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
        for (NSTextCheckingResult *match in matches) {
            NSRegularExpression *regexA = [NSRegularExpression regularExpressionWithPattern:@"^>[ >]*" options:0 error:NULL];
            NSRange rangeA = [[regexA firstMatchInString:text options:0 range:[match range]] range];
            [attributedText addAttribute:NSForegroundColorAttributeName value:[NSColor grayColor] range:rangeA];
            
            NSRange rangeB = NSMakeRange([match range].location + rangeA.length, [match range].length - rangeA.length);
            [attributedText addAttribute:NSBackgroundColorAttributeName value:[NSColor lightGrayColor] range:rangeB];
        }
    }
    
    // strong
    // \*{2}(?:[^ \*\n\r][^\*\n\r]+[^ \*\n\r]|[^ \*\n\r]{1,2})\*{2}
    // _{2}(?:[^ _\n\r][^_\n\r]+[^ _\n\r]|[^ _\n\r]{1,2})_{2}
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\*{2}(?:[^ \\*\\n\\r][^\\*\\n\\r]+[^ \\*\\n\\r]|[^ \\*\\n\\r]{1,2})\\*{2}|_{2}(?:[^ _\\n\\r][^_\\n\\r]+[^ _\\n\\r]|[^ _\\n\\r]{1,2})_{2}" options:0 error:NULL];
        NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
        for (NSTextCheckingResult *match in matches) {
            NSRange rangeA = NSMakeRange([match range].location, 2);
            [attributedText addAttribute:NSForegroundColorAttributeName value:[NSColor grayColor] range:rangeA];
            
            NSRange rangeC = NSMakeRange([match range].location + [match range].length - 2, 2);
            [attributedText addAttribute:NSForegroundColorAttributeName value:[NSColor grayColor] range:rangeC];
            
            NSRange rangeB = NSMakeRange([match range].location + 2, [match range].length - 4);
            [attributedText applyFontTraits:NSBoldFontMask range:rangeB];
        }
    }
    
    // emphasis
    // (?<!\*)\*(?:[^ \*\n\r][^\*\n\r]+[^ \*\n\r]|[^ \*\n\r]{1,2})\*
    // (?<!_)_(?:[^ _\n\r][^_\n\r]+[^ _\n\r]|[^ _\n\r]{1,2})_
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<!\\*)\\*(?:[^ \\*\\n\\r][^\\*\\n\\r]+[^ \\*\\n\\r]|[^ \\*\\n\\r]{1,2})\\*|(?<!_)_(?:[^ _\\n\\r][^_\\n\\r]+[^ _\\n\\r]|[^ _\\n\\r]{1,2})_" options:0 error:NULL];
        NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
        for (NSTextCheckingResult *match in matches) {
            NSRange rangeA = NSMakeRange([match range].location, 1);
            [attributedText addAttribute:NSForegroundColorAttributeName value:[NSColor grayColor] range:rangeA];
            
            NSRange rangeC = NSMakeRange([match range].location + [match range].length - 1, 1);
            [attributedText addAttribute:NSForegroundColorAttributeName value:[NSColor grayColor] range:rangeC];
            
            NSRange rangeB = NSMakeRange([match range].location + 1, [match range].length - 2);
            [attributedText applyFontTraits:NSItalicFontMask range:rangeB];
        }
    }
    
    // strikethrough
    // horizontal rules
    // fenced code blocks
    // links
    
    [[targetTextView textStorage] endEditing];
}

- (void)textViewTextDidChange:(NSNotification *)notification
{
    [self highlight];
}

#pragma mark -

- (void)activate
{
    [self highlight];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewTextDidChange:)
                                                 name:NSTextDidChangeNotification
                                               object:targetTextView];
}

- (void)deactivate
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSTextDidChangeNotification
                                                  object:targetTextView];
}

@end
