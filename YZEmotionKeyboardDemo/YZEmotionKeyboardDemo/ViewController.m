//
//  ViewController.m
//  YZEmotionKeyboardDemo
//
//  Created by yz on 16/8/6.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "ViewController.h"
#import "YZInputView.h"
#import "UITextView+YZEmotion.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet YZInputView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHCons;
@property (strong, nonatomic) YZEmotionKeyboard *emotionKeyboard;

@end

@implementation ViewController

// 懒加载键盘
- (YZEmotionKeyboard *)emotionKeyboard
{
    // 创建表情键盘
    if (_emotionKeyboard == nil) {
        
        YZEmotionKeyboard *emotionKeyboard = [YZEmotionKeyboard emotionKeyboard];
        
        emotionKeyboard.sendContent = ^(NSString *content){
            // 点击发送会调用，自动把文本框内容返回给你
        };
        
        _emotionKeyboard = emotionKeyboard;
    }
    return _emotionKeyboard;
}

- (IBAction)clickEmtionKeyboard:(UIButton *)sender {
    
    
    
    if (_textView.inputView == nil) {
        _textView.yz_emotionKeyboard = self.emotionKeyboard;
        [sender setBackgroundImage:[UIImage imageNamed:@"toolbar-text"] forState:UIControlStateNormal];
    } else {
        _textView.inputView = nil;
        [_textView reloadInputViews];
        [sender setBackgroundImage:[UIImage imageNamed:@"smail"] forState:UIControlStateNormal];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 设置文本框占位文字
    _textView.placeholder = @"小码哥 iOS培训 吖了个峥";
    _textView.placeholderColor = [UIColor redColor];
    
    // 监听文本框文字高度改变
    _textView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        // 文本框文字高度改变会自动执行这个【block】，可以在这【修改底部View的高度】
        // 设置底部条的高度 = 文字高度 + textView距离上下间距约束
        // 为什么添加10 ？（10 = 底部View距离上（5）底部View距离下（5）间距总和）
        _bottomHCons.constant = textHeight + 10;
    };
    
    // 设置文本框最大行数
    _textView.maxNumberOfLines = 4;
}

-  (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

// 键盘弹出会调用
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 获取键盘frame
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 获取键盘弹出时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 修改底部视图距离底部的间距
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    _bottomCons.constant = endFrame.origin.y != screenH? endFrame.size.height:0;
    
    // 约束动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}


@end
