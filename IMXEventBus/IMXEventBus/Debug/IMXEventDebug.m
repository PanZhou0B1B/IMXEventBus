//
//  IMXEventDebug.m
//  IMXEventBus
//
//  Created by zhoupanpan on 2018/3/29.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import "IMXEventDebug.h"
#import <UIKit/UIKit.h>
#import "IMXEventBus.h"
#import "IMXEvent.h"
#import "IMXEventSubscribModel.h"
@interface IMXEventDebug()
@property (nonatomic,assign,getter=isEnableDebug)BOOL enableDebug;
@end
@implementation IMXEventDebug
- (void)dealloc{
}
#pragma mark ======  public  ======
+ (IMXEventDebug *)sharedInstance
{
    static IMXEventDebug *instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[IMXEventDebug alloc] init];
    });
    return instance;
}
- (void)enableDebug:(BOOL)isEnableDebug{
#ifdef DEBUG
    self.enableDebug = isEnableDebug;
#else
    self.enableDebug = NO;
#endif
}
- (void)showDebugMsg:(NSString *)msg{
    if(!self.isEnableDebug) { return; }
    if(!msg) { return; }

    if(self.debugType == IMXEventDebugTypeLog){
        [self showLog:msg];
    }else{
        [self showAlert:msg];
    }
}
- (void)showAllRegistEvent{
#ifdef DEBUG
    NSDictionary *events = [[IMXEventBus sharedInstance] valueForKey:@"events"];
    NSMutableString *mString = [[NSMutableString alloc] initWithString:@""];
    [events enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, IMXEvent * _Nonnull event, BOOL * _Nonnull stop) {         
        BOOL isNoSubs = [event isEmptyMap];
        if(isNoSubs){
            [mString appendFormat:@"%@", [NSString stringWithFormat:@"=====Attention=====eventName:%@\n===========subscribeModel:high~0,default~0,low~0\n",key]];
        }else{
            NSMapTable *high = [event valueForKey:@"mapHigh"];
            NSInteger highCount = high.keyEnumerator.allObjects.count;
            NSMapTable *defaultMap = [event valueForKey:@"mapDefault"];
            NSInteger defaultCount = defaultMap.keyEnumerator.allObjects.count;
            NSMapTable *low = [event valueForKey:@"mapLow"];
            NSInteger lowCount = low.keyEnumerator.allObjects.count;
            [mString appendFormat:@"%@", [NSString stringWithFormat:@"eventName:%@\nsubscribeModel:high~%ld,default~%ld,low~%ld\n",key,(long)highCount,(long)defaultCount,(long)lowCount]];
        }
        [mString appendFormat:@"=============\n\n"];
    }];
    NSLog(@"%@",mString);
#endif
}
- (void)showAllRegistEventDetail{
#ifdef DEBUG
    NSDictionary *events = [[IMXEventBus sharedInstance] valueForKey:@"events"];
    NSMutableString *mString = [[NSMutableString alloc] initWithString:@""];
    [events enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, IMXEvent * _Nonnull event, BOOL * _Nonnull stop) {
        BOOL isNoSubs = [event isEmptyMap];
        if(isNoSubs){
            [mString appendFormat:@"%@", [NSString stringWithFormat:@"=====Attention=====eventName:%@\n===========subscribeModel:high~0,default~0,low~0",key]];
        }else{
            NSMapTable *high = [event valueForKey:@"mapHigh"];
            NSInteger highCount = high.keyEnumerator.allObjects.count;
            NSMapTable *defaultMap = [event valueForKey:@"mapDefault"];
            NSInteger defaultCount = defaultMap.keyEnumerator.allObjects.count;
            NSMapTable *low = [event valueForKey:@"mapLow"];
            NSInteger lowCount = low.keyEnumerator.allObjects.count;
            [mString appendFormat:@"%@", [NSString stringWithFormat:@"eventName:%@\nsubscribeModel:high~%ld,default~%ld,low~%ld\n",key,(long)highCount,(long)defaultCount,(long)lowCount]];
            //event
            NSArray *tmps = [[NSArray alloc] initWithArray:high.objectEnumerator.allObjects];
            [tmps enumerateObjectsUsingBlock:^(IMXEventSubscribModel * _Nonnull subscriber, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger count = subscriber.triggerCount;
                if(count <= 0){
                    [mString appendFormat:@"===high need check===target:%@,        triggerCount:%ld\n",subscriber.target,(long)subscriber.triggerCount];
                }else{
                    [mString appendFormat:@"===high ===target:%@,triggerCount:%ld\n",subscriber.target,(long)subscriber.triggerCount];
                }
            }];
            tmps = [[NSArray alloc] initWithArray:defaultMap.objectEnumerator.allObjects];
            [tmps enumerateObjectsUsingBlock:^(IMXEventSubscribModel * _Nonnull subscriber, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger count = subscriber.triggerCount;
                if(count <= 0){
                    [mString appendFormat:@"===default need check======target:%@,        triggerCount:%ld\n",subscriber.target,(long)subscriber.triggerCount];
                }else{
                    [mString appendFormat:@"===default ===target:%@,triggerCount:%ld\n",subscriber.target,(long)subscriber.triggerCount];
                }
            }];
            tmps = [[NSArray alloc] initWithArray:low.objectEnumerator.allObjects];
            [tmps enumerateObjectsUsingBlock:^(IMXEventSubscribModel * _Nonnull subscriber, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger count = subscriber.triggerCount;
                if(count <= 0){
                    [mString appendFormat:@"===low need check======target:%@,        triggerCount:%ld\n",subscriber.target,(long)subscriber.triggerCount];
                }else{
                    [mString appendFormat:@"===low ===target:%@,triggerCount:%ld\n",subscriber.target,(long)subscriber.triggerCount];
                }
            }];

        }
        [mString appendFormat:@"=============\n\n"];
    }];
    NSLog(@"%@",mString);
#endif
}
#pragma mark ======  life cycle  ======
- (instancetype)init{
    self = [super init];
    if (self) {
        self.enableDebug = NO;
        self.debugType = IMXEventDebugTypeLog;
    }
    return self;
}
#pragma mark ======  delegate  ======

#pragma mark ======  event  ======

#pragma mark ======  private  ======
- (void)showLog:(NSString *)msg{
    NSLog(@"debug only:\n%@", msg);
}
- (void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"debug only"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    NSString *ok = NSLocalizedString(@"OK",nil);
    UIAlertAction *action = [UIAlertAction actionWithTitle:ok
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alert addAction:action];
    UIViewController *ctrl = [IMXEventDebug IMXEventDebug_CurrentViewCtrl];
    [ctrl presentViewController:alert animated:YES completion:nil];
}
+ (UIViewController *)IMXEventDebug_CurrentViewCtrl{
    UIWindow * window = [self IMXEventDebug_window];

    UIViewController *rootViewController = window.rootViewController;
    UIViewController *currentVC = [self IMXEventDebug_getCurrentVCFrom:rootViewController];

    return currentVC;
}

+ (UIViewController *)IMXEventDebug_getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        currentVC = [self IMXEventDebug_getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];

    } else if ([rootVC isKindOfClass:[UINavigationController class]]){

        currentVC = [self IMXEventDebug_getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];

    } else {
        currentVC = rootVC;
    }
    return currentVC;
}
+ (UIWindow *)IMXEventDebug_window{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}
#pragma mark ======  getter & setter  ======


@end
