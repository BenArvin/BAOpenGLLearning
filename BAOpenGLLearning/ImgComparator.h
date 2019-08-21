//
//  ImgComparator.h
//  BAOpenGLLearning
//
//  Created by BenArvin on 2019/8/20.
//  Copyright © 2019 BenArvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgComparator : NSObject

+ (BOOL)compareImages:(UIImage *)image1 image2:(UIImage *)image2 diffPoints:(NSArray **)diffPoints error:(NSError **)error;

@end
