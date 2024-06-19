���     	J  �SK  !x_               default�N�
7�     �I  ���  "X�                      T  //macros
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
//------------
//
//shader-maker
//

uniform vec4 flare_color; //vec4
uniform vec4 depth_threshold; //vec4
uniform vec4 depth_sample_interval; //vec4
uniform vec4 middle_point; //vec4
uniform vec4 origin_positions[10];
uniform vec4 origin_parameters[10];
uniform vec4 ghost_uvrects[10];
uniform vec4 ghost_transforms[20];
uniform vec4 ghost_parameters[20];
uniform sampler2D ghost_map;
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
  vec4 current_transform = MaterialArray(ghost_transforms, quadindex);
  vec4 current_parameter = MaterialArray(ghost_parameters, quadindex);
  float compare_threshold = Material(depth_threshold).x;
  float compare_sample_interval = Material(depth_sample_interval).x;
  int origin_index = int(current_parameter.x);
  vec4 origin_position = MaterialArray(origin_positions, origin_index);
  origin_position = PostProcessPass(sys_camera_viewproj) * vec4(origin_position.xyz, 1.0);
  origin_position.xyz = origin_position.xyz / origin_position.w * vec3(0.5, 0.5, 1.0) + vec3(0.5, 0.5, 0.0);

  vec4 current_uvrect = MaterialArray(ghost_uvrects, int(current_parameter.y));
  BaseUV = texcoord.xy;
  BaseUV.y = 1.0 - BaseUV.y;
  BaseUV = current_uvrect.xy + current_uvrect.zw * BaseUV;
#define DEPTH_SAMPLE_COUNT 13
#define STANDARD_HEIGHT (720.0*3.0)
  vec2[DEPTH_SAMPLE_COUNT] scales = vec2[](
    vec2(0.0, 0.0),
    vec2(1.0/STANDARD_HEIGHT, 1.0/STANDARD_HEIGHT),
    vec2(1.0/STANDARD_HEIGHT, -1.0/STANDARD_HEIGHT),
    vec2(-1.0/STANDARD_HEIGHT, 1.0/STANDARD_HEIGHT),
    vec2(-1.0/STANDARD_HEIGHT, -1.0/STANDARD_HEIGHT),
    vec2(2.0/STANDARD_HEIGHT, 0.0),
    vec2(0.0, 2.0/STANDARD_HEIGHT),
    vec2(-2.0/STANDARD_HEIGHT, 0.0),
    vec2(0.0, -2.0/STANDARD_HEIGHT),
    vec2(3.0/STANDARD_HEIGHT, 3.0/STANDARD_HEIGHT),
    vec2(3.0/STANDARD_HEIGHT, -3.0/STANDARD_HEIGHT),
    vec2(-3.0/STANDARD_HEIGHT, 3.0/STANDARD_HEIGHT),
    vec2(-3.0/STANDARD_HEIGHT, -3.0/STANDARD_HEIGHT));
  float draw_ratio = 0.0;
  for (int i = 0; i < DEPTH_SAMPLE_COUNT; i++) {
    vec2 depth_uv = origin_position.xy + vec2(compare_sample_interval) * scales[i] * vec2(1.0, PostProcessPass(sys_camera_aspect).y);
    float depth = textureLod(depth_map, depth_uv, 0.0).x;
    float distance = PostProcessPass(sys_camera_depth).z/(PostProcessPass(sys_camera_depth).w - depth);
#if CHECK_OUTSIDE_REGION
    vec2 det = abs(depth_uv - vec2(0.5));
    vec3 step_result = step(vec3(compare_threshold, det.xy), vec3(distance, vec2(0.5)));
    draw_ratio += step_result.x * step_result.y * step_result.z;
#else
    draw_ratio += step(compare_threshold, distance);
#endif
  }
  draw_ratio /= float(DEPTH_SAMPLE_COUNT);
  Color = vec4(draw_ratio) * Material(flare_color) * current_parameter.z;
  vec2 origin = origin_position.xy * vec2(2.0, -2.0) - vec2(1.0, -1.0);
  origin.x *= PostProcessPass(sys_camera_aspect).x;
  vec2 middle = Material(middle_point).xy;
  middle.x *= PostProcessPass(sys_camera_aspect).x;
  vec2 move = middle - origin;
  vec2 dir = vec2(0.0, 1.0);
  if (length(move) > 0.000001) {
    dir = normalize(move);
  }
  vec4 tmp_position = vec4(position, 1.0);
  tmp_position.xy = (tmp_position.xy * vec2(2.0, -2.0) - vec2(1.0, -1.0)) * current_transform.xy;

  if (current_parameter.w > 0.0) {
    vec3 support_vec = cross(vec3(0.0, 0.0, 1.0), vec3(-dir.xy, 0.0));
    tmp_position.xy = vec2(dot(normalize(support_vec.xy), tmp_position.xy), dot(-dir.xy, tmp_position.xy));
  }
  vec2 unit = dir + length(origin) * dir;
  tmp_position.xy += (unit * current_transform.z + origin);
  tmp_position.x *= PostProcessPass(sys_camera_aspect).y;
  tmp_position.xy = tmp_position.xy * 0.5 + 0.5;
  gl_Position = PostProcessPass(projection) * tmp_position;
  gl_Position.xyz *= step(1.0/255.0, draw_ratio);
}
�  //macros
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
//------------
//
//shader-maker
//

uniform vec4 flare_color; //vec4
uniform vec4 depth_threshold; //vec4
uniform vec4 depth_sample_interval; //vec4
uniform vec4 middle_point; //vec4
uniform vec4 origin_positions[10];
uniform vec4 origin_parameters[10];
uniform vec4 ghost_uvrects[10];
uniform vec4 ghost_transforms[20];
uniform vec4 ghost_parameters[20];
uniform sampler2D ghost_map;
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
  out_FragColor.xyz = textureLod(ghost_map, BaseUV, 0.0).xyz * Color.xyz * PostProcessPass(sys_camera_colorscale).xyz;
  out_FragColor.w = 1.0;
}
H  #version 450
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
  vec4 middle_point; //vec4
  vec4 origin_positions[10];
  vec4 origin_parameters[10];
  vec4 ghost_uvrects[10];
  vec4 ghost_transforms[20];
  vec4 ghost_parameters[20];
} u_material_parameters;

//
// Material texture-samplers:
//
layout(set=2, binding=3) uniform sampler2D ghost_map;

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
  vec4 current_transform = MaterialArray(ghost_transforms, quadindex);
  vec4 current_parameter = MaterialArray(ghost_parameters, quadindex);
  float compare_threshold = Material(depth_threshold).x;
  float compare_sample_interval = Material(depth_sample_interval).x;
  int origin_index = int(current_parameter.x);
  vec4 origin_position = MaterialArray(origin_positions, origin_index);
  origin_position = PostProcessPass(sys_camera_viewproj) * vec4(origin_position.xyz, 1.0);
  origin_position.xyz = origin_position.xyz / origin_position.w * vec3(0.5, 0.5, 1.0) + vec3(0.5, 0.5, 0.0);

  vec4 current_uvrect = MaterialArray(ghost_uvrects, int(current_parameter.y));
  BaseUV = texcoord.xy;
  BaseUV.y = 1.0 - BaseUV.y;
  BaseUV = current_uvrect.xy + current_uvrect.zw * BaseUV;
#define DEPTH_SAMPLE_COUNT 13
#define STANDARD_HEIGHT (720.0*3.0)
  vec2[DEPTH_SAMPLE_COUNT] scales = vec2[](
    vec2(0.0, 0.0),
    vec2(1.0/STANDARD_HEIGHT, 1.0/STANDARD_HEIGHT),
    vec2(1.0/STANDARD_HEIGHT, -1.0/STANDARD_HEIGHT),
    vec2(-1.0/STANDARD_HEIGHT, 1.0/STANDARD_HEIGHT),
    vec2(-1.0/STANDARD_HEIGHT, -1.0/STANDARD_HEIGHT),
    vec2(2.0/STANDARD_HEIGHT, 0.0),
    vec2(0.0, 2.0/STANDARD_HEIGHT),
    vec2(-2.0/STANDARD_HEIGHT, 0.0),
    vec2(0.0, -2.0/STANDARD_HEIGHT),
    vec2(3.0/STANDARD_HEIGHT, 3.0/STANDARD_HEIGHT),
    vec2(3.0/STANDARD_HEIGHT, -3.0/STANDARD_HEIGHT),
    vec2(-3.0/STANDARD_HEIGHT, 3.0/STANDARD_HEIGHT),
    vec2(-3.0/STANDARD_HEIGHT, -3.0/STANDARD_HEIGHT));
  float draw_ratio = 0.0;
  for (int i = 0; i < DEPTH_SAMPLE_COUNT; i++) {
    vec2 depth_uv = origin_position.xy + vec2(compare_sample_interval) * scales[i] * vec2(1.0, PostProcessPass(sys_camera_aspect).y);
    float depth = textureLod(depth_map, depth_uv, 0.0).x;
    float distance = PostProcessPass(sys_camera_depth).z/(PostProcessPass(sys_camera_depth).w - depth);
#if CHECK_OUTSIDE_REGION
    vec2 det = abs(depth_uv - vec2(0.5));
    vec3 step_result = step(vec3(compare_threshold, det.xy), vec3(distance, vec2(0.5)));
    draw_ratio += step_result.x * step_result.y * step_result.z;
#else
    draw_ratio += step(compare_threshold, distance);
#endif
  }
  draw_ratio /= float(DEPTH_SAMPLE_COUNT);
  Color = vec4(draw_ratio) * Material(flare_color) * current_parameter.z;
  vec2 origin = origin_position.xy * vec2(2.0, -2.0) - vec2(1.0, -1.0);
  origin.x *= PostProcessPass(sys_camera_aspect).x;
  vec2 middle = Material(middle_point).xy;
  middle.x *= PostProcessPass(sys_camera_aspect).x;
  vec2 move = middle - origin;
  vec2 dir = vec2(0.0, 1.0);
  if (length(move) > 0.000001) {
    dir = normalize(move);
  }
  vec4 tmp_position = vec4(position, 1.0);
  tmp_position.xy = (tmp_position.xy * vec2(2.0, -2.0) - vec2(1.0, -1.0)) * current_transform.xy;

  if (current_parameter.w > 0.0) {
    vec3 support_vec = cross(vec3(0.0, 0.0, 1.0), vec3(-dir.xy, 0.0));
    tmp_position.xy = vec2(dot(normalize(support_vec.xy), tmp_position.xy), dot(-dir.xy, tmp_position.xy));
  }
  vec2 unit = dir + length(origin) * dir;
  tmp_position.xy += (unit * current_transform.z + origin);
  tmp_position.x *= PostProcessPass(sys_camera_aspect).y;
  tmp_position.xy = tmp_position.xy * 0.5 + 0.5;
  gl_Position = PostProcessPass(projection) * tmp_position;
  gl_Position.xyz *= step(1.0/255.0, draw_ratio);
}
�
  #version 450
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
  vec4 middle_point; //vec4
  vec4 origin_positions[10];
  vec4 origin_parameters[10];
  vec4 ghost_uvrects[10];
  vec4 ghost_transforms[20];
  vec4 ghost_parameters[20];
} u_material_parameters;

//
// Material texture-samplers:
//
layout(set=2, binding=3) uniform sampler2D ghost_map;

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
  out_FragColor.xyz = textureLod(ghost_map, BaseUV, 0.0).xyz * Color.xyz * PostProcessPass(sys_camera_colorscale).xyz;
  out_FragColor.w = 1.0;
}
   	   Positions�p   position   Uvs1p�   texcoord   QuadIndicesK2	   quadindex      Model��   model	   ModelView�@	   modelview
   Projection.
   projection   View��   view   BaseTextureSize�.   base_map_size   BaseTextureSize2:&5   base_map_size2   BaseTextureSize3;'5   base_map_size3   BaseTextureSize4<(5   base_map_size4   BaseTextureSize5=)5   base_map_size5   BaseTextureSize6>*5   base_map_size6   BaseTextureSize7?+5   base_map_size7   BaseTextureSize8@,5   base_map_size8   DepthTextureSize�=6   depth_map_size   sys_camera_aspect�?   sys_camera_aspect   sys_light_projposCTA   sys_light_projpos   sys_camera_colorscale�+`   sys_camera_colorscale   sys_camera_viewproj��O   sys_camera_viewproj   sys_camera_depth��8   sys_camera_depth      flare_color��   flare_color  �?  �?  �?  �?      depth_thresholdB�1   depth_threshold  HC                  depth_sample_interval��_   depth_sample_interval  �A                  middle_point��   middle_point                         origin_positions��9   origin_positions
     �  B  �A                                                                                                                                                       origin_parameters�?   origin_parameters
     pA                                                                                                                                                               ghost_uvrects��&   ghost_uvrects
           1�*>  �?1�*>33�>1�*>���>L��>    1�*>  �?   ?    1�*>  �?L�*?    1�*>  �?&SU?    1�*>  �?        1�*>  �?        1�*>  �?        1�*>  �?        1�*>  �?   ghost_transforms��9   ghost_transforms     �?  �?���=    ���=���=���=  @@��L>��L>��L>   @���>���>���>    ���>���>333?       ?   ?  �?                               ?            ��?            ��L?                                                                                                                                                                       ghost_parameters��8   ghost_parameters     ��  �@  �?      ��  @@  �?  �?  ��   @  �?  �?  ��  �@  �?  �?  ��      �?  �?  ��   @  �?  �?      �?  �?          �@  �?  �?          �?  �?       @  �?  �?                                                                                                                                                                
      BaseTexturemX   base_map   BaseTexture2��	   base_map2   BaseTexture3��	   base_map3   BaseTexture4��	   base_map4   BaseTexture5��	   base_map5   BaseTexture6��	   base_map6   BaseTexture7��	   base_map7   BaseTexture8��	   base_map8   DepthTexture��	   depth_map   GhostTexture�S	   ghost_map              ORIGIN_COUNT��   ORIGIN_COUNT
      
   RECT_COUNT�
   RECT_COUNT
         CHECK_OUTSIDE_REGION��>   CHECK_OUTSIDE_REGION      	   lensflare��