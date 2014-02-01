//
//  TSTFlipboard.m
//  flipboardSample
//
//  Created by Ken Shiota on 2014/02/01.
//  Copyright (c) 2014年 Tesseract. All rights reserved.
//

#import "TSTFlipboard.h"

@interface TSTFlipboard ()
- (void)setupLayers;
- (void)makePanels;
- (NSArray*)createPanel:(UIImage*)image;
- (void)setupImage;
@end

@implementation TSTFlipboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayers];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupLayers];
    }
    return self;
}

#pragma mark - Setup Layers
- (void)setupLayers {
    CGFloat unit_width = CGRectGetWidth(self.frame) / 2;
    CGFloat unit_height = CGRectGetHeight(self.frame) / 2;
    
    self.layers = [NSMutableArray arrayWithCapacity:4];
    for (int index = 0; index < 4; index++) {
        int x = index % 2;
        int y = index / 2;
        CALayer* layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, unit_width, unit_height);
        layer.anchorPoint = CGPointMake(1.0 - x, 1.0 - y);
        layer.position = CGPointMake(unit_width, unit_height);
        [self.layer addSublayer:layer];
        
        layer.backgroundColor = [UIColor colorWithRed:((index + 1) & 0x01) * 1.0 green:(((index + 1) & 0x02) >> 1) * 1.0 blue:(((index + 1) & 0x04) >> 2) * 1.0 alpha:1.0].CGColor;
        
        [self.layers addObject:layer];
    }
    
    CATransform3D aTransform = CATransform3DIdentity;
    aTransform.m34 = -1.0 / 320.0;
    self.layer.sublayerTransform = aTransform;
}

- (void)setImages:(NSArray*)images {
    _images = images;
    
    [self makePanels];
    
    self.imageIndex = 0;
    [self setupImage];
}

- (void)setupImage {
    NSArray* panel = self.panels[self.imageIndex];
    for (int index = 0; index < 4; index++) {
        CALayer* layer = self.layers[index];
        layer.contents = (id)[panel[index] CGImage];
    }
}

- (void)makePanels {
    self.panels = [NSMutableArray arrayWithCapacity:self.images.count];
    for (UIImage* image in self.images) {
        [self.panels addObject:[self createPanel:image]];
    }
}

- (NSArray*)createPanel:(UIImage*)image {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    [image drawInRect:self.bounds];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat unit_width = CGRectGetWidth(self.frame) / 2;
    CGFloat unit_height = CGRectGetHeight(self.frame) / 2;
    
    NSMutableArray* panel = [NSMutableArray arrayWithCapacity:4];
    
    for (int index = 0; index < 4; index++) {
        int x = index % 2;
        int y = index / 2;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(unit_width, unit_height), NO, 0.0);
        [scaledImage drawAtPoint:CGPointMake(x * -unit_width, y * -unit_height)];
        UIImage* partImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        [panel addObject:partImage];
    }
    return panel;
}

- (void)startAnimation {
    CGFloat animationDuration = 0.2;
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:animationDuration] forKey:kCATransactionAnimationDuration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setCompletionBlock:^{
        self.imageIndex = (self.imageIndex + 1) % self.images.count;
        NSArray* panel = self.panels[self.imageIndex];

        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        for (int index = 0; index < 4; index++) {
            int x = index % 2;
            int y = index / 2;
            CALayer* layer = self.layers[index];
            layer.contents = (id)[panel[index] CGImage];
            layer.transform = CATransform3DMakeRotation(M_PI_2 * (y == 0 ? -1 : 1) , (x + y) % 2 == 1 ? 1 : 0, (x + y) % 2 == 0 ? 1 : 0, 0);
        }
        [CATransaction commit];
        
        [CATransaction begin];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [CATransaction setValue:[NSNumber numberWithFloat:animationDuration] forKey:kCATransactionAnimationDuration];
        [CATransaction setCompletionBlock:^{
        }];
        
        for (int index = 0; index < 4; index++) {
            CALayer* layer = self.layers[index];
            layer.transform = CATransform3DMakeRotation(0, 1, 1, 1);
        }
        
        [CATransaction commit];
    }];
    for (int index = 0; index < 4; index++) {
        CALayer* layer = self.layers[index];
        int x = index % 2;
        int y = index / 2;
        layer.transform = CATransform3DMakeRotation(M_PI_2 * (y == 0 ? -1 : 1) , (x + y) % 2 == 0 ? 1 : 0, (x + y) % 2 == 1 ? 1 : 0, 0);
    }
    [CATransaction commit];
}
@end
