//
//  ViewController.m
//  KLPopMenu
//
//  Created by kou on 2019/4/24.
//  Copyright © 2019年 kouliang. All rights reserved.
//

#import "ViewController.h"
#import "KLPopMenu.h"

@interface ViewController ()<KLPopMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *targetView;
@property (strong, nonatomic) KLPopMenu *popMenu;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _popMenu = [KLPopMenu new];
    _popMenu.delegate = self;
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(press:)];
    [_targetView addGestureRecognizer:press];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_popMenu hid];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *touchView = [touches anyObject].view;
    if (touchView == _targetView) {
        UITouch *touchu=[touches anyObject];
        CGPoint curP=[touchu locationInView:touchView];
        CGPoint preP=[touchu previousLocationInView:touchView];
        
        CGFloat offsetX=curP.x-preP.x;
        CGFloat offsetY=curP.y-preP.y;
        
        CGPoint viewCenter=touchView.center;
        viewCenter.x+=offsetX;
        viewCenter.y+=offsetY;
        touchView.center=viewCenter;
    }
}

#pragma mark -
- (void)press:(UILongPressGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateBegan) {
        NSArray *itemList = @[@"全选", @"new", @"复制", @"全部选中", @"删除所有", @"翻译当前文字", @"向右缩进", @"11111", @"2222", @"333333", @"444444"];
        [_popMenu showItemList:itemList withTargetView:_targetView];
        [_popMenu addNewTagForItems:@[@"new"]];
    }
}

- (void)popMenuClickedWithTitle:(NSString *)title {
    NSLog(@"--%@", title);
}

@end
