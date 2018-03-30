//
//  IMXEventUserInfo.m
//  IMXEventBus
//
//  Created by zhoupanpan on 2018/3/19.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import "IMXEventUserInfo.h"

@implementation IMXEventUserInfo
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%p> - userInfo: %@, extobj: %@", self, [self.userInfo description],[self.extObj description]];
}
@end
