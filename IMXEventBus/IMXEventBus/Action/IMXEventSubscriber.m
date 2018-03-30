//
//  IMXEventSubscriber.m
//  IMXProject
//
//  Created by zhoupanpan on 2018/3/12.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import "IMXEventSubscriber.h"
#import "IMXEventBus.h"

@interface IMXEventSubscriber()
@end

@implementation IMXEventSubscriber
- (void)dealloc{
}
#pragma mark ======  public  ======
//优先级：Default
//线程：非主线程
+ (void)addTarget:(id _Nonnull)target name:(NSString * _Nonnull)name action:(IMXEventSubscriberActionBlock _Nonnull)action{
    [self addTarget:target name:name priority:IMXEventSubscriberPriorityDefault inMainTread:NO action:action];
}
+ (void)addTarget:(id _Nonnull)target name:(NSString * _Nonnull)name priority:(IMXEventSubscriberPriority)priority inMainTread:(BOOL)isMain action:(IMXEventSubscriberActionBlock _Nonnull)action{
    [[IMXEventBus sharedInstance] registSubscribModel:target markEvent:name priority:priority inMainTread:isMain action:action];
}
+ (void)removeTarget:(id _Nonnull)target{
    [[IMXEventBus sharedInstance] unregistSubscribModelFromTarget:target];
}
+ (void)removeEvent:(NSString *_Nonnull)eventName{
    [[IMXEventBus sharedInstance] removeEvent:eventName];
}

@end
