//
//  RCTKeyboardPicker.h
//  RCTKeyboardToolbar
//
//  Created by Kanzaki Mirai on 11/9/15.
//  Copyright © 2015 DickyT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>

@interface RCTKeyboardPicker : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) NSMutableArray* viewData;
@property (nonatomic, retain) id callbackObject;
@property (nonatomic, assign) SEL callbackSeletor;

- (void)setCallbackObject:(id)anObject withSelector:(SEL)selector;

- (void)setData:(NSArray*)viewData;

@end
