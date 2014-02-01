//
//  TSTViewController.m
//  flipboardSample
//
//  Created by Ken Shiota on 2014/02/01.
//  Copyright (c) 2014年 Tesseract. All rights reserved.
//

#import "TSTViewController.h"

@interface TSTViewController ()

@end

@implementation TSTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.flipboard setImages:@[[UIImage imageNamed:@"monalisa"], [UIImage imageNamed:@"rena"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onStartAnimation:(id)sender {
    [self.flipboard startAnimation];
}
@end
