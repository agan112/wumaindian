//
//  WumaindianManager.m
//  wumaidian
//
//  Created by 张济航 on 2016/10/3.
//  Copyright © 2016年 张济航. All rights reserved.
//

#import "WumaindianManager.h"


#define WumaindianKey @"WumaindianKey"

@implementation WumaindianManager

- (NSDictionary *)wumaindianDic {
    if (!_wumaindianDic) {
        _wumaindianDic = [WumaindianManager getDictionaryFromUserDefaults:WumaindianKey];
    }
    return _wumaindianDic;
}

- (void)saveWumaindianDic:(NSDictionary *)wumaindianDic {
    self.wumaindianDic = wumaindianDic;
    [WumaindianManager saveDictionaryToUserDefaults:wumaindianDic ForKey:WumaindianKey];
}
//上传
+ (void) saveDictionaryToUserDefaults: (NSDictionary*) dict ForKey: (NSString*) key
{
    if (dict && ![dict isKindOfClass: [NSDictionary class]]) {
        return;
    }
    
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject: dict];
        [standardUserDefaults setObject: data forKey: key];
        [standardUserDefaults synchronize];
    }
}
//获取
+ (NSDictionary*) getDictionaryFromUserDefaults: (NSString*) key
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* val = nil;
    
    if (standardUserDefaults) {
        NSData* data = [standardUserDefaults objectForKey: key];
        if (nil == data) {
            return nil;
        }
        val = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    }
    return val;
}

+(instancetype)shareInstance {
    static WumaindianManager *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (NSString *)getViewID:(UIControl *)view withVC:(UIViewController *)vc {
    NSString *selectorName = nil;
    //check if view has click event
    if (view.allControlEvents & UIControlEventTouchUpInside) {
        for (id target in view.allTargets) {
            NSArray *array = [view actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
            if (array && array.count > 0) {
                selectorName = array[0];
                break;
            }
        }
    }
    if (selectorName) {
        NSString *vcTree = [self getVCTree:vc];
        NSString *viewID = [NSString stringWithFormat:@"%@:%@",vcTree,selectorName];
        return viewID;
    }
    return nil;
}
+ (NSString *)getVCTree:(UIViewController *)vc {
    return [self getVCTree:vc withString:@""];
}

+ (NSString *)getVCTree:(UIViewController *)vc withString:(NSString *)string {

    if (vc.parentViewController) {
        NSString *appendString = [[NSString alloc] initWithString:string];
        if ([vc.parentViewController isKindOfClass:[UINavigationController class]]) {
            //将根控制器的栈给算上
            if (vc.parentViewController.childViewControllers.lastObject == vc) {
                for (UIViewController *subVC in vc.parentViewController.childViewControllers) {
                    appendString = [appendString stringByAppendingString:[NSString stringWithFormat:@"%@-",NSStringFromClass([subVC class])]];
                }
            }
        }
        
        return [self getVCTree:vc.parentViewController withString:[NSString stringWithFormat:@"%@-%@",[vc.parentViewController class],appendString]] ;
    }else {
        if (vc.navigationController) {
            return [self getVCTree:vc.navigationController withString:[NSString stringWithFormat:@"%@-%@",[vc.navigationController class],string]];
        }else {
            return string;
        }
        
    }
}

+ (BOOL)hasWumainDian {
    if ([WumaindianManager shareInstance].wumaindianDic) {
        return YES;
    }else {
        return NO;
    }
}



@end
