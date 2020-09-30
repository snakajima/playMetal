//
//  MyShaderTypes.h
//  playMetal
//
//  Created by SATOSHI NAKAJIMA on 9/29/20.
//

#ifndef MyShaderTypes_h
#define MyShaderTypes_h

#include <simd/simd.h>

typedef enum AAPLVertexInputIndex
{
    AAPLVertexInputIndexVertices = 0,
    AAPLVertexInputIndexUniforms = 1,
} AAPLVertexInputIndex;

typedef struct
{
    // Positions in pixel space (i.e. a value of 100 indicates 100 pixels from the origin/center)
    vector_float2 position;

    // 2D texture coordinate
    vector_float3 color;
} AAPLVertex;

typedef struct
{
    float scale;
    vector_uint2 viewportSize;
} AAPLUniforms;

#endif /* MyShaderTypes_h */
