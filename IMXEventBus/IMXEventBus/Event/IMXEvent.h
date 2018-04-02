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
@class IMXEventSubscribModel,IMXEventUserInfo;
@interface IMXEvent : NSObject
@property (nonatomic,copy)NSString * _Nonnull eventName;

#ifdef DEBUG
@property (nonatomic,assign)NSInteger triggerCount;
#endif

/**
 Event 中是否包含`target-subscribModel`条目

 @param target key
 @return 包含：YES
 */
- (BOOL)hasContainedSubscribModelForKey:(id _Nonnull )target;
/**
 注册订阅者：
 将订阅者条目`target-subscriber`添加至对应的优先级队列中

 @param subscrib 订阅者条目
 @param target key
 */
- (void)registSubscribModel:(IMXEventSubscribModel *_Nonnull)subscrib forKey:(id _Nonnull )target;
/**
 触发具体事件，执行其队列中的订阅者行为

 @param info 传输数据
 @param isMain 订阅者行为是否强制在主线程执行
 */
- (void)postEventWithDeliveryData:(IMXEventUserInfo *_Nonnull )info isInMain:(BOOL)isMain;
/**
 删除事件中Target对应的一条订阅者记录

 @param target key
 @return 删除target对应记录后，各队列是否全为空
 */
- (BOOL)deleteEntryForTarget:(id _Nonnull)target;
/**
 各优先级对应的队列是否全为空

 @return 若全为空，返回YES；反之则否。
 */
- (BOOL)isEmptyMap;
@end


