���     =b  �SK  !x_               default�N�
7�     �a  ���  "X�                      �	  //macros
#define Scene(name) name
#define SceneArray(name, index) name[index]
#define Camera(name) name
#define CameraArray(name, index) name[index]
#define Transform(name) name
#define TransformArray(name, index) name[index]
#define Skeleton(name) name
#define SkeletonArray(name, index) name[index]
#define Material(name) name
#define MaterialArray(name, index) name[index]
#define PostProcessPass(name) name
#define PostProcessPassArray(name, index) name[index]
//
//shader-maker
//

in vec3 position;
in vec2 texcoord;
out vec2 BaseUV;
out vec2 MaskUV;
out vec2 TexelSize;
out vec4 UVRange;
//------------
//
//shader-maker
//

uniform vec4 blur_scale0; //vec4
uniform vec4 blur_scale1; //vec4
uniform vec4 scale_rate; //vec4
uniform vec4 mask_color; //vec3
//------------
// parameters
uniform mat4 projection;
uniform vec4 sys_camera_aspect;
uniform vec4 sys_camera_depth;
uniform vec4 sys_camera_pos;
uniform vec4 sys_camera_dir;
uniform mat4 sys_camera_viewproj;
uniform mat4 sys_camera_invviewproj;
uniform mat4 sys_camera_invproj;
uniform vec4 sys_camera_colorscale;
uniform vec4 sys_camera_invcolorscale;
uniform vec4 sys_light_projpos;
uniform vec4 sys_time;
uniform vec4 base_map_size;
uniform vec4 base_map_size2;
uniform vec4 base_map_size3;
uniform vec4 base_map_size4;
uniform vec4 base_map_size5;
uniform vec4 base_map_size6;
uniform vec4 base_map_size7;
uniform vec4 base_map_size8;
uniform vec4 depth_map_size;
// textures
uniform sampler2D base_map;
uniform sampler2D base_map2;
uniform sampler2D base_map3;
uniform sampler2D base_map4;
uniform sampler2D base_map5;
uniform sampler2D base_map6;
uniform sampler2D base_map7;
uniform sampler2D base_map8;
uniform HIGHP sampler2D depth_map;
void main() {
  vec4 tmp_position = vec4(position, 1.0);
  gl_Position = PostProcessPass(projection) * tmp_position;
  BaseUV = texcoord;

  gl_Position.xyz *= Material(scale_rate).z;

  BaseUV *= 2.0;
  BaseUV -= vec2(1.0);
  BaseUV *= Material(scale_rate).y;
  BaseUV += vec2(1.0);
  BaseUV *= 0.5;

#if DEPTH_MASK
  MaskUV = texcoord;
#endif

  ivec2 itexture_size = textureSize(base_map, 0);
  vec2 texture_size = vec2(float(itexture_size.x), float(itexture_size.y));
  vec2 texel_size = vec2(1.0) / texture_size;
  vec2 range_offset = vec2(0.5) * Material(scale_rate).y - texel_size;
  vec2 range_min = vec2(0.5) - range_offset;
  vec2 range_max = vec2(0.5) + range_offset;
  TexelSize.xy = texel_size;
  UVRange.xy = range_min;
  UVRange.zw = range_max;
}
�!  //macros
#define Scene(name) name
#define SceneArray(name, index) name[index]
#define Camera(name) name
#define CameraArray(name, index) name[index]
#define Transform(name) name
#define TransformArray(name, index) name[index]
#define Skeleton(name) name
#define SkeletonArray(name, index) name[index]
#define Material(name) name
#define MaterialArray(name, index) name[index]
#define PostProcessPass(name) name
#define PostProcessPassArray(name, index) name[index]
//
//shader-maker
//

in vec2 BaseUV;
in vec2 MaskUV;
in vec2 TexelSize;
in vec4 UVRange;
//------------
//
//shader-maker
//

uniform vec4 blur_scale0; //vec4
uniform vec4 blur_scale1; //vec4
uniform vec4 scale_rate; //vec4
uniform vec4 mask_color; //vec3
//------------
// parameters
uniform mat4 projection;
uniform vec4 sys_camera_aspect;
uniform vec4 sys_camera_depth;
uniform vec4 sys_camera_pos;
uniform vec4 sys_camera_dir;
uniform mat4 sys_camera_viewproj;
uniform mat4 sys_camera_invviewproj;
uniform mat4 sys_camera_invproj;
uniform vec4 sys_camera_colorscale;
uniform vec4 sys_camera_invcolorscale;
uniform vec4 sys_light_projpos;
uniform vec4 sys_time;
uniform vec4 base_map_size;
uniform vec4 base_map_size2;
uniform vec4 base_map_size3;
uniform vec4 base_map_size4;
uniform vec4 base_map_size5;
uniform vec4 base_map_size6;
uniform vec4 base_map_size7;
uniform vec4 base_map_size8;
uniform vec4 depth_map_size;
// textures
uniform sampler2D base_map;
uniform sampler2D base_map2;
uniform sampler2D base_map3;
uniform sampler2D base_map4;
uniform sampler2D base_map5;
uniform sampler2D base_map6;
uniform sampler2D base_map7;
uniform sampler2D base_map8;
uniform HIGHP sampler2D depth_map;
vec4 tex_mask(in const vec2 uv, in const vec2 mask_uv, in const vec2 offset, in const vec2 texel_size,
              in const float scale, in const vec2 min, in const vec2 max,
              inout float valid_count) {
#if DEPTH_MASK
  if (texture(base_map2, (mask_uv + offset * texel_size / scale)).r < 1.0) {
    valid_count -= 1.0;
    return vec4(0.0);
  }
#endif
  return texture(base_map, clamp((uv + offset * texel_size), min, max));
}

void main() {
#if DEPTH_MASK
  if (texture(base_map2, MaskUV).r < 1.0) {
    out_FragColor.xyz = Material(mask_color).xyz;
    out_FragColor.w = 0.0;
    return;
  }
#endif

#if BLUR_TYPE == 0
  float applyed_rate = 0.0;
  float valid_count = 1.0;
  out_FragColor = tex_mask(BaseUV, MaskUV, vec2(0.0, 0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) * Material(blur_scale0).x;
  applyed_rate = valid_count * Material(blur_scale0).x;
  valid_count = 4.0;
  out_FragColor += (tex_mask(BaseUV, MaskUV, vec2( 2.0,  0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-2.0,  0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 0.0,  2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 0.0, -2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * Material(blur_scale0).y;
  applyed_rate += valid_count * Material(blur_scale0).y;
  valid_count = 4.0;
  out_FragColor += (tex_mask(BaseUV, MaskUV, vec2( 4.0,  0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-4.0,  0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 0.0,  4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 0.0, -4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * Material(blur_scale0).z;
  applyed_rate += valid_count * Material(blur_scale0).z;
  valid_count = 4.0;
  out_FragColor += (tex_mask(BaseUV, MaskUV, vec2( 2.0,  2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-2.0,  2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 2.0, -2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-2.0, -2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * Material(blur_scale0).w;
  applyed_rate += valid_count * Material(blur_scale0).w;
  valid_count = 8.0;
  out_FragColor += (tex_mask(BaseUV, MaskUV, vec2( 4.0,  2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-4.0,  2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 4.0, -2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-4.0, -2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 2.0, -4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 2.0,  4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-2.0,  4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-2.0, -4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * Material(blur_scale1).x;
  applyed_rate += valid_count * Material(blur_scale1).x;
  valid_count = 4.0;
  out_FragColor += (tex_mask(BaseUV, MaskUV, vec2( 4.0,  4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-4.0,  4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 4.0, -4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-4.0, -4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * Material(blur_scale1).y;
  applyed_rate += valid_count * Material(blur_scale1).y;
  out_FragColor /= applyed_rate;
#elif BLUR_TYPE == 1
  float valid_count = 4.0;
  out_FragColor = (tex_mask(BaseUV, MaskUV, vec2(-1.0, -1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                   tex_mask(BaseUV, MaskUV, vec2(-1.0,  1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                   tex_mask(BaseUV, MaskUV, vec2( 1.0, -1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                   tex_mask(BaseUV, MaskUV, vec2( 1.0,  1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * 0.25;
  float applyed_rate = valid_count * 0.25;
  out_FragColor /= applyed_rate;
#elif BLUR_TYPE == 2
  float applyed_rate = 0.0;
  float valid_count = 1.0;
  out_FragColor = tex_mask(BaseUV, MaskUV, vec2(0.0, 0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) * 0.13039;
  applyed_rate = valid_count * 0.13039;
  valid_count = 4.0;
  out_FragColor += (tex_mask(BaseUV, MaskUV, vec2( 2.0,  0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-2.0,  0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 0.0,  2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 0.0, -2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * 0.115352;
  applyed_rate += valid_count * 0.115352;
  valid_count = 4.0;
  out_FragColor += (tex_mask(BaseUV, MaskUV, vec2( 1.0,  1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-1.0,  1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 1.0, -1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-1.0, -1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * 0.102049;
  applyed_rate += valid_count * 0.102049;
  out_FragColor /= applyed_rate;
#endif
  out_FragColor.w = 1.0;
}
�  #version 450
//macros
#define Scene(name) u_scene.name
#define SceneArray(name, index) u_scene.name[index]
#define Camera(name) u_camera.name
#define CameraArray(name, index) u_camera.name[index]
#define Transform(name) u_transform.name
#define TransformArray(name, index) u_transform.name[index]
#define Geometry(name) u_geometry.name
#define GeometryArray(name) u_geometry.name[index]
#define Skeleton(name) u_skeleton.name
#define SkeletonArray(name, index) u_skeleton.name[index]
#define Material(name) u_material_parameters.name
#define MaterialArray(name, index) u_material_parameters.name[index]
#define PostProcessPass(name) u_post_process_pass.name
#define PostProcessPassArray(name, index) u_post_process_pass.name[index]

#define out_FragColor out_color
//
//shader-maker
//

layout(location = 0) in vec3 position;
layout(location = 1) in vec2 texcoord;
layout(location = 0) out vec2 BaseUV;
layout(location = 1) out vec2 MaskUV;
layout(location = 2) out vec2 TexelSize;
layout(location = 3) out vec4 UVRange;
//------------
//
//shader-maker
//

//
// Material uniform parameters:
//
layout(set=2, binding=2) uniform MaterialUniformParametersUbo {
  vec4 blur_scale0; //vec4
  vec4 blur_scale1; //vec4
  vec4 scale_rate; //vec4
  vec4 mask_color; //vec3
} u_material_parameters;

//
// No material texture-samplers.
//

//
// No material buffer block bindings.
//

//------------
// parameters
layout(set=0, binding=0) uniform PostProcessPassUbo {
  mat4 projection;
  vec4 sys_camera_aspect;
  vec4 sys_camera_depth;
  vec4 sys_camera_pos;
  vec4 sys_camera_dir;
  mat4 sys_camera_viewproj;
  mat4 sys_camera_invviewproj;
  mat4 sys_camera_invproj;
  vec4 sys_camera_colorscale;
  vec4 sys_camera_invcolorscale;
  vec4 sys_light_projpos;
  vec4 sys_time;
  vec4 base_map_size;
  vec4 base_map_size2;
  vec4 base_map_size3;
  vec4 base_map_size4;
  vec4 base_map_size5;
  vec4 base_map_size6;
  vec4 base_map_size7;
  vec4 base_map_size8;
  vec4 depth_map_size;
} u_post_process_pass;
// textures
layout(set=1, binding=0) uniform sampler2D base_map;
layout(set=1, binding=1) uniform sampler2D base_map2;
layout(set=1, binding=2) uniform sampler2D base_map3;
layout(set=1, binding=3) uniform sampler2D base_map4;
layout(set=1, binding=4) uniform sampler2D base_map5;
layout(set=1, binding=5) uniform sampler2D base_map6;
layout(set=1, binding=6) uniform sampler2D base_map7;
layout(set=1, binding=7) uniform sampler2D base_map8;
layout(set=1, binding=8) uniform sampler2D depth_map;
void main() {
  vec4 tmp_position = vec4(position, 1.0);
  gl_Position = PostProcessPass(projection) * tmp_position;
  BaseUV = texcoord;

  gl_Position.xyz *= Material(scale_rate).z;

  BaseUV *= 2.0;
  BaseUV -= vec2(1.0);
  BaseUV *= Material(scale_rate).y;
  BaseUV += vec2(1.0);
  BaseUV *= 0.5;

#if DEPTH_MASK
  MaskUV = texcoord;
#endif

  ivec2 itexture_size = textureSize(base_map, 0);
  vec2 texture_size = vec2(float(itexture_size.x), float(itexture_size.y));
  vec2 texel_size = vec2(1.0) / texture_size;
  vec2 range_offset = vec2(0.5) * Material(scale_rate).y - texel_size;
  vec2 range_min = vec2(0.5) - range_offset;
  vec2 range_max = vec2(0.5) + range_offset;
  TexelSize.xy = texel_size;
  UVRange.xy = range_min;
  UVRange.zw = range_max;
}
�$  #version 450
//macros
#define Scene(name) u_scene.name
#define SceneArray(name, index) u_scene.name[index]
#define Camera(name) u_camera.name
#define CameraArray(name, index) u_camera.name[index]
#define Transform(name) u_transform.name
#define TransformArray(name, index) u_transform.name[index]
#define Geometry(name) u_geometry.name
#define GeometryArray(name) u_geometry.name[index]
#define Skeleton(name) u_skeleton.name
#define SkeletonArray(name, index) u_skeleton.name[index]
#define Material(name) u_material_parameters.name
#define MaterialArray(name, index) u_material_parameters.name[index]
#define PostProcessPass(name) u_post_process_pass.name
#define PostProcessPassArray(name, index) u_post_process_pass.name[index]

#define out_FragColor out_color
//
//shader-maker
//

layout(location = 0) in vec2 BaseUV;
layout(location = 1) in vec2 MaskUV;
layout(location = 2) in vec2 TexelSize;
layout(location = 3) in vec4 UVRange;
//------------
layout(location=0) out vec4 out_color;
//
//shader-maker
//

//
// Material uniform parameters:
//
layout(set=2, binding=2) uniform MaterialUniformParametersUbo {
  vec4 blur_scale0; //vec4
  vec4 blur_scale1; //vec4
  vec4 scale_rate; //vec4
  vec4 mask_color; //vec3
} u_material_parameters;

//
// No material texture-samplers.
//

//
// No material buffer block bindings.
//

//------------
// parameters
layout(set=0, binding=0) uniform PostProcessPassUbo {
  mat4 projection;
  vec4 sys_camera_aspect;
  vec4 sys_camera_depth;
  vec4 sys_camera_pos;
  vec4 sys_camera_dir;
  mat4 sys_camera_viewproj;
  mat4 sys_camera_invviewproj;
  mat4 sys_camera_invproj;
  vec4 sys_camera_colorscale;
  vec4 sys_camera_invcolorscale;
  vec4 sys_light_projpos;
  vec4 sys_time;
  vec4 base_map_size;
  vec4 base_map_size2;
  vec4 base_map_size3;
  vec4 base_map_size4;
  vec4 base_map_size5;
  vec4 base_map_size6;
  vec4 base_map_size7;
  vec4 base_map_size8;
  vec4 depth_map_size;
} u_post_process_pass;
// textures
layout(set=1, binding=0) uniform sampler2D base_map;
layout(set=1, binding=1) uniform sampler2D base_map2;
layout(set=1, binding=2) uniform sampler2D base_map3;
layout(set=1, binding=3) uniform sampler2D base_map4;
layout(set=1, binding=4) uniform sampler2D base_map5;
layout(set=1, binding=5) uniform sampler2D base_map6;
layout(set=1, binding=6) uniform sampler2D base_map7;
layout(set=1, binding=7) uniform sampler2D base_map8;
layout(set=1, binding=8) uniform sampler2D depth_map;
vec4 tex_mask(in const vec2 uv, in const vec2 mask_uv, in const vec2 offset, in const vec2 texel_size,
              in const float scale, in const vec2 min, in const vec2 max,
              inout float valid_count) {
#if DEPTH_MASK
  if (texture(base_map2, (mask_uv + offset * texel_size / scale)).r < 1.0) {
    valid_count -= 1.0;
    return vec4(0.0);
  }
#endif
  return texture(base_map, clamp((uv + offset * texel_size), min, max));
}

void main() {
#if DEPTH_MASK
  if (texture(base_map2, MaskUV).r < 1.0) {
    out_FragColor.xyz = Material(mask_color).xyz;
    out_FragColor.w = 0.0;
    return;
  }
#endif

#if BLUR_TYPE == 0
  float applyed_rate = 0.0;
  float valid_count = 1.0;
  out_FragColor = tex_mask(BaseUV, MaskUV, vec2(0.0, 0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) * Material(blur_scale0).x;
  applyed_rate = valid_count * Material(blur_scale0).x;
  valid_count = 4.0;
  out_FragColor += (tex_mask(BaseUV, MaskUV, vec2( 2.0,  0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-2.0,  0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 0.0,  2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 0.0, -2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * Material(blur_scale0).y;
  applyed_rate += valid_count * Material(blur_scale0).y;
  valid_count = 4.0;
  out_FragColor += (tex_mask(BaseUV, MaskUV, vec2( 4.0,  0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-4.0,  0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 0.0,  4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 0.0, -4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * Material(blur_scale0).z;
  applyed_rate += valid_count * Material(blur_scale0).z;
  valid_count = 4.0;
  out_FragColor += (tex_mask(BaseUV, MaskUV, vec2( 2.0,  2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-2.0,  2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 2.0, -2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-2.0, -2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * Material(blur_scale0).w;
  applyed_rate += valid_count * Material(blur_scale0).w;
  valid_count = 8.0;
  out_FragColor += (tex_mask(BaseUV, MaskUV, vec2( 4.0,  2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-4.0,  2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 4.0, -2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-4.0, -2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 2.0, -4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 2.0,  4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-2.0,  4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-2.0, -4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * Material(blur_scale1).x;
  applyed_rate += valid_count * Material(blur_scale1).x;
  valid_count = 4.0;
  out_FragColor += (tex_mask(BaseUV, MaskUV, vec2( 4.0,  4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-4.0,  4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 4.0, -4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-4.0, -4.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * Material(blur_scale1).y;
  applyed_rate += valid_count * Material(blur_scale1).y;
  out_FragColor /= applyed_rate;
#elif BLUR_TYPE == 1
  float valid_count = 4.0;
  out_FragColor = (tex_mask(BaseUV, MaskUV, vec2(-1.0, -1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                   tex_mask(BaseUV, MaskUV, vec2(-1.0,  1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                   tex_mask(BaseUV, MaskUV, vec2( 1.0, -1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                   tex_mask(BaseUV, MaskUV, vec2( 1.0,  1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * 0.25;
  float applyed_rate = valid_count * 0.25;
  out_FragColor /= applyed_rate;
#elif BLUR_TYPE == 2
  float applyed_rate = 0.0;
  float valid_count = 1.0;
  out_FragColor = tex_mask(BaseUV, MaskUV, vec2(0.0, 0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) * 0.13039;
  applyed_rate = valid_count * 0.13039;
  valid_count = 4.0;
  out_FragColor += (tex_mask(BaseUV, MaskUV, vec2( 2.0,  0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-2.0,  0.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 0.0,  2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 0.0, -2.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * 0.115352;
  applyed_rate += valid_count * 0.115352;
  valid_count = 4.0;
  out_FragColor += (tex_mask(BaseUV, MaskUV, vec2( 1.0,  1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-1.0,  1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2( 1.0, -1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count) +
                    tex_mask(BaseUV, MaskUV, vec2(-1.0, -1.0), TexelSize, Material(scale_rate).y, UVRange.xy, UVRange.zw, valid_count)) * 0.102049;
  applyed_rate += valid_count * 0.102049;
  out_FragColor /= applyed_rate;
#endif
  out_FragColor.w = 1.0;
}
   	   Positions�p   position   Uvs1p�   texcoord      Model��   model	   ModelView�@	   modelview
   Projection.
   projection   View��   view   BaseTextureSize�.   base_map_size   BaseTextureSize2:&5   base_map_size2   BaseTextureSize3;'5   base_map_size3   BaseTextureSize4<(5   base_map_size4   BaseTextureSize5=)5   base_map_size5   BaseTextureSize6>*5   base_map_size6   BaseTextureSize7?+5   base_map_size7   BaseTextureSize8@,5   base_map_size8   DepthTextureSize�=6   depth_map_size   sys_camera_depth��8   sys_camera_depth      blur_scale0M"   blur_scale0+O�=�c=�A=i�H=      blur_scale1N#   blur_scale1#=˽�<           
   scale_ratep
   scale_rate  �?  �?           
   mask_color+�
   mask_color��L>��L>��L>           	      BaseTexturemX   base_map   BaseTexture2��	   base_map2   BaseTexture3��	   base_map3   BaseTexture4��	   base_map4   BaseTexture5��	   base_map5   BaseTexture6��	   base_map6   BaseTexture7��	   base_map7   BaseTexture8��	   base_map8   DepthTexture��	   depth_map           	   BLUR_TYPE�	   BLUR_TYPE      
   DEPTH_MASK^
   DEPTH_MASK         depthmaskblurw�%