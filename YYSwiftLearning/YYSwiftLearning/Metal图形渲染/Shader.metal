//
//  Shader.metal
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/2/7.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[position]];
};

vertex Vertex vertex_func(constant Vertex *vertices [[buffer(0)]],uint vid [[vertex_id]]){
    return vertices[vid];
}

fragment float4 fragment_func(Vertex vert [[stage_in]]){
    return float4(0.7,1,1,1);
}
