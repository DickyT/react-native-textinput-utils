#import <UIKit/UIKit.h>

@interface RCTKeyboardDatePicker : UIDatePicker

@property (nonatomic, retain) id callbackObject;
@property (nonatomic, assign) SEL callbackSeletor;

- (void)setOptions:(NSDictionary*)options;
- (void)setCallbackObject:(id)anObject withSelector:(SEL)selector;

@end