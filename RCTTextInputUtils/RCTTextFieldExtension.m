//
//  RCTTextFieldExtension.m
//  RCTKeyboardToolbar
//
//  Created by Kanzaki Mirai on 11/10/15.
//  Copyright © 2015 DickyT. All rights reserved.
//

#import "RCTTextFieldExtension.h"
#import "RCTUITextField.h"


@implementation RCTTextField (RCTTextFieldExtension)

- (void)setSelectedRange:(NSRange)range
{

    UITextView *textField = nil;

    UITextPosition* beginning = textField.beginningOfDocument;
    UITextPosition* startPosition = [textField positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [textField positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [textField textRangeFromPosition:startPosition toPosition:endPosition];
    [textField setSelectedTextRange:selectionRange];
    }

@end
