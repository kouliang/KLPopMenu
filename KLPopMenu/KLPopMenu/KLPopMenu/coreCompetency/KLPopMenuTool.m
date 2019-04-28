//
//  KLPopMenuTool.m
//  KLPopMenu
//
//  Created by kou on 2019/4/24.
//  Copyright © 2019年 kouliang. All rights reserved.
//

#import "KLPopMenuTool.h"

NSString * const KLPopMenuNextGroup = @"▶";
NSString * const KLPopMenuPreviousGroup = @"◀";
NSUInteger const KLPopMenuFontSize = 14;
NSUInteger const KLPopMenuHeight = 44;
NSUInteger const KLPopMenuArrow_Height = 9;
NSUInteger const KLPopMenuCornerRadius = 6;

@implementation KLPopMenuTool

CGPoint getCrossPoint(CGPoint point11, CGPoint point12, CGFloat x) {
    //y = a * x + b;
    CGFloat a = (point11.y - point12.y) / (point11.x - point12.x);
    CGFloat b = (point11.y * point12.x - point12.y *point11.x) / (point12.x - point11.x);
    
    return CGPointMake(x, a * x + b);
}

+ (UIImage *)creatImageWithSize:(CGSize)size arrowDirection:(KLMenuViewArrowDirection)arrowDirection arrowPosition:(CGFloat)arrowPosition splitPositions:(NSArray<NSNumber *> *)splitPositions isHighlight:(BOOL)isHighlight {
    //Fault Tolerance
    size.width = MAX(size.width, (KLPopMenuArrow_Height+KLPopMenuCornerRadius*2)*2);
    size.height = MAX(size.height, KLPopMenuArrow_Height+KLPopMenuCornerRadius*3);
    arrowPosition = MAX(arrowPosition, KLPopMenuArrow_Height+KLPopMenuCornerRadius*2);
    arrowPosition = MIN(arrowPosition, (size.width-KLPopMenuArrow_Height-KLPopMenuCornerRadius*2));
    
    //Prepare data
    CGPoint arrowPoint, arrowNextPoint, arrowPrevioustPoint;
    CGPoint point1, point2, point3, point4;
    if (arrowDirection == KLMenuViewArrowDirectionUp) {
        arrowPoint = CGPointMake(arrowPosition, 0);
        arrowPrevioustPoint = CGPointMake(arrowPosition+KLPopMenuArrow_Height, KLPopMenuArrow_Height); //右
        arrowNextPoint = CGPointMake(arrowPosition-KLPopMenuArrow_Height, KLPopMenuArrow_Height); //左
        point1 = CGPointMake(0, KLPopMenuArrow_Height); //左上
        point2 = CGPointMake(0, size.height); //左下
        point3 = CGPointMake(size.width, size.height); //右下
        point4 = CGPointMake(size.width, KLPopMenuArrow_Height); //右上
    } else {
        arrowPoint = CGPointMake(arrowPosition, size.height);
        arrowPrevioustPoint = CGPointMake(arrowPosition-KLPopMenuArrow_Height, size.height-KLPopMenuArrow_Height); //左
        arrowNextPoint = CGPointMake(arrowPosition+KLPopMenuArrow_Height, size.height-KLPopMenuArrow_Height); //右
        point1 = CGPointMake(size.width, size.height-KLPopMenuArrow_Height); //右下
        point2 = CGPointMake(size.width, 0); //右上
        point3 = CGPointMake(0, 0); //左上
        point4 = CGPointMake(0, size.height-KLPopMenuArrow_Height); //左下
    }
    
    //set context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.8, 0.8, 0.8, 0.9);
    CGContextSetLineWidth(context, 0.3);
    if (isHighlight) {
        CGContextSetRGBFillColor(context, 0.6, 0.6, 0.6, 0.9);
    } else {
        CGContextSetRGBFillColor(context, 0, 0, 0, 0.9);
    }
    
    //draw background
    CGMutablePathRef bubblePath = CGPathCreateMutable();
    CGPathMoveToPoint(bubblePath, NULL, arrowPrevioustPoint.x, arrowPrevioustPoint.y);
    CGPathAddLineToPoint(bubblePath, NULL, arrowPoint.x, arrowPoint.y);
    CGPathAddLineToPoint(bubblePath, NULL, arrowNextPoint.x, arrowNextPoint.y);
    CGPathAddArcToPoint(bubblePath, NULL, point1.x, point1.y, point2.x, point2.y, KLPopMenuCornerRadius);
    CGPathAddArcToPoint(bubblePath, NULL, point2.x, point2.y, point3.x, point3.y, KLPopMenuCornerRadius);
    CGPathAddArcToPoint(bubblePath, NULL, point3.x, point3.y, point4.x, point4.y, KLPopMenuCornerRadius);
    CGPathAddArcToPoint(bubblePath, NULL, point4.x, point4.y, arrowPrevioustPoint.x, arrowPrevioustPoint.y, KLPopMenuCornerRadius);
    CGPathCloseSubpath(bubblePath);
    CGContextAddPath(context, bubblePath);
    CGContextFillPath(context);
    CGPathRelease(bubblePath);
    
    //draw splitLine
    for (NSNumber *splitPosition in splitPositions) {
        CGFloat position = [splitPosition floatValue];
        if (position<5 || position>size.width-5) {continue;}
        
        CGPoint drawPoint1 = CGPointMake(position, 0);
        CGPoint drawPoint2 = CGPointMake(position, 1);
        CGPoint crossPoint1 = getCrossPoint(arrowPoint, arrowPrevioustPoint, position);
        CGPoint crossPoint2 = getCrossPoint(arrowPoint, arrowNextPoint, position);
        if (arrowDirection == KLMenuViewArrowDirectionUp) {
            drawPoint1.y = size.height;
            drawPoint2.y = MIN(KLPopMenuArrow_Height, MAX(crossPoint1.y, crossPoint2.y));
        } else {
            drawPoint1.y = 0;
            drawPoint2.y = MAX(size.height-KLPopMenuArrow_Height, MIN(crossPoint1.y, crossPoint2.y));
        }
        
        CGContextMoveToPoint(context, drawPoint1.x, drawPoint1.y);
        CGContextAddLineToPoint(context, drawPoint2.x, drawPoint2.y);
    }
    CGContextStrokePath(context);
    
    //get image
    UIImage *currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return currentImage;
}

#pragma mark - rectsWidthItemList
+ (NSArray<NSValue *> *)rectsWidthItemList:(NSArray<NSString *> *)itemList systemFontSize:(CGFloat)fontSize rectHeight:(CGFloat)rectHeight {
    NSMutableArray *itemRects = [NSMutableArray arrayWithCapacity:itemList.count];
    CGFloat rectX = 0;
    for (NSString *item in itemList) {
        CGFloat itemWidth = [KLPopMenuTool widthOfText:item systemFontSize:fontSize] + 26;
        if ([item isEqualToString:KLPopMenuNextGroup] || [item isEqualToString:KLPopMenuPreviousGroup]) {
            itemWidth = 26;
        }
        itemWidth = MIN(itemWidth, 80);
        CGRect itemRect = CGRectMake(rectX, 0, itemWidth, rectHeight);
        [itemRects addObject:[NSValue valueWithCGRect:itemRect]];
        rectX += itemWidth;
    }
    return itemRects;
}

#pragma mark - widthOfText
+ (CGFloat)widthOfText:(NSString *)text systemFontSize:(CGFloat)fontSize {
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 45) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.width;
}

@end
