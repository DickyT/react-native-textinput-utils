//
//  RCTKeyboardToolbar.m
//  RCTKeyboardToolbar
//
//  Created by Kanzaki Mirai on 11/7/15.
//  Copyright © 2015 DickyT. All rights reserved.
//

#import "RCTKeyboardToolbar.h"

#import "RCTBridge.h"
#import "RCTConvert.h"
#import "RCTTextField.h"
#import "RCTTextView.h"
#import "RCTSparseArray.h"
#import "RCTUIManager.h"
#import "RCTEventDispatcher.h"
#import "RCTKeyboardPicker.h"
#import "RCTTextViewExtension.h"

@implementation RCTKeyboardToolbar

#pragma mark -

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue {
    return self.bridge.uiManager.methodQueue;
}

RCT_EXPORT_METHOD(configure:(nonnull NSNumber *)reactNode
                  options:(NSDictionary *)options
                  callback:(RCTResponseSenderBlock)callback) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, RCTSparseArray *viewRegistry) {
        
        UIView *view = viewRegistry[reactNode];
        if (!view) {
            RCTLogError(@"RCTKeyboardToolbar: TAG #%@ NOT FOUND", reactNode);
            return;
        }
        
        // The convert is little bit dangerous, change it if you are going to fock the project
        // Or do not assign any non-common property between UITextView and UITextView
        UITextField *textView;
        if ([view class] == [RCTTextView class]) {
            RCTTextView *reactNativeTextView = ((RCTTextView *)view);
            textView = [reactNativeTextView getTextView];
        }
        else {
            RCTTextField *reactNativeTextView = ((RCTTextField *)view);
            textView = reactNativeTextView;
        }
        
        if (options[@"tintColor"]) {
            NSLog(@"tintColor is %@", options[@"tintColor"]);
            textView.tintColor = [RCTConvert UIColor:options[@"tintColor"]];
        }

        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        NSInteger toolbarStyle = [RCTConvert NSInteger:options[@"barStyle"]];
        numberToolbar.barStyle = toolbarStyle;
        
        NSString *leftButtonText = [RCTConvert NSString:options[@"leftButtonText"]];
        NSString *rightButtonText = [RCTConvert NSString:options[@"rightButtonText"]];
        
        NSNumber *currentUid = [RCTConvert NSNumber:options[@"uid"]];
        
        NSMutableArray *toolbarItems = [NSMutableArray array];
        if (![leftButtonText isEqualToString:@""]) {
            UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:leftButtonText style:UIBarButtonItemStyleBordered target:self action:@selector(keyboardCancel:)];
            leftItem.tag = [currentUid intValue];
            [toolbarItems addObject:leftItem];
        }
        if (![leftButtonText isEqualToString:@""] && ![rightButtonText isEqualToString:@""]) {
            [toolbarItems addObject:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
        }
        if (![rightButtonText isEqualToString:@""]) {
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:rightButtonText style:UIBarButtonItemStyleDone target:self action:@selector(keyboardDone:)];
            rightItem.tag = [currentUid intValue];
            [toolbarItems addObject:rightItem];
        }
        numberToolbar.items = toolbarItems;
        
        NSArray *pickerData = [RCTConvert NSArray:options[@"pickerViewData"]];
        
        if (pickerData.count > 0) {
            RCTKeyboardPicker *pickerView = [[RCTKeyboardPicker alloc]init];
            pickerView.tag = [currentUid intValue];
            [pickerView setCallbackObject:self withSelector:@selector(valueSelected:)];
            [pickerView setData:pickerData];
            textView.inputView = pickerView;
        }
        
        [numberToolbar sizeToFit];
        textView.inputAccessoryView = numberToolbar;
        
        callback(@[[NSNull null], [currentUid stringValue]]);
    }];
}

RCT_EXPORT_METHOD(dismissKeyboard:(nonnull NSNumber *)reactNode) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, RCTSparseArray *viewRegistry) {
        
        UIView *view = viewRegistry[reactNode];
        if (!view) {
            RCTLogError(@"RCTKeyboardToolbar: TAG #%@ NOT FOUND", reactNode);
            return;
        }
        RCTTextField *textView = ((RCTTextField *)view);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [textView resignFirstResponder];
        });
    }];
}

RCT_EXPORT_METHOD(moveCursorToLast:(nonnull NSNumber *)reactNode) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, RCTSparseArray *viewRegistry) {
        
        UIView *view = viewRegistry[reactNode];
        if (!view) {
            RCTLogError(@"RCTKeyboardToolbar: TAG #%@ NOT FOUND", reactNode);
            return;
        }
        RCTTextField *textView = ((RCTTextField *)view);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UITextPosition *position = [textView endOfDocument];
            textView.selectedTextRange = [textView textRangeFromPosition:position toPosition:position];
        });
    }];
}

RCT_EXPORT_METHOD(setSelectedTextRange:(nonnull NSNumber *)reactNode
                  options:(NSDictionary *)options) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, RCTSparseArray *viewRegistry) {
        
        UIView *view = viewRegistry[reactNode];
        if (!view) {
            RCTLogError(@"RCTKeyboardToolbar: TAG #%@ NOT FOUND", reactNode);
            return;
        }
        RCTTextField *textView = ((RCTTextField *)view);
        
        NSNumber *startPosition = [RCTConvert NSNumber:options[@"start"]];
        NSNumber *endPosition = [RCTConvert NSNumber:options[@"length"]];
        
        NSRange range  = NSMakeRange([startPosition integerValue], [endPosition integerValue]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UITextPosition *from = [textView positionFromPosition:[textView beginningOfDocument] offset:range.location];
            UITextPosition *to = [textView positionFromPosition:from offset:range.length];
            [textView setSelectedTextRange:[textView textRangeFromPosition:from toPosition:to]];
        });
    }];
}

- (void)valueSelected:(RCTKeyboardPicker*)sender
{
    NSNumber *selectedIndex = [NSNumber numberWithLong:[sender selectedRowInComponent:0]];
    NSLog(@"Selected %d", [selectedIndex intValue]);
    NSNumber *currentUid = [NSNumber numberWithLong:sender.tag];
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"keyboardPickerViewDidSelected"
                                                    body:@{@"currentUid" : [currentUid stringValue], @"selectedIndex": [selectedIndex stringValue]}];
}

- (void)keyboardCancel:(UIBarButtonItem*)sender
{
    NSNumber *currentUid = [NSNumber numberWithLong:sender.tag];
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"keyboardToolbarDidTouchOnCancel"
                                                    body:@([currentUid intValue])];
}

- (void)keyboardDone:(UIBarButtonItem*)sender
{
    NSNumber *currentUid = [NSNumber numberWithLong:sender.tag];
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"keyboardToolbarDidTouchOnDone"
                                                    body:@([currentUid intValue])];
}

@end
