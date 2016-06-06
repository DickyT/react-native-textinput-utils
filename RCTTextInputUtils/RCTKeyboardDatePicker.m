
#import "RCTKeyboardDatePicker.h"
#import "RCTConvert.h"
#import "RCTDatePickerManager.h"

@implementation RCTKeyboardDatePicker

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self addTarget:self action:@selector(didChange)
       forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)setCallbackObject:(id)anObject withSelector:(SEL)selector
{
    self.callbackObject = anObject;
    self.callbackSeletor = selector;
}

- (void)didChange
{
    [self.callbackObject performSelector:self.callbackSeletor withObject:self];
}

-(void)setOptions:(NSDictionary *)options
{
    self.minimumDate = [RCTConvert NSDate:[options objectForKey:@"minimumDate"]];
    self.maximumDate = [RCTConvert NSDate:[options objectForKey:@"maximumDate"]];
    self.minuteInterval = [RCTConvert NSInteger:[options objectForKey:@"minuteInterval"]];
    self.datePickerMode = [RCTConvert UIDatePickerMode:[options objectForKey:@"mode"]];
    self.timeZone = [RCTConvert NSTimeZone:[options objectForKey:@"timeZoneOffsetInMinutes"]];
}

@end