//
//  FlexibleInputView.h
//  
//
//  Created by Louis Liu on 28/09/2016.
//  Copyright © 2016 Louis Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define defaultBGColor  [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0]
#define screenWidth  [UIScreen mainScreen].bounds.size.width

@protocol FlexibleInputViewDelegate <NSObject>

@required
-(void)onSendBtnTapped:(UITextView *)textView text:(NSString *)text;

@optional
-(void)onKeyboardRectChanging:(CGRect)rect isShowing:(BOOL)isShowing;

@end

@interface FlexibleInputView : UIView
- (instancetype)initWithOrigin:(CGPoint)point height:(NSInteger)height;
@property (weak, nonatomic) id<FlexibleInputViewDelegate> delegate;
@end
