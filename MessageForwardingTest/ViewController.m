//
//  ViewController.m
//  MessageForwardingTest
//
//  Created by 黄龙辉 on 15/9/18.
//  Copyright (c) 2015年 黄龙辉. All rights reserved.
//

#import "ViewController.h"
#import "PersonModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PersonModel *personModel = [[PersonModel alloc] init];
    
    //消息转发  resolveInstanceMethod
    personModel.name = @"Jim Green";
    NSString *name = personModel.name;
    NSLog(@"%@", name);
    return;
    NSLog(@"%@", personModel.firstName);
    NSLog(@"%@", personModel.lastName);
    
    //消息转发 forwardingTargetForSelector
    //companyName 方法是在PersonModel是未实现的 转发给CompanyModel对象，让它去实现
    name = [personModel companyName];
    NSLog(@"%@", name);
    
    //消息转发 forwardInvocation
    name = [personModel deptName];
    NSLog(@"%@", name);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
