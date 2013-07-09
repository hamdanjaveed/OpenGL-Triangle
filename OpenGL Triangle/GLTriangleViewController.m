//
//  GLTriangleViewController.m
//  OpenGL Triangle
//
//  Created by Hamdan Javeed on 2013-07-09.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "GLTriangleViewController.h"

typedef struct {
    float position[3];
} vertex;

const vertex triangleVBOData[] = {
    { 0.0f,  0.5f, 0.0f},
    {-0.5f, -0.5f, 0.0f},
    { 0.5f, -0.5f, 0.0f}
};

@interface GLTriangleViewController () <GLKViewDelegate> {
    GLuint triangleVBOHandle;
}

@property (strong, nonatomic) GLKBaseEffect *effect;
@end

@implementation GLTriangleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"GLTriangleViewController's view is not a GLKView");
    
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    [self.effect setUseConstantColor:GL_TRUE];
    [self.effect setConstantColor:GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f)];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    glGenBuffers(1, &triangleVBOHandle);
    glBindBuffer(GL_ARRAY_BUFFER, triangleVBOHandle);
    glBufferData(GL_ARRAY_BUFFER, sizeof(triangleVBOData), triangleVBOData, GL_STATIC_DRAW);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.effect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(vertex), NULL);
    
    glDrawArrays(GL_TRIANGLES, 0, sizeof(triangleVBOData) / sizeof(vertex));
}

- (void)dealloc {
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if (triangleVBOHandle != 0) {
        glDeleteBuffers(1, &triangleVBOHandle);
        triangleVBOHandle = 0;
    }
    
    view.context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
