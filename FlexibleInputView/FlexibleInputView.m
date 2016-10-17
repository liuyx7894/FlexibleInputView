//
//  FlexibleInputView.m
//  FlexibleInputView
//
//  Created by Louis Liu on 28/09/2016.
//  Copyright © 2016 Louis Liu. All rights reserved.
//

#import "FlexibleInputView.h"

@interface FlexibleInputView ()<UITextViewDelegate>
@property ( nonatomic) CGPoint rawPoint;
@property (assign, nonatomic) NSInteger rawHeight;
@property (assign, nonatomic) CGFloat latestHeight;
@property (assign, nonatomic) CGFloat edgeHeight;
@property (assign, nonatomic) BOOL isShowing;
@property (assign, nonatomic) CGFloat btnWidth;
@property (strong, nonatomic) UIButton *sendBtn;
@property (strong, nonatomic) UITextView *textView;
@end
@implementation FlexibleInputView

- (instancetype)initWithOrigin:(CGPoint)point height:(NSInteger)height
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, screenWidth, height)];
    if (self) {
        
        _rawHeight = height;
        _rawPoint = point;
        _latestHeight = -1.0;
        _edgeHeight = 5;
        _btnWidth = 50;
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(_edgeHeight, _edgeHeight, screenWidth-_btnWidth-_edgeHeight, height-_edgeHeight*2) textContainer:nil];
        
        [_textView.layer setCornerRadius:5];
        [_textView setScrollEnabled:false];
        [_textView setTextAlignment:NSTextAlignmentLeft];
        [_textView setFont:[UIFont systemFontOfSize:14]];
        [_textView setDelegate:self];
        
        CGFloat fixedHeight = [_textView sizeThatFits:CGSizeMake(_textView.frame.size.width, _textView.frame.size.height)].height;
        _latestHeight = fixedHeight;
        
        _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(_textView.frame.size.width+_edgeHeight, _edgeHeight, _btnWidth, height-_edgeHeight*2)];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(onTappedSendBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn setTitleColor:[UIColor colorWithRed:83.0/255.0 green:214.0/255.0 blue:106.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self addSubview:_sendBtn];
     
        [self addSubview:_textView];
        
        [self updateFramesWithHeight:_textView fixedHeight:fixedHeight];

        [self addKeyboardListener];
    }
    return self;
}

-(void)onTappedSendBtn:(UIButton *)sender{
    if(_delegate != nil && [_delegate respondsToSelector:@selector(onSendBtnTapped:text:)]){
        [_delegate onSendBtnTapped:_textView text:_textView.text];
    }
    [_textView setText:@""];
    [self endEditing:true];
}

-(void)addKeyboardListener{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShowing:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardChangingFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHiding:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)onKeyboardShowing:(NSNotification *)sender{

    if(_isShowing){
        return;
    }
    _isShowing = true;
    CGRect keyboardFrame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x,
                                  self.frame.origin.y-keyboardFrame.size.height,
                                  self.frame.size.width,
                                  self.frame.size.height)];
    }];
    if(_delegate != nil && [_delegate respondsToSelector:@selector(onKeyboardHeightChanging: isShowing:)]){
        [_delegate onKeyboardHeightChanging:keyboardFrame.size.height isShowing:true];
    }
    
}

-(void)onKeyboardChangingFrame:(NSNotification *)sender{
    CGRect startFrame = [sender.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offset = startFrame.size.height - endFrame.size.height;
    if(offset == 0){
        return;
    }

    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x,
                                  self.frame.origin.y+offset,
                                  self.frame.size.width,
                                  self.frame.size.height)];
    }];
    
    if(_delegate != nil && [_delegate respondsToSelector:@selector(onKeyboardHeightChanging: isShowing:)]){
        [_delegate onKeyboardHeightChanging:-offset isShowing:true];
    }
}

-(void)onKeyboardHiding:(NSNotification *)sender{
    if(!_isShowing){
        return;
    }
    _isShowing = false;
    CGRect keyboardFrame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x,
                                  self.frame.origin.y+keyboardFrame.size.height,
                                  self.frame.size.width,
                                  self.frame.size.height)];
    }];
    
    if(_delegate != nil && [_delegate respondsToSelector:@selector(onKeyboardHeightChanging: isShowing:)]){
        [_delegate onKeyboardHeightChanging:-keyboardFrame.size.height isShowing:false];
    }
}

-(void) updateFramesWithHeight:(UITextView *)textView fixedHeight:(NSInteger)fixedHeight{
    [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, screenWidth-55, fixedHeight)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, screenWidth, fixedHeight+10)];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [self textViewDidChange:textView];
}

-(void)textViewDidChange:(UITextView *)textView{
    
    CGFloat fixedHeight = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, textView.frame.size.height)].height;
    CGFloat fixedY = (fixedHeight - _latestHeight);

    if(fixedY!=0){
        [UIView animateWithDuration:0.3 animations:^{
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y-fixedY, screenWidth, fixedHeight+10)];
            
            [textView setFrame:CGRectMake(textView.frame.origin.x,
                                          textView.frame.origin.y,
                                          textView.frame.size.width,
                                          fixedHeight)];
        }];
    }
    
    _latestHeight = fixedHeight;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
 
    if(![self pointInside:point withEvent:event]){
        [self endEditing:true];
    }
    return [super hitTest:point withEvent:event];;
}

@end
