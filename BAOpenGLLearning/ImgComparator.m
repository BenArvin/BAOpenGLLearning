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

+ (NSArray *)compareImage:(UIImage *)image1
                   image2:(UIImage *)image2
                    error:(NSError **)error {
    CGImageRef imageRef_1 = image1.CGImage;
    CGImageRef imageRef_2 = image2.CGImage;
    return [self comparePixels:imageRef_1 react1:CGRectMake(0, 0, CGImageGetWidth(imageRef_1), CGImageGetHeight(imageRef_1)) image2:imageRef_2 react2:CGRectMake(0, 0, CGImageGetWidth(imageRef_2), CGImageGetHeight(imageRef_2)) error:error];
}

+ (NSArray *)comparePixels:(CGImageRef)image1
                    react1:(CGRect)react1
                    image2:(CGImageRef)image2
                    react2:(CGRect)react2
                     error:(NSError **)error {
    //TODO: need convert to same image format first
    if (!image1 || !image2) {
        if (error) {
            *error = [NSError errorWithDomain:@"ImgComparatorError" code:-1001 userInfo:@{@"msg": @"image is nil"}];
        }
        return nil;
    }
    if (react1.size.width == 0 || react1.size.height == 0 || react1.size.height == 0 || react1.size.height == 0) {
        if (error) {
            *error = [NSError errorWithDomain:@"ImgComparatorError" code:-1002 userInfo:@{@"msg": @"react size invalid"}];
        }
        return nil;
    }
    if (!CGSizeEqualToSize(react1.size, react2.size)) {
        if (error) {
            *error = [NSError errorWithDomain:@"ImgComparatorError" code:-1003 userInfo:@{@"msg": @"react size different"}];
        }
        return nil;
    }
    
    CGImageRef imageRef_1 = image1;
    CGImageRef imageRef_2 = image2;
    
    size_t width_1 = CGImageGetWidth(imageRef_1);
    size_t height_1 = CGImageGetHeight(imageRef_1);
    size_t width_2 = CGImageGetWidth(imageRef_1);
    size_t height_2 = CGImageGetHeight(imageRef_1);
    
    if (react1.origin.x < 0 || react1.origin.x + react1.size.width > width_1 || react1.origin.y < 0 || react1.origin.y + react1.size.height > height_1) {
        if (error) {
            *error = [NSError errorWithDomain:@"ImgComparatorError" code:-1004 userInfo:@{@"msg": @"react area over image size"}];
        }
        return nil;
    }
    if (react2.origin.x < 0 || react2.origin.x + react2.size.width > width_2 || react2.origin.y < 0 || react2.origin.y + react2.size.height > height_2) {
        if (error) {
            *error = [NSError errorWithDomain:@"ImgComparatorError" code:-1004 userInfo:@{@"msg": @"react area over image size"}];
        }
        return nil;
    }
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bitsPerComponent = 8;;
    NSUInteger bytesPerRow = bytesPerPixel * width_1;
    
    unsigned char *rawData_1 = (unsigned char*)calloc(width_1 * height_1 * 4, sizeof(unsigned char));
    unsigned char *rawData_2 = (unsigned char*)calloc(width_2 * height_2 * 4, sizeof(unsigned char));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context_1 = CGBitmapContextCreate(rawData_1,
                                                   width_1,
                                                   height_1,
                                                   bitsPerComponent,
                                                   bytesPerRow,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context_1, CGRectMake(0, 0, width_1, height_1), imageRef_1);
    CGContextRelease(context_1);
    
    CGContextRef context_2 = CGBitmapContextCreate(rawData_2,
                                                   width_2,
                                                   height_2,
                                                   bitsPerComponent,
                                                   bytesPerRow,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context_2, CGRectMake(0, 0, width_2, height_2), imageRef_2);
    CGContextRelease(context_2);
    
    CGColorSpaceRelease(colorSpace);
    
    NSUInteger width = react1.size.width;
    NSUInteger height = react1.size.height;
    NSMutableArray *result = nil;
    for (int yi = 0; yi < height; yi++) {
        for (int xi = 0; xi < width; xi++) {
            NSUInteger byteIndex_1 = (bytesPerRow * (yi + react1.origin.y)) + (bytesPerPixel * (xi + react1.origin.x));
            CGFloat alpha_1 = ((CGFloat)rawData_1[byteIndex_1 + 3]) / 255.0f;
            CGFloat red_1   = ((CGFloat)rawData_1[byteIndex_1 + 0]) / alpha_1;
            CGFloat green_1 = ((CGFloat)rawData_1[byteIndex_1 + 1]) / alpha_1;
            CGFloat blue_1  = ((CGFloat)rawData_1[byteIndex_1 + 2]) / alpha_1;
            
            NSUInteger byteIndex_2 = (bytesPerRow * (yi + react2.origin.y)) + (bytesPerPixel * (xi + react2.origin.x));
            CGFloat alpha_2 = ((CGFloat)rawData_2[byteIndex_2 + 3]) / 255.0f;
            CGFloat red_2   = ((CGFloat)rawData_2[byteIndex_2 + 0]) / alpha_2;
            CGFloat green_2 = ((CGFloat)rawData_2[byteIndex_2 + 1]) / alpha_2;
            CGFloat blue_2  = ((CGFloat)rawData_2[byteIndex_2 + 2]) / alpha_2;
            
            if (alpha_1 != alpha_2 || red_1 != red_2 || green_1 != green_2 || blue_1 != blue_2) {
                if (alpha_1 == 0 && alpha_2 == 0) {
                    continue;
                }
                if (!result) {
                    result = [[NSMutableArray alloc] init];
                }
                [result addObject:[NSValue valueWithCGPoint:CGPointMake(xi, yi)]];
            }
        }
    }
    
    free(rawData_1);
    free(rawData_2);
    return result;
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
