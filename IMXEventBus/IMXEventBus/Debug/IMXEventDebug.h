//
//  IMXEventDebug.h
//  IMXEventBus
//
//  Created by zhoupanpan on 2018/3/29.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IMXEventDebug_multiple_registration_err @"!multiple_registration!\nName:%@\nTarget:%@"
#define IMXEventDebug_post_to_no_exist_err @"!post_to_no_exist_event!\nName:%@"
typedef NS_ENUM(NSInteger, IMXEventDebugType) {
    IMXEventDebugTypeLog,
    IMXEventDebugTypeAlert,
};
#define IMXEventDebug_share [IMXEventDebug sharedInstance]
@interface IMXEventDebug : NSObject
@property (nonatomic,assign)IMXEventDebugType debugType;

+ (IMXEventDebug *)sharedInstance;
- (void)enableDebug:(BOOL)isEnableDebug;
- (void)showDebugMsg:(NSString *)msg;

- (void)showAllRegistEventDetail;
- (void)sizeOfEventBus;
@end
