//
//  TestTriangleView.m
//  BAGPUImage
//
//  Created by BenArvin on 2019/8/12.
//  Copyright © 2019 BenArvin. All rights reserved.
//

#import "TestTriangleView.h"
#import <OpenGLES/ES3/gl.h>

NSString *const vertexShaderSource = SHADER_STRING
(
 attribute vec3 aPos;
 void main() {
     gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
 });

NSString *const fragmentShaderSource = SHADER_STRING
(
 void main() {
     gl_FragColor = vec4(1.0, 0.5, 0.2, 1.0);
 });

@interface TestTriangleView() {
}

@property (nonatomic) CAEAGLLayer *openGLLayer;
@property (nonatomic) EAGLContext *openGLContext;
@property (nonatomic) GLuint renderBuffer;
@property (nonatomic) GLuint frameBuffer;

@end

@implementation TestTriangleView

+ (Class)layerClass {
    //设置layer类型
    return [CAEAGLLayer class];
}

- (void)display {
    _openGLLayer = (CAEAGLLayer *)self.layer;
    _openGLLayer.opaque = YES;
    _openGLLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: @(YES), kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};
    _openGLLayer.contentsScale = 1.0;
    
    //设置context
    _openGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:_openGLContext];
    
    //清除缓存
    glDeleteBuffers(1, &_renderBuffer);
    _renderBuffer = 0;
    glDeleteBuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    
    //render buffer
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    
    //frame buffer
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
    
    [_openGLContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_openGLLayer];
    
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    const GLchar *vertexShaderSourceChar = (GLchar *)[vertexShaderSource UTF8String];
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
    const GLchar *fragmentShaderSourceChar = (GLchar *)[fragmentShaderSource UTF8String];
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
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    
    float vertices[] = {
        -1.0f, -1.0f, 0.0f, // left
        1.0f, -1.0f, 0.0f, // right
        -1.0f,  1.0f, 0.0f  // top
    };
    unsigned int VAO, VBO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    
    glBindVertexArray(VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3*sizeof(float), (void *)0);
    glEnableVertexAttribArray(0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    glUseProgram(program);
    glBindVertexArray(VAO);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    if ([EAGLContext currentContext] != _openGLContext) {
        [EAGLContext setCurrentContext:_openGLContext];
    }
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_openGLContext presentRenderbuffer:GL_RENDERBUFFER];
    
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
}

@end
