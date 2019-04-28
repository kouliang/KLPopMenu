//
//  KLPopMenu.m
//  KLPopMenu
//
//  Created by kou on 2019/4/24.
//  Copyright © 2019年 kouliang. All rights reserved.
//

#import "KLPopMenu.h"
#import "KLPopMenuView.h"
#import "KLTagLayer.h"

@interface KLPopMenu () <KLPopMenuViewDelegate>
@property (weak, nonatomic)   UIView *currentPopMenuView;

@property (weak, nonatomic)   UIView *popMenuSuperview;
@property (assign, nonatomic) KLMenuViewArrowDirection arrowDirection;
@property (assign, nonatomic) CGRect targetRectInSuperview;
//data
@property (strong, nonatomic) NSMutableArray<NSArray *> *itemListArray;
@property (assign, nonatomic) NSUInteger currentArrayIndex;
@property (strong, nonatomic) NSArray<NSString *> *NEWTagItems;
@end

@implementation KLPopMenu
- (instancetype)init {
    if (self = [super init]) {
        _itemListArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - public
- (void)showItemList:(NSArray<NSString *> *)itemList withTargetView:(UIView *)targetView {
    [self showItemList:itemList withTargetView:targetView inSuperview:targetView.superview];
}

- (void)showItemList:(NSArray<NSString *> *)itemList withTargetView:(UIView *)targetView inSuperview:(UIView *)popMenuSuperview {
    CGRect targetRect = [popMenuSuperview convertRect:targetView.bounds fromView:targetView];
    [self showItemList:itemList withTargetRect:targetRect inSuperview:popMenuSuperview];
}

- (void)showItemList:(NSArray<NSString *> *)itemList withTargetRect:(CGRect)targetRect inSuperview:(UIView *)popMenuSuperview {
    
    _NEWTagItems = nil;
    [_itemListArray removeAllObjects];
    
    //calculate spillOverItemList
    CGFloat maxWidth = popMenuSuperview.bounds.size.width - 10;
    [self handleItemList:itemList maxWidth:maxWidth];
    
    _arrowDirection = (targetRect.origin.y < KLPopMenuHeight+5) ? KLMenuViewArrowDirectionUp:KLMenuViewArrowDirectionDown;
    _popMenuSuperview = popMenuSuperview;
    _targetRectInSuperview = targetRect;
    
    _currentArrayIndex = 0;
    [self showWithItemList:_itemListArray[_currentArrayIndex]];
}

- (void)hid {
    [_currentPopMenuView removeFromSuperview];
}

- (void)addNewTagForItems:(NSArray<NSString *> *)items {
    _NEWTagItems = items;
    
    for (NSString *item in items) {
        for (UIButton *obj in _currentPopMenuView.subviews) {
            if ([obj.titleLabel.text isEqualToString:item]) {
                KLTagLayer *layer = [KLTagLayer layerWithTag:@"NEW"];
                [obj.layer addSublayer:layer];
                if (_arrowDirection == KLMenuViewArrowDirectionUp) {
                    layer.frame = CGRectMake(0, 9, 30, 30);
                } else {
                    layer.frame = CGRectMake(0, 0, 30, 30);
                }
            }
        }
    }
}

#pragma mark - dealloc
- (void)dealloc {
    [_currentPopMenuView removeFromSuperview];
}

#pragma mark - private
- (void)showWithItemList:(NSArray<NSString *> *)itemList {
    [self hid];
    if ((itemList.count < 1) || (_popMenuSuperview == nil) || (_arrowDirection == KLMenuViewArrowDirectionNoDef)) {return;}
    
    //1.itemList 2.arrowDirection 3.popMenuSuperview 4.targetRectInSuperview
    KLPopMenuView *menuView = [[KLPopMenuView alloc] initWithItemList:itemList arrowDirection:_arrowDirection];
    menuView.delegate = self;
    CGSize menuViewSize = menuView.recommendSize;
    
    //calculate position
    CGFloat originX,originY,arrowPosition;
    if (_arrowDirection == KLMenuViewArrowDirectionDown) {
        originY = _targetRectInSuperview.origin.y - KLPopMenuHeight;
    } else {
        originY = CGRectGetMaxY(_targetRectInSuperview);
    }
    CGFloat targetMidX = CGRectGetMidX(_targetRectInSuperview);
    originX = targetMidX - menuViewSize.width*0.5;
    originX = MIN(originX, _popMenuSuperview.bounds.size.width-menuViewSize.width-5);
    originX = MAX(originX, 5);
    
    menuView.frame = CGRectMake(originX, originY, menuViewSize.width, menuViewSize.height);
    [_popMenuSuperview addSubview:menuView];
    
    arrowPosition = [menuView convertPoint:CGPointMake(targetMidX, 0) fromView:_popMenuSuperview].x;
    [menuView showWithArrowPosition:arrowPosition];
    
    _currentPopMenuView = menuView;
    [self addNewTagForItems:_NEWTagItems];
}

- (void)handleItemList:(NSArray<NSString *> *)itemList maxWidth:(CGFloat)maxWidth {
    maxWidth = MAX(maxWidth, 150);
    NSArray<NSValue *> *itemRects = [KLPopMenuTool rectsWidthItemList:itemList systemFontSize:KLPopMenuFontSize rectHeight:KLPopMenuHeight];
    CGRect lastItemRect = [[itemRects lastObject] CGRectValue];
    if (CGRectGetMaxX(lastItemRect) <= maxWidth) {
        [_itemListArray addObject:itemList];
        return;
    }
    
    NSMutableArray *tmpItemList = [NSMutableArray arrayWithCapacity:itemRects.count];
    NSMutableArray *spillOverItemList = [NSMutableArray arrayWithCapacity:itemRects.count];
    [spillOverItemList addObject:KLPopMenuPreviousGroup];
    
    [itemRects enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectGetMaxX([obj CGRectValue])+26 > maxWidth) {
            [spillOverItemList addObject:itemList[idx]];
        } else {
            [tmpItemList addObject:itemList[idx]];
        }
    }];
    [tmpItemList addObject:KLPopMenuNextGroup];
    [_itemListArray addObject:tmpItemList];
    
    [self handleItemList:spillOverItemList maxWidth:maxWidth];
}

#pragma mark - KLPopMenuViewDelegate
- (void)popMenuView:(UIView *)menuView ClickedIndex:(NSUInteger)index withTitle:(NSString *)title {
    if ([title isEqualToString:KLPopMenuNextGroup]) {
        _currentArrayIndex++;
        [self showWithItemList:_itemListArray[_currentArrayIndex]];
    } else if ([title isEqualToString:KLPopMenuPreviousGroup]) {
        _currentArrayIndex--;
        [self showWithItemList:_itemListArray[_currentArrayIndex]];
    } else {
        if ([_delegate respondsToSelector:@selector(popMenuClickedWithTitle:)]) {
            [_delegate popMenuClickedWithTitle:title];
        }
    }
    [menuView removeFromSuperview];
}
@end
