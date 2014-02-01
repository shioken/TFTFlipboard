//
//  TSTFlipboard.h
//  flipboardSample
//
//  Created by Ken Shiota on 2014/02/01.
//  Copyright (c) 2014年 Tesseract. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSTFlipboard : UIView {
}
@property (nonatomic, strong) NSMutableArray* layers;
@property (nonatomic, strong) NSArray* images;
@property (nonatomic) NSUInteger imageIndex;
@property (nonatomic, strong) NSMutableArray* panels;

- (void)startAnimation;
@end
