���     X@  �SK  !x_               default�N�
7�     @  ���  "X�                        //macros
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
//------------
//
//shader-maker
//

uniform vec4 base_color; //vec4
uniform vec4 fxaa_parameter; //vec4
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
// program
void main(){
  vec4 tmp_position = vec4(position, 1.0);
  gl_Position = PostProcessPass(projection) * tmp_position;
//  BaseUV      = texcoord + PostProcessPass(base_map_size).xy * 0.5;
  BaseUV      = texcoord;
}
�  //macros
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
//------------
//
//shader-maker
//

uniform vec4 base_color; //vec4
uniform vec4 fxaa_parameter; //vec4
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
// functions
float compute_luma(in vec3 color) {
  return color.g * (0.587 / 0.299) + color.r;
}
vec3 apply_fxaa(in sampler2D texture_map, in vec2 base_uv) {
  vec2 texel_size = PostProcessPass(base_map_size).xy;
  vec2 NW_UV = base_uv + vec2(-0.5, -0.5) * texel_size;
  vec2 NE_UV = base_uv + vec2( 0.5, -0.5) * texel_size;
  vec2 SW_UV = base_uv + vec2(-0.5,  0.5) * texel_size;
  vec2 SE_UV = base_uv + vec2( 0.5,  0.5) * texel_size;
  
  float edge_threshold_min = Material(fxaa_parameter).x;  // 1.0 / 16.0
  float edge_threshold = Material(fxaa_parameter).y;      // 0.3
  float edge_sharpness = Material(fxaa_parameter).z;      // 4.0
  vec3 m_color = textureLod(texture_map, base_uv, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  float m_luma = compute_luma(m_color);
  vec3 nw_color = textureLod(texture_map, NW_UV, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  vec3 ne_color = textureLod(texture_map, NE_UV, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  vec3 sw_color = textureLod(texture_map, SW_UV, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  vec3 se_color = textureLod(texture_map, SE_UV, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  float nw_luma = compute_luma(nw_color);
  float ne_luma = compute_luma(ne_color) + 1.0 / 384.0;
  float sw_luma = compute_luma(sw_color);
  float se_luma = compute_luma(se_color);
  float min_luma = min(m_luma, min(min(nw_luma, ne_luma), min(sw_luma, se_luma)));
  float max_luma = max(m_luma, max(max(nw_luma, ne_luma), max(sw_luma, se_luma)));
  float local_contrast = max_luma - min_luma;
  if (local_contrast < max(edge_threshold_min, max_luma * edge_threshold)) {
    return m_color;
  }
  vec2 local_luma_gradient;
  local_luma_gradient.x = -((nw_luma + ne_luma) - (sw_luma + se_luma));
  local_luma_gradient.y =  ((nw_luma + sw_luma) - (ne_luma + se_luma));
  vec2 tap_dir = normalize(local_luma_gradient);
  vec3 positive_tap_color = textureLod(texture_map, base_uv + tap_dir * 0.5 * texel_size, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  vec3 negative_tap_color = textureLod(texture_map, base_uv - tap_dir * 0.5 * texel_size, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  float dir_abs_min_times_sharpness = min(abs(tap_dir.x), abs(tap_dir.y)) * edge_sharpness;
  vec2 extra_tap_dir = clamp(tap_dir / dir_abs_min_times_sharpness, -2.0, 2.0);
  vec3 positive_extra_tap_color = textureLod(texture_map, base_uv + extra_tap_dir * 2.0 * texel_size, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  vec3 negative_extra_tap_color = textureLod(texture_map, base_uv - extra_tap_dir * 2.0 * texel_size, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  // float positive_extra_tap_luma = compute_luma(positive_extra_tap_color);
  // float negative_extra_tap_luma = compute_luma(negative_extra_tap_color);
  vec3 four_tap_filter_color = (positive_tap_color + negative_tap_color) * 0.25 + (positive_extra_tap_color + negative_extra_tap_color) * 0.25;
  float four_tap_filter_luma = compute_luma(four_tap_filter_color);
  bool use_two_taps = four_tap_filter_luma < min_luma || max_luma < four_tap_filter_luma;
  vec3 filter_color = use_two_taps ? (positive_tap_color + negative_tap_color) * 0.5 : four_tap_filter_color;
  return filter_color;
}

// program
void main() {
  out_FragColor = vec4(apply_fxaa(base_map, BaseUV), 1.0);

  out_FragColor.xyz *= PostProcessPass(sys_camera_colorscale).xyz;
  out_FragColor.w = 1.0;
}
�	  #version 450
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
//------------
//
//shader-maker
//

//
// Material uniform parameters:
//
layout(set=2, binding=2) uniform MaterialUniformParametersUbo {
  vec4 base_color; //vec4
  vec4 fxaa_parameter; //vec4
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
// program
void main(){
  vec4 tmp_position = vec4(position, 1.0);
  gl_Position = PostProcessPass(projection) * tmp_position;
//  BaseUV      = texcoord + PostProcessPass(base_map_size).xy * 0.5;
  BaseUV      = texcoord;
}
�  #version 450
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
//------------
layout(location=0) out vec4 out_color;
//
//shader-maker
//

//
// Material uniform parameters:
//
layout(set=2, binding=2) uniform MaterialUniformParametersUbo {
  vec4 base_color; //vec4
  vec4 fxaa_parameter; //vec4
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
// functions
float compute_luma(in vec3 color) {
  return color.g * (0.587 / 0.299) + color.r;
}
vec3 apply_fxaa(in sampler2D texture_map, in vec2 base_uv) {
  vec2 texel_size = PostProcessPass(base_map_size).xy;
  vec2 NW_UV = base_uv + vec2(-0.5, -0.5) * texel_size;
  vec2 NE_UV = base_uv + vec2( 0.5, -0.5) * texel_size;
  vec2 SW_UV = base_uv + vec2(-0.5,  0.5) * texel_size;
  vec2 SE_UV = base_uv + vec2( 0.5,  0.5) * texel_size;
  
  float edge_threshold_min = Material(fxaa_parameter).x;  // 1.0 / 16.0
  float edge_threshold = Material(fxaa_parameter).y;      // 0.3
  float edge_sharpness = Material(fxaa_parameter).z;      // 4.0
  vec3 m_color = textureLod(texture_map, base_uv, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  float m_luma = compute_luma(m_color);
  vec3 nw_color = textureLod(texture_map, NW_UV, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  vec3 ne_color = textureLod(texture_map, NE_UV, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  vec3 sw_color = textureLod(texture_map, SW_UV, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  vec3 se_color = textureLod(texture_map, SE_UV, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  float nw_luma = compute_luma(nw_color);
  float ne_luma = compute_luma(ne_color) + 1.0 / 384.0;
  float sw_luma = compute_luma(sw_color);
  float se_luma = compute_luma(se_color);
  float min_luma = min(m_luma, min(min(nw_luma, ne_luma), min(sw_luma, se_luma)));
  float max_luma = max(m_luma, max(max(nw_luma, ne_luma), max(sw_luma, se_luma)));
  float local_contrast = max_luma - min_luma;
  if (local_contrast < max(edge_threshold_min, max_luma * edge_threshold)) {
    return m_color;
  }
  vec2 local_luma_gradient;
  local_luma_gradient.x = -((nw_luma + ne_luma) - (sw_luma + se_luma));
  local_luma_gradient.y =  ((nw_luma + sw_luma) - (ne_luma + se_luma));
  vec2 tap_dir = normalize(local_luma_gradient);
  vec3 positive_tap_color = textureLod(texture_map, base_uv + tap_dir * 0.5 * texel_size, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  vec3 negative_tap_color = textureLod(texture_map, base_uv - tap_dir * 0.5 * texel_size, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  float dir_abs_min_times_sharpness = min(abs(tap_dir.x), abs(tap_dir.y)) * edge_sharpness;
  vec2 extra_tap_dir = clamp(tap_dir / dir_abs_min_times_sharpness, -2.0, 2.0);
  vec3 positive_extra_tap_color = textureLod(texture_map, base_uv + extra_tap_dir * 2.0 * texel_size, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  vec3 negative_extra_tap_color = textureLod(texture_map, base_uv - extra_tap_dir * 2.0 * texel_size, 0.0).rgb * PostProcessPass(sys_camera_invcolorscale).xyz;
  // float positive_extra_tap_luma = compute_luma(positive_extra_tap_color);
  // float negative_extra_tap_luma = compute_luma(negative_extra_tap_color);
  vec3 four_tap_filter_color = (positive_tap_color + negative_tap_color) * 0.25 + (positive_extra_tap_color + negative_extra_tap_color) * 0.25;
  float four_tap_filter_luma = compute_luma(four_tap_filter_color);
  bool use_two_taps = four_tap_filter_luma < min_luma || max_luma < four_tap_filter_luma;
  vec3 filter_color = use_two_taps ? (positive_tap_color + negative_tap_color) * 0.5 : four_tap_filter_color;
  return filter_color;
}

// program
void main() {
  out_FragColor = vec4(apply_fxaa(base_map, BaseUV), 1.0);

  out_FragColor.xyz *= PostProcessPass(sys_camera_colorscale).xyz;
  out_FragColor.w = 1.0;
}
   	   Positions�p   position   Uvs1p�   texcoord      Model��   model	   ModelView�@	   modelview
   Projection.
   projection   View��   view   BaseTextureSize�.   base_map_size   BaseTextureSize2:&5   base_map_size2   BaseTextureSize3;'5   base_map_size3   BaseTextureSize4<(5   base_map_size4   BaseTextureSize5=)5   base_map_size5   BaseTextureSize6>*5   base_map_size6   BaseTextureSize7?+5   base_map_size7   BaseTextureSize8@,5   base_map_size8   DepthTextureSize�=6   depth_map_size   sys_camera_colorscale�+`   sys_camera_colorscale   sys_camera_invcolorscale�	O}   sys_camera_invcolorscale
   base_color
   base_color   fxaa_parameter��*   fxaa_parameter   
   base_color
   base_color  �?  �?  �?  �?      fxaa_parameter��*   fxaa_parameter  �=���>  �@           	      BaseTexturemX   base_map   BaseTexture2��	   base_map2   BaseTexture3��	   base_map3   BaseTexture4��	   base_map4   BaseTexture5��	   base_map5   BaseTexture6��	   base_map6   BaseTexture7��	   base_map7   BaseTexture8��	   base_map8   DepthTexture��	   depth_map               fxaa�'