//
//  IMXEvent.m
//  IMXProject
//
//  Created by zhoupanpan on 2018/3/12.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import "IMXEvent.h"
#import "IMXEventSubscriber.h"
@interface IMXEvent(){
    dispatch_semaphore_t actionSemaphore;
}
@property (nonatomic,strong)NSMapTable *mapHigh;
@property (nonatomic,strong)NSMapTable *mapDefault;
@property (nonatomic,strong)NSMapTable *mapLow;
@end

@implementation IMXEvent
- (void)dealloc{
    NSLog(@"yew-dealloc");
}
#pragma mark ======  public  ======
- (BOOL)hasContainedSubscriberForKey:(id)target{
    if(!target) return NO;

    if([self.mapHigh objectForKey:target]){
        return YES;
    }
    if([self.mapDefault objectForKey:target]){
        return YES;
    }
    if([self.mapLow objectForKey:target]){
        return YES;
    }
    return NO;
}
- (void)addSubscriber:(IMXEventSubscriber *)subscriber forKey:(id)target{
    if(!subscriber) {return;}
    if(!target) {return;}NSNotification

    switch (subscriber.priority) {
        case IMXEventSubscriberPriorityHigh:{
            [self addSubscriber:subscriber forKey:target toMap:self.mapHigh];
        }
            break;
        case IMXEventSubscriberPriorityDefault:{
            [self addSubscriber:subscriber forKey:target toMap:self.mapDefault];
        }
            break;
        case IMXEventSubscriberPriorityLow:{
            [self addSubscriber:subscriber forKey:target toMap:self.mapLow];
        }
            break;

        default:{
            [self addSubscriber:subscriber forKey:target toMap:self.mapDefault];
        }
            break;
    }
}

- (void)responseEventWithDeliveryData:(id)info isInMain:(BOOL)isMain{
        [self actionMap:self.mapHigh deliveryData:info isInMain:isMain];
        [self actionMap:self.mapDefault deliveryData:info isInMain:isMain];
        [self actionMap:self.mapLow deliveryData:info isInMain:isMain];
}
- (BOOL)deleteEntriesForTarget:(id _Nonnull)target{
    if(!target) {return NO;}

    [self deleteEntriesForTarget:target in:self.mapHigh];
    [self deleteEntriesForTarget:target in:self.mapDefault];
    [self deleteEntriesForTarget:target in:self.mapLow];

    BOOL isEmpty = [self isEmptyMap];
    return isEmpty;
}
- (BOOL)isEmptyMap{
    BOOL isEmptyHigh = self.mapHigh.keyEnumerator.allObjects.count <= 0;
    BOOL isEmptyDefault = self.mapDefault.keyEnumerator.allObjects.count <= 0;
    BOOL isEmptyLow = self.mapLow.keyEnumerator.allObjects.count <= 0;

    return isEmptyHigh && isEmptyDefault && isEmptyLow;
}
#pragma mark ======  life cycle  ======
- (instancetype)init{
    self = [super init];
    if (self) {
        actionSemaphore = dispatch_semaphore_create(4);
        [self nestConcurrent2SerialQueue];
    }
    return self;
}
#pragma mark ======  delegate  ======
#pragma mark ======  event  ======

#pragma mark ======  private  ======
- (void)nestConcurrent2SerialQueue{
    dispatch_set_target_queue(event_subscriber_dispatcher_concurrentQueue(), event_subscriber_dispatcher_serialQueue());
}
- (void)actionMap:(NSMapTable *)map deliveryData:(id)info isInMain:(BOOL)isMain{
    // do need lock?
    dispatch_async(event_subscriber_dispatcher_concurrentQueue(), ^{
        NSArray *tmps = [[NSArray alloc] initWithArray:map.objectEnumerator.allObjects];
        [tmps enumerateObjectsUsingBlock:^(IMXEventSubscriber * _Nonnull subscriber, NSUInteger idx, BOOL * _Nonnull stop) {
            dispatch_semaphore_wait(actionSemaphore, DISPATCH_TIME_FOREVER);
            if(isMain){
                [self mainTreadAction:^{
                    subscriber.actionBlock(info);
                }];
            }else{
                if(subscriber.isInMainTread){
                    [self mainTreadAction:^{
                        subscriber.actionBlock(info);
                    }];
                }else{
                    subscriber.actionBlock(info);
                }
            }
            dispatch_semaphore_signal(actionSemaphore);
        }];
    });
}
- (void)deleteEntriesForTarget:(id)target in:(NSMapTable *)map{
    [map removeObjectForKey:target];
}
- (void)addSubscriber:(IMXEventSubscriber *)subscriber forKey:(id)target toMap:(NSMapTable *)map{
    [map setObject:subscriber forKey:target];
}
- (void)mainTreadAction:(void(^)(void))action{
    if([NSThread isMainThread]){
        if(action){
            action();
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(action){
                action();
            }
        });
    }
}
#pragma mark ======  c  ======
static dispatch_queue_t event_subscriber_dispatcher_serialQueue() {
    static dispatch_queue_t imx_event_subscriber_dispatcher_serialQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imx_event_subscriber_dispatcher_serialQueue = dispatch_queue_create("COM.IMX_EVENT.SERIAL_QUEUE", DISPATCH_QUEUE_SERIAL);

        dispatch_queue_t referQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_set_target_queue(imx_event_subscriber_dispatcher_serialQueue, referQueue);

    });
    return imx_event_subscriber_dispatcher_serialQueue;
}
static dispatch_queue_t event_subscriber_dispatcher_concurrentQueue() {
    static dispatch_queue_t imx_event_subscriber_dispatcher_concurrentQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imx_event_subscriber_dispatcher_concurrentQueue = dispatch_queue_create("COM.IMX_EVENT.CONCURRENT_QUEUE", DISPATCH_QUEUE_CONCURRENT);

        dispatch_queue_t referQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_set_target_queue(imx_event_subscriber_dispatcher_concurrentQueue, referQueue);
    });
    return imx_event_subscriber_dispatcher_concurrentQueue;
}
#pragma mark ======  getter & setter  ======
- (NSMapTable *)mapHigh{
    if(!_mapHigh){
        _mapHigh = [NSMapTable weakToStrongObjectsMapTable];
    }
    return _mapHigh;
}
- (NSMapTable *)mapDefault{
    if(!_mapDefault){
        _mapDefault = [NSMapTable weakToStrongObjectsMapTable];
    }
    return _mapDefault;
}
- (NSMapTable *)mapLow{
    if(!_mapLow){
        _mapLow = [NSMapTable weakToStrongObjectsMapTable];
    }
    return _mapLow;
}
@end
