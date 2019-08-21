//
//  SimpleGPUImgProcesser.h
//  BAOpenGLLearning
//
//  Created by BenArvin on 2019/8/21.
//  Copyright © 2019 BenArvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface SimpleGPUImgProcesser : NSObject

+ (UIImage *)processImage:(UIImage *)image filters:(NSArray <GPUImageFilter *> *)filters;

@end
