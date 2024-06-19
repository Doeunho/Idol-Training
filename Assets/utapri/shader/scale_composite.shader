���     [5  �SK  !x_               default�N�
7�     5  ���  "X�                      �
  //macros
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
out vec2 BaseUV0;
out vec2 BaseUV1;
out vec2 BaseUV2;
out vec2 BaseUV3;
out vec2 BaseUV4;
out vec2 BaseUV5;
out vec2 BaseUV6;
out vec2 BaseUV7;
//------------
//
//shader-maker
//

uniform vec4 weight0; //vec4
uniform vec4 weight1; //vec4
uniform vec4 scale_rate0; //vec4
uniform vec4 scale_rate1; //vec4
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
vec2 scale_uv(in vec2 uv, in float scale) {
  vec2 base_uv = uv;
  base_uv *= 2.0;
  base_uv -= vec2(1.0);
  base_uv *= scale;
  base_uv += vec2(1.0);
  base_uv *= 0.5;
  return base_uv;
}

void main() {
  vec4 tmp_position = vec4(position, 1.0);
  gl_Position = PostProcessPass(projection) * tmp_position;
  BaseUV0 = scale_uv(texcoord, Material(scale_rate0).x);
#if TEXTURE_COUNT >= 2
  BaseUV1 = scale_uv(texcoord, Material(scale_rate0).y);
#endif
#if TEXTURE_COUNT >= 3
  BaseUV2 = scale_uv(texcoord, Material(scale_rate0).z);
#endif
#if TEXTURE_COUNT >= 4
  BaseUV3 = scale_uv(texcoord, Material(scale_rate0).w);
#endif
#if TEXTURE_COUNT >= 5
  BaseUV4 = scale_uv(texcoord, Material(scale_rate1).x);
#endif
#if TEXTURE_COUNT >= 6
  BaseUV5 = scale_uv(texcoord, Material(scale_rate1).y);
#endif
#if TEXTURE_COUNT >= 7
  BaseUV6 = scale_uv(texcoord, Material(scale_rate1).z);
#endif
#if TEXTURE_COUNT >= 8
  BaseUV7 = scale_uv(texcoord, Material(scale_rate1).w);
#endif
}

  //macros
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

in vec2 BaseUV0;
in vec2 BaseUV1;
in vec2 BaseUV2;
in vec2 BaseUV3;
in vec2 BaseUV4;
in vec2 BaseUV5;
in vec2 BaseUV6;
in vec2 BaseUV7;
//------------
//
//shader-maker
//

uniform vec4 weight0; //vec4
uniform vec4 weight1; //vec4
uniform vec4 scale_rate0; //vec4
uniform vec4 scale_rate1; //vec4
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
  out_FragColor = texture(base_map, BaseUV0) * Material(weight0).x;
#if TEXTURE_COUNT >= 2
  out_FragColor += texture(base_map2, BaseUV1) * Material(weight0).y;
#endif
#if TEXTURE_COUNT >= 3
  out_FragColor += texture(base_map3, BaseUV2) * Material(weight0).z;
#endif
#if TEXTURE_COUNT >= 4
  out_FragColor += texture(base_map4, BaseUV3) * Material(weight0).w;
#endif
#if TEXTURE_COUNT >= 5
  out_FragColor += texture(base_map5, BaseUV4) * Material(weight1).x;
#endif
#if TEXTURE_COUNT >= 6
  out_FragColor += texture(base_map6, BaseUV5) * Material(weight1).y;
#endif
#if TEXTURE_COUNT >= 7
  out_FragColor += texture(base_map7, BaseUV6) * Material(weight1).z;
#endif
#if TEXTURE_COUNT >= 8
  out_FragColor += texture(base_map8, BaseUV7) * Material(weight1).w;
#endif
#if USE_ALPHA_IS_ONE
  out_FragColor.w = 1.0;
#endif
}
#  #version 450
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
layout(location = 0) out vec2 BaseUV0;
layout(location = 1) out vec2 BaseUV1;
layout(location = 2) out vec2 BaseUV2;
layout(location = 3) out vec2 BaseUV3;
layout(location = 4) out vec2 BaseUV4;
layout(location = 5) out vec2 BaseUV5;
layout(location = 6) out vec2 BaseUV6;
layout(location = 7) out vec2 BaseUV7;
//------------
//
//shader-maker
//

//
// Material uniform parameters:
//
layout(set=2, binding=2) uniform MaterialUniformParametersUbo {
  vec4 weight0; //vec4
  vec4 weight1; //vec4
  vec4 scale_rate0; //vec4
  vec4 scale_rate1; //vec4
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
vec2 scale_uv(in vec2 uv, in float scale) {
  vec2 base_uv = uv;
  base_uv *= 2.0;
  base_uv -= vec2(1.0);
  base_uv *= scale;
  base_uv += vec2(1.0);
  base_uv *= 0.5;
  return base_uv;
}

void main() {
  vec4 tmp_position = vec4(position, 1.0);
  gl_Position = PostProcessPass(projection) * tmp_position;
  BaseUV0 = scale_uv(texcoord, Material(scale_rate0).x);
#if TEXTURE_COUNT >= 2
  BaseUV1 = scale_uv(texcoord, Material(scale_rate0).y);
#endif
#if TEXTURE_COUNT >= 3
  BaseUV2 = scale_uv(texcoord, Material(scale_rate0).z);
#endif
#if TEXTURE_COUNT >= 4
  BaseUV3 = scale_uv(texcoord, Material(scale_rate0).w);
#endif
#if TEXTURE_COUNT >= 5
  BaseUV4 = scale_uv(texcoord, Material(scale_rate1).x);
#endif
#if TEXTURE_COUNT >= 6
  BaseUV5 = scale_uv(texcoord, Material(scale_rate1).y);
#endif
#if TEXTURE_COUNT >= 7
  BaseUV6 = scale_uv(texcoord, Material(scale_rate1).z);
#endif
#if TEXTURE_COUNT >= 8
  BaseUV7 = scale_uv(texcoord, Material(scale_rate1).w);
#endif
}
j  #version 450
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

layout(location = 0) in vec2 BaseUV0;
layout(location = 1) in vec2 BaseUV1;
layout(location = 2) in vec2 BaseUV2;
layout(location = 3) in vec2 BaseUV3;
layout(location = 4) in vec2 BaseUV4;
layout(location = 5) in vec2 BaseUV5;
layout(location = 6) in vec2 BaseUV6;
layout(location = 7) in vec2 BaseUV7;
//------------
layout(location=0) out vec4 out_color;
//
//shader-maker
//

//
// Material uniform parameters:
//
layout(set=2, binding=2) uniform MaterialUniformParametersUbo {
  vec4 weight0; //vec4
  vec4 weight1; //vec4
  vec4 scale_rate0; //vec4
  vec4 scale_rate1; //vec4
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
  out_FragColor = texture(base_map, BaseUV0) * Material(weight0).x;
#if TEXTURE_COUNT >= 2
  out_FragColor += texture(base_map2, BaseUV1) * Material(weight0).y;
#endif
#if TEXTURE_COUNT >= 3
  out_FragColor += texture(base_map3, BaseUV2) * Material(weight0).z;
#endif
#if TEXTURE_COUNT >= 4
  out_FragColor += texture(base_map4, BaseUV3) * Material(weight0).w;
#endif
#if TEXTURE_COUNT >= 5
  out_FragColor += texture(base_map5, BaseUV4) * Material(weight1).x;
#endif
#if TEXTURE_COUNT >= 6
  out_FragColor += texture(base_map6, BaseUV5) * Material(weight1).y;
#endif
#if TEXTURE_COUNT >= 7
  out_FragColor += texture(base_map7, BaseUV6) * Material(weight1).z;
#endif
#if TEXTURE_COUNT >= 8
  out_FragColor += texture(base_map8, BaseUV7) * Material(weight1).w;
#endif
#if USE_ALPHA_IS_ONE
  out_FragColor.w = 1.0;
#endif
}
   	   Positions�p   position   Uvs1p�   texcoord      Model��   model	   ModelView�@	   modelview
   Projection.
   projection   View��   view   BaseTextureSize�.   base_map_size   BaseTextureSize2:&5   base_map_size2   BaseTextureSize3;'5   base_map_size3   BaseTextureSize4<(5   base_map_size4   BaseTextureSize5=)5   base_map_size5   BaseTextureSize6>*5   base_map_size6   BaseTextureSize7?+5   base_map_size7   BaseTextureSize8@,5   base_map_size8   DepthTextureSize�=6   depth_map_size      weight0��   weight0  �?  �?  �?  �?      weight1��   weight1  �?  �?  �?  �?      scale_rate0D�   scale_rate0  �?  �?  �?  �?      scale_rate1E�   scale_rate1  �?  �?  �?  �?       	      BaseTexturemX   base_map   BaseTexture2��	   base_map2   BaseTexture3��	   base_map3   BaseTexture4��	   base_map4   BaseTexture5��	   base_map5   BaseTexture6��	   base_map6   BaseTexture7��	   base_map7   BaseTexture8��	   base_map8   DepthTexture��	   depth_map              TEXTURE_COUNT�   TEXTURE_COUNT         USE_ALPHA_IS_ONE�*   USE_ALPHA_IS_ONE         scale_composite;M1