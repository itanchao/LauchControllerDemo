//
//  LauchViewController.m
//  LauchControllerDemo
//
//  Created by tanchao的iMac on 2017/1/3.
//  Copyright © 2017年 tanchao. All rights reserved.
//

#import "LauchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
@interface LauchViewController ()<CAAnimationDelegate>
@property (nonatomic, retain) CALayer *animationLayer;
@property (nonatomic, retain) CAShapeLayer *pathLayer;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *yingwenIcon;
@end


@implementation LauchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self creactUI];
    [self creatAnimation];
    
}
- (void)creactUI{
    self.iconView = ({
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
        view.center = CGPointMake(self.view.center.x, self.view.center.y-90);
        [self.view addSubview:view];
        view;
    });
    self.yingwenIcon = ({
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yingwen"]];
        view.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.iconView.frame)+40);
        [self.view addSubview:view];
        view;
    });
}
-(void)creatAnimation{
    self.animationLayer = [CALayer layer];
    self.animationLayer.frame = CGRectMake(20, CGRectGetMaxY(self.yingwenIcon.frame), CGRectGetWidth(self.view.frame)-40, 40);
    [self.view.layer addSublayer:self.animationLayer];
    [self setupTextLayer];
    [self startAnimation];
}
- (void) startAnimation
{
    [self.pathLayer removeAllAnimations];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.delegate = self;
    pathAnimation.duration = 10.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.view removeFromSuperview];
}
- (void)removeFromSuperView{
    [self.view removeFromSuperview];
}
-(void)dealloc{
    NSLog(@"----------");

}
- (void) setupTextLayer
{
    if (self.pathLayer != nil) {
        [self.pathLayer removeFromSuperlayer];
        self.pathLayer = nil;
    }
    UIBezierPath *path = [self creactPathLetterWithStr:@"按 需 会 员 制 , 汽 车 消 费 新 方 式" fontref: CTFontCreateWithName(CFSTR("HelveticaNeue-UltraLight"), 14.0f, NULL)];
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.animationLayer.bounds;
//    pathLayer.frame = CGRectMake(0, 90, CGRectGetWidth(self.animationLayer.bounds), 30);
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [UIColor whiteColor].CGColor;
    pathLayer.fillColor = nil;
    //    pathLayer.lineWidth = 0.9f;
    pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.animationLayer addSublayer:pathLayer];

    self.animationLayer.speed = 5;
    self.animationLayer.timeOffset = 30;
    self.pathLayer = pathLayer;
}

- (UIBezierPath *)creactPathLetterWithStr:(NSString *)str fontref:(CTFontRef)font{
    CGMutablePathRef letters = CGPathCreateMutable();
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id)CFBridgingRelease(font), kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:str
                                                                     attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    // for each RUN
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        // Get FONT for this run
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // for each GLYPH in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            // get Glyph & Glyph-data
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            // Get PATH of outline
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    CGPathRelease(letters);
    CFRelease(font);
    return path;
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
