//
//  ACEViewController.m
//  ACEDrawingViewDemo
//
//  Created by Stefano Acerbetti on 1/6/13.
//  Copyright (c) 2013 Stefano Acerbetti. All rights reserved.
//

#import "ACEViewController.h"
#import "ACEDrawingView.h"

#import <QuartzCore/QuartzCore.h>

#define kActionSheetColor       100
#define kActionSheetTool        101

@interface ACEViewController ()<UIActionSheetDelegate, ACEDrawingViewDelegate>
{
    NSMutableArray *drawPointsArray;
    CGPoint originPoint;
    CGPoint destPoint;
    CGPoint buttonCenter;
    NSInteger clearNumbers;//清除的次数
    NSInteger numberIndex;//Button移动动画的index
    NSInteger imageNameIndex;
    NSArray *imageNameArray;
    BOOL stopDraw;
}

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIButton *showButton;

@end

@implementation ACEViewController
- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0)
{
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeImage:) name:@"changeImage" object:nil];
    imageNameArray = @[@"三角形.png",@"正方形.png",@"长方形",@"六边形",@"圆形"];
    imageNameIndex = 2;
    // set the delegate
    self.view.userInteractionEnabled = NO;
    self.showButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 148)];
//    [self.showButton setImage:[UIImage imageNamed:@"handExample.png"] forState:UIControlStateNormal];
    buttonCenter = CGPointMake(505, 202.0);
    self.showButton.center = buttonCenter;
    [self.showButton setBackgroundColor:[UIColor clearColor]];
    [self.showImage addSubview:self.showButton];
    
    buttonCenter = CGPointMake(272.0, 614.0);
    self.drawingView.delegate = self;
    
    // start with a black pen
    self.lineWidthSlider.value = self.drawingView.lineWidth;
    
    // init the preview image
    self.previewImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.previewImageView.layer.borderWidth = 2.0f;
    self.showImage.image = [UIImage imageNamed:@"三角形"];
    numberIndex = 1;
    originPoint = CGPointMake(505.0, 132.0);
    destPoint = CGPointMake(505.0, 132.0);
    if (!self.timer) {
         self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(drawGraphics) userInfo:nil repeats:YES];
    }
    [self moveButtonFromRect];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onChangeImage:(NSNotification*)sender
{
    self.resultOKNumbers = sender.object;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定提交本次绘画吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100002;
    alertView.delegate = self;
    [alertView show];
}


#pragma mark - alertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100002) {
        
        switch (buttonIndex) {
            case 0:
                [self clear:nil];
                break;
            case 1:
            {
                
                [self showResultAlertView];
                clearNumbers = -1;
                [self clear:nil];
            }
                break;
                
            default:
                break;
                
        }
    }else if(alertView.tag == 100001){

        [self showResultAlertView];
        clearNumbers = -1;
        [self clear:nil];
    }else if(alertView.tag == 100003){
        if (self.drawingView.dataIndex < imageNameArray.count - 2) {
            self.drawingView.dataIndex++;
        }
        [self changeImage:imageNameArray[imageNameIndex]];
        if (imageNameIndex<imageNameArray.count-1) {
            imageNameIndex++;
            NSLog(@"the result OKNumbers is %@",self.resultOKNumbers);
        }

        
    }
}


- (void)showResultAlertView
{
    NSInteger resultNum = [self.resultOKNumbers integerValue];
    NSString *text = nil;
    if (resultNum<10) {
        text = @"差";
    }else if(10<resultNum&&resultNum<20){
        text = @"不及格";
    }else if(20<resultNum&&resultNum<40){
        text = @"及格";
    }else if(40<resultNum&&resultNum<65){
        text = @"良好";
    }else if(65<resultNum){
        text = @"优秀";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"你的得分结果：%@",text] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.tag = 100003;
    [alertView show];
}
/**
 *  此方法是为了 演示画第一个图形 三角形
 */
- (void)drawGraphics
{
    switch (numberIndex) {
        case 1:
        {
            destPoint.x = destPoint.x - 1.3;
            destPoint.y = destPoint.y+2.3;
        }
            break;
        case 2:
        {
            destPoint.x = destPoint.x+2.61;
        }
            break;
        case 3:
        {
            destPoint.x = destPoint.x - 1.3;
            destPoint.y = destPoint.y -2.25;
            stopDraw = YES;
        }
            break;
        default:
            break;
    }
   
    UIGraphicsBeginImageContext(self.showImage.frame.size);
    [self.showImage.image drawInRect:CGRectMake(0, 0, self.showImage.frame.size.width, self.showImage.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //边缘样式
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 15.0);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), originPoint.x, originPoint.y);  //起点坐标
    
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), destPoint.x, destPoint.y);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.showImage.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (((int)destPoint.x) <= 272.0) {
        numberIndex = 2;
        NSLog(@"the point is %@",NSStringFromCGPoint(destPoint));
        buttonCenter = CGPointMake(750.0, 614.0);
        [self moveButtonFromRect];
        originPoint = CGPointMake(272.0, 543.0);
        destPoint = CGPointMake(272.0, 543.0);
    }else if(((int)destPoint.x) >= 750){
        numberIndex = 3;
        buttonCenter = CGPointMake(505.0, 202.0);
        [self moveButtonFromRect];
        originPoint = CGPointMake(750.0, 540.0);
        destPoint = CGPointMake(750.0, 540.0);
    }else if(stopDraw&&((int)destPoint.x)==510)
    {
        [self.timer invalidate];
        [self changeImage:@"正方形.png"];
        [self.drawingView clear];
        self.view.userInteractionEnabled = YES;
        [self.showButton removeFromSuperview];
    }
    
}


/**
 *  为了让手势图片Button 动态画图
 */
- (void)moveButtonFromRect
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:5.3];
    self.showButton.center = buttonCenter;
    [UIView commitAnimations];
}

/**
 *  翻页效果切换图片
 *
 *  @param imageName 图片的名字
 */
- (void)changeImage:(NSString*)imageName
{
    clearNumbers = 0;
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.endProgress =1;
    animation.removedOnCompletion = NO;
    animation.type = @"pageCurl";//110
    [self.view.layer addAnimation:animation forKey:@"animation"];
    [self.showImage setImage:[UIImage imageNamed:imageName]];
}
#pragma mark - Actions

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.drawingView canUndo];
    self.redoButton.enabled = [self.drawingView canRedo];
}

- (IBAction)takeScreenshot:(id)sender
{
    // show the preview image
//    self.previewImageView.image = self.drawingView.image;
//    self.previewImageView.hidden = NO;
    
    // close it after 3 seconds
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
//        self.previewImageView.hidden = YES;
//    });
    [self changeImage:@"长方形.png"];
}

- (IBAction)undo:(id)sender
{
    [self.drawingView undoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)redo:(id)sender
{
    [self.drawingView redoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)clear:(id)sender
{
    
    clearNumbers ++;
//    _wmjCheckOver.okNumbers = 0;
    if (clearNumbers>=3&&self.drawingView.drawPoint!=nil) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒！" message:@"您已经清除三次不能再次清除" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alertView.tag = 100001;
        [alertView show];
    }else
    {
        [self.drawingView clear];
        [self updateButtonStatus];
    }
}


#pragma mark - ACEDrawing View Delegate

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}


#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        if (actionSheet.tag == kActionSheetColor) {
            
            self.colorButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    self.drawingView.lineColor = [UIColor blackColor];
                    break;
                    
                case 1:
                    self.drawingView.lineColor = [UIColor redColor];
                    break;
                    
                case 2:
                    self.drawingView.lineColor = [UIColor greenColor];
                    break;
                    
                case 3:
                    self.drawingView.lineColor = [UIColor blueColor];
                    break;
            }
            
        } else {
            
            self.toolButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    self.drawingView.drawTool = ACEDrawingToolTypePen;
                    break;
                    
                case 1:
                    self.drawingView.drawTool = ACEDrawingToolTypeLine;
                    break;
                    
                case 2:
                    self.drawingView.drawTool = ACEDrawingToolTypeRectagleStroke;
                    break;
                    
                case 3:
                    self.drawingView.drawTool = ACEDrawingToolTypeRectagleFill;
                    break;
                    
                case 4:
                    self.drawingView.drawTool = ACEDrawingToolTypeEllipseStroke;
                    break;
                    
                case 5:
                    self.drawingView.drawTool = ACEDrawingToolTypeEllipseFill;
                    break;
                    
                case 6:
                    self.drawingView.drawTool = ACEDrawingToolTypeEraser;
                    break;
                    
//                case 7:
//                    self.drawingView.drawTool = ACEDrawingToolTypeText;
//                    break;
            }
            
            // if eraser, disable color and alpha selection
            self.colorButton.enabled = self.alphaButton.enabled = buttonIndex != 6;
        }
    }
}

#pragma mark - Settings

- (IBAction)colorChange:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Selet a color"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Black", @"Red", @"Green", @"Blue", nil];
    
    [actionSheet setTag:kActionSheetColor];
    [actionSheet showInView:self.view];
}

- (IBAction)toolChange:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Selet a tool"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Pen", @"Line",
                                  @"Rect (Stroke)", @"Rect (Fill)",
                                  @"Ellipse (Stroke)", @"Ellipse (Fill)",
                                  @"Eraser",
                                  nil];
    
    [actionSheet setTag:kActionSheetTool];
    [actionSheet showInView:self.view];
}

- (IBAction)toggleWidthSlider:(id)sender
{
    // toggle the slider
    self.lineWidthSlider.hidden = !self.lineWidthSlider.hidden;
    self.lineAlphaSlider.hidden = YES;
}


- (IBAction)widthChange:(UISlider *)sender
{
    self.drawingView.lineWidth = sender.value;
}

- (IBAction)toggleAlphaSlider:(id)sender
{
    // toggle the slider
    self.lineAlphaSlider.hidden = !self.lineAlphaSlider.hidden;
    self.lineWidthSlider.hidden = YES;
}

- (IBAction)alphaChange:(UISlider *)sender
{
    self.drawingView.lineAlpha = sender.value;
}


@end
