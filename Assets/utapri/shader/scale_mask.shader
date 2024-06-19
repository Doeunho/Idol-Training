���     �i  �SK  !x_               default�N�
7�     [i  ���  "X�                      6	  //macros
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

uniform vec4 scale_rate; //vec4
uniform vec4 alpha_threshold; //float
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

  BaseUV.xy *= 2.0;
  BaseUV.xy -= vec2(1.0);
  BaseUV.xy *= Material(scale_rate).x;
  BaseUV.xy += vec2(1.0);
  BaseUV.xy *= 0.5;

  MaskUV = texcoord;

  ivec2 itexture_size = textureSize(base_map, 0);
  vec2 texture_size = vec2(float(itexture_size.x), float(itexture_size.y));
  vec2 texel_size = vec2(1.0) / texture_size;
  vec2 range_offset = vec2(0.5) * Material(scale_rate).x - texel_size;
  vec2 range_min = vec2(0.5) - range_offset;
  vec2 range_max = vec2(0.5) + range_offset;
  TexelSize.xy = texel_size;
  UVRange.xy = range_min;
  UVRange.zw = range_max;
}
G&  //macros
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

uniform vec4 scale_rate; //vec4
uniform vec4 alpha_threshold; //float
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
#if FILTER_TYPE == 1
vec4 bilinear(const in vec2 uv, const in vec2 texel_size, const in float scale,
              const in vec2 min, const in vec2 max) {
  vec2 uv_texel = uv / texel_size;
  vec2 uv_floor = floor(uv_texel);
  vec2 uv_frac = uv_texel - uv_floor;

  vec4 color00 = texture(base_map, clamp((uv_floor + vec2(0.0, 0.0) * scale) * texel_size, min, max));
  vec4 color10 = texture(base_map, clamp((uv_floor + vec2(1.0, 0.0) * scale) * texel_size, min, max));
  vec4 color01 = texture(base_map, clamp((uv_floor + vec2(0.0, 1.0) * scale) * texel_size, min, max));
  vec4 color11 = texture(base_map, clamp((uv_floor + vec2(1.0, 1.0) * scale) * texel_size, min, max));

  return mix(mix(color00, color10, uv_frac.x), mix(color01, color11, uv_frac.x), uv_frac.y);
}

#elif FILTER_TYPE == 2

vec4 mask_bilinear(const in vec2 uv, const in vec2 mask_uv, const in vec2 texel_size, const in float scale,
                   const in vec2 min, const in vec2 max) {
  vec2 uv_texel = uv / texel_size;
  vec2 uv_floor = floor(uv_texel);
  vec2 uv_frac = uv_texel - uv_floor;
  vec2 mask_uv_floor = floor(mask_uv / texel_size);

  vec4 color00 = texture(base_map, clamp((uv_floor + vec2(0.0, 0.0) * scale) * texel_size, min, max));
  vec4 color10 = texture(base_map, clamp((uv_floor + vec2(1.0, 0.0) * scale) * texel_size, min, max));
  vec4 color01 = texture(base_map, clamp((uv_floor + vec2(0.0, 1.0) * scale) * texel_size, min, max));
  vec4 color11 = texture(base_map, clamp((uv_floor + vec2(1.0, 1.0) * scale) * texel_size, min, max));

  vec4 out_color = vec4(0.0);
  float applyed_weight = 0.0;
  if (texture(base_map2, (mask_uv_floor + vec2(0.0, 0.0)) * texel_size).r >= 1.0) {
    out_color += (1.0 - uv_frac.x) * (1.0 - uv_frac.y) * color00;
    applyed_weight += (1.0 - uv_frac.x) * (1.0 - uv_frac.y);
  }
  if (texture(base_map2, (mask_uv_floor + vec2(1.0, 0.0)) * texel_size).r >= 1.0) {
    out_color += (uv_frac.x) * (1.0 - uv_frac.y) * color10;
    applyed_weight += (uv_frac.x) * (1.0 - uv_frac.y);
  }
  if (texture(base_map2, (mask_uv_floor + vec2(0.0, 1.0)) * texel_size).r >= 1.0) {
    out_color += (1.0 - uv_frac.x) * (uv_frac.y) * color01;
    applyed_weight += (1.0 - uv_frac.x) * (uv_frac.y);
  }
  if (texture(base_map2, (mask_uv_floor + vec2(1.0, 1.0)) * texel_size).r >= 1.0) {
    out_color += (uv_frac.x) * (uv_frac.y) * color11;
    applyed_weight += (uv_frac.x) * (uv_frac.y);
  }
  out_color /= applyed_weight;

  return out_color;
}

#elif FILTER_TYPE == 3

vec4 alpha_mask_bilinear(const in vec2 uv, const in vec2 texel_size, const in float scale,
                         const in vec2 min, const in vec2 max, const in float alpha_threshold) {
  vec2 uv_texel = uv / texel_size;
  vec2 uv_floor = floor(uv_texel);
  vec2 uv_frac = uv_texel - uv_floor;

  vec4 color00 = texture(base_map, clamp((uv_floor + vec2(0.0, 0.0) * scale) * texel_size, min, max));
  vec4 color10 = texture(base_map, clamp((uv_floor + vec2(1.0, 0.0) * scale) * texel_size, min, max));
  vec4 color01 = texture(base_map, clamp((uv_floor + vec2(0.0, 1.0) * scale) * texel_size, min, max));
  vec4 color11 = texture(base_map, clamp((uv_floor + vec2(1.0, 1.0) * scale) * texel_size, min, max));

  vec4 out_color = vec4(0.0);
  float applyed_weight = 0.0;
  if (color00.w >= alpha_threshold) {
    out_color += (1.0 - uv_frac.x) * (1.0 - uv_frac.y) * color00 * color00.w;
    applyed_weight += (1.0 - uv_frac.x) * (1.0 - uv_frac.y) * color00.w;
  }
  if (color10.w >= alpha_threshold) {
    out_color += (uv_frac.x) * (1.0 - uv_frac.y) * color10 * color10.w;
    applyed_weight += (uv_frac.x) * (1.0 - uv_frac.y) * color10.w;
  }
  if (color01.w >= alpha_threshold) {
    out_color += (1.0 - uv_frac.x) * (uv_frac.y) * color01 * color01.w;
    applyed_weight += (1.0 - uv_frac.x) * (uv_frac.y) * color01.w;
  }
  if (color11.w >= alpha_threshold) {
    out_color += (uv_frac.x) * (uv_frac.y) * color11 * color11.w;
    applyed_weight += (uv_frac.x) * (uv_frac.y) * color11.w;
  }
  out_color /= applyed_weight;

  return out_color;
}

#elif FILTER_TYPE == 4

const float variance = 0.5;

void func(inout vec4 csum, inout vec4 wsum,
          const in vec4 base_color, const in vec4 offset_color,
          const in float weight, const in float alpha_threshold) {
  vec4 d = offset_color - base_color;
  vec4 e = exp(-0.5 * d * d / variance) * weight;
  if (offset_color.w > alpha_threshold) {
    e *= offset_color.w;
    csum += offset_color * e;
    wsum += e;
  }
}

vec4 tex_clamp(const in vec2 uv, const in vec2 offset, const in vec2 scale, const in vec2 min, const in vec2 max) {
  return texture(base_map, clamp(uv + offset * scale, min, max));
}

vec4 mask_bilateral(const in vec2 uv, const in vec2 scale, const in vec2 min, const in vec2 max,
                    const in float alpha_threshold) {
  vec4 csum = texture(base_map, uv);
  vec4 wsum = vec4(1.0);
  vec4 base = csum;

  func(csum, wsum, base, tex_clamp(uv, vec2(-2.0, -2.0), scale, min, max), 0.018315639, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2(-1.0, -2.0), scale, min, max), 0.082084999, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 0.0, -2.0), scale, min, max), 0.135335283, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 1.0, -2.0), scale, min, max), 0.082084999, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 2.0, -2.0), scale, min, max), 0.018315639, alpha_threshold);

  func(csum, wsum, base, tex_clamp(uv, vec2(-2.0, -1.0), scale, min, max), 0.082084999, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2(-1.0, -1.0), scale, min, max), 0.367879441, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 0.0, -1.0), scale, min, max), 0.60653066,  alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 1.0, -1.0), scale, min, max), 0.367879441, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 2.0, -1.0), scale, min, max), 0.082084999, alpha_threshold);

  func(csum, wsum, base, tex_clamp(uv, vec2(-2.0,  0.0), scale, min, max), 0.135335283, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2(-1.0,  0.0), scale, min, max), 0.60653066,  alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 1.0,  0.0), scale, min, max), 0.60653066,  alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 2.0,  0.0), scale, min, max), 0.135335283, alpha_threshold);

  func(csum, wsum, base, tex_clamp(uv, vec2(-2.0,  1.0), scale, min, max), 0.082084999, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2(-1.0,  1.0), scale, min, max), 0.367879441, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 0.0,  1.0), scale, min, max), 0.60653066,  alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 1.0,  1.0), scale, min, max), 0.367879441, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 2.0,  1.0), scale, min, max), 0.082084999, alpha_threshold);

  func(csum, wsum, base, tex_clamp(uv, vec2(-2.0,  2.0), scale, min, max), 0.018315639, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2(-1.0,  2.0), scale, min, max), 0.082084999, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 0.0,  2.0), scale, min, max), 0.135335283, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 1.0,  2.0), scale, min, max), 0.082084999, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 2.0,  2.0), scale, min, max), 0.018315639, alpha_threshold);

  return csum / wsum;
}

#endif

void main() {
#if FILTER_TYPE == 0
  vec2 base_uv = clamp(BaseUV, UVRange.xy, UVRange.zw);
  out_FragColor.xyz = texture(base_map, base_uv).xyz;
#elif FILTER_TYPE == 1
  out_FragColor = bilinear(BaseUV, TexelSize, Material(scale_rate).x, UVRange.xy, UVRange.zw);
#elif FILTER_TYPE == 2
  out_FragColor = mask_bilinear(BaseUV, MaskUV, TexelSize, Material(scale_rate).x, UVRange.xy, UVRange.zw);
#elif FILTER_TYPE == 3
  out_FragColor = alpha_mask_bilinear(BaseUV, TexelSize, Material(scale_rate).x, UVRange.xy, UVRange.zw, Material(alpha_threshold).x);
#elif FILTER_TYPE == 4
  out_FragColor = mask_bilateral(BaseUV, TexelSize, UVRange.xy, UVRange.zw, Material(alpha_threshold).x);
#endif

  out_FragColor.w = 1.0;
}
S  #version 450
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
  vec4 scale_rate; //vec4
  vec4 alpha_threshold; //float
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

  BaseUV.xy *= 2.0;
  BaseUV.xy -= vec2(1.0);
  BaseUV.xy *= Material(scale_rate).x;
  BaseUV.xy += vec2(1.0);
  BaseUV.xy *= 0.5;

  MaskUV = texcoord;

  ivec2 itexture_size = textureSize(base_map, 0);
  vec2 texture_size = vec2(float(itexture_size.x), float(itexture_size.y));
  vec2 texel_size = vec2(1.0) / texture_size;
  vec2 range_offset = vec2(0.5) * Material(scale_rate).x - texel_size;
  vec2 range_min = vec2(0.5) - range_offset;
  vec2 range_max = vec2(0.5) + range_offset;
  TexelSize.xy = texel_size;
  UVRange.xy = range_min;
  UVRange.zw = range_max;
}
a)  #version 450
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
  vec4 scale_rate; //vec4
  vec4 alpha_threshold; //float
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
#if FILTER_TYPE == 1
vec4 bilinear(const in vec2 uv, const in vec2 texel_size, const in float scale,
              const in vec2 min, const in vec2 max) {
  vec2 uv_texel = uv / texel_size;
  vec2 uv_floor = floor(uv_texel);
  vec2 uv_frac = uv_texel - uv_floor;

  vec4 color00 = texture(base_map, clamp((uv_floor + vec2(0.0, 0.0) * scale) * texel_size, min, max));
  vec4 color10 = texture(base_map, clamp((uv_floor + vec2(1.0, 0.0) * scale) * texel_size, min, max));
  vec4 color01 = texture(base_map, clamp((uv_floor + vec2(0.0, 1.0) * scale) * texel_size, min, max));
  vec4 color11 = texture(base_map, clamp((uv_floor + vec2(1.0, 1.0) * scale) * texel_size, min, max));

  return mix(mix(color00, color10, uv_frac.x), mix(color01, color11, uv_frac.x), uv_frac.y);
}

#elif FILTER_TYPE == 2

vec4 mask_bilinear(const in vec2 uv, const in vec2 mask_uv, const in vec2 texel_size, const in float scale,
                   const in vec2 min, const in vec2 max) {
  vec2 uv_texel = uv / texel_size;
  vec2 uv_floor = floor(uv_texel);
  vec2 uv_frac = uv_texel - uv_floor;
  vec2 mask_uv_floor = floor(mask_uv / texel_size);

  vec4 color00 = texture(base_map, clamp((uv_floor + vec2(0.0, 0.0) * scale) * texel_size, min, max));
  vec4 color10 = texture(base_map, clamp((uv_floor + vec2(1.0, 0.0) * scale) * texel_size, min, max));
  vec4 color01 = texture(base_map, clamp((uv_floor + vec2(0.0, 1.0) * scale) * texel_size, min, max));
  vec4 color11 = texture(base_map, clamp((uv_floor + vec2(1.0, 1.0) * scale) * texel_size, min, max));

  vec4 out_color = vec4(0.0);
  float applyed_weight = 0.0;
  if (texture(base_map2, (mask_uv_floor + vec2(0.0, 0.0)) * texel_size).r >= 1.0) {
    out_color += (1.0 - uv_frac.x) * (1.0 - uv_frac.y) * color00;
    applyed_weight += (1.0 - uv_frac.x) * (1.0 - uv_frac.y);
  }
  if (texture(base_map2, (mask_uv_floor + vec2(1.0, 0.0)) * texel_size).r >= 1.0) {
    out_color += (uv_frac.x) * (1.0 - uv_frac.y) * color10;
    applyed_weight += (uv_frac.x) * (1.0 - uv_frac.y);
  }
  if (texture(base_map2, (mask_uv_floor + vec2(0.0, 1.0)) * texel_size).r >= 1.0) {
    out_color += (1.0 - uv_frac.x) * (uv_frac.y) * color01;
    applyed_weight += (1.0 - uv_frac.x) * (uv_frac.y);
  }
  if (texture(base_map2, (mask_uv_floor + vec2(1.0, 1.0)) * texel_size).r >= 1.0) {
    out_color += (uv_frac.x) * (uv_frac.y) * color11;
    applyed_weight += (uv_frac.x) * (uv_frac.y);
  }
  out_color /= applyed_weight;

  return out_color;
}

#elif FILTER_TYPE == 3

vec4 alpha_mask_bilinear(const in vec2 uv, const in vec2 texel_size, const in float scale,
                         const in vec2 min, const in vec2 max, const in float alpha_threshold) {
  vec2 uv_texel = uv / texel_size;
  vec2 uv_floor = floor(uv_texel);
  vec2 uv_frac = uv_texel - uv_floor;

  vec4 color00 = texture(base_map, clamp((uv_floor + vec2(0.0, 0.0) * scale) * texel_size, min, max));
  vec4 color10 = texture(base_map, clamp((uv_floor + vec2(1.0, 0.0) * scale) * texel_size, min, max));
  vec4 color01 = texture(base_map, clamp((uv_floor + vec2(0.0, 1.0) * scale) * texel_size, min, max));
  vec4 color11 = texture(base_map, clamp((uv_floor + vec2(1.0, 1.0) * scale) * texel_size, min, max));

  vec4 out_color = vec4(0.0);
  float applyed_weight = 0.0;
  if (color00.w >= alpha_threshold) {
    out_color += (1.0 - uv_frac.x) * (1.0 - uv_frac.y) * color00 * color00.w;
    applyed_weight += (1.0 - uv_frac.x) * (1.0 - uv_frac.y) * color00.w;
  }
  if (color10.w >= alpha_threshold) {
    out_color += (uv_frac.x) * (1.0 - uv_frac.y) * color10 * color10.w;
    applyed_weight += (uv_frac.x) * (1.0 - uv_frac.y) * color10.w;
  }
  if (color01.w >= alpha_threshold) {
    out_color += (1.0 - uv_frac.x) * (uv_frac.y) * color01 * color01.w;
    applyed_weight += (1.0 - uv_frac.x) * (uv_frac.y) * color01.w;
  }
  if (color11.w >= alpha_threshold) {
    out_color += (uv_frac.x) * (uv_frac.y) * color11 * color11.w;
    applyed_weight += (uv_frac.x) * (uv_frac.y) * color11.w;
  }
  out_color /= applyed_weight;

  return out_color;
}

#elif FILTER_TYPE == 4

const float variance = 0.5;

void func(inout vec4 csum, inout vec4 wsum,
          const in vec4 base_color, const in vec4 offset_color,
          const in float weight, const in float alpha_threshold) {
  vec4 d = offset_color - base_color;
  vec4 e = exp(-0.5 * d * d / variance) * weight;
  if (offset_color.w > alpha_threshold) {
    e *= offset_color.w;
    csum += offset_color * e;
    wsum += e;
  }
}

vec4 tex_clamp(const in vec2 uv, const in vec2 offset, const in vec2 scale, const in vec2 min, const in vec2 max) {
  return texture(base_map, clamp(uv + offset * scale, min, max));
}

vec4 mask_bilateral(const in vec2 uv, const in vec2 scale, const in vec2 min, const in vec2 max,
                    const in float alpha_threshold) {
  vec4 csum = texture(base_map, uv);
  vec4 wsum = vec4(1.0);
  vec4 base = csum;

  func(csum, wsum, base, tex_clamp(uv, vec2(-2.0, -2.0), scale, min, max), 0.018315639, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2(-1.0, -2.0), scale, min, max), 0.082084999, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 0.0, -2.0), scale, min, max), 0.135335283, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 1.0, -2.0), scale, min, max), 0.082084999, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 2.0, -2.0), scale, min, max), 0.018315639, alpha_threshold);

  func(csum, wsum, base, tex_clamp(uv, vec2(-2.0, -1.0), scale, min, max), 0.082084999, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2(-1.0, -1.0), scale, min, max), 0.367879441, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 0.0, -1.0), scale, min, max), 0.60653066,  alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 1.0, -1.0), scale, min, max), 0.367879441, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 2.0, -1.0), scale, min, max), 0.082084999, alpha_threshold);

  func(csum, wsum, base, tex_clamp(uv, vec2(-2.0,  0.0), scale, min, max), 0.135335283, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2(-1.0,  0.0), scale, min, max), 0.60653066,  alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 1.0,  0.0), scale, min, max), 0.60653066,  alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 2.0,  0.0), scale, min, max), 0.135335283, alpha_threshold);

  func(csum, wsum, base, tex_clamp(uv, vec2(-2.0,  1.0), scale, min, max), 0.082084999, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2(-1.0,  1.0), scale, min, max), 0.367879441, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 0.0,  1.0), scale, min, max), 0.60653066,  alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 1.0,  1.0), scale, min, max), 0.367879441, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 2.0,  1.0), scale, min, max), 0.082084999, alpha_threshold);

  func(csum, wsum, base, tex_clamp(uv, vec2(-2.0,  2.0), scale, min, max), 0.018315639, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2(-1.0,  2.0), scale, min, max), 0.082084999, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 0.0,  2.0), scale, min, max), 0.135335283, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 1.0,  2.0), scale, min, max), 0.082084999, alpha_threshold);
  func(csum, wsum, base, tex_clamp(uv, vec2( 2.0,  2.0), scale, min, max), 0.018315639, alpha_threshold);

  return csum / wsum;
}

#endif

void main() {
#if FILTER_TYPE == 0
  vec2 base_uv = clamp(BaseUV, UVRange.xy, UVRange.zw);
  out_FragColor.xyz = texture(base_map, base_uv).xyz;
#elif FILTER_TYPE == 1
  out_FragColor = bilinear(BaseUV, TexelSize, Material(scale_rate).x, UVRange.xy, UVRange.zw);
#elif FILTER_TYPE == 2
  out_FragColor = mask_bilinear(BaseUV, MaskUV, TexelSize, Material(scale_rate).x, UVRange.xy, UVRange.zw);
#elif FILTER_TYPE == 3
  out_FragColor = alpha_mask_bilinear(BaseUV, TexelSize, Material(scale_rate).x, UVRange.xy, UVRange.zw, Material(alpha_threshold).x);
#elif FILTER_TYPE == 4
  out_FragColor = mask_bilateral(BaseUV, TexelSize, UVRange.xy, UVRange.zw, Material(alpha_threshold).x);
#endif

  out_FragColor.w = 1.0;
}
   	   Positions�p   position   Uvs1p�   texcoord      Model��   model	   ModelView�@	   modelview
   Projection.
   projection   View��   view   BaseTextureSize�.   base_map_size   BaseTextureSize2:&5   base_map_size2   BaseTextureSize3;'5   base_map_size3   BaseTextureSize4<(5   base_map_size4   BaseTextureSize5=)5   base_map_size5   BaseTextureSize6>*5   base_map_size6   BaseTextureSize7?+5   base_map_size7   BaseTextureSize8@,5   base_map_size8   DepthTextureSize�=6   depth_map_size   
   scale_ratep
   scale_rate  �?                  alpha_threshold3O1   alpha_threshold��L?                   	      BaseTexturemX   base_map   BaseTexture2��	   base_map2   BaseTexture3��	   base_map3   BaseTexture4��	   base_map4   BaseTexture5��	   base_map5   BaseTexture6��	   base_map6   BaseTexture7��	   base_map7   BaseTexture8��	   base_map8   DepthTexture��	   depth_map              FILTER_TYPEh   FILTER_TYPE      
   scale_mask`