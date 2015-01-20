//
//  WMJCheckOverGraphics.m
//  drawGraphics
//
//  Created by 思来氏 on 14-9-16.
//  Copyright (c) 2014年 PSYtest. All rights reserved.
//

#import "WMJCheckOverGraphics.h"
#import "ACEViewController.h"


@interface WMJCheckOverGraphics ()

{
    NSArray *squreArray;
    NSArray *changFangArray;
    NSArray *liuBianArray;
    NSArray *circleArray;
    NSInteger arrayIndex;
    NSArray *array;
}
@property (nonatomic, strong)ACEViewController *aceViewController;
@end
@implementation WMJCheckOverGraphics
- (id)init
{
    self = [super init];
    if (self) {
      
        NSString *squrePoint1  = NSStringFromCGPoint(CGPointMake(312, 101));
        NSString *squrePoint12 = NSStringFromCGPoint(CGPointMake(425, 101));
        NSString *squrePoint13 = NSStringFromCGPoint(CGPointMake(589, 101));
        NSString *squrePoint2  = NSStringFromCGPoint(CGPointMake(730, 101));
        NSString *squrePoint21 = NSStringFromCGPoint(CGPointMake(730, 248));
        NSString *squrePoint22 = NSStringFromCGPoint(CGPointMake(730, 430));
        NSString *squrePoint3  = NSStringFromCGPoint(CGPointMake(730, 522));
        NSString *squrePoint31 = NSStringFromCGPoint(CGPointMake(608, 522));
        NSString *squrePoint32 = NSStringFromCGPoint(CGPointMake(430, 522));
        NSString *squrePoint4  = NSStringFromCGPoint(CGPointMake(312, 522));
        NSString *squrePoint41 = NSStringFromCGPoint(CGPointMake(312, 435));
        NSString *squrePoint42 = NSStringFromCGPoint(CGPointMake(312, 290));

        NSString *changFangPoint1  = NSStringFromCGPoint(CGPointMake(270, 104));
        NSString *changFangPoint11 = NSStringFromCGPoint(CGPointMake(400, 104));
        NSString *changFangPoint12 = NSStringFromCGPoint(CGPointMake(600, 104));
        NSString *changFangPoint2  = NSStringFromCGPoint(CGPointMake(780, 104));
        NSString *changFangPoint21 = NSStringFromCGPoint(CGPointMake(780, 211));
        NSString *changFangPoint22 = NSStringFromCGPoint(CGPointMake(780, 377));
        NSString *changFangPoint3  = NSStringFromCGPoint(CGPointMake(780, 508));
        NSString *changFangPoint31 = NSStringFromCGPoint(CGPointMake(620, 508));
        NSString *changFangPoint32 = NSStringFromCGPoint(CGPointMake(415, 508));
        NSString *changFangPoint4  = NSStringFromCGPoint(CGPointMake(270, 508));
        NSString *changFangPoint41 = NSStringFromCGPoint(CGPointMake(270, 375));
        NSString *changFangPoint42 = NSStringFromCGPoint(CGPointMake(270, 201));
        
        
        NSString *liuBianPoint1  = NSStringFromCGPoint(CGPointMake(395, 120));
        NSString *liuBianPoint11 = NSStringFromCGPoint(CGPointMake(520, 120));
        NSString *liuBianPoint2 = NSStringFromCGPoint(CGPointMake(640, 120));
        NSString *liuBianPoint21 = NSStringFromCGPoint(CGPointMake(690, 207));
        NSString *liuBianPoint3 = NSStringFromCGPoint(CGPointMake(752, 324));
        NSString *liuBianPoint31 = NSStringFromCGPoint(CGPointMake(702, 427));
        NSString *liuBianPoint4 = NSStringFromCGPoint(CGPointMake(635, 533));
        NSString *liuBianPoint41 = NSStringFromCGPoint(CGPointMake(506, 535));
        NSString *liuBianPoint5 = NSStringFromCGPoint(CGPointMake(397, 536));
        NSString *liuBianPoint51 = NSStringFromCGPoint(CGPointMake(334, 429));
        NSString *liuBianPoint6 = NSStringFromCGPoint(CGPointMake(280, 325));
        NSString *liuBianPoint61 = NSStringFromCGPoint(CGPointMake(337, 218));
        
        NSString *circlePoint1 = NSStringFromCGPoint(CGPointMake(526, 109));
        NSString *circlePoint11 = NSStringFromCGPoint(CGPointMake(635, 145));
        NSString *circlePoint12 = NSStringFromCGPoint(CGPointMake(701, 212));
        NSString *circlePoint2 = NSStringFromCGPoint(CGPointMake(724, 304));
        NSString *circlePoint21 = NSStringFromCGPoint(CGPointMake(704, 400));
        NSString *circlePoint22 = NSStringFromCGPoint(CGPointMake(651, 471));
        NSString *circlePoint3 = NSStringFromCGPoint(CGPointMake(520, 517));
        NSString *circlePoint31 = NSStringFromCGPoint(CGPointMake(419, 485));
        NSString *circlePoint32 = NSStringFromCGPoint(CGPointMake(339, 397));
        NSString *circlePoint4 = NSStringFromCGPoint(CGPointMake(320, 303));
        NSString *circlePoint41 = NSStringFromCGPoint(CGPointMake(350, 198));
        NSString *circlePoint42 = NSStringFromCGPoint(CGPointMake(442, 126));
        
        squreArray = @[squrePoint1,squrePoint12,squrePoint13,squrePoint2,squrePoint21,squrePoint22,squrePoint3,squrePoint31,squrePoint32,squrePoint4,squrePoint41,squrePoint42];
        changFangArray =@[changFangPoint1,changFangPoint11,changFangPoint12,changFangPoint2,changFangPoint21,changFangPoint22,changFangPoint3,changFangPoint31,changFangPoint32,changFangPoint4,changFangPoint41,changFangPoint42];
        liuBianArray = @[liuBianPoint1,liuBianPoint11,liuBianPoint2,liuBianPoint21,liuBianPoint3,liuBianPoint31,liuBianPoint4,liuBianPoint41,liuBianPoint5,liuBianPoint51,liuBianPoint6,liuBianPoint61];
        circleArray = @[circlePoint1,circlePoint11,circlePoint12,circlePoint2,circlePoint21,circlePoint22,circlePoint3,circlePoint31,circlePoint32,circlePoint4,circlePoint41,circlePoint42];
        
        self.dataArray = @[squreArray,changFangArray,liuBianArray,circleArray];
        array = self.dataArray[0];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDataArray:) name:@"changeData" object:nil];
    }
    return self;
}
- (void)checkOverGraphics
{
    NSLog(@"the dataIndex is %ld",(long)self.dataIndex);
    for (NSString *string in array) {
        CGPoint stringPoint = CGPointFromString(string);
        CGPoint drawPoint = CGPointFromString(self.drawPoint);
        BOOL stringX = [self judgePoint:drawPoint.x fromDot:(stringPoint.x-5) toDot:(stringPoint.x+5)];
        BOOL stringY = [self judgePoint:drawPoint.y fromDot:(stringPoint.y-5) toDot:(stringPoint.y+5)];
        if (stringX&&stringY) {
            NSLog(@"OK");
            self.okNumbers++;
        }
    }
}

/**
 *  检测画点范围
 *
 *  @param pointx 当前点的x或y值
 *  @param point1 标准点的小范围
 *  @param point2 标准点的大范围
 *
 *  @return 当前点是不是在检测范围内
 */
- (BOOL)judgePoint:(CGFloat)pointx fromDot:(CGFloat)point1 toDot:(CGFloat)point2
{
    if (pointx>point1 && pointx < point2) {
        return YES;
    }else{
        return NO;
    }
}


- (void)changeDataArray:(NSInteger)index
{
    if (arrayIndex<self.dataArray.count-1) {
        arrayIndex++;
    }
   array = self.dataArray[index];

}


@end
