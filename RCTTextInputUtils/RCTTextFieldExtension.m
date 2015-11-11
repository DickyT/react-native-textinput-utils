//
//  RCTTextFieldExtension.m
//  RCTKeyboardToolbar
//
//  Created by Kanzaki Mirai on 11/10/15.
//  Copyright © 2015 DickyT. All rights reserved.
//

#import "RCTTextFieldExtension.h"

@implementation RCTTextField (RCTTextFieldExtension)

- (void)setSelectedRange:(NSRange)range
{
    UITextPosition* beginning = self.beginningOfDocument;
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

@end
