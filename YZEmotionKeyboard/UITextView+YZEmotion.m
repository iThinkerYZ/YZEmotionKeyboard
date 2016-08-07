//
//  UITextView+YZEmotion.m
//  Emoji
//
//  Created by yz on 16/8/6.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "UITextView+YZEmotion.h"
#import "YZTextAttachment.h"

@implementation UITextView (YZEmotion)
- (void)setYz_emotionKeyboard:(YZEmotionKeyboard *)yz_emotionKeyboard
{
    self.inputView = yz_emotionKeyboard;
    [self reloadInputViews];
    yz_emotionKeyboard.textView = self;
    
}
- (YZEmotionKeyboard *)yz_emotionKeyboard
{
    return (YZEmotionKeyboard *)self.inputView;
}
@end
