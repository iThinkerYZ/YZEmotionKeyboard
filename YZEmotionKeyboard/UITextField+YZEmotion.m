//
//  UITextField+YZEmotion.m
//  Emoji
//
//  Created by yz on 16/8/6.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "UITextField+YZEmotion.h"
#import "YZTextAttachment.h"

@implementation UITextField (YZEmotion)


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
