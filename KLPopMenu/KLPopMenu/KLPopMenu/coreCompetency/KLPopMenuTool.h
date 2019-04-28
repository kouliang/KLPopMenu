//
//  KLPopMenuTool.h
//  KLPopMenu
//
//  Created by kou on 2019/4/24.
//  Copyright © 2019年 kouliang. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const KLPopMenuNextGroup;
UIKIT_EXTERN NSString * const KLPopMenuPreviousGroup;
UIKIT_EXTERN NSUInteger const KLPopMenuFontSize;
UIKIT_EXTERN NSUInteger const KLPopMenuHeight;

typedef NS_ENUM(NSInteger, KLMenuViewArrowDirection) {
    KLMenuViewArrowDirectionNoDef,
    KLMenuViewArrowDirectionUp,
    KLMenuViewArrowDirectionDown,
};

@interface KLPopMenuTool : NSObject

/**
 创建背景图
 
 @param size 图片尺寸
 @param arrowDirection 箭头方向
 @param arrowPosition 箭头位置
 @param splitPositions 分割线位置
 @param isHighlight 高亮显示
 @return UIImage
 */
+ (UIImage *)creatImageWithSize:(CGSize)size arrowDirection:(KLMenuViewArrowDirection)arrowDirection arrowPosition:(CGFloat)arrowPosition splitPositions:(NSArray<NSNumber *> *)splitPositions isHighlight:(BOOL)isHighlight;

+ (NSArray<NSValue *> *)rectsWidthItemList:(NSArray<NSString *> *)itemList systemFontSize:(CGFloat)fontSize rectHeight:(CGFloat)rectHeight;
@end
