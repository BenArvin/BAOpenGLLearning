//
//  TestCircleView.m
//  BAOpenGLLearning
//
//  Created by BenArvin on 2019/8/16.
//  Copyright © 2019 BenArvin. All rights reserved.
//

#import "TestCircleView.h"
#import <OpenGLES/ES3/gl.h>

NSString *const vertexShaderSourceForCircleView = SHADER_STRING
(
 attribute vec3 aPos;
 void main() {
     gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
 });

NSString *const fragmentShaderSourceForCircleView = SHADER_STRING
(
 void main() {
     gl_FragColor = vec4(1.0, 0.5, 0.2, 1.0);
 });

@interface TestCircleView() {
}

@property (nonatomic) CAEAGLLayer *openGLLayer;
@property (nonatomic) EAGLContext *openGLContext;
@property (nonatomic) GLuint renderBuffer;
@property (nonatomic) GLuint frameBuffer;

@end

@implementation TestCircleView

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
    const GLchar *vertexShaderSourceChar = (GLchar *)[vertexShaderSourceForCircleView UTF8String];
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
    const GLchar *fragmentShaderSourceChar = (GLchar *)[fragmentShaderSourceForCircleView UTF8String];
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
    
    int piecesCount = 100000;
    float vertices[piecesCount * 3];
    float delta = 2.0 * M_PI / piecesCount;
    float radiusH = 0.8;
    float radiusV = 0.8 * (self.bounds.size.width / self.bounds.size.height);
    for (int i = 0; i<piecesCount; i++) {
        GLfloat x = radiusH * cos(delta * i);
        GLfloat y = radiusV * sin(delta * i);
        GLfloat z = 0.0;
        vertices[i * 3 + 0] = x;
        vertices[i * 3 + 1] = y;
        vertices[i * 3 + 2] = z;
    }
    
    unsigned int VAO, VBO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    
    glBindVertexArray(VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    glUseProgram(program);
    glBindVertexArray(VAO);
    glDrawArrays(GL_TRIANGLE_FAN, 0, piecesCount);
    
    if ([EAGLContext currentContext] != _openGLContext) {
        [EAGLContext setCurrentContext:_openGLContext];
    }
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_openGLContext presentRenderbuffer:GL_RENDERBUFFER];
    
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
}

@end
