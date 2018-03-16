//
//  IMXEventMapTable.h
//  IMXEventBus
//
//  Created by zhoupanpan on 2018/3/14.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMXEventMapTable : NSMapTable
@property (nonatomic, copy) void(^elementChangeBlock)(void);

- (void)addObserverForMaps;
@end
