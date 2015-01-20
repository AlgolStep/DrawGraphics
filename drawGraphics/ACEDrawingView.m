/*
 * ACEDrawingView: https://github.com/acerbetti/ACEDrawingView
 *
 * Copyright (c) 2013 Stefano Acerbetti
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "ACEDrawingView.h"
#import "WMJCheckOverGraphics.h"
#import "ACEDrawingTools.h"


#import <QuartzCore/QuartzCore.h>

#define kDefaultLineColor       [UIColor blackColor]
#define kDefaultLineWidth       20.0f;
#define kDefaultLineAlpha       1.0f

// experimental code
#define PARTIAL_REDRAW          0

@interface ACEDrawingView () {
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    float meiZhenDistance ;
    float _curLineWidth;
    CGPoint beginPoint;
    CGPoint endPoint;
    
    NSArray *squreArray;
    NSArray *changFangArray;
    NSArray *liuBianArray;
    NSArray *circleArray;
    NSInteger arrayIndex;
    NSArray *array;
}


@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) NSMutableArray *bufferArray;
@property (nonatomic, strong) id<ACEDrawingTool> currentTool;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) CGFloat originalFrameYPos;

@end

#pragma mark -

@implementation ACEDrawingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
        
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0)
{
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
        
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
    }
    return self;
}

- (void)configure
{
    // init the private arrays
    
    self.pathArray = [NSMutableArray array];
    self.bufferArray = [NSMutableArray array];
    
    // set the default values for the public properties
    self.lineColor = kDefaultLineColor;
    self.lineWidth = kDefaultLineWidth;
    self.lineAlpha = kDefaultLineAlpha;
    
    // set the transparent background
    self.backgroundColor = [UIColor clearColor];
    
    self.originalFrameYPos = self.frame.origin.y;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
   
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
#if PARTIAL_REDRAW
    // TODO: draw only the updated part of the image
    [self drawPath];
#else
    [self.image drawInRect:self.bounds];
    [self.currentTool draw];
#endif
}

- (void)updateCacheImage:(BOOL)redraw
{
    // init a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (redraw) {
        // erase the previous image
        self.image = nil;
        
        // load previous image (if returning to screen)
        [[self.prev_image copy] drawInRect:self.bounds];
        
        // I need to redraw all the lines
        for (id<ACEDrawingTool> tool in self.pathArray) {
            [tool draw];
        }
        
    } else {
        // set the draw point
        [self.image drawAtPoint:CGPointZero];
        [self.currentTool draw];
    }
    
    // store the image
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)finishDrawing
{
    // update the image
    [self updateCacheImage:NO];
    
    // clear the redo queue
    [self.bufferArray removeAllObjects];
    
    // call the delegate
    if ([self.delegate respondsToSelector:@selector(drawingView:didEndDrawUsingTool:)]) {
        [self.delegate drawingView:self didEndDrawUsingTool:self.currentTool];
    }
    
    // clear the current tool
    self.currentTool = nil;
}


- (id<ACEDrawingTool>)toolWithCurrentSettings
{
    switch (self.drawTool) {
        case ACEDrawingToolTypePen:
        {
            return ACE_AUTORELEASE([ACEDrawingPenTool new]);
        }
            
        case ACEDrawingToolTypeLine:
        {
            return ACE_AUTORELEASE([ACEDrawingLineTool new]);
        }
            
//        case ACEDrawingToolTypeText:
//        {
//            return ACE_AUTORELEASE([ACEDrawingTextTool new]);
//        }
            
        case ACEDrawingToolTypeRectagleStroke:
        {
            ACEDrawingRectangleTool *tool = ACE_AUTORELEASE([ACEDrawingRectangleTool new]);
            tool.fill = NO;
            return tool;
        }
            
        case ACEDrawingToolTypeRectagleFill:
        {
            ACEDrawingRectangleTool *tool = ACE_AUTORELEASE([ACEDrawingRectangleTool new]);
            tool.fill = YES;
            return tool;
        }
            
        case ACEDrawingToolTypeEllipseStroke:
        {
            ACEDrawingEllipseTool *tool = ACE_AUTORELEASE([ACEDrawingEllipseTool new]);
            tool.fill = NO;
            return tool;
        }
            
        case ACEDrawingToolTypeEllipseFill:
        {
            ACEDrawingEllipseTool *tool = ACE_AUTORELEASE([ACEDrawingEllipseTool new]);
            tool.fill = YES;
            return tool;
        }
            
        case ACEDrawingToolTypeEraser:
        {
            return ACE_AUTORELEASE([ACEDrawingEraserTool new]);
        }
    }
}

#pragma mark -- distance
-(float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end{
    float distance;
    CGFloat xDist = (end.x - start.x);
    CGFloat yDist = (end.y - start.y);
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.textView && !self.textView.hidden) {
        [self commitAndHideTextEntry];
        return;
    }
    beginPoint = [[[event allTouches] anyObject] locationInView:self];
    NSLog(@"beginPoint %@",NSStringFromCGPoint(beginPoint));
    // add the first touch
    UITouch *touch = [touches anyObject];
    previousPoint1 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    // init the bezier path
    self.currentTool = [self toolWithCurrentSettings];
    self.currentTool.lineWidth = self.lineWidth;
    self.currentTool.lineColor = self.lineColor;
    self.currentTool.lineAlpha = self.lineAlpha;
    
    if ([self.currentTool isKindOfClass:[ACEDrawingTextTool class]]) {
        [self initializeTextBox: currentPoint];
    }
    else {
        [self.pathArray addObject:self.currentTool];
        
        [self.currentTool setInitialPoint:currentPoint];
    }
    
    // call the delegate
    if ([self.delegate respondsToSelector:@selector(drawingView:willBeginDrawUsingTool:)]) {
        [self.delegate drawingView:self willBeginDrawUsingTool:self.currentTool];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    
    // save all the touches in the path
    UITouch *touch = [touches anyObject];
    CGPoint rePoint = [[[event allTouches] anyObject] locationInView:self];
    [self checkOverGraphics];
    
    
    self.drawPoint = NSStringFromCGPoint(rePoint);
    NSLog(@"----------%@",NSStringFromCGPoint(rePoint));
    previousPoint2 = previousPoint1;
    previousPoint1 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    meiZhenDistance  = [self distanceFromPointX:previousPoint1 distanceToPointY:currentPoint];
    
    
    
    if ([self.currentTool isKindOfClass:[ACEDrawingPenTool class]]) {
        CGRect bounds = [(ACEDrawingPenTool*)self.currentTool addPathPreviousPreviousPoint:previousPoint2 withPreviousPoint:previousPoint1 withCurrentPoint:currentPoint];
        CGRect drawBox = bounds;
        
        drawBox.origin.x -= self.lineWidth * 2.0;
        drawBox.origin.y -= self.lineWidth * 2.0;
        drawBox.size.width += self.lineWidth * 4.0;
        drawBox.size.height += self.lineWidth * 4.0;
        
        [self setNeedsDisplayInRect:drawBox];
    }
    else if ([self.currentTool isKindOfClass:[ACEDrawingTextTool class]]) {
        [self resizeTextViewFrame: currentPoint];
    }
    else {
        
        [self.currentTool moveFromPoint:previousPoint1 toPoint:currentPoint];
        [self setNeedsDisplay];
    }
    
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesMoved:touches withEvent:event];
    endPoint = [[[event allTouches] anyObject] locationInView:self];
    NSLog(@"beginPoint %@",NSStringFromCGPoint(beginPoint));
    NSLog(@"endPoint %@",NSStringFromCGPoint(endPoint));
    if ([self.currentTool isKindOfClass:[ACEDrawingTextTool class]]) {
        [self startTextEntry];
    }
    else {
        [self finishDrawing];
    }
    if (![self checkEndAndBegin]) {
        self.okNumbers = 0;
    }
    if (self.okNumbers<10) {
        NSLog(@"差%d",self.okNumbers);
    }else if(10<self.okNumbers&&self.okNumbers<20){
        NSLog(@"不及格%d",self.okNumbers);
    }else if(20<self.okNumbers&&self.okNumbers<40){
        NSLog(@"及格%d",self.okNumbers);
    }else if(40<self.okNumbers&&self.okNumbers<65){
        NSLog(@"良好%d",self.okNumbers);
    }else if(65<self.okNumbers){
        NSLog(@"优秀%d",self.okNumbers);
    }
    aceViewController = [[ACEViewController alloc]init];
    NSString *text = [NSString stringWithFormat:@"%d",self.okNumbers];
    aceViewController.resultOKNumbers = text;
//    aceViewController.resultOKNumbers =[NSString stringWithFormat:@"%d",self.okNumbers];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeImage" object:text];
}



- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}


- (void)checkOverGraphics
{
    NSLog(@"the dataIndex is %d",self.dataIndex);
    for (NSString *string in self.dataArray[self.dataIndex]) {
        CGPoint stringPoint = CGPointFromString(string);
        CGPoint drawPoint = CGPointFromString(self.drawPoint);
        BOOL stringX = [self judgePoint:drawPoint.x fromDot:(stringPoint.x-10) toDot:(stringPoint.x+10)];
        BOOL stringY = [self judgePoint:drawPoint.y fromDot:(stringPoint.y-10) toDot:(stringPoint.y+10)];
        if (stringX&&stringY) {
            NSLog(@"OK");
            self.okNumbers++;
        }
    }
    
}

- (BOOL)checkEndAndBegin
{
    NSLog(@"22222222beginPoint %@",NSStringFromCGPoint(beginPoint));
    NSLog(@"34343434343endPoint %@",NSStringFromCGPoint(endPoint));
    BOOL stringX = [self judgePoint:endPoint.x fromDot:(beginPoint.x-20) toDot:(beginPoint.x+20)];
    BOOL stringY = [self judgePoint:endPoint.y fromDot:(beginPoint.y-20) toDot:(beginPoint.y+20)];
    BOOL result = stringX&&stringY;
    return result;
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


#pragma mark - Text Entry

- (void) initializeTextBox: (CGPoint)startingPoint {
    
    if (!self.textView) {
        self.textView = [[UITextView alloc] init];
        self.textView.delegate = self;
        self.textView.returnKeyType = UIReturnKeyDone;
        self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.layer.borderWidth = 1.0f;
        self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
        self.textView.layer.cornerRadius = 8;
        [self.textView setContentInset: UIEdgeInsetsZero];
        
        
        [self addSubview:self.textView];
    }
    
    int calculatedFontSize = self.lineWidth * 3; //3 is an approximate size factor
    
    [self.textView setFont:[UIFont systemFontOfSize:calculatedFontSize]];
    self.textView.textColor = self.lineColor;
    self.textView.alpha = self.lineAlpha;
    
    int defaultWidth = 200;
    int defaultHeight = calculatedFontSize * 2;
    int initialYPosition = startingPoint.y - (defaultHeight/2);
    
    CGRect frame = CGRectMake(startingPoint.x, initialYPosition, defaultWidth, defaultHeight);
    frame = [self adjustFrameToFitWithinDrawingBounds:frame];
    
    self.textView.frame = frame;
    self.textView.text = @"";
    self.textView.hidden = NO;
}

- (void) startTextEntry {
    if (!self.textView.hidden) {
        [self.textView becomeFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    CGRect frame = self.textView.frame;
    if (self.textView.contentSize.height > frame.size.height) {
        frame.size.height = self.textView.contentSize.height;
    }
    
    self.textView.frame = frame;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self commitAndHideTextEntry];
}

-(void)resizeTextViewFrame: (CGPoint)adjustedSize {
    
    int minimumAllowedHeight = self.textView.font.pointSize * 2;
    int minimumAllowedWidth = self.textView.font.pointSize * 0.5;
    
    CGRect frame = self.textView.frame;
    
    //adjust height
    int adjustedHeight = adjustedSize.y - self.textView.frame.origin.y;
    if (adjustedHeight > minimumAllowedHeight) {
        frame.size.height = adjustedHeight;
    }
    
    //adjust width
    int adjustedWidth = adjustedSize.x - self.textView.frame.origin.x;
    if (adjustedWidth > minimumAllowedWidth) {
        frame.size.width = adjustedWidth;
    }
    frame = [self adjustFrameToFitWithinDrawingBounds:frame];
    
    self.textView.frame = frame;
}

- (CGRect)adjustFrameToFitWithinDrawingBounds: (CGRect)frame {
    
    //check that the frame does not go beyond bounds of parent view
    if ((frame.origin.x + frame.size.width) > self.frame.size.width) {
        frame.size.width = self.frame.size.width - frame.origin.x;
    }
    if ((frame.origin.y + frame.size.height) > self.frame.size.height) {
        frame.size.height = self.frame.size.height - frame.origin.y;
    }
    return frame;
}

- (void)commitAndHideTextEntry {
    [self.textView resignFirstResponder];
    
    if ([self.textView.text length]) {
        UIEdgeInsets textInset = self.textView.textContainerInset;
        CGFloat additionalXPadding = 5;
        CGPoint start = CGPointMake(self.textView.frame.origin.x + textInset.left + additionalXPadding, self.textView.frame.origin.y + textInset.top);
        CGPoint end = CGPointMake(self.textView.frame.origin.x + self.textView.frame.size.width - additionalXPadding, self.textView.frame.origin.y + self.textView.frame.size.height);
        
        ((ACEDrawingTextTool*)self.currentTool).attributedText = [self.textView.attributedText copy];
        
        [self.pathArray addObject:self.currentTool];
        
        [self.currentTool setInitialPoint:start]; //change this for precision accuracy of text location
        [self.currentTool moveFromPoint:start toPoint:end];
        [self setNeedsDisplay];
        
        [self finishDrawing];
        
    }
    
    self.currentTool = nil;
    self.textView.hidden = YES;
    self.textView = nil;
}



#pragma mark - Keyboard Events

- (void)keyboardDidShow:(NSNotification *)notification
{
    if ( UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        [self landscapeChanges:notification];
    } else {
        [self portraitChanges:notification];
    }
}

- (void)landscapeChanges:(NSNotification *)notification {
    CGPoint textViewBottomPoint = [self convertPoint:self.textView.frame.origin toView:self];
    CGFloat textViewOriginY = textViewBottomPoint.y;
    CGFloat textViewBottomY = textViewOriginY + self.textView.frame.size.height;

    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    CGFloat offset = (self.frame.size.height - keyboardSize.width) - textViewBottomY;

    if (offset < 0) {
        CGFloat newYPos = self.frame.origin.y + offset;
        self.frame = CGRectMake(self.frame.origin.x,newYPos, self.frame.size.width, self.frame.size.height);

    }
}
- (void)portraitChanges:(NSNotification *)notification {
    CGPoint textViewBottomPoint = [self convertPoint:self.textView.frame.origin toView:nil];
    textViewBottomPoint.y += self.textView.frame.size.height;

    CGRect screenRect = [[UIScreen mainScreen] bounds];

    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    CGFloat offset = (screenRect.size.height - keyboardSize.height) - textViewBottomPoint.y;

    if (offset < 0) {
        CGFloat newYPos = self.frame.origin.y + offset;
        self.frame = CGRectMake(self.frame.origin.x,newYPos, self.frame.size.width, self.frame.size.height);

    }
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    self.frame = CGRectMake(self.frame.origin.x,self.originalFrameYPos,self.frame.size.width,self.frame.size.height);
}


#pragma mark - Load Image

- (void)loadImage:(UIImage *)image
{
    self.image = image;
    
    //save the loaded image to persist after an undo step
    self.prev_image = [image copy];
    
    // when loading an external image, I'm cleaning all the paths and the undo buffer
    [self.bufferArray removeAllObjects];
    [self.pathArray removeAllObjects];
    [self updateCacheImage:YES];
    [self setNeedsDisplay];
}

- (void)loadImageData:(NSData *)imageData
{
    CGFloat imageScale;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        imageScale = [[UIScreen mainScreen] scale];
        
    } else {
        imageScale = 1.0;
    }
    
    UIImage *image = [UIImage imageWithData:imageData scale:imageScale];
    [self loadImage:image];
}

- (void)resetTool
{
    if ([self.currentTool isKindOfClass:[ACEDrawingTextTool class]]) {
        self.textView.text = @"";
        [self commitAndHideTextEntry];
    }
    self.currentTool = nil;
}

#pragma mark - Actions

- (void)clear
{
    self.okNumbers = 0;
    [self resetTool];
    [self.bufferArray removeAllObjects];
    [self.pathArray removeAllObjects];
    self.prev_image = nil;
    [self updateCacheImage:YES];
    
    [self setNeedsDisplay];
}


#pragma mark - Undo / Redo

- (NSUInteger)undoSteps
{
    return self.bufferArray.count;
}

- (BOOL)canUndo
{
    return self.pathArray.count > 0;
}

- (void)undoLatestStep
{
    if ([self canUndo]) {
        [self resetTool];
        id<ACEDrawingTool>tool = [self.pathArray lastObject];
        [self.bufferArray addObject:tool];
        [self.pathArray removeLastObject];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}

- (BOOL)canRedo
{
    return self.bufferArray.count > 0;
}

- (void)redoLatestStep
{
    if ([self canRedo]) {
        [self resetTool];
        id<ACEDrawingTool>tool = [self.bufferArray lastObject];
        [self.pathArray addObject:tool];
        [self.bufferArray removeLastObject];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}


- (void)dealloc
{
    self.pathArray = nil;
    self.bufferArray = nil;
    self.currentTool = nil;
    self.image = nil;
    self.prev_image = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
#if !ACE_HAS_ARC
    
    [super dealloc];
#endif
}


@end
