//
//  IMXEventSubscriber.h
//  IMXProject
//
//  Created by zhoupanpan on 2018/3/12.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMXEventDefinition.h"
/**
 事件订阅者
 */
@interface IMXEventSubscriber : NSObject
@property (nonatomic,copy)IMXEventSubscriberActionBlock actionBlock;
@property (nonatomic,assign)IMXEventSubscriberPriority priority;
@property (nonatomic,assign)BOOL isInMainTread;
@end
