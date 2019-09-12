//
//  ViewController.m
//  FastCodeProduct
//
//  Created by lsr on 2019/9/12.
//  Copyright © 2019 GJNativeTeam. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect codeFrame = CGRectMake(15, 160,self.view.frame.size.width - 30, 60);
    FastCodeView *codeView = [[FastCodeView alloc] initWithFrame:codeFrame];
    codeView.style = kCodeStyleWithSquare;
    [codeView showCodeView];
    [codeView didSelectCode:^(NSString * _Nullable code) {
        NSLog(@"code======%@",code);
    }];
    
    [self.view addSubview:codeView];
    // Do any additional setup after loading the view.
}


@end
