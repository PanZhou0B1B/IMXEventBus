//
//  IMXEventBus.h
//  IMXProject
//
//  Created by zhoupanpan on 2018/3/12.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMXEventDefinition.h"
/**
 事件集合
 */
@class IMXEventUserInfo;
@interface IMXEventBus : NSObject

+ (IMXEventBus *_Nonnull)sharedInstance;

/**
 注册订阅者事件（单一）

 @param target target
 @param eventName 事件名称
 @param priority target对应订阅者的优先级
 @param isMain target对应订阅者的行为触发时是否在主线程执行
 @param action target对应订阅者的行为
 */
- (void)registSubscribModel:(id _Nonnull)target markEvent:(NSString * _Nonnull)eventName priority:(IMXEventSubscriberPriority)priority inMainTread:(BOOL)isMain action:(IMXEventSubscriberActionBlock _Nonnull)action;

/**
 触发事件

 @param eventName 事件名称
 @param info 传输的数据
 @param isMain 是否强制对应的所有订阅者行为均在主线程执行
 */
- (void)publishEvent:(NSString * _Nonnull)eventName delivery:(IMXEventUserInfo *_Nullable)info isFromMainTread:(BOOL)isMain;
/**
 解注册Target对应的订阅者：
 若解除后事件无相关订阅者，则移除该Event对象

 @param target target
 */
- (void)unregistSubscribModelFromTarget:(id _Nonnull)target;
/**
 移除事件

 @param eventName 事件名称
 */
- (void)removeEvent:(NSString *_Nonnull)eventName;
@end
