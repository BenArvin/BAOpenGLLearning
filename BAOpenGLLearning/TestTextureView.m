//
//  TestTextureView.m
//  BAOpenGLLearning
//
//  Created by BenArvin on 2019/8/19.
//  Copyright © 2019 BenArvin. All rights reserved.
//

#import "TestTextureView.h"
#import <OpenGLES/ES3/gl.h>
#import <GLKit/GLKit.h>

@interface TestTextureView() {
}

@property (nonatomic) CAEAGLLayer *openGLLayer;
@property (nonatomic) EAGLContext *openGLContext;
@property (nonatomic) GLuint renderBuffer;
@property (nonatomic) GLuint frameBuffer;

@end

@implementation TestTextureView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)display {
    _openGLLayer = (CAEAGLLayer *)self.layer;
    _openGLLayer.opaque = YES;
    _openGLLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: @(YES), kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};
    _openGLLayer.contentsScale = 1.0;
    
    _openGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:_openGLContext];
    
    glDeleteBuffers(1, &_renderBuffer);
    _renderBuffer = 0;
    glDeleteBuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
    
    [_openGLContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_openGLLayer];
    
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    const GLchar *vertexShaderSourceChar = (GLchar *)[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TestTextureVertex" ofType:@"glsl"] encoding:NSUTF8StringEncoding error:nil] UTF8String];
    glShaderSource(vertexShader, 1, &vertexShaderSourceChar, NULL);
    glCompileShader(vertexShader);
    int success;
    char infoLog[512];
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        return;
    }
    
    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    const GLchar *fragmentShaderSourceChar = (GLchar *)[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TestTextureFragment" ofType:@"glsl"] encoding:NSUTF8StringEncoding error:nil] UTF8String];
    glShaderSource(fragmentShader, 1, &fragmentShaderSourceChar, NULL);
    glCompileShader(fragmentShader);
    int success2;
    char infoLog2[512];
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success2);
    if (!success2) {
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog2);
        return;
    }
    
    GLuint program = glCreateProgram();
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    glLinkProgram(program);
    int success3;
    char infoLog3[512];
    glGetProgramiv(program, GL_LINK_STATUS, &success3);
    if (!success3) {
        glGetProgramInfoLog(program, 512, NULL, infoLog3);
        return;
    }
    
    glDeleteShader(fragmentShader);
    glDeleteShader(vertexShader);
    
    GLKTextureInfo *textureInfo = [self generateTextureInfo:[UIImage imageNamed:@"testImage"]];
    glBindTexture(GL_TEXTURE_2D, textureInfo.name);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    
    float vertices[] = {
        -1.0f,  1.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f,// left top
         1.0f,  1.0f, 0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f,// right top
        -1.0f, -1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 1.0f,// left bottom
         1.0f, -1.0f, 0.0f, 0.0f, 1.0f, 0.0f, 1.0f, 1.0f,// right bottom
    };
// 不设置颜色
//    float vertices[] = {
//        -1.0f,  1.0f, 0.0f, 0.0f, 0.0f,// left top
//         1.0f,  1.0f, 0.0f, 1.0f, 0.0f,// right top
//        -1.0f, -1.0f, 0.0f, 0.0f, 1.0f,// left bottom
//         1.0f, -1.0f, 0.0f, 1.0f, 1.0f,// right bottom
//    };
    unsigned int indices[] = {
        0, 1, 2,
        1, 2, 3,
    };
    unsigned int VAO, VBO, EBO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    glGenBuffers(1, &EBO);
    
    glBindVertexArray(VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)(6 * sizeof(float)));
    glEnableVertexAttribArray(2);
//    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
//    glEnableVertexAttribArray(0);
//    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
//    glEnableVertexAttribArray(1);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureInfo.name);
    glUseProgram(program);
    glBindVertexArray(VAO);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
    
    if ([EAGLContext currentContext] != _openGLContext) {
        [EAGLContext setCurrentContext:_openGLContext];
    }
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_openGLContext presentRenderbuffer:GL_RENDERBUFFER];
    
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
    glDeleteBuffers(1, &EBO);
}

- (GLKTextureInfo *)generateTextureInfo:(UIImage *)image {
    return [GLKTextureLoader textureWithCGImage:image.CGImage options:nil error:NULL];
}

@end
