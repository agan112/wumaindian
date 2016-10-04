//
//  ViewController.m
//  wumaidian
//
//  Created by 张济航 on 2016/10/3.
//  Copyright © 2016年 张济航. All rights reserved.
//

#import "ViewController.h"
#import "WumaindianManager.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(40, 100, 100, 100)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(dianji) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"push" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.view addSubview:button];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 150, 100)];
    button3.backgroundColor = [UIColor greenColor];
    [button3 addTarget:self action:@selector(clickToCheck) forControlEvents:UIControlEventTouchUpInside];
    [button3 setTitle:@"click to check" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.view addSubview:button3];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(110, 340, 240, 100)];
    [button2 setTitle:@"将当前页面的按钮都注册了" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [button2 addTarget:self action:@selector(zhuce:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
}

- (void)zhuce:(id)sender {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (UIView *subView in self.view.subviews) {
        
        if ([subView isKindOfClass:[UIControl class]] && subView != sender) {
            NSString *viewID = [WumaindianManager getViewID:subView withVC:self];
            if (viewID) {
                [dic setObject:@"99933rr" forKey:viewID];
            }
        }
    }
    [[WumaindianManager shareInstance] saveWumaindianDic:[dic copy]];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"注册点击成功" message:@"需要重启app之后，再点击click to check按钮" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"👌", nil];
    [alertView show];
}

- (void)logView:(UIView *)view {
    NSString *viewTree = [self getSuperView:view withString:@"view tree:"];
    
    NSLog(@"%@",viewTree);
    
}

- (NSString *)getSuperView:(UIView *)view withString:(NSString *)oldString{
    NSString *str = [NSString stringWithFormat:@"%@%@",oldString,NSStringFromClass([view class])];

    if ([view superview]) {
        return  [self getSuperView:[view superview] withString:str];
    }
    return str;
}

- (void)dianji {
    [self.navigationController pushViewController:[ViewController new] animated:YES];
}

- (void)clickToCheck{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
