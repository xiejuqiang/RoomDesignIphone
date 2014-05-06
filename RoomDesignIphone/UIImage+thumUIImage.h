//
//  UIImage+thumUIImage.h
//  RoomDesign
//
//  Created by apple on 13-11-22.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (thumUIImage)

- (UIImage *)thumbWithWidth:(CGFloat)width height:(CGFloat)height;
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

@end
