
#version 450 core

precision mediump int;
precision highp float;

layout(location = 0) flat in lowp vec4 fragColor;
layout(location = 0) out lowp vec4 myOutput;

void main(void)
{
    myOutput = fragColor;
}
