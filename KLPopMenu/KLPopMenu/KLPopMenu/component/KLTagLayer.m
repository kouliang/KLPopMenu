//
//  KLTagLayer.m
//  KLPopMenu
//
//  Created by kou on 2019/4/24.
//  Copyright © 2019年 kouliang. All rights reserved.
//

#import "KLTagLayer.h"
#import <UIKit/UIKit.h>

@implementation KLTagLayer
+ (instancetype)layerWithTag:(NSString *)tag {
    KLTagLayer *layer = [super layer];
    [layer setNeedsDisplay];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = tag;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.alignmentMode = @"center";
    textLayer.bounds = CGRectMake(0, 0, 21, 8);
    textLayer.position = CGPointMake(8, 8);
    textLayer.foregroundColor = [UIColor whiteColor].CGColor;
    textLayer.fontSize = 8;
    textLayer.font = CFBridgingRetain(@".AlNilePUA-Bold");
    textLayer.transform = CATransform3DMakeRotation(((270 + 45) * M_PI / 180.0), 0, 0, 1);
    
    [layer addSublayer:textLayer];
    return layer;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGContextMoveToPoint(ctx, 9, 0);
    CGContextAddLineToPoint(ctx, 25, 0);
    CGContextAddLineToPoint(ctx, 0, 25);
    CGContextAddLineToPoint(ctx, 0, 9);
    CGContextAddLineToPoint(ctx, 9, 0);
    
    CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
    CGContextFillPath(ctx);
}
@end
