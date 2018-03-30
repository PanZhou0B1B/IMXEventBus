//
//  IMXEventUserInfo.h
//  IMXEventBus
//
//  Created by zhoupanpan on 2018/3/19.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMXEventUserInfo : NSObject
@property (nonatomic,copy)NSDictionary *userInfo;
@property (nonatomic,strong)id extObj;
@end
