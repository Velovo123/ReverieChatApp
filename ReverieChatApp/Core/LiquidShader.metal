//
//  LiquidShader.metal
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 21.04.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float hash(float2 p) {
    p = fract(p * float2(234.34, 435.345));
    p += dot(p, p + 34.23);
    return fract(p.x * p.y);
}

float noise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    float2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(
               mix(hash(i + float2(0,0)), hash(i + float2(1,0)), u.x),
               mix(hash(i + float2(0,1)), hash(i + float2(1,1)), u.x),
               u.y
               );
}

float fbm(float2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

[[ stitchable ]]
half4 liquidRainbow(float2 position, half4 color, float2 size, float time) {
    float2 uv = position / size;

    float t = time * 0.2;

    float2 q = float2(
        fbm(uv * 2.5 + float2(0.0, 0.0) + t * 0.3),
        fbm(uv * 2.5 + float2(5.2, 1.3) + t * 0.25)
    );

    float2 r = float2(
        fbm(uv * 2.5 + 3.0 * q + float2(1.7, 9.2) + t * 0.2),
        fbm(uv * 2.5 + 3.0 * q + float2(8.3, 2.8) + t * 0.15)
    );

    float f = fbm(uv * 2.5 + 3.0 * r + t * 0.1);

    float3 colorA = float3(0.6, 0.75, 1.0);
    float3 colorB = float3(0.75, 0.6, 1.0);
    float3 colorC = float3(1.0, 0.7, 0.85);
    float3 white  = float3(0.97, 0.97, 1.0);   

    float3 rgb = mix(colorA, colorB, f);
    rgb = mix(rgb, colorC, fbm(uv * 3.0 + t * 0.08));
    rgb = mix(rgb, white, pow(f, 2.0) * 0.5);

    return half4(half3(rgb), 1.0);
}

[[ stitchable ]]
half4 dotGrid(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    float2 grid = fract(position / 16.0);
    float2 centered = grid - 0.5;
    float dist = length(centered);
    float dot = 1.0 - smoothstep(0.08, 0.12, dist);
    float3 bg = float3(0.98, 0.98, 0.97);
    float3 dotColor = float3(0.76, 0.76, 0.75);
    float3 rgb = mix(bg, dotColor, dot * 0.8);
    return half4(half3(rgb), 1.0);
}

[[ stitchable ]]
half4 auroraStripe(float2 position, half4 color, float2 size, float time) {
    float2 uv = position / size;
    float t = fmod(time, 100.0) * 0.3;

    if (position.x > 3.0) {
        return half4(0.0, 0.0, 0.0, 0.0);
    }

    float hue = uv.y + t * 0.1;
    hue = fract(hue);

    float3 hsv = float3(hue, 0.7, 1.0);
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 p = abs(fract(hsv.xxx + K.xyz) * 6.0 - K.www);
    float3 rgb = hsv.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), hsv.y);

    return half4(half3(rgb), 1.0);
}
