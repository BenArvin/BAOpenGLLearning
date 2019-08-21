#import "BAGPUImageStickerFilter.h"

NSString *const kBAGPUImageStickerFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
    lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    
    gl_FragColor = vec4((1.0 - textureColor.rgb), textureColor.w);
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

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates {
    
}

@end

