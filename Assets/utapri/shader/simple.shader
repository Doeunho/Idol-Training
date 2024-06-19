���     E  �SK  !x_               simple�	�
7�     �D  ���  "X�                Scene3Df(
        �  //macros
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
// defines
#if !defined(USE_DIFFUSE_LIGHT)
#define USE_DIFFUSE_LIGHT 0
#endif

#if !defined(USE_SPECULAR_LIGHT)
#define USE_SPECULAR_LIGHT 0
#endif

#if !defined(USE_BASE_TEXTURE)
#define USE_BASE_TEXTURE 0
#endif

#if !defined(USE_NORMAL_TEXTURE)
#define USE_NORMAL_TEXTURE 0
#endif

#if !defined(USE_NOISE_TEXTURE)
#define USE_NOISE_TEXTURE 0
#endif

#if !defined(USE_VTX_COLOR)
#define USE_VTX_COLOR 0
#endif

#if !defined(USE_REFLECT_TEXTURE)
#define USE_REFLECT_TEXTURE 0
#endif

#if !defined(USE_FOG)
#define USE_FOG 0
#endif

#if !defined(USE_PROJ_SHADOW)
#define USE_PROJ_SHADOW 0
#endif

#if !defined(USE_PROJ_COLOR)
#define USE_PROJ_COLOR 0
#endif

#if !defined(USE_UVREGION1)
#define USE_UVREGION1 0
#endif
#if !defined(USE_UVREGION2)
#define USE_UVREGION2 0
#endif

#if USE_BASE_TEXTURE || USE_NORMAL_TEXTURE || USE_NOISE_TEXTURE
#define USE_TEXCOORD 1
#define UV_ENABLE 1
#else
#define USE_TEXCOORD 0
#define UV_ENABLE 0
#endif

#if USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT || USE_REFLECT_TEXTURE || USE_NORMAL_TEXTURE
#define USE_NORMAL 1
#define USE_EYE_DIRECTION 1
#else
#define USE_NORMAL 0
#define USE_EYE_DIRECTION 0
#endif
  
// uniforms
uniform mat4 projection;
uniform mat4 view;
#if !SYS_DRAW_INSTANCED
uniform mat4 model;
#endif

#if SYS_SKINNING
uniform mat4 bindpose;
uniform mat4 bindpose_inverse;
#if SYS_BONE_TEXTURE
uniform sampler2D bone_map;
#else
uniform vec4 matrix_palette[3*64];
#endif
#endif

#if USE_FOG
uniform vec4 fog_parameter;
#endif

#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
uniform mat4 proj_matrix0;
#if SYS_SHADOW_COUNT >= 2
uniform mat4 proj_matrix1;
#endif
#endif

#if USE_PROJ_COLOR && SYS_PROJ_COLOR
uniform mat4 proj_color_matrix;
#endif
  
#if USE_EYE_DIRECTION
uniform vec4 eye_position;
#endif

#if UV_ENABLE
uniform vec4 texcoord_matrix[2];
#endif

// input
IN vec3 position;
#if USE_NORMAL
IN vec3 normal;
#endif
#if USE_NORMAL_TEXTURE
IN vec3 binormal;
IN vec3 tangent;
#endif
#if USE_VTX_COLOR
IN vec4 color;
#endif
#if USE_TEXCOORD
IN vec2 texcoord;
IN vec2 texcoord2;
#endif
#if SYS_SKINNING
IN uvec4 skinindex;
IN vec4 skinweight;
#endif
#if SYS_DRAW_INSTANCED
IN mat4 world;
#endif

#if USE_UVREGION1
IN vec4 uvregion1;
#endif
#if USE_UVREGION2
IN vec4 uvregion2;
#endif

// output
OUT vec3 Position;
#if USE_NORMAL
OUT vec3 Normal;
#endif
#if USE_NORMAL_TEXTURE
OUT vec3 Binormal;
OUT vec3 Tangent;
#endif
#if USE_VTX_COLOR
OUT vec4 Color;
#endif
#if USE_EYE_DIRECTION
OUT vec3 EyeDirection;
#endif
#if USE_TEXCOORD
OUT vec2 BaseUV;
OUT vec2 BaseUV2;
#endif
#if USE_FOG
OUT vec4 FogCoef;
#endif

#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
OUT vec4 ShadowCoordDir0_0;
#if SYS_SHADOW_COUNT >= 2
OUT vec4 ShadowCoordDir0_1;
#endif
#endif

#if USE_PROJ_COLOR && SYS_PROJ_COLOR
OUT vec4 ProjColorCoord;
#endif
#if USE_UVREGION1
OUT vec4 UVRegion1;
#endif
#if USE_UVREGION2
OUT vec4 UVRegion2;
#endif
void main(){
  vec4 tmp_position = vec4(position, 1.0);
  mat4 world = model;
  gl_Position = projection * view * world * tmp_position;
  BaseUV = texcoord;
}
�  //macros
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
// defines
#if !defined(USE_DIFFUSE_LIGHT)
#define USE_DIFFUSE_LIGHT 0
#endif

#if !defined(USE_SPECULAR_LIGHT)
#define USE_SPECULAR_LIGHT 0
#endif

#if !defined(USE_BASE_TEXTURE)
#define USE_BASE_TEXTURE 0
#endif

#if !defined(USE_NORMAL_TEXTURE)
#define USE_NORMAL_TEXTURE 0
#endif

#if !defined(USE_REFLECT_TEXTURE)
#define USE_REFLECT_TEXTURE 0
#endif

#if !defined(USE_SPECULAR_TEXTURE)
#define USE_SPECULAR_TEXTURE 0
#endif

#if !defined(USE_BLOOM_TEXTURE)
#define USE_BLOOM_TEXTURE 0
#endif

#if !defined(USE_NOISE_TEXTURE)
#define USE_NOISE_TEXTURE 0
#endif

#if !defined(USE_ALPHA_CUTOFF)
#define USE_ALPHA_CUTOFF 0
#endif

#if !defined(USE_FOG)
#define USE_FOG 0
#endif

#if !defined(USE_VTX_COLOR)
#define USE_VTX_COLOR 0
#endif

#if !defined(USE_DITHER)
#define USE_DITHER 0
#endif

#if !defined(USE_ALPHA_TO_COVERAGE)
#define USE_ALPHA_TO_COVERAGE 0
#endif // USE_ALPHA_TO_COVERAGE

#if !defined(USE_PROJ_SHADOW)
#define USE_PROJ_SHADOW 0
#endif

#if !defined(USE_PROJ_COLOR)
#define USE_PROJ_COLOR 0
#endif

#if !defined(USE_UVREGION1)
#define USE_UVREGION1 0
#endif
#if !defined(USE_UVREGION2)
#define USE_UVREGION2 0
#endif

#if USE_BASE_TEXTURE || USE_NORMAL_TEXTURE || USE_SPECULAR_TEXTURE || USE_BLOOM_TEXTURE || USE_NOISE_TEXTURE
#define USE_TEXCOORD 1
#define UV_ENABLE 1
#else
#define USE_TEXCOORD 0
#define UV_ENABLE 0
#endif

#if USE_REFLECT_TEXTURE || USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT || USE_NORMAL_TEXTURE
#define USE_NORMAL 1
#define USE_EYE_DIRECTION 1
#else
#define USE_NORMAL 0
#define USE_EYE_DIRECTION 0
#endif

precision HIGHP sampler2DShadow;
// uniforms
uniform mat4 modelviewprojection;
#if USE_BASE_TEXTURE
uniform vec4 base_gain;
uniform sampler2D base_map;
#endif

#if USE_SPECULAR_TEXTURE
uniform sampler2D specular_map;
#endif
  
#if USE_NORMAL_TEXTURE
uniform sampler2D normal_map;
#endif
#if USE_REFLECT_TEXTURE
uniform samplerCube reflection_map;
#endif

#if USE_BLOOM_TEXTURE
uniform vec4 bloom_gain;
uniform sampler2D bloom_map;
#endif
uniform vec4 color_scale;
uniform vec4 diffuse_color;
#if USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT
uniform vec4 specular_color;
uniform vec4 specular_power;
#endif
#if USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT
uniform vec4 ambient_color;
#endif
uniform vec4 emissive_color;
uniform vec4 replace_color;
#if USE_REFLECT_TEXTURE
uniform vec4 reflection_color;
uniform vec4 eye_position;
#endif

#if USE_ALPHA_CUTOFF
uniform vec4 alpha_cutoff;
#endif

#if USE_FOG
uniform vec4 fog_color;
uniform vec4 fog_parameter;
#endif

#if USE_DITHER
uniform vec4 dither_param;
#endif

#if USE_ALPHA_TO_COVERAGE
uniform vec4 a2c_param;
#endif //USE_ALPHA_TO_COVERAGE

// input
IN vec3 Position;
#if USE_NORMAL
IN vec3 Normal;
#endif
#if USE_NORMAL_TEXTURE
IN vec3 Binormal;
IN vec3 Tangent;
#endif
#if USE_VTX_COLOR
IN vec4 Color;
#endif
#if USE_EYE_DIRECTION
IN vec3 EyeDirection;
#endif
#if USE_TEXCOORD
IN vec2 BaseUV;
IN vec2 BaseUV2;
#endif
#if USE_FOG
IN vec4 FogCoef;
#endif

#if USE_UVREGION1
IN vec4 UVRegion1;
#endif
#if USE_UVREGION2
IN vec4 UVRegion2;
#endif

#if USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT
uniform vec3 ambient_light;
#if SYS_DIRECTIONAL_LIGHT_NUM > 0
uniform vec4 directional_light0[2];
#if SYS_DIRECTIONAL_LIGHT_NUM > 1
uniform vec4 directional_light1[2];
#if SYS_DIRECTIONAL_LIGHT_NUM > 2
uniform vec4 directional_light2[2];
#if SYS_DIRECTIONAL_LIGHT_NUM > 3
uniform vec4 directional_light3[2];
#if SYS_DIRECTIONAL_LIGHT_NUM > 4
uniform vec4 directional_light4[2];
#if SYS_DIRECTIONAL_LIGHT_NUM > 5
uniform vec4 directional_light5[2];
#if SYS_DIRECTIONAL_LIGHT_NUM > 6
uniform vec4 directional_light6[2];
#if SYS_DIRECTIONAL_LIGHT_NUM > 7
uniform vec4 directional_light7[2];
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#if SYS_POINT_LIGHT_NUM > 0
uniform vec4 point_light0[3];
#if SYS_POINT_LIGHT_NUM > 1
uniform vec4 point_light1[3];
#if SYS_POINT_LIGHT_NUM > 2
uniform vec4 point_light2[3];
#if SYS_POINT_LIGHT_NUM > 3
uniform vec4 point_light3[3];
#if SYS_POINT_LIGHT_NUM > 4
uniform vec4 point_light4[3];
#if SYS_POINT_LIGHT_NUM > 5
uniform vec4 point_light5[3];
#if SYS_POINT_LIGHT_NUM > 6
uniform vec4 point_light6[3];
#if SYS_POINT_LIGHT_NUM > 7
uniform vec4 point_light7[3];
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#if SYS_SPOT_LIGHT_NUM > 0
uniform vec4 spot_light0[5];
#if SYS_SPOT_LIGHT_NUM > 1
uniform vec4 spot_light1[5];
#if SYS_SPOT_LIGHT_NUM > 2
uniform vec4 spot_light2[5];
#if SYS_SPOT_LIGHT_NUM > 3
uniform vec4 spot_light3[5];
#if SYS_SPOT_LIGHT_NUM > 4
uniform vec4 spot_light4[5];
#if SYS_SPOT_LIGHT_NUM > 5
uniform vec4 spot_light5[5];
#if SYS_SPOT_LIGHT_NUM > 6
uniform vec4 spot_light6[5];
#if SYS_SPOT_LIGHT_NUM > 7
uniform vec4 spot_light7[5];
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif  // #if USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT

#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
IN vec4 ShadowCoordDir0_0;
uniform vec4 proj_config0;
#if SYS_SHADOW_TYPE == 0
uniform sampler2DShadow proj_map0;
#else
uniform sampler2D proj_map0;
#endif

#if SYS_SHADOW_COUNT >= 2
IN vec4 ShadowCoordDir0_1;
uniform vec4 proj_config1;
#if SYS_SHADOW_TYPE == 0
uniform sampler2DShadow proj_map1;
#else
uniform sampler2D proj_map1;
#endif
#endif
uniform  vec4 shadow_color;
#endif //SYS_SHADOW_COUNT && USE_PROJ_SHADOW
void main() {
  out_FragColor.xyz = texture(base_map, BaseUV).xyz;
#if USE_ALPHA_IS_ONE
  out_FragColor.w = 1.0;
#endif
}
�  #version 450
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
layout(location = 0) out vec3 Position;
layout(location = 1) out vec2 BaseUV;
//------------
// ------------------------------------------------------------
// Common resource definitions for all scene object shaders.

//
// Per-camera-scene set
//

layout(set=0, binding=0) uniform CameraUbo {
  mat4 view;
  mat4 projection;
  vec4 eye_position;
  vec4 color_scale;
  vec4 fog_color;
  vec4 fog_parameter;
} u_camera;

#define MAX_LIGHT_COUNT (8)

layout(set=0, binding=1) uniform SceneUbo {
  vec4 ambient_light;
  vec4 directional_light_color_and_intensity[MAX_LIGHT_COUNT];
  vec4 directional_light_direction[MAX_LIGHT_COUNT];
  vec4 point_light_color_and_intensity[MAX_LIGHT_COUNT];
  vec4 point_light_position[MAX_LIGHT_COUNT];
  vec4 point_light_attenuation_and_distance[MAX_LIGHT_COUNT];
  vec4 spot_light_color_and_intensity[MAX_LIGHT_COUNT];
  vec4 spot_light_position[MAX_LIGHT_COUNT];
  vec4 spot_light_attenuation_and_distance[MAX_LIGHT_COUNT];
  vec4 spot_light_direction[MAX_LIGHT_COUNT];
  vec4 spot_light_cosine_cone_in_out[MAX_LIGHT_COUNT];
  mat4 proj_matrix0;
  mat4 proj_matrix1;
  mat4 proj_color_matrix;
  vec4 proj_config0;
  vec4 proj_config1;
  // 1520 bytes with MAX_LIGHT_COUNT == 8
} u_scene;

//
// Per-object set
//

layout(set=1, binding=0) uniform TransformUbo {
  mat4 model;
  mat4 modelview;
  mat4 modelviewprojection;
} u_transform;

#if SYS_SKINNING

# define UBO_MAX_BONE_COUNT (338)

layout(set=1, binding=1) uniform SkeletonUbo {
  mat4 bindpose;
  mat4 bindpose_inverse;
  vec4 matrix_palette[3 * UBO_MAX_BONE_COUNT]; // R^(3x4)^T * UBO_MAX_BONE_COUNT
} u_skeleton;

# if SYS_BONE_TEXTURE
layout(set=1, binding=2) uniform sampler2D bone_map;
# endif

#endif  // SYS_SKINNING

//
// Per-geometry set
//

#if SYS_GEOMETRY_UBO
layout(set=2, binding=0) uniform GeometryUbo {
  ivec4 vertex_count;
} u_geometry;
#endif  // SYS_GEOMETRY_UBO

#if SYS_VERTEX_TEXTURE
# if !SYS_GEOMETRY_UBO
#  error SYS_VERTEX_TEXTURE != 0 but SYS_GEOMETRY_UBO == 0. This is unexpected and illegal.
# endif
layout(set=2, binding=1) uniform sampler2D vertex_map;
#endif // SYS_VERTEX_TEXTURE

// Material uniform parameters UBO:
//  layout(set=2, binding=2) uniform MaterialUniformParametersUbo { ... } u_material_parameters;

// Per-material texture-samplers follow:
//  layout(set=2, binding=3) uniform sampler2D material_texture0;
//  ...

// Per-material buffer block bindings follow:
//  layout(set=2, binding=(3 + <texture_count> + 0) uniform UniformBufferBlock { ... } u_buffer_block0;
//  ...
//
//shader-maker
//

//
// No material uniform parameters.
//

//
// Material texture-samplers:
//
layout(set=2, binding=3) uniform sampler2D base_map;

//
// No material buffer block bindings.
//

//------------
void main(){
  vec4 tmp_position = vec4(position, 1.0);
  mat4 world = Transform(model);
  gl_Position = Camera(projection) * Camera(view) * world * tmp_position;
  BaseUV = texcoord;
}
_  #version 450
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

layout(location = 0) in vec3 Position;
layout(location = 1) in vec2 BaseUV;
//------------
layout(location=0) out vec4 out_color;
// ------------------------------------------------------------
// Common resource definitions for all scene object shaders.

//
// Per-camera-scene set
//

layout(set=0, binding=0) uniform CameraUbo {
  mat4 view;
  mat4 projection;
  vec4 eye_position;
  vec4 color_scale;
  vec4 fog_color;
  vec4 fog_parameter;
} u_camera;

#define MAX_LIGHT_COUNT (8)

layout(set=0, binding=1) uniform SceneUbo {
  vec4 ambient_light;
  vec4 directional_light_color_and_intensity[MAX_LIGHT_COUNT];
  vec4 directional_light_direction[MAX_LIGHT_COUNT];
  vec4 point_light_color_and_intensity[MAX_LIGHT_COUNT];
  vec4 point_light_position[MAX_LIGHT_COUNT];
  vec4 point_light_attenuation_and_distance[MAX_LIGHT_COUNT];
  vec4 spot_light_color_and_intensity[MAX_LIGHT_COUNT];
  vec4 spot_light_position[MAX_LIGHT_COUNT];
  vec4 spot_light_attenuation_and_distance[MAX_LIGHT_COUNT];
  vec4 spot_light_direction[MAX_LIGHT_COUNT];
  vec4 spot_light_cosine_cone_in_out[MAX_LIGHT_COUNT];
  mat4 proj_matrix0;
  mat4 proj_matrix1;
  mat4 proj_color_matrix;
  vec4 proj_config0;
  vec4 proj_config1;
  // 1520 bytes with MAX_LIGHT_COUNT == 8
} u_scene;

//
// Per-object set
//

layout(set=1, binding=0) uniform TransformUbo {
  mat4 model;
  mat4 modelview;
  mat4 modelviewprojection;
} u_transform;

#if SYS_SKINNING

# define UBO_MAX_BONE_COUNT (338)

layout(set=1, binding=1) uniform SkeletonUbo {
  mat4 bindpose;
  mat4 bindpose_inverse;
  vec4 matrix_palette[3 * UBO_MAX_BONE_COUNT]; // R^(3x4)^T * UBO_MAX_BONE_COUNT
} u_skeleton;

# if SYS_BONE_TEXTURE
layout(set=1, binding=2) uniform sampler2D bone_map;
# endif

#endif  // SYS_SKINNING

//
// Per-geometry set
//

#if SYS_GEOMETRY_UBO
layout(set=2, binding=0) uniform GeometryUbo {
  ivec4 vertex_count;
} u_geometry;
#endif  // SYS_GEOMETRY_UBO

#if SYS_VERTEX_TEXTURE
# if !SYS_GEOMETRY_UBO
#  error SYS_VERTEX_TEXTURE != 0 but SYS_GEOMETRY_UBO == 0. This is unexpected and illegal.
# endif
layout(set=2, binding=1) uniform sampler2D vertex_map;
#endif // SYS_VERTEX_TEXTURE

// Material uniform parameters UBO:
//  layout(set=2, binding=2) uniform MaterialUniformParametersUbo { ... } u_material_parameters;

// Per-material texture-samplers follow:
//  layout(set=2, binding=3) uniform sampler2D material_texture0;
//  ...

// Per-material buffer block bindings follow:
//  layout(set=2, binding=(3 + <texture_count> + 0) uniform UniformBufferBlock { ... } u_buffer_block0;
//  ...
//
//shader-maker
//

//
// No material uniform parameters.
//

//
// Material texture-samplers:
//
layout(set=2, binding=3) uniform sampler2D base_map;

//
// No material buffer block bindings.
//

//------------
void main() {
  out_FragColor.xyz = texture(base_map, BaseUV).xyz;
#if USE_ALPHA_IS_ONE
  out_FragColor.w = 1.0;
#endif
}
   	   Positions�p   position   Uvs1p�   texcoord      Model��   model	   ModelView�@	   modelview
   Projection.
   projection   View��   view   EyePositiony�   eye_position
   ColorScale�/   color_scale   BindPoseW   bindpose   InvBindPoseB�   bindpose_inverse   Jointsx6   matrix_palette   FogColorJ	   fog_color   FogNear�)
   fog_near   FogFar6w   fog_far
   FogDensity��   fog_density   FogExp2|
   fog_exp2   FogParameter��   fog_parameter   ModelViewProjection��J   modelviewprojection   VertexCount��   vertex_count              BoneTexturev�   bone_map   BaseTexturemX   base_map              USE_ALPHA_IS_ONE�*   USE_ALPHA_IS_ONE         simple�	