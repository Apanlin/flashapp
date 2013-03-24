//
//  UIImageUtil.m
//  flashapp
//
//  Created by Zhao Qi on 12-10-26.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "UIImageUtil.h"

@implementation UIImage (UIImageUtil)


- (UIImage *)scaleImage:(float)scaleSize
{
    float width = self.size.width * scaleSize;
    float height = self.size.height * scaleSize;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
                                
    return scaledImage;
}


- (UIImage *)resizeImage:(CGSize)resize
{
    UIGraphicsBeginImageContext(CGSizeMake(resize.width, resize.height));
    [self drawInRect:CGRectMake(0, 0, resize.width, resize.height)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return resizeImage;
}


-(UIImage*)getSubImage:(CGRect)rect
{
    //从原图片中取小图
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    
    //设置 image的CGRect
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    //创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)。 位图的大小就是刚刚得到的图片的大小
    UIGraphicsBeginImageContext(smallBounds.size);
    
    //得到上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘图 绘制在上下文 
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}



@end
