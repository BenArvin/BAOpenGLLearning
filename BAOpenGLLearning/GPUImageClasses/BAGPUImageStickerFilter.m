#import "BAGPUImageStickerFilter.h"

//NSString *const kBAGPUImageStickerVertexShaderString = SHADER_STRING
//(
// attribute vec4 position;
// attribute vec4 inputTextureCoordinate;
//
// varying vec2 blurCoordinates[5];
//
// void main()
// {
//     gl_Position = position;
//
//     blurCoordinates[0] = inputTextureCoordinate.xy;
//     blurCoordinates[1] = inputTextureCoordinate.xy + vec2(0.0015, 0.0015) * 1.407333;
//     blurCoordinates[2] = inputTextureCoordinate.xy - vec2(0.0015, 0.0015) * 1.407333;
//     blurCoordinates[3] = inputTextureCoordinate.xy + vec2(0.0015, 0.0015) * 3.294215;
//     blurCoordinates[4] = inputTextureCoordinate.xy - vec2(0.0015, 0.0015) * 3.294215;
// }
// );

NSString *const kBAGPUImageStickerFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
// varying highp vec2 blurCoordinates[5];
 
 void main()
 {
    lowp vec4 textureColor1 = texture2D(inputImageTexture, textureCoordinate.xy) * 0.2;
    lowp vec4 textureColor2 = texture2D(inputImageTexture, textureCoordinate.xy + vec2(-0.0015, -0.0015)) * 0.4;
    lowp vec4 textureColor3 = texture2D(inputImageTexture, textureCoordinate.xy + vec2(0, -0.0015)) * 0.0;
    lowp vec4 textureColor4 = texture2D(inputImageTexture, textureCoordinate.xy + vec2(0.0015, -0.0015)) * 0.0;
    lowp vec4 textureColor5 = texture2D(inputImageTexture, textureCoordinate.xy + vec2(-0.0015, 0)) * 0.0;
    lowp vec4 textureColor6 = texture2D(inputImageTexture, textureCoordinate.xy + vec2(0.0015, 0)) * 0.0;
    lowp vec4 textureColor7 = texture2D(inputImageTexture, textureCoordinate.xy + vec2(-0.0015, 0.0015)) * 0.0;
    lowp vec4 textureColor8 = texture2D(inputImageTexture, textureCoordinate.xy + vec2(0, 0.0015)) * 0.0;
    lowp vec4 textureColor9 = texture2D(inputImageTexture, textureCoordinate.xy + vec2(0.0015, 0.0015)) * 0.4;

     gl_FragColor = textureColor1 + textureColor2 + textureColor3 + textureColor4 + textureColor5 + textureColor6 + textureColor7 + textureColor8 + textureColor9;
//     highp vec4 textureColor1 = texture2D(inputImageTexture, blurCoordinates[0]) * 0.204164;
//     highp vec4 textureColor2 = texture2D(inputImageTexture, blurCoordinates[1]) * 0.304005;
//     highp vec4 textureColor3 = texture2D(inputImageTexture, blurCoordinates[2]) * 0.304005;
//     highp vec4 textureColor4 = texture2D(inputImageTexture, blurCoordinates[3]) * 0.093913;
//     highp vec4 textureColor5 = texture2D(inputImageTexture, blurCoordinates[4]) * 0.093913;
//
//     gl_FragColor = textureColor1 + textureColor2 + textureColor3 + textureColor4 + textureColor5;
 }
);

@implementation BAGPUImageStickerFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kBAGPUImageStickerFragmentShaderString])) {
		return nil;
    }
    return self;
}

//- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates {
//
//}

@end

