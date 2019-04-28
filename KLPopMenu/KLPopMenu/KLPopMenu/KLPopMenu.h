//
//  KLPopMenu.h
//  KLPopMenu
//
//  Created by kou on 2019/4/24.
//  Copyright © 2019年 kouliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KLPopMenuDelegate<NSObject>
@optional
- (void)popMenuClickedWithTitle:(NSString *)title;
@end

@interface KLPopMenu : NSObject
@property (weak, nonatomic) id<KLPopMenuDelegate> delegate;

/** this will call [showWithItemList: targetView: inSuperview:targetView.superview]; */
- (void)showItemList:(NSArray<NSString *> *)itemList withTargetView:(UIView *)targetView;
- (void)showItemList:(NSArray<NSString *> *)itemList withTargetView:(UIView *)targetView inSuperview:(UIView *)popMenuSuperview;
- (void)showItemList:(NSArray<NSString *> *)itemList withTargetRect:(CGRect)targetRect inSuperview:(UIView *)popMenuSuperview;
- (void)hid;

/** called after show... methd */
- (void)addNewTagForItems:(NSArray<NSString *> *)items;
@end
