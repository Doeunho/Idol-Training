���     f7  �SK  !x_               default�N�
7�     7  ���  "X�                      6  //macros
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
in int quadindex;
out vec2 BaseUV;
out vec4 Color;
out float TextureIndex;
//------------
//
//shader-maker
//

uniform vec4 flare_color; //vec4
uniform vec4 depth_threshold; //vec4
uniform vec4 depth_sample_interval; //vec4
uniform vec4 effect_parameters[8];
uniform vec4 effect_uvrects[8];
uniform vec4 effect_transforms[8];
uniform vec4 effect_colors[8];
uniform sampler2D overlay_map1;
uniform sampler2D overlay_map2;
uniform sampler2D overlay_map3;
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
void main(){
  Color = MaterialArray(effect_colors, quadindex);
  vec4 current_transform = MaterialArray(effect_transforms, quadindex);
  vec4 current_parameter = MaterialArray(effect_parameters, quadindex);
  TextureIndex = current_parameter.x;
  vec4 tmp_position = vec4(position, 1.0);
  tmp_position.xy = (tmp_position.xy * vec2(2.0, -2.0) - vec2(1.0, -1.0)) * current_transform.zw;
  float s = sin(current_parameter.y);
  float c = cos(current_parameter.y);
  mat2 rotation = mat2(c, s, -s, c);
  tmp_position.xy = rotation * tmp_position.xy;
  tmp_position.x *= PostProcessPass(sys_camera_aspect).y;
  tmp_position.x += current_transform.x;
  tmp_position.y -= current_transform.y;
  tmp_position.xy = tmp_position.xy * 0.5 + 0.5;
  gl_Position = PostProcessPass(projection) * tmp_position;

  vec4 current_uvrect = MaterialArray(effect_uvrects, quadindex);
  BaseUV = texcoord;
  BaseUV = current_uvrect.xy + current_uvrect.zw * BaseUV;
}
�  //macros
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
in vec4 Color;
in float TextureIndex;
//------------
//
//shader-maker
//

uniform vec4 flare_color; //vec4
uniform vec4 depth_threshold; //vec4
uniform vec4 depth_sample_interval; //vec4
uniform vec4 effect_parameters[8];
uniform vec4 effect_uvrects[8];
uniform vec4 effect_transforms[8];
uniform vec4 effect_colors[8];
uniform sampler2D overlay_map1;
uniform sampler2D overlay_map2;
uniform sampler2D overlay_map3;
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
vec4 getColor() {
#if TEXTURE_COUNT >= 3
  if (TextureIndex >= 3.0) {
    return textureLod(overlay_map3, BaseUV, 0.0);
  }
#endif
#if TEXTURE_COUNT >= 2
  if (TextureIndex >= 2.0) {
    return textureLod(overlay_map2, BaseUV, 0.0);
  }
#endif
  return textureLod(overlay_map1, BaseUV, 0.0);
}

void main() {
  out_FragColor = getColor() * Color;
}
}  #version 450
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
layout(location = 2) in int quadindex;
layout(location = 0) out vec2 BaseUV;
layout(location = 1) out vec4 Color;
layout(location = 2) out float TextureIndex;
//------------
//
//shader-maker
//

//
// Material uniform parameters:
//
layout(set=2, binding=2) uniform MaterialUniformParametersUbo {
  vec4 flare_color; //vec4
  vec4 depth_threshold; //vec4
  vec4 depth_sample_interval; //vec4
  vec4 effect_parameters[8];
  vec4 effect_uvrects[8];
  vec4 effect_transforms[8];
  vec4 effect_colors[8];
} u_material_parameters;

//
// Material texture-samplers:
//
layout(set=2, binding=3) uniform sampler2D overlay_map1;
layout(set=2, binding=4) uniform sampler2D overlay_map2;
layout(set=2, binding=5) uniform sampler2D overlay_map3;

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
void main(){
  Color = MaterialArray(effect_colors, quadindex);
  vec4 current_transform = MaterialArray(effect_transforms, quadindex);
  vec4 current_parameter = MaterialArray(effect_parameters, quadindex);
  TextureIndex = current_parameter.x;
  vec4 tmp_position = vec4(position, 1.0);
  tmp_position.xy = (tmp_position.xy * vec2(2.0, -2.0) - vec2(1.0, -1.0)) * current_transform.zw;
  float s = sin(current_parameter.y);
  float c = cos(current_parameter.y);
  mat2 rotation = mat2(c, s, -s, c);
  tmp_position.xy = rotation * tmp_position.xy;
  tmp_position.x *= PostProcessPass(sys_camera_aspect).y;
  tmp_position.x += current_transform.x;
  tmp_position.y -= current_transform.y;
  tmp_position.xy = tmp_position.xy * 0.5 + 0.5;
  gl_Position = PostProcessPass(projection) * tmp_position;

  vec4 current_uvrect = MaterialArray(effect_uvrects, quadindex);
  BaseUV = texcoord;
  BaseUV = current_uvrect.xy + current_uvrect.zw * BaseUV;
}
�  #version 450
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
layout(location = 1) in vec4 Color;
layout(location = 2) in float TextureIndex;
//------------
layout(location=0) out vec4 out_color;
//
//shader-maker
//

//
// Material uniform parameters:
//
layout(set=2, binding=2) uniform MaterialUniformParametersUbo {
  vec4 flare_color; //vec4
  vec4 depth_threshold; //vec4
  vec4 depth_sample_interval; //vec4
  vec4 effect_parameters[8];
  vec4 effect_uvrects[8];
  vec4 effect_transforms[8];
  vec4 effect_colors[8];
} u_material_parameters;

//
// Material texture-samplers:
//
layout(set=2, binding=3) uniform sampler2D overlay_map1;
layout(set=2, binding=4) uniform sampler2D overlay_map2;
layout(set=2, binding=5) uniform sampler2D overlay_map3;

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
vec4 getColor() {
#if TEXTURE_COUNT >= 3
  if (TextureIndex >= 3.0) {
    return textureLod(overlay_map3, BaseUV, 0.0);
  }
#endif
#if TEXTURE_COUNT >= 2
  if (TextureIndex >= 2.0) {
    return textureLod(overlay_map2, BaseUV, 0.0);
  }
#endif
  return textureLod(overlay_map1, BaseUV, 0.0);
}

void main() {
  out_FragColor = getColor() * Color;
}
   	   Positions�p   position   Uvs1p�   texcoord   QuadIndicesK2	   quadindex      Model��   model	   ModelView�@	   modelview
   Projection.
   projection   View��   view   BaseTextureSize�.   base_map_size   BaseTextureSize2:&5   base_map_size2   BaseTextureSize3;'5   base_map_size3   BaseTextureSize4<(5   base_map_size4   BaseTextureSize5=)5   base_map_size5   BaseTextureSize6>*5   base_map_size6   BaseTextureSize7?+5   base_map_size7   BaseTextureSize8@,5   base_map_size8   DepthTextureSize�=6   depth_map_size   sys_camera_aspect�?   sys_camera_aspect   sys_light_projposCTA   sys_light_projpos   sys_camera_colorscale�+`   sys_camera_colorscale   sys_camera_viewproj��O   sys_camera_viewproj   sys_camera_depth��8   sys_camera_depth      flare_color��   flare_color  �?  �?  �?  �?      depth_thresholdB�1   depth_threshold  HC                  depth_sample_interval��_   depth_sample_interval  �A                     effect_parameters>   effect_parameters     �?              �?              �?              �?              �?              �?              �?              �?               effect_uvrects�+   effect_uvrects             �?  �?          �?  �?          �?  �?          �?  �?          �?  �?          �?  �?          �?  �?          �?  �?   effect_transforms�>   effect_transforms             �?  �?   ?  �>���>���>          �?  �?          �?  �?          �?  �?          �?  �?          �?  �?          �?  �?   effect_colors_�$   effect_colors     �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?      BaseTexturemX   base_map   BaseTexture2��	   base_map2   BaseTexture3��	   base_map3   BaseTexture4��	   base_map4   BaseTexture5��	   base_map5   BaseTexture6��	   base_map6   BaseTexture7��	   base_map7   BaseTexture8��	   base_map8   DepthTexture��	   depth_map   OverlayTexture1�0   overlay_map1   OverlayTexture2�0   overlay_map2   OverlayTexture3�0   overlay_map3              TEXTURE_COUNT�   TEXTURE_COUNT         EFFECT_COUNT��   EFFECT_COUNT         overlay_effect�,