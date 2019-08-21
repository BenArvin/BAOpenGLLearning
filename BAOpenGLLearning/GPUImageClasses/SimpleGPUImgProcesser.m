//
//  SimpleGPUImgProcesser.m
//  BAOpenGLLearning
//
//  Created by BenArvin on 2019/8/21.
//  Copyright © 2019 BenArvin. All rights reserved.
//

#import "SimpleGPUImgProcesser.h"

@implementation SimpleGPUImgProcesser

+ (UIImage *)processImage:(UIImage *)image filters:(NSArray <GPUImageFilter *> *)filters {
    CGImageRef newImageSource = [image CGImage];
    size_t width = CGImageGetWidth(newImageSource);
    size_t height = CGImageGetHeight(newImageSource);
    size_t bytesPerComponent = CGImageGetBitsPerComponent(newImageSource);
    size_t bytesPerRow = CGImageGetBytesPerRow(newImageSource);
    size_t bytesPerPixel = CGImageGetBitsPerPixel(newImageSource);
    
    CFDataRef dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(newImageSource));
    GLubyte *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
    
    
    GPUImageRawDataInput *input = [[GPUImageRawDataInput alloc] initWithBytes:imageData size:CGSizeMake(width, height) pixelFormat:GPUPixelFormatRGBA];
    GPUImageRawDataOutput *output = [[GPUImageRawDataOutput alloc] initWithImageSize:CGSizeMake(width, height) resultsInBGRAFormat:YES];
    GPUImageFilterPipeline *pipLine = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:filters input:input output:output];
    
    [input processData];

    [output lockFramebufferForReading];
    GLubyte *outputBytes = [output rawBytesForImage];
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, outputBytes, bytesPerRow * height, NULL);
    CGImageRef cgImage = CGImageCreate(width, height, bytesPerComponent, bytesPerPixel, [output bytesPerRowInOutput], CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little, provider, NULL, true, kCGRenderingIntentDefault);
    [output unlockFramebufferAfterReading];
    UIImage *xx = [UIImage imageWithCGImage:cgImage];
    return [UIImage imageWithCGImage:cgImage];
}

@end
