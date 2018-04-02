//
//  ThirdViewController.m
//  IMXEventBus
//
//  Created by zhoupanpan on 2018/3/14.
//  Copyright © 2018年 panzhow. All rights reserved.
//

#import "ThirdViewController.h"
#import "IMXEventBusKit.h"

static NSInteger highSuffix = 0,defaultSuffix = 0,lowSuffix = 0;
@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)dealloc{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"third page";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"publish High Btn" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(publishHigh:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(80, 320, 200, 60);
    [self.view addSubview:btn];


    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"publish Default Btn" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(publishDefault:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(80, 390, 200, 60);
    [self.view addSubview:btn];


    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"publish Low Btn" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(publishLow:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(80, 460, 200, 60);
    [self.view addSubview:btn];

    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Reset Publish Suffix" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(80, 530, 200, 30);
    [self.view addSubview:btn];
}

- (void)publishHigh:(UIButton *)btn{
    NSString *eventName = [NSString stringWithFormat:@"event_high_%ld",(long)highSuffix++];
    [IMXEventPoster postEventName:eventName object:nil forceMain:YES];
}
- (void)publishDefault:(UIButton *)btn{
    NSString *eventName = [NSString stringWithFormat:@"event_default_%ld",(long)defaultSuffix++];
    [IMXEventPoster postEventName:eventName object:@{@"yes":@"wef"} forceMain:NO];
}
- (void)publishLow:(UIButton *)btn{
    [IMXEventDebug_share showAllRegistEvent];
    [IMXEventDebug_share showAllRegistEventDetail];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *eventName = [NSString stringWithFormat:@"event_low_%ld",(long)lowSuffix++];
        [IMXEventPoster postEventName:eventName object:nil forceMain:YES];
    });
}
- (void)reset:(UIButton *)btn{
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
