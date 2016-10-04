//
//  UIViewController+wumaidian.m
//  wumaidian
//
//  Created by 张济航 on 2016/10/3.
//  Copyright © 2016年 张济航. All rights reserved.
//

#import "UIViewController+wumaidian.h"
#import <objc/runtime.h> 
#import "WumaindianManager.h"

@implementation UIViewController(wumaidian)

+ (void)registerWumaidian {
    Class class = [UIViewController class];
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(viewDidAppear:);
    SEL swizzledSelector = @selector(xxx_viewWillAppear:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated];
    
    //register
    [self registerView:self.view];
    
}

- (void)registerView:(UIView *)view {
    if ([view isKindOfClass:[UIControl class]]) {
        UIControl * control = (UIControl *)view;
        NSString *viewID = [WumaindianManager getViewID:control withVC:self];
        if (viewID) {
            if ([[WumaindianManager shareInstance].wumaindianDic.allKeys containsObject:viewID]) {
                [control addTarget:self action:@selector(shangbao:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }else {
        for (UIView *subView in view.subviews) {
            [self registerView:subView];
        }
    }
}

- (void)shangbao:(id)sender {
    UIControl * control = (UIControl *)sender;
    NSString *viewID = [WumaindianManager getViewID:control withVC:self];
    if (viewID) {
        NSString *parameter = [[WumaindianManager shareInstance].wumaindianDic objectForKey:viewID];
        NSLog(@"");
        NSLog(@"无埋点注册成功，点击的viewID是:%@",viewID);
    }
}


@end
