//
//  PerlinNoise.h
//  PerlinTest
//
//  Created by Weston Hanners on 7/16/12.
//  Copyright (c) 2012 Hanners Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kLinearInterpolation = 0,
    kCosineInterpolation = 1
} interpolationType;

@interface PerlinNoise : NSObject

- (id)initWithSeed:(NSInteger)seed;
- (double)perlin1DValueForPoint:(double)x;
- (double)perlin2DValueForPoint:(double)x y:(double)y;

@property NSInteger seed;
@property NSInteger octaves;
@property double persistence;
@property double scale;
@property double frequency;
@property double amplitude;
@property interpolationType interpolationMethod;
@property BOOL smoothing;

@end
