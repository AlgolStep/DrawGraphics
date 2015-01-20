//
//  WMJCheckOverGraphics.h
//  drawGraphics
//
//  Created by 思来氏 on 14-9-16.
//  Copyright (c) 2014年 PSYtest. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WMJCheckOverGraphics : NSObject
@property (strong,nonatomic) NSString *drawPoint;
@property (assign,nonatomic) NSInteger okNumbers;
@property (strong,nonatomic) NSArray *dataArray;
@property (assign,nonatomic) NSInteger dataIndex;
- (void)checkOverGraphics;
- (void)changeDataArray:(NSInteger)index;
@end
