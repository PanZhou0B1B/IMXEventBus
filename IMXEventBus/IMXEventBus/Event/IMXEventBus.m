//
//  IMXEventBus.m
//  IMXProject
//
//  Created by zhoupanpan on 2018/3/12.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import "IMXEventBus.h"
#import "IMXEvent.h"
#import "IMXEventSubscribModel.h"
#import "IMXEventUserInfo.h"
#import "IMXEventDebug.h"
@interface IMXEventBus()
@property (nonatomic,strong)NSMutableDictionary *events;
@end

@implementation IMXEventBus

- (void)dealloc{
}
#pragma mark ======  public  ======
+ (IMXEventBus *)sharedInstance
{
    static IMXEventBus *instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[IMXEventBus alloc] init];
    });
    return instance;
}
- (void)registSubscribModel:(id _Nonnull)target markEvent:(NSString * _Nonnull)eventName priority:(IMXEventSubscriberPriority)priority inMainTread:(BOOL)isMain action:(IMXEventSubscriberActionBlock _Nonnull)action{
    if(!target) {return;}
    if(!eventName) {return;}
    if(!action) {return;}

    dispatch_async(event_bus_dispatcher_serialQueue(), ^{
        IMXEvent *event = self.events[eventName];
        if(!event){
            event = [[IMXEvent alloc] init];
            event.eventName = eventName;
            self.events[eventName] = event;
        }else{
            if([event hasContainedSubscribModelForKey:target]){
                NSString *msg = [NSString stringWithFormat:IMXEventDebug_multiple_registration_err,eventName,target];
                [IMXEventDebug_share showDebugMsg:msg];
                return;
            }
        }
        IMXEventSubscribModel *subscribModel = [[IMXEventSubscribModel alloc] init];
        subscribModel.priority = priority;
        subscribModel.isInMainThread = isMain;
        subscribModel.actionBlock = action;
        subscribModel.target = target;
        [event registSubscribModel:subscribModel forKey:target];
    });
}
- (void)publishEvent:(NSString * _Nonnull)eventName delivery:(IMXEventUserInfo *)info isFromMainTread:(BOOL)isMain{
    if(!eventName) {return;}

    dispatch_async(event_bus_dispatcher_serialQueue(), ^{
        IMXEvent *event = self.events[eventName];
        if(!event){
            NSString *msg = [NSString stringWithFormat:IMXEventDebug_post_to_no_exist_err,eventName];
            [IMXEventDebug_share showDebugMsg:msg];
            return;
        }
        if([event isEmptyMap]){
            [self removeEvent:eventName];
            NSString *msg = [NSString stringWithFormat:IMXEventDebug_post_to_no_exist_err,eventName];
            [IMXEventDebug_share showDebugMsg:msg];
            return;
        }
        [event postEventWithDeliveryData:info isInMain:isMain];
    });
}
- (void)unregistSubscribModelFromTarget:(id _Nonnull)target{
    if(!target) {return;}

    dispatch_async(event_bus_dispatcher_serialQueue(), ^{
        NSMutableArray *deleteEventNames = [NSMutableArray array];
        [self.events enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            IMXEvent *event = obj;
            NSString *eventName = key;
            BOOL hasNoSubscribers = [event deleteEntryForTarget:target];
            if(hasNoSubscribers){
                [deleteEventNames addObject:eventName];
            }
        }];
        [self.events removeObjectsForKeys:deleteEventNames];
    });
}
- (void)removeEvent:(NSString *_Nonnull)eventName{
    if(!eventName) {return;}
    dispatch_async(event_bus_dispatcher_serialQueue(), ^{
        [self.events removeObjectForKey:eventName];
    });
}
#pragma mark ======  life cycle  ======

#pragma mark ======  delegate  ======

#pragma mark ======  event  ======

#pragma mark ======  private  ======

#pragma mark ======  c  ======
static dispatch_queue_t event_bus_dispatcher_serialQueue() {
    static dispatch_queue_t imx_event_bus_dispatcher_serialQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imx_event_bus_dispatcher_serialQueue = dispatch_queue_create("COM.IMX_EVENT.BUS.SERIAL_QUEUE", DISPATCH_QUEUE_SERIAL);

        dispatch_queue_t referQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_set_target_queue(imx_event_bus_dispatcher_serialQueue, referQueue);

    });
    return imx_event_bus_dispatcher_serialQueue;
}
#pragma mark ======  getter & setter  ======
- (NSMutableDictionary *)events{
    if(!_events){
        _events = [[NSMutableDictionary alloc] init];
    }
    return _events;
}

@end
