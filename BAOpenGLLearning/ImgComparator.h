//
//  ImgComparator.h
//  BAOpenGLLearning
//
//  Created by BenArvin on 2019/8/20.
//  Copyright © 2019 BenArvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgComparator : NSObject

+ (NSArray *)compareImage:(UIImage *)image1
                   image2:(UIImage *)image2
                    error:(NSError **)error;

+ (NSArray *)comparePixels:(CGImageRef)image1
                    react1:(CGRect)react1
                    image2:(CGImageRef)image2
                    react2:(CGRect)react2
                     error:(NSError **)error;

@end
