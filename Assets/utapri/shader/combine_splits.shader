���     uP  �SK  !x_               default�N�
7�     &P  ���  "X�                      �  //macros
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

uniform vec4 splits_param; //vec4
uniform vec4 color; //vec4
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
}
m  //macros
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

uniform vec4 splits_param; //vec4
uniform vec4 color; //vec4
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
  vec2 offset = BaseUV;
#if SPLITS_MODE == 0  // horizontal splits
  if (offset.x <= Material(splits_param).x) {
    offset.x *= Material(splits_param).y;
    out_FragColor = textureLod(base_map, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x -= Material(splits_param).x;
  if (offset.x <= Material(splits_param).x) {
    offset.x *= Material(splits_param).y;
    out_FragColor = textureLod(base_map2, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x -= Material(splits_param).x;
  if (offset.x <= Material(splits_param).x) {
    offset.x *= Material(splits_param).y;
    out_FragColor = textureLod(base_map3, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x -= Material(splits_param).x;
  if (offset.x <= Material(splits_param).x) {
    offset.x *= Material(splits_param).y;
    out_FragColor = textureLod(base_map4, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x -= Material(splits_param).x;
  if (offset.x <= Material(splits_param).x) {
    offset.x *= Material(splits_param).y;
    out_FragColor = textureLod(base_map5, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x -= Material(splits_param).x;
  if (offset.x <= Material(splits_param).x) {
    offset.x *= Material(splits_param).y;
    out_FragColor = textureLod(base_map6, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x -= Material(splits_param).x;
  if (offset.x <= Material(splits_param).x) {
    offset.x *= Material(splits_param).y;
    out_FragColor = textureLod(base_map7, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x -= Material(splits_param).x;
  offset.x = min(offset.x * Material(splits_param).y, 1.0);
  out_FragColor = textureLod(base_map8, offset, 0.0);
  out_FragColor.rgb *= Material(color).rgb;
  out_FragColor.rgb *= Material(color).a;
#elif SPLITS_MODE == 1  // vertical splits
  float border = 1.0 - Material(splits_param).x;
  if (offset.y >= border) {
    offset.y = (offset.y - border) * Material(splits_param).y;
    out_FragColor = textureLod(base_map, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  border -= Material(splits_param).x;
  if (offset.y >= border) {
    offset.y = (offset.y - border) * Material(splits_param).y;
    out_FragColor = textureLod(base_map2, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  border -= Material(splits_param).x;
  if (offset.y >= border) {
    offset.y = (offset.y - border) * Material(splits_param).y;
    out_FragColor = textureLod(base_map3, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  border -= Material(splits_param).x;
  if (offset.y >= border) {
    offset.y = (offset.y - border) * Material(splits_param).y;
    out_FragColor = textureLod(base_map4, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  border -= Material(splits_param).x;
  if (offset.y >= border) {
    offset.y = (offset.y - border) * Material(splits_param).y;
    out_FragColor = textureLod(base_map5, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  border -= Material(splits_param).x;
  if (offset.y >= border) {
    offset.y = (offset.y - border) * Material(splits_param).y;
    out_FragColor = textureLod(base_map6, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  border -= Material(splits_param).x;
  if (offset.y >= border) {
    offset.y = (offset.y - border) * Material(splits_param).y;
    out_FragColor = textureLod(base_map7, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  border -= Material(splits_param).x;
  offset.y = max((offset.y - border) * Material(splits_param).y, 0.0);
  out_FragColor = textureLod(base_map8, offset, 0.0);
  out_FragColor.rgb *= Material(color).rgb;
  out_FragColor.rgb *= Material(color).a;
#elif SPLITS_MODE == 2  // cross splits
  if (offset.x <= 0.5 && offset.y <= 0.5) {
    offset.x *= 2.0;
    offset.y *= 2.0;
    out_FragColor = textureLod(base_map3, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  if (offset.x > 0.5 && offset.y <= 0.5) {
    offset.x = min((offset.x - 0.5) * 2.0, 1.0);
    offset.y *= 2.0;
    out_FragColor = textureLod(base_map4, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  if (offset.x <= 0.5 && offset.y > 0.5) {
    offset.x *= 2.0;
    offset.y = min((offset.y - 0.5) * 2.0, 1.0);
    out_FragColor = textureLod(base_map, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x = min((offset.x - 0.5) * 2.0, 1.0);
  offset.y = min((offset.y - 0.5) * 2.0, 1.0);
  out_FragColor = textureLod(base_map2, offset, 0.0);
  out_FragColor.rgb *= Material(color).rgb;
  out_FragColor.rgb *= Material(color).a;
#endif
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
  vec4 splits_param; //vec4
  vec4 color; //vec4
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
}
H  #version 450
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
  vec4 splits_param; //vec4
  vec4 color; //vec4
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
  vec2 offset = BaseUV;
#if SPLITS_MODE == 0  // horizontal splits
  if (offset.x <= Material(splits_param).x) {
    offset.x *= Material(splits_param).y;
    out_FragColor = textureLod(base_map, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x -= Material(splits_param).x;
  if (offset.x <= Material(splits_param).x) {
    offset.x *= Material(splits_param).y;
    out_FragColor = textureLod(base_map2, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x -= Material(splits_param).x;
  if (offset.x <= Material(splits_param).x) {
    offset.x *= Material(splits_param).y;
    out_FragColor = textureLod(base_map3, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x -= Material(splits_param).x;
  if (offset.x <= Material(splits_param).x) {
    offset.x *= Material(splits_param).y;
    out_FragColor = textureLod(base_map4, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x -= Material(splits_param).x;
  if (offset.x <= Material(splits_param).x) {
    offset.x *= Material(splits_param).y;
    out_FragColor = textureLod(base_map5, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x -= Material(splits_param).x;
  if (offset.x <= Material(splits_param).x) {
    offset.x *= Material(splits_param).y;
    out_FragColor = textureLod(base_map6, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x -= Material(splits_param).x;
  if (offset.x <= Material(splits_param).x) {
    offset.x *= Material(splits_param).y;
    out_FragColor = textureLod(base_map7, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x -= Material(splits_param).x;
  offset.x = min(offset.x * Material(splits_param).y, 1.0);
  out_FragColor = textureLod(base_map8, offset, 0.0);
  out_FragColor.rgb *= Material(color).rgb;
  out_FragColor.rgb *= Material(color).a;
#elif SPLITS_MODE == 1  // vertical splits
  float border = 1.0 - Material(splits_param).x;
  if (offset.y >= border) {
    offset.y = (offset.y - border) * Material(splits_param).y;
    out_FragColor = textureLod(base_map, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  border -= Material(splits_param).x;
  if (offset.y >= border) {
    offset.y = (offset.y - border) * Material(splits_param).y;
    out_FragColor = textureLod(base_map2, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  border -= Material(splits_param).x;
  if (offset.y >= border) {
    offset.y = (offset.y - border) * Material(splits_param).y;
    out_FragColor = textureLod(base_map3, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  border -= Material(splits_param).x;
  if (offset.y >= border) {
    offset.y = (offset.y - border) * Material(splits_param).y;
    out_FragColor = textureLod(base_map4, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  border -= Material(splits_param).x;
  if (offset.y >= border) {
    offset.y = (offset.y - border) * Material(splits_param).y;
    out_FragColor = textureLod(base_map5, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  border -= Material(splits_param).x;
  if (offset.y >= border) {
    offset.y = (offset.y - border) * Material(splits_param).y;
    out_FragColor = textureLod(base_map6, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  border -= Material(splits_param).x;
  if (offset.y >= border) {
    offset.y = (offset.y - border) * Material(splits_param).y;
    out_FragColor = textureLod(base_map7, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  border -= Material(splits_param).x;
  offset.y = max((offset.y - border) * Material(splits_param).y, 0.0);
  out_FragColor = textureLod(base_map8, offset, 0.0);
  out_FragColor.rgb *= Material(color).rgb;
  out_FragColor.rgb *= Material(color).a;
#elif SPLITS_MODE == 2  // cross splits
  if (offset.x <= 0.5 && offset.y <= 0.5) {
    offset.x *= 2.0;
    offset.y *= 2.0;
    out_FragColor = textureLod(base_map3, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  if (offset.x > 0.5 && offset.y <= 0.5) {
    offset.x = min((offset.x - 0.5) * 2.0, 1.0);
    offset.y *= 2.0;
    out_FragColor = textureLod(base_map4, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  if (offset.x <= 0.5 && offset.y > 0.5) {
    offset.x *= 2.0;
    offset.y = min((offset.y - 0.5) * 2.0, 1.0);
    out_FragColor = textureLod(base_map, offset, 0.0);
    out_FragColor.rgb *= Material(color).rgb;
    out_FragColor.rgb *= Material(color).a;
    return;
  }
  offset.x = min((offset.x - 0.5) * 2.0, 1.0);
  offset.y = min((offset.y - 0.5) * 2.0, 1.0);
  out_FragColor = textureLod(base_map2, offset, 0.0);
  out_FragColor.rgb *= Material(color).rgb;
  out_FragColor.rgb *= Material(color).a;
#endif
}
   	   Positions�p   position   Uvs1p�   texcoord      Model��   model	   ModelView�@	   modelview
   Projection.
   projection   View��   view   BaseTextureSize�.   base_map_size   BaseTextureSize2:&5   base_map_size2   BaseTextureSize3;'5   base_map_size3   BaseTextureSize4<(5   base_map_size4   BaseTextureSize5=)5   base_map_size5   BaseTextureSize6>*5   base_map_size6   BaseTextureSize7?+5   base_map_size7   BaseTextureSize8@,5   base_map_size8   DepthTextureSize�=6   depth_map_size      splits_parama!   splits_param  �>  �@              color D   color  �?  �?  �?  �?       	      BaseTexturemX   base_map   BaseTexture2��	   base_map2   BaseTexture3��	   base_map3   BaseTexture4��	   base_map4   BaseTexture5��	   base_map5   BaseTexture6��	   base_map6   BaseTexture7��	   base_map7   BaseTexture8��	   base_map8   DepthTexture��	   depth_map           
   SplitsMode   SPLITS_MODE          combine_splits�N+