//
//  ViewController.m
//  IMXEventBus
//
//  Created by zhoupanpan on 2018/3/14.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "IMXEventKit.h"
static NSInteger highSuffix = 0,defaultSuffix = 0,lowSuffix = 0;
@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc{
    NSLog(@"yes");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *eventName = [NSString stringWithFormat:@"noti"];
        NSLog(@"R---regist  1 thread:%@",[NSThread currentThread]);
        [IMXEventBus_share registSubscriber:self markEvent:eventName priority:IMXEventSubscriberPriorityLow inMainTread:NO action:^(id info) {
            NSLog(@"high - ctrl :%@    thread:%@",[info description],[NSThread currentThread]);
        }];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *eventName = [NSString stringWithFormat:@"noti"];
        NSLog(@"R---regist  2 thread:%@",[NSThread currentThread]);
        [IMXEventBus_share registSubscriber:self.view markEvent:eventName priority:IMXEventSubscriberPriorityHigh inMainTread:NO action:^(id info) {
            NSLog(@"high - view :%@    thread:%@",[info description],[NSThread currentThread]);
        }];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"publish thread:%@",[NSThread currentThread]);
        NSString *eventName = [NSString stringWithFormat:@"noti"];
        [IMXEventBus_share publishEvent:eventName delivery:@{@"yes":@"wef"} isFromMainTread:NO];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"unregister 1 thread:%@",[NSThread currentThread]);
        [IMXEventBus_share unregistSubscriberFromTarget:self];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"unregister 2 thread:%@",[NSThread currentThread]);
        [IMXEventBus_share unregistSubscriberFromTarget:self.view];
    });



    self.title = @"main page";
    self.view.backgroundColor = [UIColor lightGrayColor];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Second" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(secondPage:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(80, 80, 80, 60);
    [self.view addSubview:btn];

    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Third Page" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(thirdPage:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(180, 80, 120, 60);
    [self.view addSubview:btn];

    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Regist High Btn" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(highPage:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(80, 180, 200, 60);
    [self.view addSubview:btn];

    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Regist Default Btn" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(defaultPage:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(80, 250, 200, 60);
    [self.view addSubview:btn];

    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Regist Low Btn" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(lowPage:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(80, 320, 200, 60);
    [self.view addSubview:btn];

    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Reset Btn" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(resetBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(80, 390, 200, 60);
    [self.view addSubview:btn];
}
- (void)secondPage:(UIButton *)btn{
    SecondViewController *ctrl = [SecondViewController new];
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (void)thirdPage:(UIButton *)btn{
    ThirdViewController *ctrl = [ThirdViewController new];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)highPage:(UIButton *)btn{
    NSString *eventName = [NSString stringWithFormat:@"event_high_%ld",(long)highSuffix++];
    [IMXEventBus_share registSubscriber:self markEvent:eventName priority:IMXEventSubscriberPriorityHigh inMainTread:NO action:^(id info) {
        NSLog(@"high :%@",[info description]);
    }];
}
- (void)defaultPage:(UIButton *)btn{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *eventName = [NSString stringWithFormat:@"event_high_%ld",(long)defaultSuffix++];
        [IMXEventBus_share registSubscriber:self markEvent:eventName priority:IMXEventSubscriberPriorityDefault inMainTread:YES action:^(id info) {
            NSLog(@"default :%@",[info description]);
        }];
    });

}
- (void)lowPage:(UIButton *)btn{
    NSString *eventName = [NSString stringWithFormat:@"event_high_%ld",(long)lowSuffix++];
    [IMXEventBus_share registSubscriber:self markEvent:eventName priority:IMXEventSubscriberPriorityLow inMainTread:YES action:^(id info) {
        NSLog(@"low :%@",[info description]);
    }];
}
- (void)resetBtn:(UIButton *)btn{
    highSuffix = 0;
    defaultSuffix = 0;
    lowSuffix = 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
