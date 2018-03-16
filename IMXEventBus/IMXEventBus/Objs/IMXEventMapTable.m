//
//  IMXEventMapTable.m
//  IMXEventBus
//
//  Created by zhoupanpan on 2018/3/14.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import "IMXEventMapTable.h"

@implementation IMXEventMapTable
- (void)dealloc{
}
#pragma mark ======  public  ======

#pragma mark ======  life cycle  ======
- (instancetype)initWithKeyOptions:(NSPointerFunctionsOptions)keyOptions valueOptions:(NSPointerFunctionsOptions)valueOptions capacity:(NSUInteger)initialCapacity{
    self = [super initWithKeyOptions:keyOptions valueOptions:valueOptions capacity:initialCapacity];
    if(self){
        [self addObserverForMaps];
    }
    return self;
}
#pragma mark ======  delegate  ======

#pragma mark ======  event  ======

#pragma mark ======  private  ======
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if(self.elementChangeBlock){
        self.elementChangeBlock();
    }
}
#pragma mark ======  getter & setter  ======
- (void)addObserverForMaps{
    [self addObserver:self forKeyPath:@"count" options:0 context:NULL];
}
@end
