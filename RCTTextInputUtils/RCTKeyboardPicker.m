//
//  RCTKeyboardPicker.m
//  RCTKeyboardToolbar
//
//  Created by Kanzaki Mirai on 11/9/15.
//  Copyright © 2015 DickyT. All rights reserved.
//
#import "RCTKeyboardPicker.h"

@implementation RCTKeyboardPicker

- (id)init
{
    self = [super init];
    self.delegate = self;
    self.dataSource = self;

    self.viewData = [[NSMutableArray alloc]init];
    [self.viewData addObject:@{
                               @"price" : [NSNumber numberWithInt:50],
                               @"credit" : [NSNumber numberWithInt:500]
                               }];
    
    [self.viewData addObject:@{
                               @"price" : [NSNumber numberWithInt:100],
                               @"credit" : [NSNumber numberWithInt:1000]
                               }];
    
    [self.viewData addObject:@{
                               @"price" : [NSNumber numberWithInt:200],
                               @"credit" : [NSNumber numberWithInt:2000]
                               }];
    return self;
}

- (void)setCallbackObject:(id)anObject withSelector:(SEL)selector
{
    self.callbackObject = anObject;
    self.callbackSeletor = selector;
}

- (void)setData:(NSArray*)viewData
{
    self.viewData = [[NSMutableArray alloc]initWithArray:viewData];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.viewData count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *currentData = [self.viewData objectAtIndex:row];
    return currentData;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.callbackObject performSelector:self.callbackSeletor withObject:self];
}

@end