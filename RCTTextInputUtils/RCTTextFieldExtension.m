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
    UITextPosition* beginning = self.backedTextInputView.beginningOfDocument;
    UITextPosition* startPosition = [self.backedTextInputView positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self.backedTextInputView positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self.backedTextInputView textRangeFromPosition:startPosition toPosition:endPosition];
    [self.backedTextInputView setSelectedTextRange:selectionRange];
}

- (void)invalidateInputAccessoryView {
    // prevents input accessory being removed
}

@end
