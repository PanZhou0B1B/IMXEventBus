//
//  IMXEventPoster.m
//  IMXEventBus
//
//  Created by zhoupanpan on 2018/3/28.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import "IMXEventPoster.h"
#import "IMXEventBus.h"
#import "IMXEventUserInfo.h"
@interface IMXEventPoster()

@end

@implementation IMXEventPoster
- (void)dealloc{
}
#pragma mark ======  public  ======
+ (void)postEventName:(NSString *)name object:(id)object{
    [self postEventName:name object:object forceMain:NO];
}
+ (void)postEventName:(NSString *)name object:(id)object forceMain:(BOOL)actionInMain{
    IMXEventUserInfo *userInfo = nil;
    if(object){
        userInfo = [IMXEventUserInfo new];
        if([object isKindOfClass:[NSDictionary class]]){
            userInfo.userInfo = object;
        }else{
            userInfo.extObj = object;
        }
    }
    [[IMXEventBus sharedInstance] publishEvent:name delivery:userInfo isFromMainTread:actionInMain];
}

@end
