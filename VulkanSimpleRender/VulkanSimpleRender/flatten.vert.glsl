
#version 450 core

#extension GL_EXT_scalar_block_layout : enable

layout(location = 0) in vec4 inPos;
layout(location = 1) in vec4 inColor;
layout(location = 0) flat out lowp vec4 fragColor;

layout(std430, set = 0, binding = 0, scalar) uniform transform_block {
    vec2 u_factor;
    float u_angle;
} trans_consts;

/** Model view translation matrix *
 * [ 1  0  0  0
     0  1  0  0
     0  0  1  0
     x  y  z  1
 * ]
*/

/** Ortho projection matrix *
 * [ 2/(r-l)       0             0             0
     0             2/(t-b)       0             0
     0             0             -2/(f-n)      0
     -(r+l)/(r-l)  -(t+b)/(t-b)  -(f+n)/(f-n)  1
 * ]
*/

/** rotate matrix *
 * [x^2*(1-c)+c  xy*(1-c)+zs  xz(1-c)-ys  0
    xy(1-c)-zs   y^2*(1-c)+c  yz(1-c)+xs  0
    xz(1-c)+ys   yz(1-c)-xs   z^2(1-c)+c  0
    0            0            0           1
 * ]
 * |(x, y, z)| must be 1.0
*/

void main(void)
{
    const float offset = -0.6f;
    // glTranslate(offset, offset, -2.3, 1.0)
    mat4 translateMatrix = mat4(1.0f, 0.0f, 0.0f, offset,      // column 0
                                0.0f, 1.0f, 0.0f, offset,      // column 1
                                0.0f, 0.0f, 1.0f, -2.3f,       // column 2
                                0.0f, 0.0f, 0.0f, 1.0f         // column 3
                                );

    const float radian = radians(trans_consts.u_angle);

    // glRotate(u_angle, 1.0, 0.0, 0.0)
    mat4 rotateMatrix = mat4(1.0f, 0.0f, 0.0f, 0.0f,                    // column 0
                             0.0f, cos(radian), -sin(radian), 0.0f,     // column 1
                             0.0f, sin(radian), cos(radian), 0.0f,      // column 2
                             0.0f, 0.0f, 0.0f, 1.0f                     // column 3
                             );

    // glOrtho(-u_factor.x, u_factor.x, -u_factor.y, u_factor.y, 1.0, 3.0)
    mat4 projectionMatrix = mat4(1.0f / trans_consts.u_factor.x, 0.0f, 0.0f, 0.0f,  // column 0
                                 0.0f, 1.0f / trans_consts.u_factor.y, 0.0f, 0.0f,  // column 1
                                 0.0f, 0.0f, -1.0f, -2.0f,                          // column 2
                                 0.0f, 0.0f, 0.0f, 1.0f                             // colimn 3
                                 );

    gl_Position = inPos * (rotateMatrix * (translateMatrix * projectionMatrix));
    
    fragColor = inColor;
}
