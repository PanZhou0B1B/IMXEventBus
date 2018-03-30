//
//  IMXEventDefinition.h
//  IMXProject
//
//  Created by zhoupanpan on 2018/3/13.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#ifndef IMXEventDefinition_h
#define IMXEventDefinition_h
#import "IMXEventUserInfo.h"
//订阅者优先级
typedef NS_ENUM(NSInteger, IMXEventSubscriberPriority) {
    IMXEventSubscriberPriorityHigh,
    IMXEventSubscriberPriorityDefault,
    IMXEventSubscriberPriorityLow
};
typedef void(^IMXEventSubscriberActionBlock) (IMXEventUserInfo *info);

#endif /* IMXEventDefinition_h */
