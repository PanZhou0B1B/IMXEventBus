//
//  IMXEventSubscribModel.h
//  IMXEventBus
//
//  Created by zhoupanpan on 2018/3/28.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMXEventDefinition.h"
/**
 事件订阅者Model
 */
@class IMXEventUserInfo;
@interface IMXEventSubscribModel : NSObject
@property (nonatomic,copy)IMXEventSubscriberActionBlock actionBlock;
@property (nonatomic,assign)IMXEventSubscriberPriority priority;
@property (nonatomic,assign)BOOL isInMainThread;
@property (nonatomic,weak)id target;


- (void)actionWIthInfo:(IMXEventUserInfo *)info forceMainThread:(BOOL)isMain;
@end
