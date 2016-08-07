//
//  YZEmotionKeyboard.m
//  YZEmotionKeyboardDemo
//
//  Created by yz on 16/8/6.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "YZEmotionKeyboard.h"
#import "YZTextAttachment.h"
#import "YZEmotionPageCell.h"
#import "YZEmotionManager.h"

static NSString * const ID = @"emotion";

#define ScreenW [UIScreen mainScreen].bounds.size.width

@interface YZEmotionKeyboard ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *categoryEmotionView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) UITextView *yz_textView;
@end

@implementation YZEmotionKeyboard

- (void)awakeFromNib
{
    // 设置collectionView
    [self setupCollectionView];

    // 设置pageControl
    [self setupPageControl];
    
    [self setupBottonButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectEmotion:) name:@"didSelectEmotion" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickDelete) name:@"didClickDelete" object:nil];
    
    
}

- (void)setupBottonButton
{
    UIButton *emotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emotionButton.frame = CGRectMake(0, 0, 30, 30);
    emotionButton.backgroundColor = _sendButton.backgroundColor;
    NSString *imageN = [NSString stringWithFormat:@"Emotion.bundle/smile"];
    [emotionButton setImage:[UIImage imageNamed:imageN] forState:UIControlStateNormal];
    [self.categoryEmotionView addSubview:emotionButton];
}

- (void)setupPageControl
{
    self.pageControl.numberOfPages = [YZEmotionManager emotionPage];
    self.pageControl.userInteractionEnabled = NO;
    
}

// 点击pageControl上小点
- (void)tapDotAction:(UITapGestureRecognizer *)tap
{
    CGFloat offsetX = tap.view.tag * self.bounds.size.width;
    [_collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


+ (instancetype)emotionKeyboard
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

// 点击发送按钮
- (IBAction)clickSend:(id)sender {
    if (_sendContent) {
        _sendContent([self emotionText]);
    }
}

// 获取表情字符串
- (NSString *)emotionText
{
    
    NSMutableString *strM = [NSMutableString string];
    
    [_yz_textView.attributedText enumerateAttributesInRange:NSMakeRange(0, _yz_textView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *str = nil;
        
        YZTextAttachment *attachment = attrs[@"NSAttachment"];
        
        if (attachment) { // 表情
            str = attachment.emotionStr;
            [strM appendString:str];
        } else { // 文字
            str = [_yz_textView.attributedText.string substringWithRange:range];
            [strM appendString:str];
        }
        
    }];
    return strM;
}



// 点击删除按钮
- (void)didClickDelete
{
    [_yz_textView deleteBackward];
}

// 点击表情
- (void)didSelectEmotion:(NSNotification *)note
{
    YZTextAttachment *attachment = note.object;
    
    NSRange range = _yz_textView.selectedRange;
    
    // 设置textView的文字
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithAttributedString:_yz_textView.attributedText];
    
    NSAttributedString *imageAttr = [NSMutableAttributedString attributedStringWithAttachment:attachment];
    
    [textAttr replaceCharactersInRange:_yz_textView.selectedRange withAttributedString:imageAttr];
    [textAttr addAttributes:@{NSFontAttributeName : _yz_textView.font} range:NSMakeRange(_yz_textView.selectedRange.location, 1)];
    
    _yz_textView.attributedText = textAttr;
    
    // 会在textView后面插入空的,触发textView文字改变
    [_yz_textView insertText:@""];
    
    // 设置光标位置
    _yz_textView.selectedRange = NSMakeRange(range.location + 1, 0);
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTextView:(UITextView *)textView
{
    _textView  = textView;
    if (!([textView isKindOfClass:[UITextField class]] || [textView isKindOfClass:[UITextView class]])) {
        @throw [NSException exceptionWithName:@"Error" reason:@"传入UITextField或者UITextView" userInfo:nil];
    }
    _yz_textView = textView;
    _yz_textView.inputView = self;
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(ScreenW, self.collectionView.bounds.size.height);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerClass:[YZEmotionPageCell class] forCellWithReuseIdentifier:ID];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
}

#pragma mark - UICollectionViewDataSource
// 返回多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// 返回每组多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [YZEmotionManager emotionPage];
}

// 返回cell外观
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZEmotionPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.emotions = [YZEmotionManager emotionsOfPage:indexPath.row];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / self.bounds.size.width;
    
    self.pageControl.currentPage = page;
}


@end
