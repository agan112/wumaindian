//
//  WumaindianManager.h
//  wumaidian
//
//  Created by 张济航 on 2016/10/3.
//  Copyright © 2016年 张济航. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WumaindianManager : NSObject

@property (nonatomic, strong) NSDictionary *wumaindianDic;

+ (instancetype)shareInstance;

+ (NSString *)getViewID:(UIControl *)view withVC:(UIViewController *)vc ;

+ (BOOL)hasWumainDian;

- (void)saveWumaindianDic:(NSDictionary *)wumaindianDic;

@end
