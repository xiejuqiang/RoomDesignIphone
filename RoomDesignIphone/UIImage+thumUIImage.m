//
//  UIImage+thumUIImage.m
//  RoomDesign
//
//  Created by apple on 13-11-22.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "UIImage+thumUIImage.h"

@implementation UIImage (thumUIImage)

// Create thumb
- (UIImage *)thumbWithWidth:(CGFloat)width height:(CGFloat)height {
    CGFloat w, h;
    CGFloat r = self.size.width / self.size.height;
    if (0 == height) {
        // thumb with specific width, X2 for retina display
        w = width*2;
        h = w / r;
    } else if (0 == width) {
        // thumb with specific height
        h = height*2;
        w = h * r;
    } else {
        if (r <= width/height) {
            h = height/4;
            w = h * r;
        } else {
            w = width/2;
            h = w / r;
        }
    }
    // Draw thumb
    CGRect rect;
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    rect = CGRectMake(0, 0, w, h);
    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(ctx, rect);
    CGFloat p = width / 2.0;
    [self drawInRect:CGRectMake(p, p, w-p*2, h-p*2)];
    UIImage *thumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumb;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


@end
