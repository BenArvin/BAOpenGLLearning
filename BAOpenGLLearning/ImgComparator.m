//
//  ImgComparator.m
//  BAOpenGLLearning
//
//  Created by BenArvin on 2019/8/20.
//  Copyright © 2019 BenArvin. All rights reserved.
//

#import "ImgComparator.h"
#import <CoreGraphics/CoreGraphics.h>

@interface ImgComparator() {
}
@end

@implementation ImgComparator

+ (BOOL)compareImages:(UIImage *)image1 image2:(UIImage *)image2 diffPoints:(NSArray **)diffPoints error:(NSError **)error {
    CGImageRef imageRef_1 = image1.CGImage;
    CGImageRef imageRef_2 = image2.CGImage;
    
    size_t width_1 = CGImageGetWidth(imageRef_1);
    size_t height_1 = CGImageGetHeight(imageRef_1);
    size_t width_2 = CGImageGetWidth(imageRef_1);
    size_t height_2 = CGImageGetHeight(imageRef_1);

    if (width_1 != width_2 || height_1 != height_2) {
        if (error) {
            *error = [NSError errorWithDomain:@"ImgComparatorError" code:-1001 userInfo:@{@"msg": @"different image size"}];
        }
        return NO;
    }
    
    size_t width = width_1;
    size_t height = height_1;
    NSUInteger bytesPerPixel = 4;
    NSUInteger bitsPerComponent = 8;;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    
    unsigned char *rawData_1 = (unsigned char*)calloc(width * height * 4, sizeof(unsigned char));
    unsigned char *rawData_2 = (unsigned char*)calloc(width * height * 4, sizeof(unsigned char));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context_1 = CGBitmapContextCreate(rawData_1,
                                                   width,
                                                   height,
                                                   bitsPerComponent,
                                                   bytesPerRow,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context_1, CGRectMake(0, 0, width, height), imageRef_1);
    CGContextRelease(context_1);
    
    CGContextRef context_2 = CGBitmapContextCreate(rawData_2,
                                                   width,
                                                   height,
                                                   bitsPerComponent,
                                                   bytesPerRow,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context_2, CGRectMake(0, 0, width, height), imageRef_2);
    CGContextRelease(context_2);
    
    CGColorSpaceRelease(colorSpace);
    
    NSMutableArray *result = nil;
    for (int yi = 0; yi < height; yi++) {
        for (int xi = 0; xi < width; xi++) {
            NSUInteger byteIndex = (bytesPerRow * yi) + (xi * bytesPerPixel);
            
            CGFloat alpha_1 = ((CGFloat)rawData_1[byteIndex + 3]) / 255.0f;
            CGFloat red_1   = ((CGFloat)rawData_1[byteIndex + 0]) / alpha_1;
            CGFloat green_1 = ((CGFloat)rawData_1[byteIndex + 1]) / alpha_1;
            CGFloat blue_1  = ((CGFloat)rawData_1[byteIndex + 2]) / alpha_1;
            
            CGFloat alpha_2 = ((CGFloat)rawData_2[byteIndex + 3]) / 255.0f;
            CGFloat red_2   = ((CGFloat)rawData_2[byteIndex + 0]) / alpha_2;
            CGFloat green_2 = ((CGFloat)rawData_2[byteIndex + 1]) / alpha_2;
            CGFloat blue_2  = ((CGFloat)rawData_2[byteIndex + 2]) / alpha_2;
            
            if (alpha_1 != alpha_2 || red_1 != red_2 || green_1 != green_2 || blue_1 != blue_2) {
                if (!result) {
                    result = [[NSMutableArray alloc] init];
                }
                [result addObject:[NSValue valueWithCGPoint:CGPointMake(xi, yi)]];
            }
        }
    }
    
    free(rawData_1);
    free(rawData_2);
    if (diffPoints) {
        *diffPoints = result;
    }
    return YES;
}

CGImageRef YYCGImageCreateDecodedCopy(CGImageRef imageRef) {
    if (!imageRef) return NULL;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    if (width == 0 || height == 0) return NULL;

    CGColorSpaceRef space = CGImageGetColorSpace(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    if (bytesPerRow == 0 || width == 0 || height == 0) return NULL;
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    if (!dataProvider) return NULL;
    CFDataRef data = CGDataProviderCopyData(dataProvider); // decode
    if (!data) return NULL;
    
    CGDataProviderRef newProvider = CGDataProviderCreateWithCFData(data);
    CFRelease(data);
    if (!newProvider) return NULL;
    
    CGImageRef newImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, space, bitmapInfo, newProvider, NULL, false, kCGRenderingIntentDefault);
    CFRelease(newProvider);
    return newImage;
}

@end
