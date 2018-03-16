//
//  IMXEvent.h
//  IMXProject
//
//  Created by zhoupanpan on 2018/3/12.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 事件对象:负责众多订阅者的派发处理等
 */
@class IMXEventSubscriber;
@interface IMXEvent : NSObject
@property (nonatomic,copy)NSString * _Nonnull eventName;

- (BOOL)hasContainedSubscriberForKey:(id _Nonnull )target;
- (void)addSubscriber:(IMXEventSubscriber *_Nonnull)subscriber forKey:(id _Nonnull )target;
- (void)responseEventWithDeliveryData:(id _Nonnull )info isInMain:(BOOL)isMain;
- (BOOL)deleteEntriesForTarget:(id _Nonnull)target;
- (BOOL)isEmptyMap;
@end


