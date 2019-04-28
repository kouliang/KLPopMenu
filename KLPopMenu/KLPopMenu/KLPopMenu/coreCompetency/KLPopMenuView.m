//
//  KLPopMenuView.m
//  KLPopMenu
//
//  Created by kou on 2019/4/24.
//  Copyright © 2019年 kouliang. All rights reserved.
//

#import "KLPopMenuView.h"

@interface KLPopMenuView ()
@property (strong, nonatomic) NSArray<NSString *> *itemList;
@property (assign, nonatomic) KLMenuViewArrowDirection arrowDirection;

@property (strong, nonatomic) NSArray<NSValue *> *itemRects;
@end

@implementation KLPopMenuView
- (instancetype)initWithItemList:(NSArray<NSString *> *)itemList arrowDirection:(KLMenuViewArrowDirection)arrowDirection {
    if (self = [super initWithFrame:CGRectZero]) {
        _itemList = itemList;
        _arrowDirection = arrowDirection;

        _itemRects = [KLPopMenuTool rectsWidthItemList:itemList systemFontSize:KLPopMenuFontSize rectHeight:KLPopMenuHeight];
        
        CGRect lastItemRect = [[_itemRects lastObject] CGRectValue];
        _recommendSize = CGSizeMake(CGRectGetMaxX(lastItemRect), KLPopMenuHeight);
    }
    return self;
}

- (void)showWithArrowPosition:(CGFloat)arrowPosition {
    
    NSMutableArray *splitPositions = [NSMutableArray arrayWithCapacity:_itemRects.count];
    for (NSValue *itemRect in _itemRects) {
        CGRect rect = [itemRect CGRectValue];
        [splitPositions addObject:@(CGRectGetMaxX(rect))];
    }
    
    UIImage *imageAllNormal = [KLPopMenuTool creatImageWithSize:_recommendSize arrowDirection:_arrowDirection arrowPosition:arrowPosition splitPositions:splitPositions isHighlight:NO];
    UIImage *imageAllChecked = [KLPopMenuTool creatImageWithSize:_recommendSize arrowDirection:_arrowDirection arrowPosition:arrowPosition splitPositions:splitPositions isHighlight:YES];
    
    for (int i = 0; i < _itemRects.count; i++) {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGRect rect = [[_itemRects objectAtIndex:i] CGRectValue];
        CGRect inRect = CGRectMake(scale*rect.origin.x, scale*rect.origin.y, scale*rect.size.width, scale*rect.size.height);
        
        CGImageRef imageNormalTemp = CGImageCreateWithImageInRect([imageAllNormal CGImage], inRect);
        UIImage *imageNormal = [UIImage imageWithCGImage:imageNormalTemp];
        CGImageRelease(imageNormalTemp);
        
        CGImageRef imageCheckedTemp = CGImageCreateWithImageInRect([imageAllChecked CGImage], inRect);
        UIImage *imageChecked = [UIImage imageWithCGImage:imageCheckedTemp];
        CGImageRelease(imageCheckedTemp);
        
        UIButton *itemBtn = [[UIButton alloc] initWithFrame:rect];
        [itemBtn setBackgroundImage:imageNormal forState:UIControlStateNormal];
        [itemBtn setBackgroundImage:imageChecked forState:UIControlStateHighlighted];
        
        itemBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        NSString *title = [_itemList objectAtIndex:i];
        [itemBtn setTitle:title forState:UIControlStateNormal];
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:KLPopMenuFontSize];
        [itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        itemBtn.tag = 1000+i;
        [itemBtn addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        itemBtn.exclusiveTouch=YES;
        [self addSubview:itemBtn];
        
        CGFloat offsetY = (_arrowDirection == KLMenuViewArrowDirectionUp) ? 5:-5;
        CGFloat offsetX = ([title isEqualToString:KLPopMenuNextGroup] || [title isEqualToString:KLPopMenuPreviousGroup]) ? 0:10;
        itemBtn.titleEdgeInsets = UIEdgeInsetsMake(offsetY, offsetX, -offsetY, offsetX);
    }
}

- (void)itemBtnClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(popMenuView:ClickedIndex:withTitle:)]) {
        [_delegate popMenuView:self ClickedIndex:sender.tag-1000 withTitle:sender.titleLabel.text];
    }
}
@end
