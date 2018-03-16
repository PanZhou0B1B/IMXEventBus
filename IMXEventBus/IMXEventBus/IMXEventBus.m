//
//  IMXEventBus.m
//  IMXProject
//
//  Created by zhoupanpan on 2018/3/12.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import "IMXEventBus.h"
#import "IMXEvent.h"
#import "IMXEventSubscriber.h"
@interface IMXEventBus()
@property (nonatomic,strong)NSMutableDictionary *events;
@property (nonatomic,strong)NSLock *accessLock;
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
- (void)registSubscriber:(id _Nonnull)target markEvent:(NSString * _Nonnull)eventName priority:(IMXEventSubscriberPriority)priority inMainTread:(BOOL)isMain action:(IMXEventSubscriberActionBlock _Nonnull)action{
    if(!target) {return;}
    if(!eventName) {return;}
    if(!action) {return;}

    //TODO: need lock for thread safe?
    [self.accessLock lock];
    IMXEvent *event = self.events[eventName];
    if(!event){
        event = [[IMXEvent alloc] init];
        event.eventName = eventName;
        self.events[eventName] = event;
    }else{
        if([event hasContainedSubscriberForKey:target]){
            return;
        }
    }
    IMXEventSubscriber *subscriber = [[IMXEventSubscriber alloc] init];
    subscriber.priority = priority;
    subscriber.isInMainTread = isMain;
    subscriber.actionBlock = action;
    [event addSubscriber:subscriber forKey:target];
    [self.accessLock unlock];
}
- (void)publishEvent:(NSString * _Nonnull)eventName delivery:(id)info isFromMainTread:(BOOL)isMain{
    if(!eventName) {return;}

    [self.accessLock lock];
    IMXEvent *event = self.events[eventName];
    if(!event){
        return;
    }
    if([event isEmptyMap]){
        [self removeEvent:eventName];
        return;
    }
    [event responseEventWithDeliveryData:info isInMain:isMain];
    [self.accessLock unlock];
}
- (void)unregistSubscriberFromTarget:(id _Nonnull)target{
    if(!target) {return;}

    [self.accessLock lock];
    NSMutableArray *deleteEventNames = [NSMutableArray array];
    [self.events enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        IMXEvent *event = obj;
        NSString *eventName = key;
        BOOL hasNoSubscribers = [event deleteEntriesForTarget:target];
        if(hasNoSubscribers){
            [deleteEventNames addObject:eventName];
        }
    }];
    [self.events removeObjectsForKeys:deleteEventNames];
    [self.accessLock unlock];
}
- (void)removeEvent:(NSString *_Nonnull)eventName{
    if(!eventName) {return;}
    [self.accessLock lock];
    [self.events removeObjectForKey:eventName];
    [self.accessLock unlock];
}
#pragma mark ======  life cycle  ======

#pragma mark ======  delegate  ======

#pragma mark ======  event  ======

#pragma mark ======  private  ======

#pragma mark ======  getter & setter  ======
- (NSMutableDictionary *)events{
    if(!_events){
        _events = [[NSMutableDictionary alloc] init];
    }
    return _events;
}
- (NSLock *)accessLock{
    if(!_accessLock){
        _accessLock = [[NSLock alloc] init];
    }
    return _accessLock;
}
@end
