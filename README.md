# KLPopMenu
完美替换 UIMenuController的 解决方案

![image](https://github.com/kouliang/KLPopMenu/blob/master/pic/1.png)
***

## usage
- 
      NSArray *itemList = @[@"全选", @"new", @"复制", @"全部选中", @"删除所有", @"翻译当前文字", @"向右缩进", @"11111", @"2222", @"333333", @"444444"];
      KLPopMenu *popMenu = [KLPopMenu new];
      [popMenu showItemList:itemList withTargetView:targetView];
      [popMenu addNewTagForItems:@[@"new"]];
    
![image](https://github.com/kouliang/KLPopMenu/blob/master/pic/2.gif)
