//
//  GLTriangleViewController.m
//  OpenGL Triangle
//
//  Created by Hamdan Javeed on 2013-07-09.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//
//  This class is responsible for drawing a triangle to the screen. The triangle will
//  be an equilateral triangle that is centered at the origin. The triangle will also
//  be completely white.
//

#import "GLTriangleViewController.h"

// a struct that contains information for one vertex
typedef struct {
    // the position of the vertex in 3D-space
    float position[3];
} vertex;

// the vertex data for the triangle, the triangle is an equilateral triangle centered at (0, 0, 0)
const vertex triangleVBOData[] = {
    { 0.0f,  0.5f, 0.0f},
    {-0.5f, -0.5f, 0.0f},
    { 0.5f, -0.5f, 0.0f}
};

@interface GLTriangleViewController () <GLKViewDelegate> {
    // a handle for the triangle vertex buffer object
    GLuint triangleVBOHandle;
}

// a GLKBaseEffect object to use some basic lighting effects (we're just going to use a constant white color)
@property (strong, nonatomic) GLKBaseEffect *effect; 
@end

@implementation GLTriangleViewController

#pragma mark - ViewController lifecycle

// called at launch, sets up opengl to draw the triangle
// needs to setup a context, an effect and the triangle vbo
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // get our GLKView and ensure that it is indeed a GLKView
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"GLTriangleViewController's view is not a GLKView");
    
    // create and set the view's context, and make it the current context
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    // initialize the effect and set it to use a constant white color
    self.effect = [[GLKBaseEffect alloc] init];
    [self.effect setUseConstantColor:GL_TRUE];
    [self.effect setConstantColor:GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f)];
    
    // tell opengl to use a black color to clear the color render buffer
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    // setup the triangle vbo for static drawing, and bind it to GL_ARRAY_BUFFER
    glGenBuffers(1, &triangleVBOHandle);
    glBindBuffer(GL_ARRAY_BUFFER, triangleVBOHandle);
    glBufferData(GL_ARRAY_BUFFER, sizeof(triangleVBOData), triangleVBOData, GL_STATIC_DRAW);
}

// called when going out of memory, should delete all contexts and buffers
// needs to set view's context to nil and delete the triangle buffer
- (void)dealloc {
    // get our view and set it's context to the current context
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    // if the triangleVBO exists, delete it and set the handle to 0
    if (triangleVBOHandle != 0) {
        glDeleteBuffers(1, &triangleVBOHandle);
        triangleVBOHandle = 0;
    }
    
    // release the view's context out of memory
    view.context = nil;
    [EAGLContext setCurrentContext:nil];
}

# pragma mark - GLKViewDelegate

// part of the GLKViewDelegate, draws the triangle
// needs to tell the effect to get ready for drawing, and then draw the triangle
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // tell the GLKBaseEffect to prepare itself to draw
    [self.effect prepareToDraw];
    
    // clear the window to black
    glClear(GL_COLOR_BUFFER_BIT);
    
    // enable the position attribute for the triangle vertices
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    // feed vertex position information, parameters are as follows:
    // 1 - what attribute the data refers to
    // 2 - the size/dimension of the data
    // 3 - the type of data
    // 4 - if the data is normalized
    // 5 - the stride, how many bytes to skip till the next value
    // 6 - the position of the data (NULL means the data is bound to GL_ARRAY_BUFFER)
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(vertex), NULL);
    
    // draw the triangle, parameters are as follows:
    // 1 - the type of drawing
    // 2 - the index of the starting data point
    // 3 - the number of data points
    glDrawArrays(GL_TRIANGLES, 0, sizeof(triangleVBOData) / sizeof(vertex));
}

@end
