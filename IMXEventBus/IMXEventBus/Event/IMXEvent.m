//
//  IMXEvent.m
//  IMXProject
//
//  Created by zhoupanpan on 2018/3/12.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import "IMXEvent.h"
#import "IMXEventSubscribModel.h"
#import "IMXEventUserInfo.h"
@interface IMXEvent(){

}
@property (nonatomic,strong)NSMapTable *mapHigh;
@property (nonatomic,strong)NSMapTable *mapDefault;
@property (nonatomic,strong)NSMapTable *mapLow;
@property (nonatomic,strong)dispatch_semaphore_t actionSemaphore;
@end

@implementation IMXEvent
- (void)dealloc{
}
#pragma mark ======  public  ======
- (BOOL)hasContainedSubscribModelForKey:(id)target{
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
- (void)registSubscribModel:(IMXEventSubscribModel *)subscrib forKey:(id)target{
    if(!subscrib) {return;}
    if(!target) {return;}

    switch (subscrib.priority) {
        case IMXEventSubscriberPriorityHigh:{
            [self addSubscribModel:subscrib forKey:target toMap:self.mapHigh];
        }
            break;
        case IMXEventSubscriberPriorityDefault:{
            [self addSubscribModel:subscrib forKey:target toMap:self.mapDefault];
        }
            break;
        case IMXEventSubscriberPriorityLow:{
            [self addSubscribModel:subscrib forKey:target toMap:self.mapLow];
        }
            break;

        default:{
            [self addSubscribModel:subscrib forKey:target toMap:self.mapDefault];
        }
            break;
    }
}
- (void)postEventWithDeliveryData:(IMXEventUserInfo *)info isInMain:(BOOL)isMain{
#ifdef DEBUG
    self.triggerCount++;
#endif
        [self actionMap:self.mapHigh deliveryData:info isInMain:isMain];
        [self actionMap:self.mapDefault deliveryData:info isInMain:isMain];
        [self actionMap:self.mapLow deliveryData:info isInMain:isMain];
}
- (BOOL)deleteEntryForTarget:(id _Nonnull)target{
    if(!target) {return NO;}

    [self deleteEntryForTarget:target in:self.mapHigh];
    [self deleteEntryForTarget:target in:self.mapDefault];
    [self deleteEntryForTarget:target in:self.mapLow];

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
        self.actionSemaphore = dispatch_semaphore_create(4);
        [self nestConcurrent2SerialQueue];

#ifdef DEBUG
        self.triggerCount = 0;
#endif
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
    dispatch_async(event_subscriber_dispatcher_concurrentQueue(), ^{
        NSArray *tmps = [[NSArray alloc] initWithArray:map.objectEnumerator.allObjects];
        __weak __typeof(self)weakSelf = self;
        [tmps enumerateObjectsUsingBlock:^(IMXEventSubscribModel * _Nonnull subscriber, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            dispatch_semaphore_wait(strongSelf.actionSemaphore, DISPATCH_TIME_FOREVER);
            [subscriber actionWIthInfo:info forceMainThread:isMain];
            dispatch_semaphore_signal(strongSelf.actionSemaphore);
        }];
    });
}
- (void)deleteEntryForTarget:(id)target in:(NSMapTable *)map{
    [map removeObjectForKey:target];
}
- (void)addSubscribModel:(IMXEventSubscribModel *)subscrib forKey:(id)target toMap:(NSMapTable *)map{
    [map setObject:subscrib forKey:target];
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
