//
//  KLPopMenuView.h
//  KLPopMenu
//
//  Created by kou on 2019/4/24.
//  Copyright © 2019年 kouliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLPopMenuTool.h"

/** demo
 KLPopMenuView *menuView = [[KLPopMenuView alloc] initWithItemList:_itemList arrowDirection:popDirection];
 CGSize menuViewSize = menuView.recommendSize;
 //calculate use menuViewSize
 CGFloat originX,originY,arrowPosition;
 originX = ...
 originY = ...
 arrowPosition = ...
 
 menuView.frame = CGRectMake(originX, originY, menuViewSize.width, menuViewSize.height);
 [superView addSubview:menuView];
 [menuView showWithArrowPosition:arrowPosition];
 */

@protocol KLPopMenuViewDelegate<NSObject>
@optional
- (void)popMenuView:(UIView *)menuView ClickedIndex:(NSUInteger)index withTitle:(NSString *)title;
@end

@interface KLPopMenuView : UIView
@property (weak, nonatomic) id<KLPopMenuViewDelegate> delegate;
@property (assign, nonatomic, readonly) CGSize recommendSize;

- (instancetype)initWithItemList:(NSArray<NSString *> *)itemList arrowDirection:(KLMenuViewArrowDirection)arrowDirection;
- (void)showWithArrowPosition:(CGFloat)arrowPosition;
@end
