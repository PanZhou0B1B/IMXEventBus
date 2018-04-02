//
//  IMXEventSubscribModel.m
//  IMXEventBus
//
//  Created by zhoupanpan on 2018/3/28.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import "IMXEventSubscribModel.h"
#import "IMXEventUserInfo.h"

@interface IMXEventSubscribModel()
@end

@implementation IMXEventSubscribModel
- (void)dealloc{
}
#pragma mark ======  public  ======
- (void)actionWIthInfo:(IMXEventUserInfo *)info forceMainThread:(BOOL)isMain{
    if(isMain){
        [IMXEventSubscribModel mainTreadAction:^{
            self.actionBlock(info);
        }];
    }else{
        if(self.isInMainThread){
            [IMXEventSubscribModel mainTreadAction:^{
                self.actionBlock(info);
            }];
        }else{
            self.actionBlock(info);
        }
    }
}
#pragma mark ======  life cycle  ======
- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}
#pragma mark ======  delegate  ======

#pragma mark ======  event  ======

#pragma mark ======  private  ======
+ (void)mainTreadAction:(void(^)(void))action{
    if([NSThread isMainThread]){
        if(action){
            action();
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(action){
                action();
            }
        });
    }
}
#pragma mark ======  getter & setter  ======
@end
