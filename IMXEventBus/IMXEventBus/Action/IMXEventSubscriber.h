//
//  IMXEventSubscriber.h
//  IMXProject
//
//  Created by zhoupanpan on 2018/3/12.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMXEventDefinition.h"

@interface IMXEventSubscriber : NSObject
/**
 Regist an event
 default value:
    priority:IMXEventSubscriberPriorityDefault
    isMainThread:NO

 @param target key
 @param name eventName
 @param action action
 */
+ (void)addTarget:(id _Nonnull)target name:(NSString * _Nonnull)name action:(IMXEventSubscriberActionBlock _Nonnull)action;

/**
 Regist an event

 @param target key
 @param name eventName
 @param priority priority
 @param isMain action in mainthread or not
 @param action action
 */
+ (void)addTarget:(id _Nonnull)target name:(NSString * _Nonnull)name priority:(IMXEventSubscriberPriority)priority inMainTread:(BOOL)isMain action:(IMXEventSubscriberActionBlock _Nonnull)action;
/**
 remove target subscribers

 @param target target
 */
+ (void)removeTarget:(id _Nonnull)target;
/**
 remove an event

 @param eventName eventName
 */
+ (void)removeEvent:(NSString *_Nonnull)eventName;
@end
