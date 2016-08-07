//
//  YZEmotionManager.h
//  YZEmotionKeyboardDemo
//
//  Created by yz on 16/8/6.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <Foundation/Foundation.h>
// 一页多少个
static NSInteger const emojiCountOfPage = 20;

// 一页多少列
static NSInteger const colsOfPage = 7;

// 每个emotion尺寸
static NSInteger const emotionWH = 30;

@interface YZEmotionManager : NSObject

/** 所有表情 */
+ (NSArray *)emotions;

/** 表情转字符串字典 */
+ (NSDictionary *)emotionToTextDict;

/** 总页码 */
+ (NSInteger)emotionPage;

/**
 *  指定页码，返回当前页的表情
 *
 *  @param page 页码
 *
 *  @return 当前页的标签
 */
+ (NSArray *)emotionsOfPage:(NSInteger)page;

@end
