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
        RCTTextField *textView = ((RCTTextField *)view);
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
