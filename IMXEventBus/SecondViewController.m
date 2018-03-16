//
//  SecondViewController.m
//  IMXEventBus
//
//  Created by zhoupanpan on 2018/3/14.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import "SecondViewController.h"
#import "IMXEventKit.h"
static NSInteger highSuffix = 0,defaultSuffix = 0,lowSuffix = 0;

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)dealloc{
    NSLog(@"yes");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"second page";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
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
- (void)highPage:(UIButton *)btn{
    NSString *eventName = [NSString stringWithFormat:@"event_high_%ld",(long)highSuffix++];
    [IMXEventBus_share registSubscriber:self markEvent:eventName priority:IMXEventSubscriberPriorityHigh inMainTread:NO action:^(id info) {
        NSLog(@"high :%@",[info description]);
    }];
}
- (void)defaultPage:(UIButton *)btn{
    NSString *eventName = [NSString stringWithFormat:@"event_default_%ld",(long)defaultSuffix++];
    [IMXEventBus_share registSubscriber:self markEvent:eventName priority:IMXEventSubscriberPriorityDefault inMainTread:YES action:^(id info) {
        NSLog(@"default :%@",[info description]);
    }];
}
- (void)lowPage:(UIButton *)btn{
    NSString *eventName = [NSString stringWithFormat:@"event_low_%ld",(long)lowSuffix++];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
