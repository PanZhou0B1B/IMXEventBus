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

@interface IMXEventBus : NSObject

+ (IMXEventBus *_Nonnull)sharedInstance;
- (void)registSubscriber:(id _Nonnull)target markEvent:(NSString * _Nonnull)eventName priority:(IMXEventSubscriberPriority)priority inMainTread:(BOOL)isMain action:(IMXEventSubscriberActionBlock _Nonnull)action;
- (void)publishEvent:(NSString * _Nonnull)eventName delivery:(id _Nullable )info isFromMainTread:(BOOL)isMain;
- (void)unregistSubscriberFromTarget:(id _Nonnull)target;
- (void)removeEvent:(NSString *_Nonnull)eventName;
@end
