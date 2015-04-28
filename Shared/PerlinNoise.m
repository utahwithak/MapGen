//
//  PerlinNoise.m
//  PerlinTest
//
//  Created by Weston Hanners on 7/16/12.
//  Copyright (c) 2012 Hanners Software. All rights reserved.
//

#import "PerlinNoise.h"

@interface PerlinNoise () {
    NSInteger _functionSelector;
}

@end

@implementation PerlinNoise

- (id)initWithSeed:(NSInteger)seed {
    if ((self = [super init])) {
        self.seed = seed;
        self.smoothing = NO;
        self.interpolationMethod = kLinearInterpolation;
        self.octaves = 1;
        self.scale = 1;
        self.frequency = 0.5;
        self.persistence = sqrt(self.amplitude);
    }
    return self;
}

- (double)linearInterpolationBetweenValueA:(double)a valueB:(double)b valueX:(double)x {
    return a * (1 - x) + b * x ;
}

- (double)cosineInterpolationBetweenValueA:(double)a valueB:(double)b valueX:(double)x {
    double ft = x * 3.1415927f;
    double f = (1 - (double)cos(ft)) * 0.5f;
    return a * (1 - f) + b * f;
}

#pragma mark - 1D Perlin Functions

- (double)makeNoise1D:(NSInteger)x {
    x = (x >> 13) ^ x;
    x = (x * (x * x * (NSInteger)_seed + 19990303) + 1376312589) & RAND_MAX;
    return ( 1.0 - ( (x * (x * x * 15731 + 789221) + 1376312589) & RAND_MAX) / 1073741824.0);
}

- (double)smoothedNoise1D:(double)x {
    return [self makeNoise1D:x] / 2 + [self makeNoise1D:(x - 1)] / 4 + [self makeNoise1D:(x + 1)] / 4;;
}

- (double)interpolatedNoise1D:(double)x {
    NSInteger integer_x = (int)x;
    double fractional_x = x-integer_x;
    
    double v1 = [self smoothedNoise1D:integer_x];
    double v2 = [self smoothedNoise1D:integer_x + 1];
    
    
    if (_interpolationMethod == kCosineInterpolation) {
        return [self cosineInterpolationBetweenValueA:v1 valueB:v2 valueX:fractional_x];
    } else {
        return [self linearInterpolationBetweenValueA:v1 valueB:v2 valueX:fractional_x];
    }
}

- (double)perlin1DValueForPoint:(double)x {
    double value = 0;
    double persistence = _persistence;
    double frequency = _frequency;
    double amplitude;
    for (NSInteger i = 0;i < _octaves;i++) {
        
        frequency = pow(frequency, i);
        amplitude = pow(persistence, i);
        
        if (_smoothing) {
            value = value + [self interpolatedNoise1D:(x * frequency) * frequency] * amplitude;
        } else {
            value = value + [self makeNoise1D:(x * frequency) * frequency] * amplitude;
        }
        
    }
    
    return value / _octaves * _scale;;
}

#pragma mark - 2D Perlin Functions

- (double)makeNoise2D:(NSInteger)x :(NSInteger)y {
    NSInteger n = x + y * 57;
    n = (n >> 13) ^  (n * _functionSelector);
    n = (n * (n * n * (NSInteger)_seed + 19990303) + 1376312589) & RAND_MAX;
    return ( 1.0 - ( (n * (n * n * 15731 + 789221) + 1376312589) & RAND_MAX) / 1073741824.0);
}

- (double)smoothedNoise2D:(double)x :(double)y {
    double corners = ([self makeNoise2D:x-1 :y-1] + [self makeNoise2D:x+1 :y-1] +
                     [self makeNoise2D:x-1 :y+1] + [self makeNoise2D:x+1 :y+1]) / 16;
    double sides = ([self makeNoise2D:x-1 :y] + [self makeNoise2D:x+1 :y] +
                   [self makeNoise2D:x :y+1] + [self makeNoise2D:x :y+1]) / 8;
    double center = [self makeNoise2D:x :y] / 4;
    
    return corners + sides + center;
}

- (double)interpolatedNoise2D:(double)x :(double)y {
    NSInteger integer_x = (int)x;
    double fractional_x = x-integer_x;
    
    NSInteger integer_y = (int)y;
    double fractional_y = y-integer_y;
    
    double v1 = [self smoothedNoise2D:integer_x :integer_y];
    double v2 = [self smoothedNoise2D:integer_x + 1 :integer_y];
    double v3 = [self smoothedNoise2D:integer_x :integer_y + 1];
    double v4 = [self smoothedNoise2D:integer_x + 1 :integer_y + 1];

    
    if (_interpolationMethod == kCosineInterpolation) {
        double i1 = [self cosineInterpolationBetweenValueA:v1 valueB:v2 valueX:fractional_x];
        double i2 = [self cosineInterpolationBetweenValueA:v3 valueB:v4 valueX:fractional_x];
        return [self cosineInterpolationBetweenValueA:i1 valueB:i2 valueX:fractional_y];
    } else {
        double i1 = [self linearInterpolationBetweenValueA:v1 valueB:v2 valueX:fractional_x];
        double i2 = [self linearInterpolationBetweenValueA:v3 valueB:v4 valueX:fractional_x];
        return [self linearInterpolationBetweenValueA:i1 valueB:i2 valueX:fractional_y];
    }
}

- (double)perlin2DValueForPoint:(double)x y:(double)y{
    _functionSelector = 1;
    double value = 0;
    double persistence = _persistence;
    double frequency = _frequency;
    double amplitude;
    for (NSInteger i = 0;i < _octaves;i++) {
        
        frequency = pow(frequency, i);
        amplitude = pow(persistence, i);
        
        if(_smoothing){
            value = value + [self interpolatedNoise2D:(x * _frequency) * frequency :(y * _frequency) * frequency] * amplitude;
        }
        else{
            value = value + [self makeNoise2D:(x * _frequency) * frequency :(y * _frequency) * frequency] * amplitude;
        }

        _functionSelector++;
    }
    return value / _octaves * _scale;
}

@end
