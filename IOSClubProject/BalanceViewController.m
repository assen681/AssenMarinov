//
//  BalanceViewController.m
//  IOSClubProject
//
//  Created by Chloe Cooper on 2/22/16.
//  Copyright © 2016 Chloe Cooper. All rights reserved.
//

#import "BalanceViewController.h"
#import <CoreMotion/CoreMotion.h>


@interface BalanceViewController ()
@property (nonatomic,weak) IBOutlet UIImageView *leftArrowImageView;
@property (nonatomic,weak) IBOutlet UIImageView *rightArrowImageView;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (weak, nonatomic) IBOutlet UIImageView *handImageView;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property(nonatomic,strong) NSTimer *longTimer;
@property(nonatomic,strong) NSTimer *shortTimer;
@property(nonatomic,assign)  BOOL isTimerRunning;
@property(nonatomic,assign) CGFloat currentTime;
@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.motionManager=[[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval =0.05;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        self.leftArrowImageView.hidden=YES;
        self.rightArrowImageView.hidden=YES;
        self.handImageView.hidden=YES;
        self.timerLabel.hidden=YES;
        if (accelerometerData.acceleration.x<-.05) {
            self.rightArrowImageView.hidden=NO;
            [self stopTimer];
        }
        else if(accelerometerData.acceleration.x<.05){
            
            self.leftArrowImageView.hidden=NO;
            [self stopTimer];
        }
        else{
            self.handImageView.hidden=NO;
            self.timerLabel.hidden=NO;
            
            if(!self.isTimerRunning){
            [self startTimer];
            }
        }
        NSLog(@"%f",accelerometerData.acceleration.x);
    }];
}

-(void) startTimer{
    self.isTimerRunning=YES;
    self.currentTime=10;
    self.longTimer =[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(longTimerExecuted) userInfo:nil repeats:NO];
    self.shortTimer =[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(shortTimerExecuted) userInfo:nil repeats:YES];
}
-(void)shortTimerExecuted{
    
    self.currentTime-=.01;
    if(self.currentTime<0){
        self.currentTime=0;
    }
    
    
    self.timerLabel.text =[NSString stringWithFormat:@"%.02f",self.currentTime];
}
-(void) longTimerExecuted{
    self.view.backgroundColor =[UIColor greenColor];
    [self stopTimer];
    [self.motionManager stopAccelerometerUpdates];
    
    self.leftArrowImageView.hidden=YES;
    self.rightArrowImageView.hidden=YES;
    self.handImageView.hidden=YES;
    self.timerLabel.hidden=YES;
}

-(void) stopTimer{
    self.isTimerRunning=NO;
    [self.longTimer invalidate];
    self.longTimer =nil;
    [self.shortTimer invalidate];
    self.shortTimer =nil;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
