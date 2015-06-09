//
//  ViewController.m
//  YSMWheelShowDemo
//
//  Created by ysmeng on 15/6/8.
//  Copyright (c) 2015年 杨声孟个人开发. All rights reserved.
//

#import "ViewController.h"
#import "Header.h"

///是否使用layer动画
//#define ___USING_CALAYER_ANIMATE___

///按钮展现状态时的半径
#define MAX_REDIO_SHOW 88.0f

///按钮的大小
#define WIDTH_HEIGHT_BUTTON 44.0f

///将角度转为弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *flyButton;
@property (weak, nonatomic) IBOutlet UIButton *personButton;
@property (weak, nonatomic) IBOutlet UIButton *whoButton;
@property (weak, nonatomic) IBOutlet UIButton *godButton;
@property (weak, nonatomic) IBOutlet UIButton *westButton;
@property (weak, nonatomic) IBOutlet UIButton *weaponButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;                  //!<显示按钮
@property (weak, nonatomic) IBOutlet UIButton *centerButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showButtonHeight;  //!<显示按钮的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showButtonWidth;   //!<显示按钮的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerButtonYPoint;

@property (assign) NSInteger isShowStatus;                                  //!<当前展开的状态
@property (assign, nonatomic) CGPoint showCenter;                           //!<展现时中心点
@property (retain, nonatomic) NSMutableArray *showDampingCenters;           //!<原始的弹性中心
@property (retain, nonatomic) NSMutableArray *showSubCenters;               //!<大圆周上按钮中心点
@property (retain, nonatomic) NSMutableArray *animateSubCenters;            //!<动画展现时的切点
@property (retain, nonatomic) NSMutableArray *buttonList;                   //!<按钮数组

@property (assign) NSInteger currentIndex;                                  //!<当前下标

@end

@implementation ViewController

#pragma mark - 
#pragma mark - UI加载
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.isShowStatus = 0;
    
    ///初始化时将按钮放在显示按钮重叠的地方，方便点击时动画
    [self hiddenStatus:NO];
    
}

#pragma mark - 
#pragma mark - 设置状态
- (void)hiddenStatus:(BOOL)animate
{

    ///非动画
    if (!animate) {
        
        ///透明度
        self.flyButton.alpha = 0.0f;
        self.personButton.alpha = 0.0f;
        self.whoButton.alpha = 0.0f;
        self.godButton.alpha = 0.0f;
        self.westButton.alpha = 0.0f;
        self.weaponButton.alpha = 0.0f;
        self.centerButton.alpha = 0.0f;
        
        ///中心点
        self.flyButton.center = self.showButton.center;
        self.personButton.center = self.showButton.center;
        self.whoButton.center = self.showButton.center;
        self.godButton.center = self.showButton.center;
        self.westButton.center = self.showButton.center;
        self.weaponButton.center = self.showButton.center;
        self.centerButton.center = self.showButton.center;
        
        ///大小
        self.flyButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 4.0f, WIDTH_HEIGHT_BUTTON / 4.0f);
        self.personButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 4.0f, WIDTH_HEIGHT_BUTTON / 4.0f);
        self.whoButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 4.0f, WIDTH_HEIGHT_BUTTON / 4.0f);
        self.godButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 4.0f, WIDTH_HEIGHT_BUTTON / 4.0f);
        self.westButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 4.0f, WIDTH_HEIGHT_BUTTON / 4.0f);
        self.weaponButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 4.0f, WIDTH_HEIGHT_BUTTON / 4.0f);
        self.centerButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 4.0f, WIDTH_HEIGHT_BUTTON / 4.0f);
        
        return;
        
    }
    
    ///收缩
    __weak typeof(self) weakSelf = self;
    [self spreadAnimate:NO andCallBack:^(BOOL isFinish) {
        
        if (isFinish) {
            
            [weakSelf shiftAnimate:NO andCallBack:^(BOOL isFinish) {
                
                weakSelf.isShowStatus = 0;
                
            }];
            
        }
        
    }];
    
}

- (void)showStatus:(BOOL)animate
{
    
    [self hiddenStatus:NO];
    
    ///非动画
    if (!animate) {
        
        ///透明度
        self.flyButton.alpha = 1.0f;
        self.personButton.alpha = 1.0f;
        self.whoButton.alpha = 1.0f;
        self.godButton.alpha = 1.0f;
        self.westButton.alpha = 1.0f;
        self.weaponButton.alpha = 1.0f;
        self.centerButton.alpha = 1.0f;
        
        ///中心点
        self.flyButton.center = CGPointMake([[self.showDampingCenters[4] objectForKey:@"x"] floatValue], [[self.showDampingCenters[4] objectForKey:@"y"] floatValue]);
        
        self.personButton.center = CGPointMake([[self.showDampingCenters[5] objectForKey:@"x"] floatValue], [[self.showDampingCenters[5] objectForKey:@"y"] floatValue]);
        
        self.whoButton.center = CGPointMake([[self.showDampingCenters[3] objectForKey:@"x"] floatValue], [[self.showDampingCenters[3] objectForKey:@"y"] floatValue]);
        
        self.godButton.center = CGPointMake([[self.showDampingCenters[2] objectForKey:@"x"] floatValue], [[self.showDampingCenters[2] objectForKey:@"y"] floatValue]);
        
        self.westButton.center = CGPointMake([[self.showDampingCenters[0] objectForKey:@"x"] floatValue], [[self.showDampingCenters[0] objectForKey:@"y"] floatValue]);
        
        self.weaponButton.center = CGPointMake([[self.showDampingCenters[1] objectForKey:@"x"] floatValue], [[self.showDampingCenters[1] objectForKey:@"y"] floatValue]);
        self.centerButton.center = self.showCenter;
        
        ///大小
        self.flyButton.bounds = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
        self.personButton.bounds = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
        self.whoButton.bounds = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
        self.godButton.bounds = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
        self.westButton.bounds = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
        self.weaponButton.bounds = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
        self.centerButton.bounds = CGRectMake(0.0f, 0.0f, 60.0f, 60.0f);
        
        return;
        
    }
    
    ///位移
    __weak typeof(self) weakSelf = self;
    [self shiftAnimate:YES andCallBack:^(BOOL isFinish) {
        
#if 1
        if (isFinish) {
            
            ///展开
            [weakSelf spreadAnimate:YES andCallBack:^(BOOL isFinish) {
                
                [weakSelf springWithDamping:self.flyButton center:CGPointMake([[self.showSubCenters[4] objectForKey:@"x"] floatValue], [[self.showSubCenters[4] objectForKey:@"y"] floatValue]) completion:^(BOOL isFinish) {}];
                [weakSelf springWithDamping:self.personButton center:CGPointMake([[self.showSubCenters[5] objectForKey:@"x"] floatValue], [[self.showSubCenters[5] objectForKey:@"y"] floatValue]) completion:^(BOOL isFinish) {}];
                [weakSelf springWithDamping:self.whoButton center:CGPointMake([[self.showSubCenters[3] objectForKey:@"x"] floatValue], [[self.showSubCenters[3] objectForKey:@"y"] floatValue]) completion:^(BOOL isFinish) {}];
                [weakSelf springWithDamping:self.godButton center:CGPointMake([[self.showSubCenters[2] objectForKey:@"x"] floatValue], [[self.showSubCenters[2] objectForKey:@"y"] floatValue]) completion:^(BOOL isFinish) {}];
                [weakSelf springWithDamping:self.westButton center:CGPointMake([[self.showSubCenters[0] objectForKey:@"x"] floatValue], [[self.showSubCenters[0] objectForKey:@"y"] floatValue]) completion:^(BOOL isFinish) {}];
                [weakSelf springWithDamping:self.weaponButton center:CGPointMake([[self.showSubCenters[1] objectForKey:@"x"] floatValue], [[self.showSubCenters[1] objectForKey:@"y"] floatValue]) completion:^(BOOL isFinish) {}];
                
                weakSelf.isShowStatus = 1;
                
            }];
            
        }
#endif
        
    }];

}

///展开/收缩动画
- (void)spreadAnimate:(BOOL)isShow andCallBack:(void(^)(BOOL isFinish))callBack
{

    if (isShow) {
        
#ifdef ___USING_CALAYER_ANIMATE___
        
#else
        [UIView animateWithDuration:0.5f animations:^{
            
            ///透明度
            self.flyButton.alpha = 1.0f;
            self.personButton.alpha = 1.0f;
            self.whoButton.alpha = 1.0f;
            self.godButton.alpha = 1.0f;
            self.westButton.alpha = 1.0f;
            self.weaponButton.alpha = 1.0f;
            self.centerButton.alpha = 1.0f;
            
            ///中心点
            self.flyButton.center = CGPointMake([[self.showDampingCenters[4] objectForKey:@"x"] floatValue], [[self.showDampingCenters[4] objectForKey:@"y"] floatValue]);
            
            self.personButton.center = CGPointMake([[self.showDampingCenters[5] objectForKey:@"x"] floatValue], [[self.showDampingCenters[5] objectForKey:@"y"] floatValue]);
            
            self.whoButton.center = CGPointMake([[self.showDampingCenters[3] objectForKey:@"x"] floatValue], [[self.showDampingCenters[3] objectForKey:@"y"] floatValue]);
            
            self.godButton.center = CGPointMake([[self.showDampingCenters[2] objectForKey:@"x"] floatValue], [[self.showDampingCenters[2] objectForKey:@"y"] floatValue]);
            
            self.westButton.center = CGPointMake([[self.showDampingCenters[0] objectForKey:@"x"] floatValue], [[self.showDampingCenters[0] objectForKey:@"y"] floatValue]);
            
            self.weaponButton.center = CGPointMake([[self.showDampingCenters[1] objectForKey:@"x"] floatValue], [[self.showDampingCenters[1] objectForKey:@"y"] floatValue]);
            
            ///大小
            self.flyButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON + 10.0f, WIDTH_HEIGHT_BUTTON + 10.0f);
            self.personButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON + 10.0f, WIDTH_HEIGHT_BUTTON + 10.0f);
            self.whoButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON + 10.0f, WIDTH_HEIGHT_BUTTON + 10.0f);
            self.godButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON + 10.0f, WIDTH_HEIGHT_BUTTON + 10.0f);
            self.westButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON + 10.0f, WIDTH_HEIGHT_BUTTON + 10.0f);
            self.weaponButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON + 10.0f, WIDTH_HEIGHT_BUTTON + 10.0f);
            self.centerButton.bounds = CGRectMake(0.0f, 0.0f, 60.0f, 60.0f);
            
        } completion:callBack];
#endif
        
        return;
        
    }
    
#ifdef ___USING_CALAYER_ANIMATE___
    
#else
    [UIView animateWithDuration:0.5f animations:^{
        
        ///透明度：渐变为0.2
        self.flyButton.alpha = 0.2f;
        self.personButton.alpha = 0.2f;
        self.whoButton.alpha = 0.2f;
        self.godButton.alpha = 0.2f;
        self.westButton.alpha = 0.2f;
        self.weaponButton.alpha = 0.2f;
        self.centerButton.alpha = 0.2f;
        
        ///位移动显示中心
        self.flyButton.center = self.showCenter;
        self.personButton.center = self.showCenter;
        self.whoButton.center = self.showCenter;
        self.godButton.center = self.showCenter;
        self.westButton.center = self.showCenter;
        self.weaponButton.center = self.showCenter;
        self.centerButton.center = self.showCenter;
        
        ///形变为一半大小
        self.flyButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 2.0f, WIDTH_HEIGHT_BUTTON / 2.0f);
        self.personButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 2.0f, WIDTH_HEIGHT_BUTTON / 2.0f);
        self.whoButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 2.0f, WIDTH_HEIGHT_BUTTON / 2.0f);
        self.godButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 2.0f, WIDTH_HEIGHT_BUTTON / 2.0f);
        self.westButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 2.0f, WIDTH_HEIGHT_BUTTON / 2.0f);
        self.weaponButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 2.0f, WIDTH_HEIGHT_BUTTON / 2.0f);
        self.centerButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 2.0f, WIDTH_HEIGHT_BUTTON / 2.0f);
        
    } completion:callBack];
#endif

}

///位移动画
- (void)shiftAnimate:(BOOL)isShow andCallBack:(void(^)(BOOL isFinish))callBack
{

    ///展开位移
    if (isShow) {
        
#ifdef ___USING_CALAYER_ANIMATE___
        
#else
        [UIView animateWithDuration:0.3f animations:^{
            
            ///透明度：渐变为0.2
            self.flyButton.alpha = 0.2f;
            self.personButton.alpha = 0.2f;
            self.whoButton.alpha = 0.2f;
            self.godButton.alpha = 0.2f;
            self.westButton.alpha = 0.2f;
            self.weaponButton.alpha = 0.2f;
            self.centerButton.alpha = 0.2f;
            
            ///位移动显示中心
            self.flyButton.center = self.showCenter;
            self.personButton.center = self.showCenter;
            self.whoButton.center = self.showCenter;
            self.godButton.center = self.showCenter;
            self.westButton.center = self.showCenter;
            self.weaponButton.center = self.showCenter;
            self.centerButton.center = self.showCenter;
            
            ///形变为一半大小
            self.flyButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 2.0f, WIDTH_HEIGHT_BUTTON / 2.0f);
            self.personButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 2.0f, WIDTH_HEIGHT_BUTTON / 2.0f);
            self.whoButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 2.0f, WIDTH_HEIGHT_BUTTON / 2.0f);
            self.godButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 2.0f, WIDTH_HEIGHT_BUTTON / 2.0f);
            self.westButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 2.0f, WIDTH_HEIGHT_BUTTON / 2.0f);
            self.weaponButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 2.0f, WIDTH_HEIGHT_BUTTON / 2.0f);
            self.centerButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 2.0f, WIDTH_HEIGHT_BUTTON / 2.0f);
            
        } completion:callBack];
#endif
        
        return;
        
    }
    
    ///收缩位移
#ifdef ___USING_CALAYER_ANIMATE___
    
#else
    [UIView animateWithDuration:0.3f animations:^{
        
        ///透明度：渐变为0.2
        self.flyButton.alpha = 0.0f;
        self.personButton.alpha = 0.0f;
        self.whoButton.alpha = 0.0f;
        self.godButton.alpha = 0.0f;
        self.westButton.alpha = 0.0f;
        self.weaponButton.alpha = 0.0f;
        self.centerButton.alpha = 0.0f;
        
        ///位移动显示中心
        self.flyButton.center = self.showButton.center;
        self.personButton.center = self.showButton.center;
        self.whoButton.center = self.showButton.center;
        self.godButton.center = self.showButton.center;
        self.westButton.center = self.showButton.center;
        self.weaponButton.center = self.showButton.center;
        self.centerButton.center = self.showButton.center;
        
        ///形变为四分之一大小
        self.flyButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 4.0f, WIDTH_HEIGHT_BUTTON / 4.0f);
        self.personButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 4.0f, WIDTH_HEIGHT_BUTTON / 4.0f);
        self.whoButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 4.0f, WIDTH_HEIGHT_BUTTON / 4.0f);
        self.godButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 4.0f, WIDTH_HEIGHT_BUTTON / 4.0f);
        self.westButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 4.0f, WIDTH_HEIGHT_BUTTON / 4.0f);
        self.weaponButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 4.0f, WIDTH_HEIGHT_BUTTON / 4.0f);
        self.centerButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON / 4.0f, WIDTH_HEIGHT_BUTTON / 4.0f);
        
    } completion:callBack];
#endif

}

///弹簧效果
- (void)springWithDamping:(UIView *)dampingView center:(CGPoint)location completion:(void(^)(BOOL isFinish))callBack
{

    [UIView animateWithDuration:1.0f
                          delay:0.0f
         usingSpringWithDamping:0.1
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         dampingView.center = location;
                         dampingView.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON, WIDTH_HEIGHT_BUTTON);
                     
                     }
                     completion:callBack];

}

#pragma mark -
#pragma mark - 按钮事件
- (IBAction)flyButtonAction:(UIButton *)sender
{
    
    NSLog(@"当前点击:fly button");
    
}

- (IBAction)personButtonAction:(UIButton *)sender
{
    
    NSLog(@"当前点击:person button");
    
}

- (IBAction)whoButtonAction:(UIButton *)sender
{
    
    NSLog(@"当前点击:who button");
    
}

- (IBAction)godButtonAction:(UIButton *)sender
{
    
    NSLog(@"当前点击:god button");
    
}

- (IBAction)westButtonAction:(UIButton *)sender
{
    
    NSLog(@"当前点击:west button");
    
}

- (IBAction)weaponButtonAction:(UIButton *)sender
{
    
    NSLog(@"当前点击:weapon button");
    
}

- (IBAction)centerButtonAction:(UIButton *)sender
{
    
    ///判断当前是否显示中
    if (1 != self.isShowStatus) {
        
        return;
        
    }
    
    ///更换位置
    for (int i = 0; i < 5; i++) {
        
        [self.showDampingCenters exchangeObjectAtIndex:i withObjectAtIndex:i+1];
        [self.showSubCenters exchangeObjectAtIndex:i withObjectAtIndex:i+1];
        
    }
    
    ///重置当前下标
    self.currentIndex++;
    if (self.currentIndex >= 6) {
        
        self.currentIndex = 0;
        
    }
    
    ///显示中，则转动一次
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        ///重置选择状态
        for (int i = 0; i < [weakSelf.buttonList count]; i++) {
            
            UIButton *tempButton = weakSelf.buttonList[i];
            
            if (i != weakSelf.currentIndex) {
                
                tempButton.selected = NO;
                continue;
                
            }
            
            tempButton.selected = YES;
            
        }
        
        ///形变
        weakSelf.flyButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON + 10.0f, WIDTH_HEIGHT_BUTTON + 10.0f);
        weakSelf.personButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON + 10.0f, WIDTH_HEIGHT_BUTTON + 10.0f);
        weakSelf.whoButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON + 10.0f, WIDTH_HEIGHT_BUTTON + 10.0f);
        weakSelf.godButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON + 10.0f, WIDTH_HEIGHT_BUTTON + 10.0f);
        weakSelf.westButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON + 10.0f, WIDTH_HEIGHT_BUTTON + 10.0f);
        weakSelf.weaponButton.bounds = CGRectMake(0.0f, 0.0f, WIDTH_HEIGHT_BUTTON + 10.0f, WIDTH_HEIGHT_BUTTON + 10.0f);
        weakSelf.centerButton.bounds = CGRectMake(0.0f, 0.0f, 70.0f, 70.0f);
        
        ///位移
        weakSelf.flyButton.center = CGPointMake([[weakSelf.showDampingCenters[4] objectForKey:@"x"] floatValue], [[weakSelf.showDampingCenters[4] objectForKey:@"y"] floatValue]);
        
        weakSelf.personButton.center = CGPointMake([[weakSelf.showDampingCenters[5] objectForKey:@"x"] floatValue], [[weakSelf.showDampingCenters[5] objectForKey:@"y"] floatValue]);
        
        weakSelf.whoButton.center = CGPointMake([[weakSelf.showDampingCenters[3] objectForKey:@"x"] floatValue], [[weakSelf.showDampingCenters[3] objectForKey:@"y"] floatValue]);
        
        weakSelf.godButton.center = CGPointMake([[weakSelf.showDampingCenters[2] objectForKey:@"x"] floatValue], [[weakSelf.showDampingCenters[2] objectForKey:@"y"] floatValue]);
        
        weakSelf.westButton.center = CGPointMake([[weakSelf.showDampingCenters[0] objectForKey:@"x"] floatValue], [[weakSelf.showDampingCenters[0] objectForKey:@"y"] floatValue]);
        
        weakSelf.weaponButton.center = CGPointMake([[weakSelf.showDampingCenters[1] objectForKey:@"x"] floatValue], [[weakSelf.showDampingCenters[1] objectForKey:@"y"] floatValue]);
        
    } completion:^(BOOL finished) {
        
        weakSelf.centerButton.bounds = CGRectMake(0.0f, 0.0f, 60.0f, 60.0f);
        
        ///再次弹动一次
        [weakSelf springWithDamping:weakSelf.flyButton center:CGPointMake([[weakSelf.showSubCenters[4] objectForKey:@"x"] floatValue], [[weakSelf.showSubCenters[4] objectForKey:@"y"] floatValue]) completion:^(BOOL isFinish) {}];
        
        [weakSelf springWithDamping:self.personButton center:CGPointMake([[weakSelf.showSubCenters[5] objectForKey:@"x"] floatValue], [[weakSelf.showSubCenters[5] objectForKey:@"y"] floatValue]) completion:^(BOOL isFinish) {}];
        
        [weakSelf springWithDamping:self.whoButton center:CGPointMake([[weakSelf.showSubCenters[3] objectForKey:@"x"] floatValue], [[weakSelf.showSubCenters[3] objectForKey:@"y"] floatValue]) completion:^(BOOL isFinish) {}];
        
        [weakSelf springWithDamping:self.godButton center:CGPointMake([[weakSelf.showSubCenters[2] objectForKey:@"x"] floatValue], [[weakSelf.showSubCenters[2] objectForKey:@"y"] floatValue]) completion:^(BOOL isFinish) {}];
        
        [weakSelf springWithDamping:self.westButton center:CGPointMake([[weakSelf.showSubCenters[0] objectForKey:@"x"] floatValue], [[weakSelf.showSubCenters[0] objectForKey:@"y"] floatValue]) completion:^(BOOL isFinish) {}];
        
        [weakSelf springWithDamping:self.weaponButton center:CGPointMake([[weakSelf.showSubCenters[1] objectForKey:@"x"] floatValue], [[weakSelf.showSubCenters[1] objectForKey:@"y"] floatValue]) completion:^(BOOL isFinish) {}];
        
    }];
    
}

- (IBAction)showButtonAction:(UIButton *)sender
{
    
    if (2 == self.isShowStatus) {
        
        return;
        
    }
    
    if (1 == self.isShowStatus) {
        
        ///锁定状态
        self.isShowStatus = 2;
        
        [self hiddenStatus:YES];
        
    } else {
    
        ///锁定状态
        self.isShowStatus = 2;
        
        [self showStatus:YES];
    
    }
    
}

#pragma mark - 
#pragma mark - getter
- (NSMutableArray *)showDampingCenters
{

    if (nil == _showDampingCenters) {
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < 6; i++) {
            
            NSMutableDictionary *tempPoint = [NSMutableDictionary dictionary];
            CGFloat xpiont = self.showCenter.x + (MAX_REDIO_SHOW + 10.0f) * cos((DEGREES_TO_RADIANS(360.0f * (i + 1) / 6.0f - 30.0f)));
            CGFloat ypiont = self.showCenter.y + (MAX_REDIO_SHOW + 10.0f) * sin((DEGREES_TO_RADIANS(360.0f * (i + 1) / 6.0f - 30.0f)));
            [tempPoint setObject:@(xpiont) forKey:@"x"];
            [tempPoint setObject:@(ypiont) forKey:@"y"];
            
            [tempArray addObject:tempPoint];
            
        }
        
        _showDampingCenters = [NSMutableArray arrayWithArray:tempArray];
        
    }
    
    return _showDampingCenters;

}

///功能按钮原始坐标点
- (NSMutableArray *)showSubCenters
{

    if (nil == _showSubCenters) {
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < 6; i++) {
            
            NSMutableDictionary *tempPoint = [NSMutableDictionary dictionary];
            CGFloat xpiont = self.showCenter.x + MAX_REDIO_SHOW * cos((DEGREES_TO_RADIANS(360.0f * (i + 1) / 6.0f - 30.0f)));
            CGFloat ypiont = self.showCenter.y + MAX_REDIO_SHOW * sin((DEGREES_TO_RADIANS(360.0f * (i + 1) / 6.0f - 30.0f)));
            [tempPoint setObject:@(xpiont) forKey:@"x"];
            [tempPoint setObject:@(ypiont) forKey:@"y"];
            
            [tempArray addObject:tempPoint];
            
        }
        
        _showSubCenters = [NSMutableArray arrayWithArray:tempArray];
        
    }
    
    return _showSubCenters;

}

- (NSMutableArray *)buttonList
{

    if (nil == _buttonList) {
        
        ///按顺序保存按钮
        _buttonList = [NSMutableArray arrayWithObjects:
                           self.flyButton,
                           self.whoButton,
                           self.godButton,
                           self.weaponButton,
                           self.westButton,
                           self.personButton,nil];
        
    }
    
    return _buttonList;

}

- (NSMutableArray *)animateSubCenters
{

    if (nil == _animateSubCenters) {
        
        
        
    }
    
    return _animateSubCenters;

}

///按钮的中心点
- (CGPoint)showCenter
{

    _showCenter = CGPointMake(self.showButton.center.x, self.centerButtonYPoint.constant + 30.0f);
    return _showCenter;

}

@end
