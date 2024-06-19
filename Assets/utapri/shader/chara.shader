���     �B �SK  !x_               default�N�
7�     �B ���  "X�                Scene3Df(
   SceneShadowU9   Scene3D_Monitor�{+   Scene3D_SplitCommon:�E   Scene3D_Split1�%   Scene3D_Split2�%   Scene3D_Split3�%   Scene3D_Split4�%   Scene3D_Split5�%   Scene3D_Split6�%   Scene3D_Split7�%   Scene3D_Split8	�%        +=  // defines
#if !defined(USE_SPHERE_FOG)
#define USE_SPHERE_FOG 0
#endif
#if SPHERE_FOG_COUNT == 0
#define USE_SPHERE_FOG 0
#endif
#if !defined(USE_SPHERE_FOG_REVERSE)
#define USE_SPHERE_FOG_REVERSE 0
#endif
#if SPHERE_FOG_REVERSE_COUNT == 0
#define USE_SPHERE_FOG_REVERSE 0
#endif

// uniforms
#if USE_SPHERE_FOG
uniform vec4 sphere_fog_center[SPHERE_FOG_COUNT];
#endif
#if USE_SPHERE_FOG_REVERSE
uniform vec4 rev_sphere_fog_center[SPHERE_FOG_REVERSE_COUNT];
#endif

// output
#if USE_SPHERE_FOG
OUT float SphereFogDistance[SPHERE_FOG_COUNT];
#endif
#if USE_SPHERE_FOG_REVERSE
OUT float RevSphereFogDistance[SPHERE_FOG_REVERSE_COUNT];
#endif
// defines
#if !defined(USE_DIFFUSE_LIGHT)
#define USE_DIFFUSE_LIGHT 0
#endif

#if !defined(USE_BASE_TEXTURE)
#define USE_BASE_TEXTURE 0
#endif

#if !defined(USE_NORMAL_TEXTURE)
#define USE_NORMAL_TEXTURE 0
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

#if !defined(UV_SHIFT_ENABLE)
#define UV_SHIFT_ENABLE 0
#endif

#if !defined(BASE_OUTLINEREVISE_ENABLE)
#define BASE_OUTLINEREVISE_ENABLE 0
#endif

#if !defined(BASE_RIMLIGHT_USECUSTOMNORMAL)
#define BASE_RIMLIGHT_USECUSTOMNORMAL 0
#endif

#if !defined(BASE_SPECULARLIGHTING_ENABLE)
#define BASE_SPECULARLIGHTING_ENABLE 0
#endif

#if !defined(USE_OUTLINE)
#define USE_OUTLINE 0
#endif

#if !defined(USE_NOSELINE)
#define USE_NOSELINE 0
#endif

#if !defined(USE_FACE_SHADOW)
#define USE_FACE_SHADOW 0
#endif

#if !defined(USE_BLEND_SHAPE)
#define USE_BLEND_SHAPE 0
#endif

#if USE_BASE_TEXTURE || USE_NORMAL_TEXTURE
#define USE_TEXCOORD 1
#define UV_ENABLE 1
#else
#define USE_TEXCOORD 0
#define UV_ENABLE 0
#endif

#if USE_REFLECT_TEXTURE || USE_DIFFUSE_LIGHT || USE_NORMAL_TEXTURE || BASE_RIMLIGHTING_ENABLE || BASE_RIMLIGHT_USECUSTOMNORMAL || BASE_SPECULARLIGHTING_ENABLE || USE_OUTLINE || USE_NOSELINE
#define USE_NORMAL 1
#define USE_EYE_DIRECTION 1
#else
#define USE_NORMAL 0
#define USE_EYE_DIRECTION 0
#endif

#if BASE_SPECULARLIGHTING_ENABLE
#define USE_CAMERA_DIRECTION 1
#else
#define USE_CAMERA_DIRECTION 0
#endif

// uniforms
uniform mat4 projection;
uniform mat4 view;
#if !SYS_DRAW_INSTANCED
uniform mat4 model;
#endif //SYS_DRAW_INSTANCED

#if SYS_SKINNING
uniform mat4 bindpose;
uniform mat4 bindpose_inverse;
#if SYS_BONE_TEXTURE
uniform HIGHP sampler2D bone_map;
#else
uniform vec4 matrix_palette[3*64];
#endif
#endif  // SYS_SKINNING

#if USE_FOG
uniform vec4 fog_parameter;
#endif  // USE_FOG

#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
uniform mat4 proj_matrix0;
#if SYS_SHADOW_COUNT >= 2
uniform mat4 proj_matrix1;
#endif
#endif

#if USE_PROJ_COLOR && SYS_PROJ_COLOR
uniform mat4 proj_color_matrix;
#endif

#if UV_SHIFT_ENABLE
uniform vec4 uv_shift;
#endif  // UV_SHIFT_ENABLE

#if USE_EYE_DIRECTION
uniform vec4 eye_position;
#endif  // USE_EYE_DIRECTION

#if UV_ENABLE
uniform vec4 texcoord_matrix[2];
#endif  // UV_ENABLE

#if USE_OUTLINE
uniform vec4 base_outline_revise_distance;
uniform vec4 base_outline_revise_ratio;
uniform vec4 base_outline_width;
uniform vec4 base_outline_shift;
#endif

#if USE_FACE_SHADOW
uniform vec4 face_shadow_shift;
uniform vec4 face_shadow_front;
#endif

#if SYS_VERTEX_TEXTURE && USE_BLEND_SHAPE
uniform ivec4 vertex_count;
uniform sampler2D vertex_map;
uniform vec4 blend_shape_index0;
uniform vec4 blend_shape_index1;
uniform vec4 blend_shape_ratio;
uniform vec4 blend_shape_eye_ratio;
#endif

// functions
#if SYS_SKINNING
vec4 getbonevector(in int index) {
#if SYS_BONE_TEXTURE
  return texelFetch(bone_map, ivec2(index, 0), 0);
#else
  return matrix_palette[index];
#endif
}
vec4 skinningP(in vec4 in_position, in uvec4 in_skinindex, in vec4 in_skinweight) {
  vec4 out_position;
  ivec4 iskinindex = ivec4(in_skinindex);
  out_position.x  = dot(getbonevector(3*iskinindex.x+0), in_position) * in_skinweight.x;
  out_position.y  = dot(getbonevector(3*iskinindex.x+1), in_position) * in_skinweight.x;
  out_position.z  = dot(getbonevector(3*iskinindex.x+2), in_position) * in_skinweight.x;
  out_position.x += dot(getbonevector(3*iskinindex.y+0), in_position) * in_skinweight.y;
  out_position.y += dot(getbonevector(3*iskinindex.y+1), in_position) * in_skinweight.y;
  out_position.z += dot(getbonevector(3*iskinindex.y+2), in_position) * in_skinweight.y;
  out_position.x += dot(getbonevector(3*iskinindex.z+0), in_position) * in_skinweight.z;
  out_position.y += dot(getbonevector(3*iskinindex.z+1), in_position) * in_skinweight.z;
  out_position.z += dot(getbonevector(3*iskinindex.z+2), in_position) * in_skinweight.z;
  out_position.x += dot(getbonevector(3*iskinindex.w+0), in_position) * in_skinweight.w;
  out_position.y += dot(getbonevector(3*iskinindex.w+1), in_position) * in_skinweight.w;
  out_position.z += dot(getbonevector(3*iskinindex.w+2), in_position) * in_skinweight.w;
  out_position.w = 1.0;
  return out_position;
}
vec4 skinningN(in vec4 in_normal, in uvec4 in_skinindex, in vec4 in_skinweight) {
  vec4 out_normal;
  ivec4 iskinindex = ivec4(in_skinindex);
  out_normal.x  = dot(getbonevector(3*iskinindex.x+0), in_normal) * in_skinweight.x;
  out_normal.y  = dot(getbonevector(3*iskinindex.x+1), in_normal) * in_skinweight.x;
  out_normal.z  = dot(getbonevector(3*iskinindex.x+2), in_normal) * in_skinweight.x;
  out_normal.x += dot(getbonevector(3*iskinindex.y+0), in_normal) * in_skinweight.y;
  out_normal.y += dot(getbonevector(3*iskinindex.y+1), in_normal) * in_skinweight.y;
  out_normal.z += dot(getbonevector(3*iskinindex.y+2), in_normal) * in_skinweight.y;
  out_normal.x += dot(getbonevector(3*iskinindex.z+0), in_normal) * in_skinweight.z;
  out_normal.y += dot(getbonevector(3*iskinindex.z+1), in_normal) * in_skinweight.z;
  out_normal.z += dot(getbonevector(3*iskinindex.z+2), in_normal) * in_skinweight.z;
  out_normal.x += dot(getbonevector(3*iskinindex.w+0), in_normal) * in_skinweight.w;
  out_normal.y += dot(getbonevector(3*iskinindex.w+1), in_normal) * in_skinweight.w;
  out_normal.z += dot(getbonevector(3*iskinindex.w+2), in_normal) * in_skinweight.w;
  out_normal.w = 0.0;
  return out_normal;
}
#endif  // USE_SKINNING
void normalEdit(in mat4 in_world, vec4 in_normal, in vec4 in_color2,
                inout vec3 out_normal, inout vec3 out_normal2) {
//#if BASE_RIMLIGHT_USECUSTOMNORMAL
  mat4 tmp_world = transpose(inverse(in_world));
  out_normal = normalize((tmp_world * in_normal).xyz);
  out_normal2 = normalize((tmp_world * in_color2).xyz);
//#else  // BASE_RIMLIGHT_USECUSTOMNORMAL
//  mat4 tmp_world = transpose(inverse(in_world));
//  out_normal = normalize((tmp_world * in_normal).xyz);
//  out_normal2 = out_normal;
//#endif  // BASE_RIMLIGHT_USECUSTOMNORMAL
}
#if SYS_VERTEX_TEXTURE && USE_BLEND_SHAPE
ivec2 calc_shape_uv(in int vertexid, in float shape_index, in int texture_width) {
  int idx = vertexid + (vertex_count.x * int(shape_index)) * 2;
  int v = idx / texture_width;
  int u = idx - v * texture_width;
  return ivec2(u, v);
}
#endif

// input
IN vec3 position;
#if USE_NORMAL
IN vec3 normal;
#endif  // USE_NORMAL
#if USE_NORMAL_TEXTURE
IN vec3 binormal;
IN vec3 tangent;
#endif  // USE_NORMAL_TEXTURE
#if USE_VTX_COLOR
IN vec4 color;
#endif  // USE_VTX_COLOR
#if BASE_RIMLIGHT_USECUSTOMNORMAL
IN vec4 color2;
#endif  // BASE_RIMLIGHT_USECUSTOMNORMAL
#if USE_TEXCOORD
IN vec2 texcoord;
#endif  // USE_TEXCOORD
#if SYS_SKINNING
IN uvec4 skinindex;
IN vec4 skinweight;
#endif  // SYS_SKINNING
#if SYS_DRAW_INSTANCED
IN mat4 world;
#endif //SYS_DRAW_INSTANCED

// output
OUT vec3 Position;
#if USE_NORMAL
OUT vec3 Normal;
#endif  // USE_NORMAL
#if USE_NORMAL_TEXTURE
OUT vec3 Binormal;
OUT vec3 Tangent;
#endif  // USE_NORMAL_TEXTURE
//#if BASE_RIMLIGHT_USECUSTOMNORMAL
OUT vec3 Normal2;
//#endif  // BASE_RIMLIGHT_USECUSTOMNORMAL
#if USE_VTX_COLOR
OUT vec4 Color;
#endif   // USE_VTX_COLOR
#if USE_EYE_DIRECTION
OUT vec3 EyeDirection;
#endif  // USE_EYE_DIRECTION
#if USE_TEXCOORD
OUT vec2 BaseUV;
#endif  // USE_TEXCOORD
#if USE_FOG
OUT vec4 FogCoef;
#endif  // USE_FOG

#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
OUT vec4 ShadowCoordDir0_0;
#if SYS_SHADOW_COUNT >= 2
OUT vec4 ShadowCoordDir0_1;
#endif
#endif

#if USE_PROJ_COLOR && SYS_PROJ_COLOR
OUT vec4 ProjColorCoord;
#endif

#if USE_CAMERA_DIRECTION
OUT vec3 CameraDirection;
#endif

// program
void main(){;
#if SYS_VERTEX_TEXTURE && USE_BLEND_SHAPE
  int pos_idx = gl_VertexID * 2;
  int texture_width = textureSize(vertex_map, 0).x;
  ivec2 uv_00 = calc_shape_uv(pos_idx, blend_shape_index0.x, texture_width);
  ivec2 uv_01 = calc_shape_uv(pos_idx, blend_shape_index1.x, texture_width);
  ivec2 uv_10 = calc_shape_uv(pos_idx, blend_shape_index0.y, texture_width);
  ivec2 uv_11 = calc_shape_uv(pos_idx, blend_shape_index1.y, texture_width);
  ivec2 uv_30 = calc_shape_uv(pos_idx, blend_shape_index0.w, texture_width);
  ivec2 uv_31 = calc_shape_uv(pos_idx, blend_shape_index1.w, texture_width);

  vec4 tmp_position = vec4( mix(texelFetch(vertex_map, uv_00, 0).xyz, texelFetch(vertex_map, uv_01, 0).xyz, blend_shape_ratio.x), 1.0);
  tmp_position.xyz +=       mix(texelFetch(vertex_map, uv_10, 0).xyz, texelFetch(vertex_map, uv_11, 0).xyz, blend_shape_ratio.y);
  tmp_position.xyz +=           texelFetch(vertex_map, uv_30, 0).xyz * blend_shape_eye_ratio.x + texelFetch(vertex_map, uv_31, 0).xyz * blend_shape_eye_ratio.y;
  tmp_position.xyz += position.xyz;
#else
  vec4 tmp_position = vec4(position.xyz, 1.0);
#endif
#if USE_NORMAL
#if SYS_VERTEX_TEXTURE && USE_BLEND_SHAPE
  vec4 tmp_normal = vec4( mix(texelFetch(vertex_map, uv_00 + ivec2(1, 0), 0).xyz, texelFetch(vertex_map, uv_01 + ivec2(1, 0), 0).xyz, blend_shape_ratio.x), 0.0);
  tmp_normal.xyz +=       mix(texelFetch(vertex_map, uv_10 + ivec2(1, 0), 0).xyz, texelFetch(vertex_map, uv_11 + ivec2(1, 0), 0).xyz, blend_shape_ratio.y);
  tmp_normal.xyz +=           texelFetch(vertex_map, uv_30 + ivec2(1, 0), 0).xyz * blend_shape_eye_ratio.x + texelFetch(vertex_map, uv_31 + ivec2(1, 0), 0).xyz * blend_shape_eye_ratio.y;
  tmp_normal.xyz += normalize(normal.xyz);
#else
  vec4 tmp_normal   = vec4(normal, 0.0);
#endif
#endif  // USE_NORMAL
#if USE_NORMAL_TEXTURE
  vec4 tmp_binormal = vec4(binormal, 0.0);
  vec4 tmp_tangent  = vec4(tangent, 0.0);
#endif  // USE_NORMAL_TEXTURE
#if BASE_RIMLIGHT_USECUSTOMNORMAL
  vec4 tmp_normal2  = vec4(color2.xyz, 0.0);
#else  // BASE_RIMLIGHT_USECUSTOMNORMAL
  vec4 tmp_normal2  = vec4(0.0);
#endif  // BASE_RIMLIGHT_USECUSTOMNORMAL
#if SYS_SKINNING
  tmp_position = bindpose * tmp_position;
  tmp_position = skinningP(tmp_position, skinindex, skinweight);
  tmp_position = bindpose_inverse * tmp_position;
#if USE_NORMAL
  tmp_normal   = bindpose * tmp_normal;
  tmp_normal   = skinningN(tmp_normal, skinindex, skinweight);
  tmp_normal   = bindpose_inverse * tmp_normal;
#endif  // USE_NORMAL
#if USE_NORMAL_TEXTURE
  tmp_binormal = bindpose * tmp_binormal;
  tmp_tangent  = bindpose * tmp_tangent;
  tmp_binormal = skinningN(tmp_binormal, skinindex, skinweight);
  tmp_tangent  = skinningN(tmp_tangent, skinindex, skinweight);
  tmp_binormal = bindpose_inverse * tmp_binormal;
  tmp_tangent  = bindpose_inverse * tmp_tangent;
#endif  // USE_NORMAL_TEXTURE
  tmp_normal2   = bindpose * tmp_normal2;
  tmp_normal2   = skinningN(tmp_normal2, skinindex, skinweight);
  tmp_normal2   = bindpose_inverse * tmp_normal2;
#endif  // SYS_SKINNING

#if !SYS_DRAW_INSTANCED
  mat4 world = model;
#endif //!SYS_DRAW_INSTANCED
  gl_Position = projection * view * world * tmp_position;
  Position    = (world * tmp_position).xyz;
#if USE_NORMAL
  normalEdit(world, tmp_normal, tmp_normal2, Normal, Normal2);
#endif  // USE_NORMAL
#if USE_NORMAL_TEXTURE
  Binormal    = normalize((world * tmp_binormal).xyz);
  Tangent     = normalize((world * tmp_tangent).xyz);
#endif  // USE_NORMAL_TEXTURE

#if USE_VTX_COLOR
  Color   = color;
#endif  // USE_VTX_COLOR
#if USE_EYE_DIRECTION
  EyeDirection = normalize(eye_position.xyz - Position);
#endif  // USE_EYE_DIRECTION
#if USE_CAMERA_DIRECTION
  CameraDirection = normalize(view[2].xyz);
#endif
#if USE_TEXCOORD
  BaseUV.xy      = texcoord;
#if UV_SHIFT_ENABLE
  BaseUV.xy += uv_shift.xy;
#endif  // UV_SHIFT_ENABLE
#if UV_ENABLE
  vec4 tmp_texcoord = vec4(BaseUV.xy, 0.0, 1.0);
  BaseUV.x = dot(texcoord_matrix[0], tmp_texcoord);
  BaseUV.y = dot(texcoord_matrix[1], tmp_texcoord);
#endif  // UV_ENABLE
#endif  // USE_TEXCOORD

#if USE_OUTLINE
  float revise_rate = 1.0;

//#if BASE_OUTLINEREVISE_ENABLE
  vec3 vertex_pos = (view * world * vec4(tmp_position.xyz, 1.0)).xyz;
  float vertex_dist = max(0.0, -vertex_pos.z);

  float distance = vertex_dist;

#if 1
  float tan15 = 0.26794919243;// tan(30/2)
  float fov_adjust = projection[1][1] * tan15;

  distance = vertex_dist / fov_adjust;
#endif

  if (distance < base_outline_revise_distance.x) {
    revise_rate = distance / base_outline_revise_distance.x;
  } else {
    revise_rate = distance * base_outline_revise_ratio.x / base_outline_revise_distance.x + 1.0 - base_outline_revise_ratio.x;
  }
  //float step_dst = step(base_outline_revise_distance.x, distance);
  //revise_rate = distance * mix(1.0, base_outline_revise_ratio.x, step_dst) / base_outline_revise_distance.x + mix(0.0, (1.0 - base_outline_revise_ratio.x), step_dst);
//#endif  // BASE_OUTLINEREVISE_ENABLE

  // if projection[3][3] == 0.0 then * 1.0, else * 0.0
  revise_rate *= 1.0 - abs(sign(projection[3][3]));

#if USE_VTX_COLOR
  // vec3 view_normal = normalize(mat3(transpose(inverse(view * world))) * Normal.xyz);
  vec3 view_normal = normalize(mat3(transpose(inverse(view * world))) * tmp_normal.xyz);
  vec2 offset = mat2(projection) * view_normal.xy;
  gl_Position.xy += offset * base_outline_width.x * color.r * revise_rate;
  gl_Position.z += base_outline_shift.x * (1.0 - color.g);
#endif
#endif

#if USE_FACE_SHADOW
  float inner = dot(face_shadow_front.xyz, EyeDirection.xyz);
  float threshold = 0.3420;   // 0.3420 = cos(toRadian(70))
  inner = max(inner, threshold);

  mat4 tmp_view = view;
  tmp_view[3].xyz += face_shadow_shift.xyz * inner;
  gl_Position = projection * tmp_view * world * tmp_position;
#endif

#if USE_FOG
  FogCoef.x = (fog_parameter.y - gl_Position.w) * (1.0 / (fog_parameter.y - fog_parameter.x));
  FogCoef.yzw = vec3(0.0);
#endif  // USE_FOG

#if USE_SPHERE_FOG
  SphereFogDistance[0] = length(Position - sphere_fog_center[0].xyz);
#if SPHERE_FOG_COUNT >= 2
  SphereFogDistance[1] = length(Position - sphere_fog_center[1].xyz);
#endif
#endif  // USE_SPHERE_FOG

#if USE_SPHERE_FOG_REVERSE
  RevSphereFogDistance[0] = length(Position - rev_sphere_fog_center[0].xyz);
#if SPHERE_FOG_REVERSE_COUNT >= 2
  RevSphereFogDistance[1] = length(Position - rev_sphere_fog_center[1].xyz);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 3
  RevSphereFogDistance[2] = length(Position - rev_sphere_fog_center[2].xyz);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 4
  RevSphereFogDistance[3] = length(Position - rev_sphere_fog_center[3].xyz);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 5
  RevSphereFogDistance[4] = length(Position - rev_sphere_fog_center[4].xyz);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 6
  RevSphereFogDistance[5] = length(Position - rev_sphere_fog_center[5].xyz);
#endif
#endif  // USE_SPHERE_FOG_REVERSE

#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
  ShadowCoordDir0_0  = (proj_matrix0 * vec4(Position, 1.0));
#if SYS_SHADOW_COUNT >= 2
  ShadowCoordDir0_1  = (proj_matrix1 * vec4(Position, 1.0));
#endif
#endif

#if USE_PROJ_COLOR && SYS_PROJ_COLOR
  ProjColorCoord  = (proj_color_matrix * vec4(Position, 1.0));
#endif
}
 �  // defines
#if !defined(USE_SPHERE_FOG)
#define USE_SPHERE_FOG 0
#endif
#if SPHERE_FOG_COUNT == 0
#define USE_SPHERE_FOG 0
#endif
#if !defined(USE_SPHERE_FOG_REVERSE)
#define USE_SPHERE_FOG_REVERSE 0
#endif
#if SPHERE_FOG_REVERSE_COUNT == 0
#define USE_SPHERE_FOG_REVERSE 0
#endif

// uniforms
#if USE_SPHERE_FOG
uniform vec4 sphere_fog_parameter[SPHERE_FOG_COUNT];
uniform vec4 sphere_fog_color[SPHERE_FOG_COUNT];
#endif
#if USE_SPHERE_FOG_REVERSE
uniform vec4 rev_sphere_fog_parameter[SPHERE_FOG_REVERSE_COUNT];
uniform vec4 rev_sphere_fog_color[SPHERE_FOG_REVERSE_COUNT];
#endif

// input
#if USE_SPHERE_FOG
IN float SphereFogDistance[SPHERE_FOG_COUNT];
#endif
#if USE_SPHERE_FOG_REVERSE
IN float RevSphereFogDistance[SPHERE_FOG_REVERSE_COUNT];
#endif
// defines
#if !defined(USE_DIFFUSE_LIGHT)
#define USE_DIFFUSE_LIGHT 0
#endif

#if !defined(USE_SPECULAR_LIGHT)
#define USE_SPECULAR_LIGHT 0
#endif

#if !defined(USE_BASE_TEXTURE)
#define USE_BASE_TEXTURE 0
#endif // USE_BASE_TEXTURE

#if !defined(USE_NORMAL_TEXTURE)
#define USE_NORMAL_TEXTURE 0
#endif // USE_NORMAL_TEXTURE

#if !defined(USE_REFLECT_TEXTURE)
#define USE_REFLECT_TEXTURE 0
#endif  // USE_REFLECT_TEXTURE

#if !defined(USE_ALPHA_CUTOFF)
#define USE_ALPHA_CUTOFF 0
#endif  // USE_ALPHA_CUTOFF

#if !defined(USE_FOG)
#define USE_FOG 0
#endif  // USE_FOG

#if !defined(USE_VTX_COLOR)
#define USE_VTX_COLOR 0
#endif

#if !defined(USE_VTX_COLOR_TO_STAGE_LIGHT)
#define USE_VTX_COLOR_TO_STAGE_LIGHT 0
#endif

#if !defined(USE_DITHER)
#define USE_DITHER 0
#endif // USE_DITHER

#if !defined(USE_ALPHA_TO_COVERAGE)
#define USE_ALPHA_TO_COVERAGE 0
#endif // USE_ALPHA_TO_COVERAGE

#if !defined(USE_PROJ_SHADOW)
#define USE_PROJ_SHADOW 0
#endif

#if !defined(USE_PROJ_COLOR)
#define USE_PROJ_COLOR 0
#endif

#if !defined(BASE_STAGELIGHTING_ENABLE)
#define BASE_STAGELIGHTING_ENABLE 0
#endif

#if !defined(BASE_RIMLIGHTING_ENABLE)
#define BASE_RIMLIGHTING_ENABLE 0
#endif

#if !defined(BASE_TEX_RIMSHADE_ENABLE)
#define BASE_TEX_RIMSHADE_ENABLE 0
#endif

#if BASE_RIMLIGHTING_ENABLE
#if !defined(BASE_RIMMASK_MODE)
#define BASE_RIMMASK_MODE 0
#endif
#endif

#if !defined(BASE_SPECULARLIGHTING_ENABLE)
#define BASE_SPECULARLIGHTING_ENABLE 0
#endif

#if !defined(BASE_TEX_BASE_ENABLE)
#define BASE_TEX_BASE_ENABLE 0
#endif // BASE_TEX_BASE_ENABLE

#if !defined(BASE_TEXTURE_ALPHA_MODE)
#define BASE_TEXTURE_ALPHA_MODE 0
#endif  // BASE_TEXTURE_ALPHA_MODE

#if !defined(USE_OUTLINE)
#define USE_OUTLINE 0
#endif

#if !defined(USE_NOSELINE)
#define USE_NOSELINE 0
#endif

#if !defined(USE_EYELID_LINE)
#define USE_EYELID_LINE 0
#endif

#if !defined(BASE_EYELIDLINE_SHOWLEFT_ENABLE)
#define BASE_EYELIDLINE_SHOWLEFT_ENABLE 0
#endif

#if !defined(BASE_ELELIDLINE_SHOWRIGHT_ENABLE)
#define BASE_ELELIDLINE_SHOWRIGHT_ENABLE 0
#endif

#if !defined(NOSELINE_SHOW_ENABLE)
#define NOSELINE_SHOW_ENABLE 0
#endif

#if !defined(USE_FACE_SHADOW)
#define USE_FACE_SHADOW 0
#endif

#if !defined(USE_REFLECT_DIRECTIONAL_LIGHT)
#define USE_REFLECT_DIRECTIONAL_LIGHT 0
#endif

#if !defined(USE_REFLECT_POINT_LIGHT)
#define USE_REFLECT_POINT_LIGHT 0
#endif

#if !defined(USE_DEFAULT_DIRECTIONAL_LIGHT)
#define USE_DEFAULT_DIRECTIONAL_LIGHT 0
#endif

#if !defined(USE_REFLECT_AMBIENT_LIGHT)
#define USE_REFLECT_AMBIENT_LIGHT 0
#endif

#if !defined(USE_REFLECT_SPECULAR_LIGHT)
#define USE_REFLECT_SPECULAR_LIGHT 0
#endif

#if USE_BASE_TEXTURE || USE_NORMAL_TEXTURE || BASE_TEX_RIMSHADE_ENABLE
#define USE_TEXCOORD 1
#define UV_ENABLE 1
#else
#define USE_TEXCOORD 0
#define UV_ENABLE 0
#endif

#if USE_REFLECT_TEXTURE || USE_DIFFUSE_LIGHT || USE_NORMAL_TEXTURE || BASE_RIMLIGHTING_ENABLE || BASE_SPECULARLIGHTING_ENABLE || USE_NOSELINE
#define USE_NORMAL 1
#define USE_EYE_DIRECTION 1
#else
#define USE_NORMAL 0
#define USE_EYE_DIRECTION 0
#endif

#if BASE_SPECULARLIGHTING_ENABLE
#define USE_CAMERA_DIRECTION 1
#else
#define USE_CAMERA_DIRECTION 0
#endif

precision HIGHP sampler2DShadow;

// uniforms
#if USE_BASE_TEXTURE
uniform sampler2D base_map;
#endif
#if USE_NORMAL_TEXTURE
uniform sampler2D normal_map;
#endif  // USE_NORMAL_TEXTURE
#if USE_REFLECT_TEXTURE
uniform samplerCube reflection_map;
#endif  // USE_REFLECT_TEXTURE

uniform vec4 color_scale;
uniform vec4 diffuse_color;
uniform vec4 emissive_color;

#if USE_REFLECT_TEXTURE
uniform vec4 reflection_color;
#endif  // USE_REFLECT_TEXTURE

#if USE_ALPHA_CUTOFF
uniform vec4 alpha_cutoff;
#endif  // USE_ALPHA_CUTOFF

#if USE_FOG
uniform vec4 fog_color;
uniform vec4 fog_parameter;
#endif  // USE_FOG

#if USE_DITHER
uniform vec4 dither_param;
#endif //USE_DITHER

#if USE_ALPHA_TO_COVERAGE
uniform vec4 a2c_param;
#endif //USE_ALPHA_TO_COVERAGE

#if BASE_TEXTURE_ALPHA_MODE == 1
uniform vec4 base_tex_alpha_rate;
#endif

#if USE_DIFFUSE_LIGHT || BASE_RIMLIGHTING_ENABLE || BASE_SPECULARLIGHTING_ENABLE
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
#endif  // #if USE_DIFFUSE_LIGHT || BASE_RIMLIGHTING_ENABLE || BASE_SPECULARLIGHTING_ENABLE

#if BASE_STAGELIGHTING_ENABLE
uniform vec4 base_stagelightborder_width;
uniform vec4 base_stagelightshade_bias;
uniform vec4 base_stagelightshade_color;
#endif

#if BASE_RIMLIGHTING_ENABLE
uniform vec4 base_rimlight_front_add_color;
uniform vec4 base_rimlight_front_mul_color;
uniform vec4 base_rimlight_back_add_color;
uniform vec4 base_rimlight_back_mul_color;
uniform vec4 base_rimlight_front_tol;
uniform vec4 base_rimlight_back_tol;
uniform vec4 base_rimlight_front_smooth;
uniform vec4 base_rimlight_back_smooth;

uniform vec4 base_rimadd_rate;
uniform vec4 base_rimmul_rate;

uniform sampler2D base_rimshade_map;
uniform vec4 base_rimshadefrontblend_rate;
uniform vec4 base_rimshadebackblend_rate;
#endif

#if BASE_SPECULARLIGHTING_ENABLE
uniform vec4 base_specularcolor;
uniform vec4 base_specularpower;
#endif

//#if USE_OUTLINE || USE_NOSELINE
uniform vec4 base_outline_color;
uniform vec4 base_outline_expand_ratio;
//#endif

#if USE_NOSELINE
uniform vec4 base_nose_displayleft_bias;
uniform vec4 base_nose_displayright_bias;
#endif

#if USE_FACE_SHADOW
uniform vec4 face_shadow_color;
#endif

#if USE_DEFAULT_DIRECTIONAL_LIGHT
uniform vec4 env_directionallight_0_color;
uniform vec4 env_directionallight_0_intensity;
uniform vec4 env_directionallight_0_vector;
#endif

#if USE_REFLECT_DIRECTIONAL_LIGHT
uniform vec4 reflect_directional_light_color;
uniform vec4 reflect_directional_light_intensity;
uniform vec4 reflect_directional_light_direction;
#endif

#if USE_REFLECT_POINT_LIGHT
uniform vec4 reflect_point_light_color;
uniform vec4 reflect_point_light_intensity;
uniform vec4 reflect_point_light_direction;
#endif

#if USE_REFLECT_AMBIENT_LIGHT
uniform vec4 reflect_ambient_light_color;
uniform vec4 reflect_ambient_light_intensity;
#endif

#if USE_REFLECT_SPECULAR_LIGHT
uniform vec4 reflect_specular_light_color;
uniform vec4 reflect_specular_light_intensity;
uniform vec4 reflect_specular_light_direction;
#endif


// functions
#if USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT
void parallel_specular_light1(inout vec3 diffuse_light, inout vec3 specular_light,
                             in vec3 normal, in vec3 eye_direction,
                             in vec3 light_color, in vec3 light_pos, in float power) {
  vec3 light_direction = normalize(light_pos * -1.0);
#if USE_DIFFUSE_LIGHT
  float diffuse = max(0.0, dot(normal, light_direction));
  diffuse_light  += light_color * diffuse;
#endif
#if USE_SPECULAR_LIGHT
  vec3 half_angle = normalize(light_direction + eye_direction);
  float specular = max(dot(normal, half_angle), 0.0);
  specular = pow(specular, power);
  specular_light += light_color * specular;
#endif
}
float light_attenuation(in float distance, in vec4 attenuation) {
  float out_attenuation = 0.0;
  if (distance <= attenuation.w) {
    out_attenuation = min(1.0,
                          1.0/(
                          distance*distance*attenuation.x+
                          distance*attenuation.y+
                          attenuation.z)
                          );
  }
  return out_attenuation;
}
void point_specular_light1(inout vec3 diffuse_light, inout vec3 specular_light,
                          in vec3 position, in vec3 normal, in vec3 eye_direction,
                          in vec3 light_color, in vec3 light_pos, in vec4 light_attn, in float power) {
  vec3 light_direction = normalize(light_pos - position);
  float light_distance = length(light_pos - position);
  float attenuation = light_attenuation(light_distance, light_attn);
#if USE_DIFFUSE_LIGHT
  float diffuse = dot(normal, light_direction);
  diffuse_light  += light_color * diffuse * attenuation;
#endif
#if USE_SPECULAR_LIGHT
  vec3 half_angle = normalize(light_direction + eye_direction);
  float specular = max(dot(normal, half_angle), 0.0);
  specular = pow(specular, power);
  specular_light += light_color * specular * attenuation;
#endif
}
void spot_specular_light1(inout vec3 diffuse_light, inout vec3 specular_light,
                         in vec3 position, in vec3 normal, in vec3 eye_direction,
                         in vec3 light_color, in vec3 light_pos, in vec4 light_attn, in vec3 light_dir, in vec2 light_cutoff, in float power) {
  vec3 light_direction = normalize(light_pos - position);
  float cos_cone_in = light_cutoff.x;
  float cos_cone_out = light_cutoff.y;
  float cos_direction = dot(-light_direction, light_dir);
  float spot = smoothstep(cos_cone_out, cos_cone_in, cos_direction);
  float light_distance = length(light_pos - position);
  float attenuation = light_attenuation(light_distance, light_attn);
#if USE_DIFFUSE_LIGHT
  float diffuse = dot(normal, light_direction);
  diffuse_light  += light_color * diffuse * attenuation * spot;
#endif
#if USE_SPECULAR_LIGHT
  vec3 half_angle = normalize(light_direction + eye_direction);
  float specular = max(dot(normal, half_angle), 0.0);
  specular = pow(specular, power);
  specular_light += light_color * specular * attenuation * spot;
#endif
}
void parallel_specular_light(inout vec3 diffuse_light, inout vec3 specular_light,
                             in vec3 normal, in vec3 eye_direction,
                             in float power, in vec3 lit0) {
#if USE_REFLECT_POINT_LIGHT
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           reflect_point_light_color.xyz, reflect_point_light_direction.xyz, power);
#elif USE_REFLECT_DIRECTIONAL_LIGHT
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           reflect_directional_light_color.xyz, reflect_directional_light_direction.xyz, power);
#elif USE_DEFAULT_DIRECTIONAL_LIGHT
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           env_directionallight_0_color.xyz, env_directionallight_0_vector.xyz, power);
#elif SYS_DIRECTIONAL_LIGHT_NUM > 0
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           directional_light0[0].xyz, directional_light0[1].xyz, power);
  diffuse_light.xyz *= lit0.xyz;
  specular_light.xyz *= lit0.xyz;
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 1
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           directional_light1[0].xyz, directional_light1[1].xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 2
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           directional_light2[0].xyz, directional_light2[1].xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 3
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           directional_light3[0].xyz, directional_light3[1].xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 4
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           directional_light4[0].xyz, directional_light4[1].xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 5
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           directional_light5[0].xyz, directional_light5[1].xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 6
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           directional_light6[0].xyz, directional_light6[1].xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 7
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           directional_light7[0].xyz, directional_light7[1].xyz, power);
#endif
}
void point_specular_light(inout vec3 diffuse_light, inout vec3 specular_light,
                          in vec3 position, in vec3 normal, in vec3 eye_direction,
                          in float power) {
#if SYS_POINT_LIGHT_NUM > 0
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light0[0].xyz, point_light0[1].xyz, point_light0[2].xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 1
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light1[0].xyz, point_light1[1].xyz, point_light1[2].xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 2
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light2[0].xyz, point_light2[1].xyz, point_light2[2].xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 3
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light3[0].xyz, point_light3[1].xyz, point_light3[2].xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 4
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light4[0].xyz, point_light4[1].xyz, point_light4[2].xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 5
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light5[0].xyz, point_light5[1].xyz, point_light5[2].xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 6
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light6[0].xyz, point_light6[1].xyz, point_light6[2].xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 7
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light7[0].xyz, point_light7[1].xyz, point_light7[2].xyzw, power);
#endif
}
void spot_specular_light(inout vec3 diffuse_light, inout vec3 specular_light,
                         in vec3 position, in vec3 normal, in vec3 eye_direction,
                         in float power) {
#if SYS_SPOT_LIGHT_NUM > 0
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light0[0].xyz, spot_light0[1].xyz, spot_light0[2].xyzw,
                       spot_light0[3].xyz, spot_light0[4].xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 1
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light1[0].xyz, spot_light1[1].xyz, spot_light1[2].xyzw,
                       spot_light1[3].xyz, spot_light1[4].xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 2
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light2[0].xyz, spot_light2[1].xyz, spot_light2[2].xyzw,
                       spot_light2[3].xyz, spot_light2[4].xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 3
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light3[0].xyz, spot_light3[1].xyz, spot_light3[2].xyzw,
                       spot_light3[3].xyz, spot_light3[4].xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 4
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light4[0].xyz, spot_light4[1].xyz, spot_light4[2].xyzw,
                       spot_light4[3].xyz, spot_light4[4].xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 5
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light5[0].xyz, spot_light5[1].xyz, spot_light5[2].xyzw,
                       spot_light5[3].xyz, spot_light5[4].xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 6
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light6[0].xyz, spot_light6[1].xyz, spot_light6[2].xyzw,
                       spot_light6[3].xyz, spot_light6[4].xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 7
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light7[0].xyz, spot_light7[1].xyz, spot_light7[2].xyzw,
                       spot_light7[3].xyz, spot_light7[4].xy, power);
#endif
}
#endif  // USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT

// input
IN vec3 Position;
#if USE_NORMAL
IN vec3 Normal;
#endif  // USE_NORMAL
//#if BASE_RIMLIGHT_USECUSTOMNORMAL
IN vec3 Normal2;
//#endif  // BASE_RIMLIGHT_USECUSTOMNORMAL
#if USE_NORMAL_TEXTURE
IN vec3 Binormal;
IN vec3 Tangent;
#endif  // USE_NORMAL_TEXTURE
#if USE_VTX_COLOR
IN vec4 Color;
#endif   // USE_VTX_COLOR
#if USE_EYE_DIRECTION
IN vec3 EyeDirection;
#endif  // USE_EYE_DIRECTION
#if USE_CAMERA_DIRECTION
IN vec3 CameraDirection;
#endif   // USE_CAMERA_DIRECTION
#if USE_TEXCOORD
IN vec2 BaseUV;
#endif  // USE_TEXCOORD
#if USE_FOG
IN vec4 FogCoef;
#endif  // USE_FOG


#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
IN vec4 ShadowCoordDir0_0;
#if SYS_SHADOW_TYPE == 0
uniform sampler2DShadow proj_map0;
#else
uniform sampler2D proj_map0;
#endif

#if SYS_SHADOW_COUNT >= 2
IN vec4 ShadowCoordDir0_1;
#if SYS_SHADOW_TYPE == 0
uniform sampler2DShadow proj_map1;
#else
uniform sampler2D proj_map1;
#endif
#endif

#endif //SHADOW

#if USE_PROJ_COLOR && SYS_PROJ_COLOR
IN vec4 ProjColorCoord;
uniform sampler2D proj_color_map;
#endif

#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
#if SYS_SHADOW_TYPE == 0
vec4 calc_shadow(in vec4 shadow_coord, in sampler2DShadow shadow_map) {
  vec3 shadowuv = shadow_coord.xyz/shadow_coord.w * 0.5 + 0.5;
  vec4 lit = vec4(1.0);
  if (shadowuv.y >= 0.0 && shadowuv.y <= 1.0) {
    lit.xyz = vec3(textureLod(shadow_map, shadowuv.xyz, 0.0));
    lit.xyz += vec3(textureLodOffset(shadow_map, shadowuv.xyz, 0.0, ivec2(1, 1)));
    lit.xyz += vec3(textureLodOffset(shadow_map, shadowuv.xyz, 0.0, ivec2(1, -1)));
    lit.xyz += vec3(textureLodOffset(shadow_map, shadowuv.xyz, 0.0, ivec2(-1, 1)));
    lit.xyz += vec3(textureLodOffset(shadow_map, shadowuv.xyz, 0.0, ivec2(-1, -1)));
    lit.xyz /= 5.0;
  }
  return vec4(lit.xyz, shadowuv.y);
}
#elif SYS_SHADOW_TYPE == 1
vec4 calc_shadow(in vec4 shadow_coord, in sampler2D shadow_map) {
  vec2 shadowuv = shadow_coord.xy/shadow_coord.w * 0.5 + 0.5;
  vec4 lit = vec4(1.0);
  if (shadowuv.y >= 0.0 && shadowuv.y <= 1.0) {
    lit.xyz = vec3(textureLod(shadow_map, shadowuv.xy, 0.0).x);
  }
  return vec4(lit.xyz, shadowuv.y);
}
#endif
#endif

#if USE_DITHER
float calc_dither(in float threshold) {
  float dither[16];
  dither[0]  =  1.0/17.0; dither[1]  =  9.0/17.0; dither[2]  =  3.0/17.0; dither[3]  = 11.0/17.0;
  dither[4]  = 13.0/17.0; dither[5]  =  5.0/17.0; dither[6]  = 15.0/17.0; dither[7]  =  7.0/17.0;
  dither[8]  =  4.0/17.0; dither[9]  = 12.0/17.0; dither[10] =  2.0/17.0; dither[11] = 10.0/17.0;
  dither[12] = 16.0/17.0; dither[13] =  8.0/17.0; dither[14] = 14.0/17.0; dither[15] =  6.0/17.0;
  vec2 screen_coord = floor(mod(gl_FragCoord.xy, 4.0));
  int pixel_index = int(clamp(screen_coord.x + screen_coord.y * 4.0, 0.0, 15.0));
#if USE_ALPHA_TO_COVERAGE
  return max((1.0 - threshold - dither[ pixel_index ]) / (1.0 - dither[ pixel_index ]), 0.0);
#else
  return step(threshold, dither[ pixel_index ]);
#endif
}
#endif

#if BASE_STAGELIGHTING_ENABLE
vec3 blend_linear_burn(vec3 base, vec3 blend) {
  return max(base + blend - vec3(1.0), vec3(0.0));
}
#endif

#if BASE_RIMLIGHTING_ENABLE
vec3 blend_add(vec3 base, vec3 blend) {
  return base + blend;
}
vec3 blend_multiply(vec3 base, vec3 blend) {
  return base * blend;
}
vec3 blend_rim_light(vec3 base, vec3 blend, float rate) {
  return mix(base, blend_add(base, blend * base_rimadd_rate.x), rate);
}
vec3 blend_rim_dark(vec3 base, vec3 blend, float rate) {
  return mix(base, blend_multiply(base, blend), rate * base_rimmul_rate.x);
}
vec3 blendShade(vec3 base, vec3 shade, vec3 dark, float shade_rate, float rim_rate) {
  return mix(base, mix(base, shade, shade_rate) * dark, rim_rate * base_rimmul_rate.x);
}
#endif

// program
void main() {
  vec4 lit = vec4(1.0);
#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
#if SYS_SHADOW_TYPE == 0 || SYS_SHADOW_TYPE == 1
  lit = calc_shadow(ShadowCoordDir0_0, proj_map0);
#if SYS_SHADOW_COUNT >= 2
  vec4 lit2 = calc_shadow(ShadowCoordDir0_1, proj_map1);
  lit = mix(vec4(lit.xyz, lit2.w), lit2, step(1.0, lit.w));
#endif
  lit.xyz = max(lit.xyz, smoothstep(0.9, 1.0, lit.w));
#endif
#endif

#if USE_EYE_DIRECTION
  vec3 eye_direction = normalize(EyeDirection);
#endif  // USE_EYE_DIRECTION

#if USE_NORMAL
  vec3 normal    = normalize(Normal);
#endif  // USE_NORMAL
  vec3 normal2   = normalize(Normal2);

#if USE_TEXCOORD
#if USE_NORMAL_TEXTURE
  vec3 binormal  = normalize(Binormal);
  vec3 tangent   = normalize(Tangent);
#endif  // USE_NORMAL_TEXTURE
  vec2 base_uv   = BaseUV;
#if USE_BASE_TEXTURE
  vec4 tex_base = texture(base_map, base_uv.xy);
#else
  vec4 tex_base = vec4(1.0);
#endif
#if USE_NORMAL_TEXTURE
  vec2 normal_uv = BaseUV;
  vec3 tex_normal = normalize(texture(normal_map, normal_uv.xy).rgb * 2.0 - 1.0);
  mat3 tangent_matrix = mat3(tangent, binormal, normal);
  normal = normalize(tangent_matrix * tex_normal);
#endif  // USE_NORMAL_TEXTURE
  vec3 base_color = tex_base.xyz;
#else  // USE_TEXCOORD
  vec4 tex_base = vec4(1.0);
  vec3 base_color = tex_base.xyz;
#endif  // USE_TEXCOORD
#if !USE_VTX_COLOR
  vec4 Color = vec4(1.0);
#endif  // USE_VTX_COLOR
#if USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT
  vec3 diffuse_light  = vec3(0.0);
  vec3 specular_light  = vec3(0.0);
  parallel_specular_light(diffuse_light,specular_light,normal,eye_direction,specular_power.x, lit.xyz);
  point_specular_light(diffuse_light,specular_light,Position,normal,eye_direction,specular_power.x);
  spot_specular_light(diffuse_light,specular_light,Position,normal,eye_direction,specular_power.x);
  out_FragColor.xyz = vec3(0.0);
#if USE_DIFFUSE_LIGHT
  out_FragColor.xyz += base_color.xyz * diffuse_color.xyz/* * Color.xyz*/ * diffuse_light;
#endif
#if USE_SPECULAR_LIGHT
  out_FragColor.xyz += specular_color.xyz * specular_light;
#endif
#else
  out_FragColor.xyz = base_color.xyz * diffuse_color.xyz/* * Color.xyz*/;
#endif
#if USE_REFLECT_TEXTURE
  vec3 reflect_vector = -reflect(eye_direction, normal);
  vec4 tex_reflect = texture(reflection_map, reflect_vector);
  out_FragColor.xyz += tex_reflect.xyz * reflection_color.xyz * reflection_color.w;
#endif  // USE_REFLECT_TEXTURE

#if USE_PROJ_COLOR && SYS_PROJ_COLOR
  vec3 ambient_scale = textureLod(proj_color_map, ProjColorCoord.xy/ProjColorCoord.w * 0.5 + 0.5, 0.0).xyz;
#else
  vec3 ambient_scale = vec3(1.0);
#endif
#if USE_DIFFUSE_LIGHT
#if USE_REFLECT_AMBIENT_LIGHT
  out_FragColor.xyz += tex_base.xyz * (reflect_ambient_light_color.xyz * reflect_ambient_light_intensity.x);
#else
  out_FragColor.xyz += tex_base.xyz * ambient_light.xyz * ambient_scale.xyz;
#endif
#endif  // USE_DIFFUSE_LIGHT
  out_FragColor.xyz += emissive_color.xyz;
  out_FragColor.w = tex_base.a/* * Color.a*/;

  vec3 color = vec3(1.0);
#if BASE_TEXTURE_ALPHA_MODE == 0
  float alpha = 1.0;
#elif BASE_TEXTURE_ALPHA_MODE == 1
  float alpha = tex_base.a * base_tex_alpha_rate.x;
#endif  // BASE_TEXTURE_ALPHA_MODE
  if (Color.b < base_outline_expand_ratio.x) {
    color = base_outline_color.xyz;
  }

  color *= out_FragColor.xyz;

#if USE_REFLECT_AMBIENT_LIGHT
  color *= reflect_ambient_light_color.xyz * reflect_ambient_light_intensity.x;
#elif USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT || BASE_RIMLIGHTING_ENABLE
  color *= ambient_light.xyz * ambient_scale.xyz;
#endif

#if BASE_STAGELIGHTING_ENABLE
#if USE_REFLECT_POINT_LIGHT
  vec3 light_vector = normalize(-reflect_point_light_direction.xyz);
#elif USE_REFLECT_DIRECTIONAL_LIGHT
  vec3 light_vector = normalize(-reflect_directional_light_direction.xyz);
#elif USE_DEFAULT_DIRECTIONAL_LIGHT
  vec3 light_vector = normalize(-env_directionallight_0_vector.xyz);
#elif SYS_DIRECTIONAL_LIGHT_NUM > 0
  vec3 light_vector = normalize(-directional_light0[1].xyz);
#else
  vec3 light_vector = vec3(0.0, 0.0, 1.0);
#endif
  vec3 rim_normal_stage = normalize(normal2.xyz);

  float stage_light_value = (dot(rim_normal_stage, light_vector) + 1.0) * 0.5;
#if USE_VTX_COLOR_TO_STAGE_LIGHT
  stage_light_value *= Color.a;
#endif
  stage_light_value += base_stagelightshade_bias.x;
  stage_light_value = smoothstep(0.5 - base_stagelightborder_width.x, 0.5 + base_stagelightborder_width.x, stage_light_value);

  vec3 light_color = color;
  vec3 shade_color = blend_linear_burn(color, base_stagelightshade_color.xyz);
  color = mix(shade_color, light_color, stage_light_value);
#endif

#if BASE_RIMLIGHTING_ENABLE
  vec2 tex_rim_shade_uv = base_uv.xy;
  vec4 tex_rim_shade = texture(base_rimshade_map, tex_rim_shade_uv);

#if BASE_RIMMASK_MODE == 0
  float rim_area_rate = Color.a;
  float rim_density_rate = 1.0;
#elif BASE_RIMMASK_MODE == 1
  float rim_area_rate = 1.0;
  float rim_density_rate = Color.a;
#endif  // BASE_RIMMASK_MODE

  vec3 rim_normal = normal2;
  float rim_value = (1.0 - clamp(dot(rim_normal, eye_direction), 0.0, 1.0)) * rim_area_rate;
  float front_tol = smoothstep(base_rimlight_front_tol.x - base_rimlight_front_smooth.x,
                               base_rimlight_front_tol.x + base_rimlight_front_smooth.x,
                               rim_value);
  float back_tol = smoothstep(base_rimlight_back_tol.x - base_rimlight_back_smooth.x,
                              base_rimlight_back_tol.x + base_rimlight_back_smooth.x,
                              rim_value);

#if USE_REFLECT_POINT_LIGHT
  float light_value = dot(rim_normal, normalize(-reflect_point_light_direction.xyz));
#elif USE_REFLECT_DIRECTIONAL_LIGHT
  float light_value = dot(rim_normal, normalize(-reflect_directional_light_direction.xyz));
#elif USE_DEFAULT_DIRECTIONAL_LIGHT
  float light_value = dot(rim_normal, normalize(-env_directionallight_0_vector.xyz));
#elif SYS_DIRECTIONAL_LIGHT_NUM > 0
  float light_value = dot(rim_normal, normalize(-directional_light0[1].xyz));
#else
  float light_value = 1.0;
#endif

  float front_rim = front_tol * clamp(light_value, 0.0, 1.0);
  float back_rim = back_tol * clamp(-light_value, 0.0, 1.0);

  // front dark
  color = blendShade(color,
                     tex_rim_shade.rgb,
                     base_rimlight_front_mul_color.rgb,
                     base_rimshadefrontblend_rate.x,
                     front_rim * rim_density_rate);
  // back dark
  color = blendShade(color,
                     tex_rim_shade.rgb,
                     base_rimlight_back_mul_color.rgb,
                     base_rimshadebackblend_rate.x,
                     back_rim * rim_density_rate);
#if USE_REFLECT_POINT_LIGHT
  // front light
  color = blend_rim_light(color,
                          base_rimlight_front_add_color.rgb * reflect_point_light_color.xyz * reflect_point_light_intensity.x * rim_density_rate,
                          front_rim);
  // back dark
  color = blend_rim_light(color,
                          base_rimlight_back_add_color.rgb * reflect_point_light_color.xyz * reflect_point_light_intensity.x * rim_density_rate,
                          back_rim);
#elif USE_REFLECT_DIRECTIONAL_LIGHT
  // front light
  color = blend_rim_light(color,
                          base_rimlight_front_add_color.rgb * reflect_directional_light_color.xyz * reflect_directional_light_intensity.x * rim_density_rate,
                          front_rim);
  // back dark
  color = blend_rim_light(color,
                          base_rimlight_back_add_color.rgb * reflect_directional_light_color.xyz * reflect_directional_light_intensity.x * rim_density_rate,
                          back_rim);
#elif USE_DEFAULT_DIRECTIONAL_LIGHT
  // front light
  color = blend_rim_light(color,
                          base_rimlight_front_add_color.rgb * env_directionallight_0_color.xyz * env_directionallight_0_intensity.x * rim_density_rate,
                          front_rim);
  // back dark
  color = blend_rim_light(color,
                          base_rimlight_back_add_color.rgb * env_directionallight_0_color.xyz * env_directionallight_0_intensity.x * rim_density_rate,
                          back_rim);
#elif SYS_DIRECTIONAL_LIGHT_NUM > 0
  // front light
  color = blend_rim_light(color,
                          base_rimlight_front_add_color.rgb * directional_light0[0].xyz * directional_light0[0].w * Color.a,
                          front_rim);
  // back dark
  color = blend_rim_light(color,
                          base_rimlight_back_add_color.rgb * directional_light0[0].xyz * directional_light0[0].w * Color.a,
                          back_rim);
#endif
#endif

#if BASE_SPECULARLIGHTING_ENABLE
#if USE_REFLECT_SPECULAR_LIGHT
  vec3 specular = reflect_specular_light_color.xyz;
  vec3 specular_light_vector = reflect_specular_light_direction.xyz;
  float specular_power = reflect_specular_light_intensity.x;
#else
  vec3 specular = base_specularcolor.xyz;
  vec3 specular_light_vector = CameraDirection;
  float specular_power = base_specularpower.x;
#endif // USE_REFLECT_SPECULAR_LIGHT
  vec3 rim_normal_specular = normalize(normal2.xyz);
  vec3 eye_vector = CameraDirection;
  float specular_value = pow(max(dot(rim_normal_specular, normalize(eye_vector + specular_light_vector)), 0.0), specular_power);
  color += (specular * specular_value * (1.0 - tex_base.a));
#endif

  out_FragColor = vec4(color, alpha);

#if USE_OUTLINE
  out_FragColor = vec4(1.0, 1.0, 1.0, alpha);
#if USE_BASE_TEXTURE
  out_FragColor.xyz *= tex_base.xyz * base_outline_color.xyz;
#if USE_REFLECT_AMBIENT_LIGHT
  out_FragColor.xyz *= reflect_ambient_light_color.xyz * reflect_ambient_light_intensity.x;
#elif USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT || BASE_RIMLIGHTING_ENABLE
  out_FragColor.xyz *= ambient_light.xyz * ambient_scale.xyz;
#endif
#else
  out_FragColor.xyz *= base_outline_color.xyz;
#if USE_REFLECT_AMBIENT_LIGHT
  out_FragColor.xyz *= reflect_ambient_light_color.xyz * reflect_ambient_light_intensity.x;
#elif USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT || BASE_RIMLIGHTING_ENABLE
  out_FragColor.xyz *= ambient_light.xyz * ambient_scale.xyz;
#endif // USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT || BASE_RIMLIGHTING_ENABLE
#endif // USE_BASE_TEXTURE
#endif // USE_OUTLINE

#if USE_NOSELINE
#if !NOSELINE_SHOW_ENABLE
  discard;
#endif
  vec3 eye = normalize(vec3(eye_direction.x, 0.0, eye_direction.z));
  float cv = dot(normal, eye_direction);
  cv = (cv + 1.0) * 0.5;

  if (Color.a > 0.5) {
    cv += base_nose_displayright_bias.x;
  } else {
    cv += base_nose_displayleft_bias.x;
  }
  vec3 nose_color = base_outline_color.xyz;
  float nose_alpha = 1.0;

#if BASE_TEX_BASE_ENABLE
  float vis = smoothstep(Color.r, Color.g, cv);
  nose_color = base_color.xyz * base_outline_color.xyz;
#if USE_REFLECT_AMBIENT_LIGHT
  nose_color *= reflect_ambient_light_color.xyz * reflect_ambient_light_intensity.x;
#elif USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT || BASE_RIMLIGHTING_ENABLE
  nose_color *= ambient_light.xyz * ambient_scale.xyz;
#endif
  nose_alpha = vis;
#endif

  if (nose_alpha < 1.0) {
    discard;
  }
  out_FragColor = vec4(nose_color, alpha);
#endif

#if USE_EYELID_LINE
#if !BASE_ELELIDLINE_SHOWRIGHT_ENABLE
  if (Color.a < 0.5) {
    discard;
  }
#endif  // BASE_ELELIDLINE_SHOWRIGHT_ENABLE
#if !BASE_EYELIDLINE_SHOWLEFT_ENABLE
  if (Color.a > 0.5) {
    discard;
  }
#endif  // BASE_EYELIDLINE_SHOWLEFT_ENABLE
#endif  // USE_EYELID_LINE

#if USE_FACE_SHADOW
  out_FragColor = face_shadow_color;
  out_FragColor.w *= alpha;
#endif

#if USE_SPHERE_FOG
  float sphere_fog_ratio = clamp((SphereFogDistance[0] - sphere_fog_parameter[0].y) * sphere_fog_parameter[0].x, 0.0, 1.0) * sphere_fog_color[0].w;
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - sphere_fog_ratio), sphere_fog_parameter[0].z)) + (sphere_fog_color[0].xyz * sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, sphere_fog_color[0].xyz, sphere_fog_ratio);
#if SPHERE_FOG_COUNT >= 2
  sphere_fog_ratio = clamp((SphereFogDistance[1] - sphere_fog_parameter[1].y) * sphere_fog_parameter[1].x, 0.0, 1.0) * sphere_fog_color[1].w;
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - sphere_fog_ratio), sphere_fog_parameter[1].z)) + (sphere_fog_color[1].xyz * sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, sphere_fog_color[1].xyz, sphere_fog_ratio);
#endif
#endif  // USE_SPHERE_FOG

#if USE_SPHERE_FOG_REVERSE
  float rev_sphere_fog_ratio = clamp((rev_sphere_fog_parameter[0].y - RevSphereFogDistance[0]) * rev_sphere_fog_parameter[0].x, 0.0, 1.0) * rev_sphere_fog_color[0].w;
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - rev_sphere_fog_ratio), rev_sphere_fog_parameter[0].z)) + (rev_sphere_fog_color[0].xyz * rev_sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, rev_sphere_fog_color[0].xyz, rev_sphere_fog_ratio);
#if SPHERE_FOG_REVERSE_COUNT >= 2
  rev_sphere_fog_ratio = clamp((rev_sphere_fog_parameter[1].y - RevSphereFogDistance[1]) * rev_sphere_fog_parameter[1].x, 0.0, 1.0) * rev_sphere_fog_color[1].w;
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - rev_sphere_fog_ratio), rev_sphere_fog_parameter[1].z)) + (rev_sphere_fog_color[1].xyz * rev_sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, rev_sphere_fog_color[1].xyz, rev_sphere_fog_ratio);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 3
  rev_sphere_fog_ratio = clamp((rev_sphere_fog_parameter[2].y - RevSphereFogDistance[2]) * rev_sphere_fog_parameter[2].x, 0.0, 1.0) * rev_sphere_fog_color[2].w;
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - rev_sphere_fog_ratio), rev_sphere_fog_parameter[2].z)) + (rev_sphere_fog_color[2].xyz * rev_sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, rev_sphere_fog_color[2].xyz, rev_sphere_fog_ratio);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 4
  rev_sphere_fog_ratio = clamp((rev_sphere_fog_parameter[3].y - RevSphereFogDistance[3]) * rev_sphere_fog_parameter[3].x, 0.0, 1.0) * rev_sphere_fog_color[3].w;
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - rev_sphere_fog_ratio), rev_sphere_fog_parameter[3].z)) + (rev_sphere_fog_color[3].xyz * rev_sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, rev_sphere_fog_color[3].xyz, rev_sphere_fog_ratio);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 5
  rev_sphere_fog_ratio = clamp((rev_sphere_fog_parameter[4].y - RevSphereFogDistance[4]) * rev_sphere_fog_parameter[4].x, 0.0, 1.0) * rev_sphere_fog_color[4].w;
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - rev_sphere_fog_ratio), rev_sphere_fog_parameter[4].z)) + (rev_sphere_fog_color[4].xyz * rev_sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, rev_sphere_fog_color[4].xyz, rev_sphere_fog_ratio);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 6
  rev_sphere_fog_ratio = clamp((rev_sphere_fog_parameter[5].y - RevSphereFogDistance[5]) * rev_sphere_fog_parameter[5].x, 0.0, 1.0) * rev_sphere_fog_color[5].w;
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - rev_sphere_fog_ratio), rev_sphere_fog_parameter[5].z)) + (rev_sphere_fog_color[5].xyz * rev_sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, rev_sphere_fog_color[5].xyz, rev_sphere_fog_ratio);
#endif
#endif  // USE_SPHERE_FOG_REVERSE

  out_FragColor *= color_scale;

#if USE_DITHER
  out_FragColor.w *= calc_dither(dither_param.x);
#elif USE_ALPHA_TO_COVERAGE
  out_FragColor.w *= (1.0 - a2c_param.x);
#endif // USE_DITHER

#if USE_ALPHA_CUTOFF
  if (out_FragColor.w < alpha_cutoff.x) {
    discard;
  }
#elif USE_DITHER
  if (out_FragColor.w < 1.0/255.0) {
    discard;
  }
#endif
}
^`  #version 450
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
// defines
#if !defined(USE_DIFFUSE_LIGHT)
# define USE_DIFFUSE_LIGHT 0
#endif

#if !defined(USE_SPECULAR_LIGHT)
# define USE_SPECULAR_LIGHT 0
#endif

#if !defined(USE_BASE_TEXTURE)
# define USE_BASE_TEXTURE 0
#endif // USE_BASE_TEXTURE

#if !defined(USE_NORMAL_TEXTURE)
# define USE_NORMAL_TEXTURE 0
#endif // USE_NORMAL_TEXTURE

#if !defined(USE_REFLECT_TEXTURE)
# define USE_REFLECT_TEXTURE 0
#endif  // USE_REFLECT_TEXTURE

#if !defined(USE_ALPHA_CUTOFF)
# define USE_ALPHA_CUTOFF 0
#endif  // USE_ALPHA_CUTOFF

#if !defined(USE_FOG)
# define USE_FOG 0
#endif  // USE_FOG

#if !defined(USE_VTX_COLOR)
# define USE_VTX_COLOR 0
#endif

#if !defined(USE_VTX_COLOR_TO_STAGE_LIGHT)
# define USE_VTX_COLOR_TO_STAGE_LIGHT 0
#endif

#if !defined(USE_DITHER)
# define USE_DITHER 0
#endif // USE_DITHER

#if !defined(USE_ALPHA_TO_COVERAGE)
#define USE_ALPHA_TO_COVERAGE 0
#endif // USE_ALPHA_TO_COVERAGE

#if !defined(USE_PROJ_SHADOW)
# define USE_PROJ_SHADOW 0
#endif

#if !defined(USE_PROJ_COLOR)
# define USE_PROJ_COLOR 0
#endif

#if !defined(BASE_OUTLINEREVISE_ENABLE)
# define BASE_OUTLINEREVISE_ENABLE 0
#endif

#if !defined(BASE_RIMLIGHT_USECUSTOMNORMAL)
# define BASE_RIMLIGHT_USECUSTOMNORMAL 0
#endif

#if !defined(BASE_SPECULARLIGHTING_ENABLE)
# define BASE_SPECULARLIGHTING_ENABLE 0
#endif

#if !defined(BASE_STAGELIGHTING_ENABLE)
# define BASE_STAGELIGHTING_ENABLE 0
#endif

#if !defined(BASE_RIMLIGHTING_ENABLE)
# define BASE_RIMLIGHTING_ENABLE 0
#endif

#if !defined(BASE_TEX_RIMSHADE_ENABLE)
# define BASE_TEX_RIMSHADE_ENABLE 0
#endif

#if BASE_RIMLIGHTING_ENABLE
# if !defined(BASE_RIMMASK_MODE)
#  define BASE_RIMMASK_MODE 0
# endif
#endif

#if !defined(BASE_SPECULARLIGHTING_ENABLE)
# define BASE_SPECULARLIGHTING_ENABLE 0
#endif

#if !defined(BASE_TEX_BASE_ENABLE)
# define BASE_TEX_BASE_ENABLE 0
#endif // BASE_TEX_BASE_ENABLE

#if !defined(BASE_TEXTURE_ALPHA_MODE)
# define BASE_TEXTURE_ALPHA_MODE 0
#endif  // BASE_TEXTURE_ALPHA_MODE

#if !defined(USE_OUTLINE)
# define USE_OUTLINE 0
#endif

#if !defined(USE_NOSELINE)
#define USE_NOSELINE 0
#endif

#if !defined(USE_EYELID_LINE)
# define USE_EYELID_LINE 0
#endif

#if !defined(BASE_EYELIDLINE_SHOWLEFT_ENABLE)
# define BASE_EYELIDLINE_SHOWLEFT_ENABLE 0
#endif

#if !defined(BASE_ELELIDLINE_SHOWRIGHT_ENABLE)
# define BASE_ELELIDLINE_SHOWRIGHT_ENABLE 0
#endif

#if !defined(NOSELINE_SHOW_ENABLE)
# define NOSELINE_SHOW_ENABLE 0
#endif

#if !defined(USE_FACE_SHADOW)
# define USE_FACE_SHADOW 0
#endif

#if !defined(USE_BLEND_SHAPE)
# define USE_BLEND_SHAPE 0
#endif

#if !defined(USE_REFLECT_DIRECTIONAL_LIGHT)
# define USE_REFLECT_DIRECTIONAL_LIGHT 0
#endif

#if !defined(USE_REFLECT_POINT_LIGHT)
# define USE_REFLECT_POINT_LIGHT 0
#endif

#if !defined(USE_DEFAULT_DIRECTIONAL_LIGHT)
# define USE_DEFAULT_DIRECTIONAL_LIGHT 0
#endif

#if !defined(USE_REFLECT_AMBIENT_LIGHT)
# define USE_REFLECT_AMBIENT_LIGHT 0
#endif

#if !defined(USE_REFLECT_SPECULAR_LIGHT)
# define USE_REFLECT_SPECULAR_LIGHT 0
#endif

#if USE_BASE_TEXTURE || USE_NORMAL_TEXTURE || BASE_TEX_RIMSHADE_ENABLE
# define USE_TEXCOORD 1
# define UV_ENABLE 1
#else
# define USE_TEXCOORD 0
# define UV_ENABLE 0
#endif

#if USE_REFLECT_TEXTURE || USE_DIFFUSE_LIGHT || USE_NORMAL_TEXTURE || BASE_RIMLIGHTING_ENABLE || BASE_RIMLIGHT_USECUSTOMNORMAL || BASE_SPECULARLIGHTING_ENABLE || USE_OUTLINE || USE_NOSELINE
# define USE_NORMAL 1
# define USE_EYE_DIRECTION 1
#else
# define USE_NORMAL 0
# define USE_EYE_DIRECTION 0
#endif

#if BASE_SPECULARLIGHTING_ENABLE
# define USE_CAMERA_DIRECTION 1
#else
# define USE_CAMERA_DIRECTION 0
#endif

#if !defined(USE_SPHERE_FOG)
# define USE_SPHERE_FOG 0
#endif
#if SPHERE_FOG_COUNT == 0
# define USE_SPHERE_FOG 0
#endif
#if !defined(USE_SPHERE_FOG_REVERSE)
# define USE_SPHERE_FOG_REVERSE 0
#endif
#if SPHERE_FOG_REVERSE_COUNT == 0
# define USE_SPHERE_FOG_REVERSE 0
#endif

#if !defined(VULKAN)
precision HIGHP sampler2DShadow;
#endif
//
//shader-maker
//

layout(location = 0) in vec3 position;
#if USE_NORMAL
layout(location = 1) in vec3 normal;
#endif
#if USE_NORMAL_TEXTURE
layout(location = 2) in vec3 binormal;
#endif
#if USE_NORMAL_TEXTURE
layout(location = 3) in vec3 tangent;
#endif
#if USE_VTX_COLOR
layout(location = 4) in vec4 color;
#endif
#if BASE_RIMLIGHT_USECUSTOMNORMAL
layout(location = 5) in vec4 color2;
#endif
#if USE_TEXCOORD
layout(location = 6) in vec2 texcoord;
#endif
#if SYS_SKINNING
layout(location = 7) in uvec4 skinindex;
#endif
#if SYS_SKINNING
layout(location = 8) in vec4 skinweight;
#endif
#if SYS_DRAW_INSTANCED
layout(location = 9) in mat4 world;
#endif
#if USE_UVREGION1
layout(location = 13) in vec4 uvregion1;
#endif
#if USE_UVREGION2
layout(location = 14) in vec4 uvregion2;
#endif
layout(location = 0) out vec3 Position;
#if USE_NORMAL
layout(location = 1) out vec3 Normal;
#endif
#if USE_NORMAL_TEXTURE
layout(location = 2) out vec3 Binormal;
#endif
#if USE_NORMAL_TEXTURE
layout(location = 3) out vec3 Tangent;
#endif
#if USE_VTX_COLOR
layout(location = 4) out vec4 Color;
#endif
#if USE_EYE_DIRECTION
layout(location = 5) out vec3 EyeDirection;
#endif
#if USE_TEXCOORD
layout(location = 6) out vec2 BaseUV;
#endif
#if USE_FOG
layout(location = 7) out vec4 FogCoef;
#endif
#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
layout(location = 8) out vec4 ShadowCoordDir0_0;
#endif
#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW && SYS_SHADOW_COUNT >= 2
layout(location = 9) out vec4 ShadowCoordDir0_1;
#endif
#if USE_PROJ_COLOR && SYS_PROJ_COLOR
layout(location = 10) out vec4 ProjColorCoord;
#endif
#if USE_UVREGION1
layout(location = 11) out vec4 UVRegion1;
#endif
#if USE_UVREGION2
layout(location = 12) out vec4 UVRegion2;
#endif
#if USE_SPHERE_FOG
layout(location = 13) out float SphereFogDistance[2];
#endif
#if USE_SPHERE_FOG_REVERSE
layout(location = 15) out float RevSphereFogDistance[6];
#endif
#if USE_CAMERA_DIRECTION
layout(location = 21) out vec3 CameraDirection;
#endif
layout(location = 22) out vec3 Normal2;
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

#if USE_PROJ_COLOR && SYS_PROJ_COLOR
layout(set=3, binding = 0) uniform sampler2D proj_color_map;
#endif
#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
# if SYS_SHADOW_TYPE == 0
layout(set=3, binding=1) uniform sampler2DShadow proj_map0;
# else
layout(set=3, binding=1) uniform sampler2D proj_map0;
# endif
# if SYS_SHADOW_COUNT >= 2
#  if SYS_SHADOW_TYPE == 0
layout(set=3, binding=2) uniform sampler2DShadow proj_map1;
#  else
layout(set=3, binding=2) uniform sampler2D proj_map1;
#  endif
# endif
#endif
//
//shader-maker
//

//
// Material uniform parameters:
//
layout(set=2, binding=2) uniform MaterialUniformParametersUbo {
  vec4 dither_param; //vec4
  vec4 a2c_param; //float
  vec4 alpha_cutoff; //vec4
  vec4 diffuse_color; //vec3
  vec4 emissive_color; //vec3
  vec4 replace_color; //vec4
  vec4 env_directionallight_0_intensity; //float
  vec4 env_directionallight_0_color; //vec3
  vec4 env_directionallight_0_vector; //vec4
  vec4 base_stagelightborder_width; //float
  vec4 base_stagelightshade_bias; //float
  vec4 base_stagelightshade_color; //vec3
  vec4 base_rimadd_rate; //float
  vec4 base_rimmul_rate; //float
  vec4 base_rimlight_front_add_color; //vec3
  vec4 base_rimlight_front_mul_color; //vec3
  vec4 base_rimlight_back_add_color; //vec3
  vec4 base_rimlight_back_mul_color; //vec3
  vec4 base_rimfront_shade_add_color; //vec3
  vec4 base_rimfront_shade_mul_color; //vec3
  vec4 base_tex_alpha_rate; //float
  vec4 uv_shift; //vec2
  vec4 base_outline_revise_distance; //float
  vec4 base_outline_revise_ratio; //float
  vec4 base_outline_width; //float
  vec4 base_outline_shift; //float
  vec4 base_outline_expand_ratio; //float
  vec4 base_outline_color; //vec3
  vec4 base_rimlight_front_tol; //float
  vec4 base_rimlight_back_tol; //float
  vec4 base_rimfront_shade_tol; //float
  vec4 base_rimlight_front_smooth; //float
  vec4 base_rimlight_back_smooth; //float
  vec4 base_rimfront_shade_smooth; //float
  vec4 base_rimshadefrontblend_rate; //float
  vec4 base_rimshadebackblend_rate; //float
  vec4 base_rimfrontshadeblend_rate; //float
  vec4 base_rimfrontshade_intensity; //float
  vec4 base_specularcolor; //vec3
  vec4 base_specularpower; //float
  vec4 base_nose_displayleft_bias; //float
  vec4 base_nose_displayright_bias; //float
  vec4 face_shadow_color; //vec4
  vec4 face_shadow_shift; //vec3
  vec4 face_shadow_front; //vec3
  vec4 blend_shape_ratio; //vec4
  vec4 blend_shape_eye_ratio; //vec4
  vec4 blend_shape_index0; //vec4
  vec4 blend_shape_index1; //vec4
  vec4 reflect_directional_light_color; //vec3
  vec4 reflect_directional_light_intensity; //float
  vec4 reflect_directional_light_direction; //vec3
  vec4 reflect_point_light_color; //vec3
  vec4 reflect_point_light_intensity; //float
  vec4 reflect_point_light_direction; //vec3
  vec4 reflect_ambient_light_color; //vec3
  vec4 reflect_ambient_light_intensity; //float
  vec4 reflect_specular_light_color; //vec3
  vec4 reflect_specular_light_intensity; //float
  vec4 reflect_specular_light_direction; //vec3
  vec4 texcoord_matrix[2];
} u_material_parameters;

//
// Material texture-samplers:
//
layout(set=2, binding=3) uniform sampler2D base_map;
layout(set=2, binding=4) uniform sampler2D base_rimshade_map;

//
// Material buffer block bindings:
//
#if (USE_SPHERE_FOG || USE_SPHERE_FOG_REVERSE) && (SPHERE_FOG_COUNT > 0 || SPHERE_FOG_REVERSE_COUNT > 0)
layout(set=2, binding=5) uniform SphereFogUbo {
  vec4 sphere_fog_center[2];
  vec4 sphere_fog_parameter[2];
  vec4 sphere_fog_color[2];
  vec4 sphere_fog_density[2];
  vec4 rev_sphere_fog_center[6];
  vec4 rev_sphere_fog_parameter[6];
  vec4 rev_sphere_fog_color[6];
  vec4 rev_sphere_fog_density[6];
} u_sphere_fog;
#endif

//------------
// functions
#if SYS_SKINNING
vec4 getbonevector(in int index) {
#if SYS_BONE_TEXTURE
  return texelFetch(bone_map, ivec2(index, 0), 0);
#else
  return SkeletonArray(matrix_palette, index);
#endif
}
vec4 skinningP(in vec4 in_position, in uvec4 in_skinindex, in vec4 in_skinweight) {
  vec4 out_position;
  ivec4 index = ivec4(in_skinindex) * 3;
  out_position.x  = dot(getbonevector(index.x+0), in_position) * in_skinweight.x;
  out_position.y  = dot(getbonevector(index.x+1), in_position) * in_skinweight.x;
  out_position.z  = dot(getbonevector(index.x+2), in_position) * in_skinweight.x;
  out_position.x += dot(getbonevector(index.y+0), in_position) * in_skinweight.y;
  out_position.y += dot(getbonevector(index.y+1), in_position) * in_skinweight.y;
  out_position.z += dot(getbonevector(index.y+2), in_position) * in_skinweight.y;
  out_position.x += dot(getbonevector(index.z+0), in_position) * in_skinweight.z;
  out_position.y += dot(getbonevector(index.z+1), in_position) * in_skinweight.z;
  out_position.z += dot(getbonevector(index.z+2), in_position) * in_skinweight.z;
  out_position.x += dot(getbonevector(index.w+0), in_position) * in_skinweight.w;
  out_position.y += dot(getbonevector(index.w+1), in_position) * in_skinweight.w;
  out_position.z += dot(getbonevector(index.w+2), in_position) * in_skinweight.w;
  out_position.w = 1.0;
  return out_position;
}
vec4 skinningN(in vec4 in_normal, in uvec4 in_skinindex, in vec4 in_skinweight) {
  vec4 out_normal;
  ivec4 index = ivec4(in_skinindex) * 3;
  out_normal.x  = dot(getbonevector(index.x+0), in_normal) * in_skinweight.x;
  out_normal.y  = dot(getbonevector(index.x+1), in_normal) * in_skinweight.x;
  out_normal.z  = dot(getbonevector(index.x+2), in_normal) * in_skinweight.x;
  out_normal.x += dot(getbonevector(index.y+0), in_normal) * in_skinweight.y;
  out_normal.y += dot(getbonevector(index.y+1), in_normal) * in_skinweight.y;
  out_normal.z += dot(getbonevector(index.y+2), in_normal) * in_skinweight.y;
  out_normal.x += dot(getbonevector(index.z+0), in_normal) * in_skinweight.z;
  out_normal.y += dot(getbonevector(index.z+1), in_normal) * in_skinweight.z;
  out_normal.z += dot(getbonevector(index.z+2), in_normal) * in_skinweight.z;
  out_normal.x += dot(getbonevector(index.w+0), in_normal) * in_skinweight.w;
  out_normal.y += dot(getbonevector(index.w+1), in_normal) * in_skinweight.w;
  out_normal.z += dot(getbonevector(index.w+2), in_normal) * in_skinweight.w;
  out_normal.w = 0.0;
  return out_normal;
}
#endif  // USE_SKINNING

#if USE_TEXCOORD && UV_ENABLE
vec2 apply_texcoord_matrix(in vec4 matrix0, in vec4 matrix1, in vec2 uv) {
  vec4 tmp_texcoord = vec4(uv, 0.0, 1.0);
  vec2 result;
  result.x = dot(matrix0, tmp_texcoord);
  result.y = dot(matrix1, tmp_texcoord);
  return result;
}
#endif

mat4 get_world_matrix() {
#if SYS_DRAW_INSTANCED
  return wordl;
#else
  return Transform(model);
#endif //SYS_DRAW_INSTANCED
}
#if defined(VULKAN)
# line 3 "g2_chara_vs.h"
#endif

// functions
void normalEdit(in mat4 in_world, vec4 in_normal, in vec4 in_color2,
                inout vec3 out_normal, inout vec3 out_normal2) {
//#if BASE_RIMLIGHT_USECUSTOMNORMAL
  mat4 tmp_world = transpose(inverse(in_world));
  out_normal = normalize((tmp_world * in_normal).xyz);
  out_normal2 = normalize((tmp_world * in_color2).xyz);
//#else  // BASE_RIMLIGHT_USECUSTOMNORMAL
//  mat4 tmp_world = transpose(inverse(in_world));
//  out_normal = normalize((tmp_world * in_normal).xyz);
//  out_normal2 = out_normal;
//#endif  // BASE_RIMLIGHT_USECUSTOMNORMAL
}
#if SYS_VERTEX_TEXTURE && USE_BLEND_SHAPE
ivec2 calc_shape_uv(in int vertexid, in float shape_index, in int texture_width) {
  int idx = vertexid + (Geometry(vertex_count).x * int(shape_index)) * 2;
  int v = idx / texture_width;
  int u = idx - v * texture_width;
  return ivec2(u, v);
}
vec4 fetch_blend_shape(ivec2 p) {
  return texelFetch(vertex_map, p, 0);
}
#endif

// program
void main(){;
#if SYS_VERTEX_TEXTURE && USE_BLEND_SHAPE
# if defined(VULKAN)
  int pos_idx = gl_VertexIndex * 2;
# else
  int pos_idx = gl_VertexID * 2;
# endif
  int texture_width = textureSize(vertex_map, 0).x;
  ivec2 uv_00 = calc_shape_uv(pos_idx, Material(blend_shape_index0).x, texture_width);
  ivec2 uv_01 = calc_shape_uv(pos_idx, Material(blend_shape_index1).x, texture_width);
  ivec2 uv_10 = calc_shape_uv(pos_idx, Material(blend_shape_index0).y, texture_width);
  ivec2 uv_11 = calc_shape_uv(pos_idx, Material(blend_shape_index1).y, texture_width);
  ivec2 uv_30 = calc_shape_uv(pos_idx, Material(blend_shape_index0).w, texture_width);
  ivec2 uv_31 = calc_shape_uv(pos_idx, Material(blend_shape_index1).w, texture_width);

  vec4 tmp_position = vec4( mix(fetch_blend_shape(uv_00).xyz, fetch_blend_shape(uv_01).xyz, Material(blend_shape_ratio).x), 1.0);
  tmp_position.xyz +=       mix(fetch_blend_shape(uv_10).xyz, fetch_blend_shape(uv_11).xyz, Material(blend_shape_ratio).y);
  tmp_position.xyz +=           fetch_blend_shape(uv_30).xyz * Material(blend_shape_eye_ratio).x + fetch_blend_shape(uv_31).xyz * Material(blend_shape_eye_ratio).y;
  tmp_position.xyz += position.xyz;
#else
  vec4 tmp_position = vec4(position.xyz, 1.0);
#endif
#if USE_NORMAL
#if SYS_VERTEX_TEXTURE && USE_BLEND_SHAPE
  vec4 tmp_normal = vec4( mix(texelFetch(vertex_map, uv_00 + ivec2(1, 0), 0).xyz, texelFetch(vertex_map, uv_01 + ivec2(1, 0), 0).xyz, Material(blend_shape_ratio).x), 0.0);
  tmp_normal.xyz +=       mix(texelFetch(vertex_map, uv_10 + ivec2(1, 0), 0).xyz, texelFetch(vertex_map, uv_11 + ivec2(1, 0), 0).xyz, Material(blend_shape_ratio).y);
  tmp_normal.xyz +=           texelFetch(vertex_map, uv_30 + ivec2(1, 0), 0).xyz * Material(blend_shape_eye_ratio).x + texelFetch(vertex_map, uv_31 + ivec2(1, 0), 0).xyz * Material(blend_shape_eye_ratio).y;
  tmp_normal.xyz += normalize(normal.xyz);
#else
  vec4 tmp_normal   = vec4(normal, 0.0);
#endif
#endif  // USE_NORMAL
#if USE_NORMAL_TEXTURE
  vec4 tmp_binormal = vec4(binormal, 0.0);
  vec4 tmp_tangent  = vec4(tangent, 0.0);
#endif  // USE_NORMAL_TEXTURE
#if BASE_RIMLIGHT_USECUSTOMNORMAL
  vec4 tmp_normal2  = vec4(color2.xyz, 0.0);
#else  // BASE_RIMLIGHT_USECUSTOMNORMAL
  vec4 tmp_normal2  = vec4(0.0);
#endif  // BASE_RIMLIGHT_USECUSTOMNORMAL
#if SYS_SKINNING
  tmp_position = Skeleton(bindpose) * tmp_position;
  tmp_position = skinningP(tmp_position, skinindex, skinweight);
  tmp_position = Skeleton(bindpose_inverse) * tmp_position;
#if USE_NORMAL
  tmp_normal   = Skeleton(bindpose) * tmp_normal;
  tmp_normal   = skinningN(tmp_normal, skinindex, skinweight);
  tmp_normal   = Skeleton(bindpose_inverse) * tmp_normal;
#endif  // USE_NORMAL
#if USE_NORMAL_TEXTURE
  tmp_binormal = Skeleton(bindpose) * tmp_binormal;
  tmp_tangent  = Skeleton(bindpose) * tmp_tangent;
  tmp_binormal = skinningN(tmp_binormal, skinindex, skinweight);
  tmp_tangent  = skinningN(tmp_tangent, skinindex, skinweight);
  tmp_binormal = Skeleton(bindpose_inverse) * tmp_binormal;
  tmp_tangent  = Skeleton(bindpose_inverse) * tmp_tangent;
#endif  // USE_NORMAL_TEXTURE
  tmp_normal2   = Skeleton(bindpose) * tmp_normal2;
  tmp_normal2   = skinningN(tmp_normal2, skinindex, skinweight);
  tmp_normal2   = Skeleton(bindpose_inverse) * tmp_normal2;
#endif  // SYS_SKINNING

#if !SYS_DRAW_INSTANCED
  mat4 world = Transform(model);
#endif //!SYS_DRAW_INSTANCED
  gl_Position = Camera(projection) * Camera(view) * world * tmp_position;
  Position    = (world * tmp_position).xyz;
#if USE_NORMAL
  normalEdit(world, tmp_normal, tmp_normal2, Normal, Normal2);
#endif  // USE_NORMAL
#if USE_NORMAL_TEXTURE
  Binormal    = normalize((world * tmp_binormal).xyz);
  Tangent     = normalize((world * tmp_tangent).xyz);
#endif  // USE_NORMAL_TEXTURE

#if USE_VTX_COLOR
  Color   = color;
#endif  // USE_VTX_COLOR
#if USE_EYE_DIRECTION
  EyeDirection = normalize(Camera(eye_position).xyz - Position);
#endif  // USE_EYE_DIRECTION
#if USE_CAMERA_DIRECTION
  CameraDirection = normalize(Camera(view)[2].xyz);
#endif
#if USE_TEXCOORD
  BaseUV.xy      = texcoord;
# if UV_SHIFT_ENABLE
  BaseUV.xy += Material(uv_shift).xy;
# endif  // UV_SHIFT_ENABLE
#if UV_ENABLE
  vec4 tmp_texcoord = vec4(BaseUV.xy, 0.0, 1.0);
  BaseUV.x = dot(MaterialArray(texcoord_matrix, 0), tmp_texcoord);
  BaseUV.y = dot(MaterialArray(texcoord_matrix, 1), tmp_texcoord);
#endif  // UV_ENABLE
#endif  // USE_TEXCOORD

#if USE_OUTLINE
  float revise_rate = 1.0;

//#if BASE_OUTLINEREVISE_ENABLE
  vec3 vertex_pos = (Camera(view) * world * vec4(tmp_position.xyz, 1.0)).xyz;
  float vertex_dist = max(0.0, -vertex_pos.z);

  float distance = vertex_dist;

#if 1
  float tan15 = 0.26794919243;// tan(30/2)
  float fov_adjust = Camera(projection)[1][1] * tan15;

  distance = vertex_dist / fov_adjust;
#endif

  if (distance < Material(base_outline_revise_distance).x) {
    revise_rate = distance / Material(base_outline_revise_distance).x;
  } else {
    revise_rate = distance * Material(base_outline_revise_ratio).x / Material(base_outline_revise_distance).x + 1.0 - Material(base_outline_revise_ratio).x;
  }
  //float step_dst = step(Material(base_outline_revise_distance).x, distance);
  //revise_rate = distance * mix(1.0, Material(base_outline_revise_ratio).x, step_dst) / Material(base_outline_revise_distance).x + mix(0.0, (1.0 - Material(base_outline_revise_ratio).x), step_dst);
//#endif  // BASE_OUTLINEREVISE_ENABLE

  // if Camera(projection)[3][3] == 0.0 then * 1.0, else * 0.0
  revise_rate *= 1.0 - abs(sign(Camera(projection)[3][3]));

#if USE_VTX_COLOR
  // vec3 view_normal = normalize(mat3(transpose(inverse(Camera(view) * world))) * Normal.xyz);
  vec3 view_normal = normalize(mat3(transpose(inverse(Camera(view) * world))) * tmp_normal.xyz);
  vec2 offset = mat2(Camera(projection)) * view_normal.xy;
  gl_Position.xy += offset * Material(base_outline_width).x * color.r * revise_rate;
  gl_Position.z += Material(base_outline_shift).x * (1.0 - color.g);
#endif
#endif

#if USE_FACE_SHADOW
  float inner = dot(Material(face_shadow_front).xyz, EyeDirection.xyz);
  float threshold = 0.3420;   // 0.3420 = cos(toRadian(70))
  inner = max(inner, threshold);

  mat4 tmp_view = Camera(view);
  tmp_view[3].xyz += Material(face_shadow_shift).xyz * inner;
  gl_Position = Camera(projection) * tmp_view * world * tmp_position;
#endif

#if USE_FOG
  FogCoef.x = (Camera(fog_parameter).y - gl_Position.w) * (1.0 / (Camera(fog_parameter).y - Camera(fog_parameter).x));
  FogCoef.yzw = vec3(0.0);
#endif  // USE_FOG

#if USE_SPHERE_FOG
  SphereFogDistance[0] = length(Position - u_sphere_fog.sphere_fog_center[0].xyz);
#if SPHERE_FOG_COUNT >= 2
  SphereFogDistance[1] = length(Position - u_sphere_fog.sphere_fog_center[1].xyz);
#endif
#endif  // USE_SPHERE_FOG

#if USE_SPHERE_FOG_REVERSE
  RevSphereFogDistance[0] = length(Position - u_sphere_fog.rev_sphere_fog_center[0].xyz);
#if SPHERE_FOG_REVERSE_COUNT >= 2
  RevSphereFogDistance[1] = length(Position - u_sphere_fog.rev_sphere_fog_center[1].xyz);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 3
  RevSphereFogDistance[2] = length(Position - u_sphere_fog.rev_sphere_fog_center[2].xyz);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 4
  RevSphereFogDistance[3] = length(Position - u_sphere_fog.rev_sphere_fog_center[3].xyz);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 5
  RevSphereFogDistance[4] = length(Position - u_sphere_fog.rev_sphere_fog_center[4].xyz);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 6
  RevSphereFogDistance[5] = length(Position - u_sphere_fog.rev_sphere_fog_center[5].xyz);
#endif
#endif  // USE_SPHERE_FOG_REVERSE

#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
  ShadowCoordDir0_0  = (Scene(proj_matrix0) * vec4(Position, 1.0));
#if SYS_SHADOW_COUNT >= 2
  ShadowCoordDir0_1  = (Scene(proj_matrix1) * vec4(Position, 1.0));
#endif
#endif

#if USE_PROJ_COLOR && SYS_PROJ_COLOR
  ProjColorCoord  = (Scene(proj_color_matrix) * vec4(Position, 1.0));
#endif
}
��  #version 450
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
// defines
#if !defined(USE_DIFFUSE_LIGHT)
# define USE_DIFFUSE_LIGHT 0
#endif

#if !defined(USE_SPECULAR_LIGHT)
# define USE_SPECULAR_LIGHT 0
#endif

#if !defined(USE_BASE_TEXTURE)
# define USE_BASE_TEXTURE 0
#endif // USE_BASE_TEXTURE

#if !defined(USE_NORMAL_TEXTURE)
# define USE_NORMAL_TEXTURE 0
#endif // USE_NORMAL_TEXTURE

#if !defined(USE_REFLECT_TEXTURE)
# define USE_REFLECT_TEXTURE 0
#endif  // USE_REFLECT_TEXTURE

#if !defined(USE_ALPHA_CUTOFF)
# define USE_ALPHA_CUTOFF 0
#endif  // USE_ALPHA_CUTOFF

#if !defined(USE_FOG)
# define USE_FOG 0
#endif  // USE_FOG

#if !defined(USE_VTX_COLOR)
# define USE_VTX_COLOR 0
#endif

#if !defined(USE_VTX_COLOR_TO_STAGE_LIGHT)
# define USE_VTX_COLOR_TO_STAGE_LIGHT 0
#endif

#if !defined(USE_DITHER)
# define USE_DITHER 0
#endif // USE_DITHER

#if !defined(USE_ALPHA_TO_COVERAGE)
#define USE_ALPHA_TO_COVERAGE 0
#endif // USE_ALPHA_TO_COVERAGE

#if !defined(USE_PROJ_SHADOW)
# define USE_PROJ_SHADOW 0
#endif

#if !defined(USE_PROJ_COLOR)
# define USE_PROJ_COLOR 0
#endif

#if !defined(BASE_OUTLINEREVISE_ENABLE)
# define BASE_OUTLINEREVISE_ENABLE 0
#endif

#if !defined(BASE_RIMLIGHT_USECUSTOMNORMAL)
# define BASE_RIMLIGHT_USECUSTOMNORMAL 0
#endif

#if !defined(BASE_SPECULARLIGHTING_ENABLE)
# define BASE_SPECULARLIGHTING_ENABLE 0
#endif

#if !defined(BASE_STAGELIGHTING_ENABLE)
# define BASE_STAGELIGHTING_ENABLE 0
#endif

#if !defined(BASE_RIMLIGHTING_ENABLE)
# define BASE_RIMLIGHTING_ENABLE 0
#endif

#if !defined(BASE_TEX_RIMSHADE_ENABLE)
# define BASE_TEX_RIMSHADE_ENABLE 0
#endif

#if BASE_RIMLIGHTING_ENABLE
# if !defined(BASE_RIMMASK_MODE)
#  define BASE_RIMMASK_MODE 0
# endif
#endif

#if !defined(BASE_SPECULARLIGHTING_ENABLE)
# define BASE_SPECULARLIGHTING_ENABLE 0
#endif

#if !defined(BASE_TEX_BASE_ENABLE)
# define BASE_TEX_BASE_ENABLE 0
#endif // BASE_TEX_BASE_ENABLE

#if !defined(BASE_TEXTURE_ALPHA_MODE)
# define BASE_TEXTURE_ALPHA_MODE 0
#endif  // BASE_TEXTURE_ALPHA_MODE

#if !defined(USE_OUTLINE)
# define USE_OUTLINE 0
#endif

#if !defined(USE_NOSELINE)
#define USE_NOSELINE 0
#endif

#if !defined(USE_EYELID_LINE)
# define USE_EYELID_LINE 0
#endif

#if !defined(BASE_EYELIDLINE_SHOWLEFT_ENABLE)
# define BASE_EYELIDLINE_SHOWLEFT_ENABLE 0
#endif

#if !defined(BASE_ELELIDLINE_SHOWRIGHT_ENABLE)
# define BASE_ELELIDLINE_SHOWRIGHT_ENABLE 0
#endif

#if !defined(NOSELINE_SHOW_ENABLE)
# define NOSELINE_SHOW_ENABLE 0
#endif

#if !defined(USE_FACE_SHADOW)
# define USE_FACE_SHADOW 0
#endif

#if !defined(USE_BLEND_SHAPE)
# define USE_BLEND_SHAPE 0
#endif

#if !defined(USE_REFLECT_DIRECTIONAL_LIGHT)
# define USE_REFLECT_DIRECTIONAL_LIGHT 0
#endif

#if !defined(USE_REFLECT_POINT_LIGHT)
# define USE_REFLECT_POINT_LIGHT 0
#endif

#if !defined(USE_DEFAULT_DIRECTIONAL_LIGHT)
# define USE_DEFAULT_DIRECTIONAL_LIGHT 0
#endif

#if !defined(USE_REFLECT_AMBIENT_LIGHT)
# define USE_REFLECT_AMBIENT_LIGHT 0
#endif

#if !defined(USE_REFLECT_SPECULAR_LIGHT)
# define USE_REFLECT_SPECULAR_LIGHT 0
#endif

#if USE_BASE_TEXTURE || USE_NORMAL_TEXTURE || BASE_TEX_RIMSHADE_ENABLE
# define USE_TEXCOORD 1
# define UV_ENABLE 1
#else
# define USE_TEXCOORD 0
# define UV_ENABLE 0
#endif

#if USE_REFLECT_TEXTURE || USE_DIFFUSE_LIGHT || USE_NORMAL_TEXTURE || BASE_RIMLIGHTING_ENABLE || BASE_RIMLIGHT_USECUSTOMNORMAL || BASE_SPECULARLIGHTING_ENABLE || USE_OUTLINE || USE_NOSELINE
# define USE_NORMAL 1
# define USE_EYE_DIRECTION 1
#else
# define USE_NORMAL 0
# define USE_EYE_DIRECTION 0
#endif

#if BASE_SPECULARLIGHTING_ENABLE
# define USE_CAMERA_DIRECTION 1
#else
# define USE_CAMERA_DIRECTION 0
#endif

#if !defined(USE_SPHERE_FOG)
# define USE_SPHERE_FOG 0
#endif
#if SPHERE_FOG_COUNT == 0
# define USE_SPHERE_FOG 0
#endif
#if !defined(USE_SPHERE_FOG_REVERSE)
# define USE_SPHERE_FOG_REVERSE 0
#endif
#if SPHERE_FOG_REVERSE_COUNT == 0
# define USE_SPHERE_FOG_REVERSE 0
#endif

#if !defined(VULKAN)
precision HIGHP sampler2DShadow;
#endif
//
//shader-maker
//

layout(location = 0) in vec3 Position;
#if USE_NORMAL
layout(location = 1) in vec3 Normal;
#endif
#if USE_NORMAL_TEXTURE
layout(location = 2) in vec3 Binormal;
#endif
#if USE_NORMAL_TEXTURE
layout(location = 3) in vec3 Tangent;
#endif
#if USE_VTX_COLOR
layout(location = 4) in vec4 Color;
#endif
#if USE_EYE_DIRECTION
layout(location = 5) in vec3 EyeDirection;
#endif
#if USE_TEXCOORD
layout(location = 6) in vec2 BaseUV;
#endif
#if USE_FOG
layout(location = 7) in vec4 FogCoef;
#endif
#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
layout(location = 8) in vec4 ShadowCoordDir0_0;
#endif
#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW && SYS_SHADOW_COUNT >= 2
layout(location = 9) in vec4 ShadowCoordDir0_1;
#endif
#if USE_PROJ_COLOR && SYS_PROJ_COLOR
layout(location = 10) in vec4 ProjColorCoord;
#endif
#if USE_UVREGION1
layout(location = 11) in vec4 UVRegion1;
#endif
#if USE_UVREGION2
layout(location = 12) in vec4 UVRegion2;
#endif
#if USE_SPHERE_FOG
layout(location = 13) in float SphereFogDistance[2];
#endif
#if USE_SPHERE_FOG_REVERSE
layout(location = 15) in float RevSphereFogDistance[6];
#endif
#if USE_CAMERA_DIRECTION
layout(location = 21) in vec3 CameraDirection;
#endif
layout(location = 22) in vec3 Normal2;
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

#if USE_PROJ_COLOR && SYS_PROJ_COLOR
layout(set=3, binding = 0) uniform sampler2D proj_color_map;
#endif
#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
# if SYS_SHADOW_TYPE == 0
layout(set=3, binding=1) uniform sampler2DShadow proj_map0;
# else
layout(set=3, binding=1) uniform sampler2D proj_map0;
# endif
# if SYS_SHADOW_COUNT >= 2
#  if SYS_SHADOW_TYPE == 0
layout(set=3, binding=2) uniform sampler2DShadow proj_map1;
#  else
layout(set=3, binding=2) uniform sampler2D proj_map1;
#  endif
# endif
#endif
//
//shader-maker
//

//
// Material uniform parameters:
//
layout(set=2, binding=2) uniform MaterialUniformParametersUbo {
  vec4 dither_param; //vec4
  vec4 a2c_param; //float
  vec4 alpha_cutoff; //vec4
  vec4 diffuse_color; //vec3
  vec4 emissive_color; //vec3
  vec4 replace_color; //vec4
  vec4 env_directionallight_0_intensity; //float
  vec4 env_directionallight_0_color; //vec3
  vec4 env_directionallight_0_vector; //vec4
  vec4 base_stagelightborder_width; //float
  vec4 base_stagelightshade_bias; //float
  vec4 base_stagelightshade_color; //vec3
  vec4 base_rimadd_rate; //float
  vec4 base_rimmul_rate; //float
  vec4 base_rimlight_front_add_color; //vec3
  vec4 base_rimlight_front_mul_color; //vec3
  vec4 base_rimlight_back_add_color; //vec3
  vec4 base_rimlight_back_mul_color; //vec3
  vec4 base_rimfront_shade_add_color; //vec3
  vec4 base_rimfront_shade_mul_color; //vec3
  vec4 base_tex_alpha_rate; //float
  vec4 uv_shift; //vec2
  vec4 base_outline_revise_distance; //float
  vec4 base_outline_revise_ratio; //float
  vec4 base_outline_width; //float
  vec4 base_outline_shift; //float
  vec4 base_outline_expand_ratio; //float
  vec4 base_outline_color; //vec3
  vec4 base_rimlight_front_tol; //float
  vec4 base_rimlight_back_tol; //float
  vec4 base_rimfront_shade_tol; //float
  vec4 base_rimlight_front_smooth; //float
  vec4 base_rimlight_back_smooth; //float
  vec4 base_rimfront_shade_smooth; //float
  vec4 base_rimshadefrontblend_rate; //float
  vec4 base_rimshadebackblend_rate; //float
  vec4 base_rimfrontshadeblend_rate; //float
  vec4 base_rimfrontshade_intensity; //float
  vec4 base_specularcolor; //vec3
  vec4 base_specularpower; //float
  vec4 base_nose_displayleft_bias; //float
  vec4 base_nose_displayright_bias; //float
  vec4 face_shadow_color; //vec4
  vec4 face_shadow_shift; //vec3
  vec4 face_shadow_front; //vec3
  vec4 blend_shape_ratio; //vec4
  vec4 blend_shape_eye_ratio; //vec4
  vec4 blend_shape_index0; //vec4
  vec4 blend_shape_index1; //vec4
  vec4 reflect_directional_light_color; //vec3
  vec4 reflect_directional_light_intensity; //float
  vec4 reflect_directional_light_direction; //vec3
  vec4 reflect_point_light_color; //vec3
  vec4 reflect_point_light_intensity; //float
  vec4 reflect_point_light_direction; //vec3
  vec4 reflect_ambient_light_color; //vec3
  vec4 reflect_ambient_light_intensity; //float
  vec4 reflect_specular_light_color; //vec3
  vec4 reflect_specular_light_intensity; //float
  vec4 reflect_specular_light_direction; //vec3
  vec4 texcoord_matrix[2];
} u_material_parameters;

//
// Material texture-samplers:
//
layout(set=2, binding=3) uniform sampler2D base_map;
layout(set=2, binding=4) uniform sampler2D base_rimshade_map;

//
// Material buffer block bindings:
//
#if (USE_SPHERE_FOG || USE_SPHERE_FOG_REVERSE) && (SPHERE_FOG_COUNT > 0 || SPHERE_FOG_REVERSE_COUNT > 0)
layout(set=2, binding=5) uniform SphereFogUbo {
  vec4 sphere_fog_center[2];
  vec4 sphere_fog_parameter[2];
  vec4 sphere_fog_color[2];
  vec4 sphere_fog_density[2];
  vec4 rev_sphere_fog_center[6];
  vec4 rev_sphere_fog_parameter[6];
  vec4 rev_sphere_fog_color[6];
  vec4 rev_sphere_fog_density[6];
} u_sphere_fog;
#endif

//------------
// functions
#if USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT
void parallel_specular_light1(inout vec3 diffuse_light, inout vec3 specular_light,
                             in vec3 normal, in vec3 eye_direction,
                             in vec3 light_color, in vec3 light_pos, in float power) {
  vec3 light_direction = normalize(light_pos * -1.0);
#if USE_DIFFUSE_LIGHT
  float diffuse = max(0.0, dot(normal, light_direction));
  diffuse_light  += light_color * diffuse;
#endif
#if USE_SPECULAR_LIGHT
  vec3 half_angle = normalize(light_direction + eye_direction);
  float specular = max(dot(normal, half_angle), 0.0);
  specular = pow(specular, power);
  specular_light += light_color * specular;
#endif
}
float light_attenuation(in float distance, in vec4 attenuation) {
  float out_attenuation = 0.0;
  if (distance <= attenuation.w) {
    out_attenuation = min(1.0, 
                          1.0/(
                          distance*distance*attenuation.x+
                          distance*attenuation.y+
                          attenuation.z)
                          );
  }
  return out_attenuation;
}
void point_specular_light1(inout vec3 diffuse_light, inout vec3 specular_light,
                          in vec3 position, in vec3 normal, in vec3 eye_direction,
                          in vec3 light_color, in vec3 light_pos, in vec4 light_attn, in float power) {
  vec3 light_direction = normalize(light_pos - position);
  float light_distance = length(light_pos - position);
  float attenuation = light_attenuation(light_distance, light_attn);
#if USE_DIFFUSE_LIGHT
  float diffuse = dot(normal, light_direction);
  diffuse_light  += light_color * diffuse * attenuation;
#endif
#if USE_SPECULAR_LIGHT
  vec3 half_angle = normalize(light_direction + eye_direction);
  float specular = max(dot(normal, half_angle), 0.0);
  specular = pow(specular, power);
  specular_light += light_color * specular * attenuation;
#endif
}
void spot_specular_light1(inout vec3 diffuse_light, inout vec3 specular_light,
                         in vec3 position, in vec3 normal, in vec3 eye_direction,
                         in vec3 light_color, in vec3 light_pos, in vec4 light_attn, in vec3 light_dir, in vec2 light_cutoff, in float power) {
  vec3 light_direction = normalize(light_pos - position);
  float cos_cone_in = light_cutoff.x;
  float cos_cone_out = light_cutoff.y;
  float cos_direction = dot(-light_direction, light_dir);
  float spot = smoothstep(cos_cone_out, cos_cone_in, cos_direction);
  float light_distance = length(light_pos - position);
  float attenuation = light_attenuation(light_distance, light_attn);
#if USE_DIFFUSE_LIGHT
  float diffuse = dot(normal, light_direction);
  diffuse_light  += light_color * diffuse * attenuation * spot;
#endif
#if USE_SPECULAR_LIGHT
  vec3 half_angle = normalize(light_direction + eye_direction);
  float specular = max(dot(normal, half_angle), 0.0);
  specular = pow(specular, power);
  specular_light += light_color * specular * attenuation * spot;
#endif
}
void parallel_specular_light(inout vec3 diffuse_light, inout vec3 specular_light,
                             in vec3 normal, in vec3 eye_direction,
                             in float power, in vec3 lit0) {
#if SYS_DIRECTIONAL_LIGHT_NUM > 0
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 0).xyz, SceneArray(directional_light_direction, 0).xyz, power);
  diffuse_light.xyz *= lit0.xyz;
  specular_light.xyz *= lit0.xyz;
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 1
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 1).xyz, SceneArray(directional_light_direction, 1).xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 2
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 2).xyz, SceneArray(directional_light_direction, 2).xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 3
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 3).xyz, SceneArray(directional_light_direction, 3).xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 4
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 4).xyz, SceneArray(directional_light_direction, 4).xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 5
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 5).xyz, SceneArray(directional_light_direction, 5).xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 6
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 6).xyz, SceneArray(directional_light_direction, 6).xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 7
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 7).xyz, SceneArray(directional_light_direction, 7).xyz, power);
#endif
}
void point_specular_light(inout vec3 diffuse_light, inout vec3 specular_light,
                          in vec3 position, in vec3 normal, in vec3 eye_direction,
                          in float power) {
#if SYS_POINT_LIGHT_NUM > 0
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light0[0].xyz, point_light0[1].xyz, point_light0[2].xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 1
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light1[0].xyz, point_light1[1].xyz, point_light1[2].xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 2
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light2[0].xyz, point_light2[1].xyz, point_light2[2].xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 3
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light3[0].xyz, point_light3[1].xyz, point_light3[2].xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 4
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light4[0].xyz, point_light4[1].xyz, point_light4[2].xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 5
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light5[0].xyz, point_light5[1].xyz, point_light5[2].xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 6
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light6[0].xyz, point_light6[1].xyz, point_light6[2].xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 7
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        point_light7[0].xyz, point_light7[1].xyz, point_light7[2].xyzw, power);
#endif
}
void spot_specular_light(inout vec3 diffuse_light, inout vec3 specular_light,
                         in vec3 position, in vec3 normal, in vec3 eye_direction,
                         in float power) {
#if SYS_SPOT_LIGHT_NUM > 0
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light0[0].xyz, spot_light0[1].xyz, spot_light0[2].xyzw,
                       spot_light0[3].xyz, spot_light0[4].xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 1
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light1[0].xyz, spot_light1[1].xyz, spot_light1[2].xyzw,
                       spot_light1[3].xyz, spot_light1[4].xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 2
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light2[0].xyz, spot_light2[1].xyz, spot_light2[2].xyzw,
                       spot_light2[3].xyz, spot_light2[4].xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 3
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light3[0].xyz, spot_light3[1].xyz, spot_light3[2].xyzw,
                       spot_light3[3].xyz, spot_light3[4].xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 4
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light4[0].xyz, spot_light4[1].xyz, spot_light4[2].xyzw,
                       spot_light4[3].xyz, spot_light4[4].xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 5
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light5[0].xyz, spot_light5[1].xyz, spot_light5[2].xyzw,
                       spot_light5[3].xyz, spot_light5[4].xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 6
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light6[0].xyz, spot_light6[1].xyz, spot_light6[2].xyzw,
                       spot_light6[3].xyz, spot_light6[4].xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 7
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       spot_light7[0].xyz, spot_light7[1].xyz, spot_light7[2].xyzw,
                       spot_light7[3].xyz, spot_light7[4].xy, power);
#endif
}
#endif  // USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT

#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
#if SYS_SHADOW_TYPE == 0
vec4 calc_shadow(in vec4 shadow_coord, in sampler2DShadow shadow_map) {
  vec3 uv = shadow_coord.xyz/shadow_coord.w;
  vec3 shadowuv = uv * 0.5 + 0.5;
  vec3 abs_uv = abs(uv);
  vec4 lit = vec4(1.0);
  if (abs_uv.x < 1.0 && abs_uv.y < 1.0) {
    lit.xyz = vec3(textureLod(shadow_map, shadowuv.xyz, 0.0));
    lit.xyz += vec3(textureLodOffset(shadow_map, shadowuv.xyz, 0.0, ivec2(1, 1)));
    lit.xyz += vec3(textureLodOffset(shadow_map, shadowuv.xyz, 0.0, ivec2(1, -1)));
    lit.xyz += vec3(textureLodOffset(shadow_map, shadowuv.xyz, 0.0, ivec2(-1, 1)));
    lit.xyz += vec3(textureLodOffset(shadow_map, shadowuv.xyz, 0.0, ivec2(-1, -1)));
    lit.xyz /= 5.0;
    return vec4(lit.xyz, max(abs_uv.x, abs_uv.y));
  }
  return lit;
}
#elif SYS_SHADOW_TYPE == 1
vec4 calc_shadow(in vec4 shadow_coord, in sampler2D shadow_map) {
  vec2 shadowuv = shadow_coord.xy/shadow_coord.w * 0.5 + 0.5;
  vec4 lit = vec4(1.0);
  if (shadowuv.y >= 0.0 && shadowuv.y <= 1.0) {
    lit.xyz = vec3(textureLod(shadow_map, shadowuv.xy, 0.0).x);
  }
  return vec4(lit.xyz, shadowuv.y);
}
#endif
#endif

#if USE_DITHER
float calc_dither(in float threshold) {
  float dither[16];
  dither[0]  =  1.0/17.0; dither[1]  =  9.0/17.0; dither[2]  =  3.0/17.0; dither[3]  = 11.0/17.0;
  dither[4]  = 13.0/17.0; dither[5]  =  5.0/17.0; dither[6]  = 15.0/17.0; dither[7]  =  7.0/17.0;
  dither[8]  =  4.0/17.0; dither[9]  = 12.0/17.0; dither[10] =  2.0/17.0; dither[11] = 10.0/17.0;
  dither[12] = 16.0/17.0; dither[13] =  8.0/17.0; dither[14] = 14.0/17.0; dither[15] =  6.0/17.0;
  vec2 screen_coord = floor(mod(gl_FragCoord.xy, 4.0));
  int pixel_index = int(clamp(screen_coord.x + screen_coord.y * 4.0, 0.0, 15.0));
#if USE_ALPHA_TO_COVERAGE
  return max((1.0 - threshold - dither[ pixel_index ]) / (1.0 - dither[ pixel_index ]), 0.0);
#else
  return step(threshold, dither[ pixel_index ]);
#endif
}
#endif
#if USE_UVREGION1 || USE_UVREGION2
vec2 apply_uv_region(in vec2 in_uv, in vec4 region) {
  return fract(in_uv) * (region.zw - region.xy) + region.xy;
}
#endif  //USE_UVREGION1 || USE_UVREGION2
#if defined(VULKAN)
# line 3 "g2_chara_fs.h"
#endif

// functions
#if USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT
void parallel_specular_light1(inout vec3 diffuse_light, inout vec3 specular_light,
                             in vec3 normal, in vec3 eye_direction,
                             in vec3 light_color, in vec3 light_pos, in float power) {
  vec3 light_direction = normalize(light_pos * -1.0);
#if USE_DIFFUSE_LIGHT
  float diffuse = max(0.0, dot(normal, light_direction));
  diffuse_light  += light_color * diffuse;
#endif
#if USE_SPECULAR_LIGHT
  vec3 half_angle = normalize(light_direction + eye_direction);
  float specular = max(dot(normal, half_angle), 0.0);
  specular = pow(specular, power);
  specular_light += light_color * specular;
#endif
}
float light_attenuation(in float distance, in vec4 attenuation) {
  float out_attenuation = 0.0;
  if (distance <= attenuation.w) {
    out_attenuation = min(1.0,
                          1.0/(
                          distance*distance*attenuation.x+
                          distance*attenuation.y+
                          attenuation.z)
                          );
  }
  return out_attenuation;
}
void point_specular_light1(inout vec3 diffuse_light, inout vec3 specular_light,
                          in vec3 position, in vec3 normal, in vec3 eye_direction,
                          in vec3 light_color, in vec3 light_pos, in vec4 light_attn, in float power) {
  vec3 light_direction = normalize(light_pos - position);
  float light_distance = length(light_pos - position);
  float attenuation = light_attenuation(light_distance, light_attn);
#if USE_DIFFUSE_LIGHT
  float diffuse = dot(normal, light_direction);
  diffuse_light  += light_color * diffuse * attenuation;
#endif
#if USE_SPECULAR_LIGHT
  vec3 half_angle = normalize(light_direction + eye_direction);
  float specular = max(dot(normal, half_angle), 0.0);
  specular = pow(specular, power);
  specular_light += light_color * specular * attenuation;
#endif
}
void spot_specular_light1(inout vec3 diffuse_light, inout vec3 specular_light,
                         in vec3 position, in vec3 normal, in vec3 eye_direction,
                         in vec3 light_color, in vec3 light_pos, in vec4 light_attn, in vec3 light_dir, in vec2 light_cutoff, in float power) {
  vec3 light_direction = normalize(light_pos - position);
  float cos_cone_in = light_cutoff.x;
  float cos_cone_out = light_cutoff.y;
  float cos_direction = dot(-light_direction, light_dir);
  float spot = smoothstep(cos_cone_out, cos_cone_in, cos_direction);
  float light_distance = length(light_pos - position);
  float attenuation = light_attenuation(light_distance, light_attn);
#if USE_DIFFUSE_LIGHT
  float diffuse = dot(normal, light_direction);
  diffuse_light  += light_color * diffuse * attenuation * spot;
#endif
#if USE_SPECULAR_LIGHT
  vec3 half_angle = normalize(light_direction + eye_direction);
  float specular = max(dot(normal, half_angle), 0.0);
  specular = pow(specular, power);
  specular_light += light_color * specular * attenuation * spot;
#endif
}
void parallel_specular_light(inout vec3 diffuse_light, inout vec3 specular_light,
                             in vec3 normal, in vec3 eye_direction,
                             in float power, in vec3 lit0) {
#if USE_REFLECT_POINT_LIGHT
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           Material(reflect_point_light_color).xyz, Material(reflect_point_light_direction).xyz, power);
#elif USE_REFLECT_DIRECTIONAL_LIGHT
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           Material(reflect_directional_light_color).xyz, Material(reflect_directional_light_direction).xyz, power);
#elif USE_DEFAULT_DIRECTIONAL_LIGHT
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           Material(env_directionallight_0_color).xyz, Material(env_directionallight_0_vector).xyz, power);
#elif SYS_DIRECTIONAL_LIGHT_NUM > 0
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 0).xyz, SceneArray(directional_light_direction, 0).xyz, power);
  diffuse_light.xyz *= lit0.xyz;
  specular_light.xyz *= lit0.xyz;
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 1
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 1).xyz, SceneArray(directional_light_direction, 1).xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 2
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 2).xyz, SceneArray(directional_light_direction, 2).xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 3
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 3).xyz, SceneArray(directional_light_direction, 3).xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 4
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 4).xyz, SceneArray(directional_light_direction, 4).xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 5
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 5).xyz, SceneArray(directional_light_direction, 5).xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 6
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 6).xyz, SceneArray(directional_light_direction, 6).xyz, power);
#endif
#if SYS_DIRECTIONAL_LIGHT_NUM > 7
  parallel_specular_light1(diffuse_light,specular_light,normal,eye_direction,
                           SceneArray(directional_light_color_and_intensity, 7).xyz, SceneArray(directional_light_direction, 7).xyz, power);
#endif
}
void point_specular_light(inout vec3 diffuse_light, inout vec3 specular_light,
                          in vec3 position, in vec3 normal, in vec3 eye_direction,
                          in float power) {
#if SYS_POINT_LIGHT_NUM > 0
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        SceneArray(point_light_color_and_intensity, 0).xyz, SceneArray(point_light_position, 0).xyz, SceneArray(point_light_attenuation_and_distance, 0).xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 1
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        SceneArray(point_light_color_and_intensity, 1).xyz, SceneArray(point_light_position, 1).xyz, SceneArray(point_light_attenuation_and_distance, 1).xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 2
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        SceneArray(point_light_color_and_intensity, 2).xyz, SceneArray(point_light_position, 2).xyz, SceneArray(point_light_attenuation_and_distance, 2).xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 3
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        SceneArray(point_light_color_and_intensity, 3).xyz, SceneArray(point_light_position, 3).xyz, SceneArray(point_light_attenuation_and_distance, 3).xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 4
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        SceneArray(point_light_color_and_intensity, 4).xyz, SceneArray(point_light_position, 4).xyz, SceneArray(point_light_attenuation_and_distance, 4).xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 5
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        SceneArray(point_light_color_and_intensity, 5).xyz, SceneArray(point_light_position, 5).xyz, SceneArray(point_light_attenuation_and_distance, 5).xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 6
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        SceneArray(point_light_color_and_intensity, 6).xyz, SceneArray(point_light_position, 6).xyz, SceneArray(point_light_attenuation_and_distance, 6).xyzw, power);
#endif
#if SYS_POINT_LIGHT_NUM > 7
  point_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                        SceneArray(point_light_color_and_intensity, 7).xyz, SceneArray(point_light_position, 7).xyz, SceneArray(point_light_attenuation_and_distance, 7).xyzw, power);
#endif
}
void spot_specular_light(inout vec3 diffuse_light, inout vec3 specular_light,
                         in vec3 position, in vec3 normal, in vec3 eye_direction,
                         in float power) {
#if SYS_SPOT_LIGHT_NUM > 0
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       SceneArray(spot_light_color_and_intensity, 0).xyz, SceneArray(spot_light_position, 0).xyz, SceneArray(spot_light_attenuation_and_distance, 0).xyzw,
                       SceneArray(spot_light_direction, 0).xyz, SceneArray(spot_light_cosine_cone_in_out, 0).xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 1
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       SceneArray(spot_light_color_and_intensity, 1).xyz, SceneArray(spot_light_position, 1).xyz, SceneArray(spot_light_attenuation_and_distance, 1).xyzw,
                       SceneArray(spot_light_direction, 1).xyz, SceneArray(spot_light_cosine_cone_in_out, 1).xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 2
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       SceneArray(spot_light_color_and_intensity, 2).xyz, SceneArray(spot_light_position, 2).xyz, SceneArray(spot_light_attenuation_and_distance, 2).xyzw,
                       SceneArray(spot_light_direction, 2).xyz, SceneArray(spot_light_cosine_cone_in_out, 2).xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 3
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       SceneArray(spot_light_color_and_intensity, 3).xyz, SceneArray(spot_light_position, 3).xyz, SceneArray(spot_light_attenuation_and_distance, 3).xyzw,
                       SceneArray(spot_light_direction, 3).xyz, SceneArray(spot_light_cosine_cone_in_out, 3).xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 4
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       SceneArray(spot_light_color_and_intensity, 4).xyz, SceneArray(spot_light_position, 4).xyz, SceneArray(spot_light_attenuation_and_distance, 4).xyzw,
                       SceneArray(spot_light_direction, 4).xyz, SceneArray(spot_light_cosine_cone_in_out, 4).xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 5
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       SceneArray(spot_light_color_and_intensity, 5).xyz, SceneArray(spot_light_position, 5).xyz, SceneArray(spot_light_attenuation_and_distance, 5).xyzw,
                       SceneArray(spot_light_direction, 5).xyz, SceneArray(spot_light_cosine_cone_in_out, 5).xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 6
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       SceneArray(spot_light_color_and_intensity, 6).xyz, SceneArray(spot_light_position, 6).xyz, SceneArray(spot_light_attenuation_and_distance, 6).xyzw,
                       SceneArray(spot_light_direction, 6).xyz, SceneArray(spot_light_cosine_cone_in_out, 6).xy, power);
#endif
#if SYS_SPOT_LIGHT_NUM > 7
  spot_specular_light1(diffuse_light,specular_light,position,normal,eye_direction,
                       SceneArray(spot_light_color_and_intensity, 7).xyz, SceneArray(spot_light_position, 7).xyz, SceneArray(spot_light_attenuation_and_distance, 7).xyzw,
                       SceneArray(spot_light_direction, 7).xyz, SceneArray(spot_light_cosine_cone_in_out, 7).xy, power);
#endif
}
#endif  // USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT

// input


#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
#if SYS_SHADOW_TYPE == 0
vec4 calc_shadow(in vec4 shadow_coord, in sampler2DShadow shadow_map) {
  vec3 shadowuv = shadow_coord.xyz/shadow_coord.w * 0.5 + 0.5;
  vec4 lit = vec4(1.0);
  if (shadowuv.y >= 0.0 && shadowuv.y <= 1.0) {
    lit.xyz = vec3(textureLod(shadow_map, shadowuv.xyz, 0.0));
    lit.xyz += vec3(textureLodOffset(shadow_map, shadowuv.xyz, 0.0, ivec2(1, 1)));
    lit.xyz += vec3(textureLodOffset(shadow_map, shadowuv.xyz, 0.0, ivec2(1, -1)));
    lit.xyz += vec3(textureLodOffset(shadow_map, shadowuv.xyz, 0.0, ivec2(-1, 1)));
    lit.xyz += vec3(textureLodOffset(shadow_map, shadowuv.xyz, 0.0, ivec2(-1, -1)));
    lit.xyz /= 5.0;
  }
  return vec4(lit.xyz, shadowuv.y);
}
#elif SYS_SHADOW_TYPE == 1
vec4 calc_shadow(in vec4 shadow_coord, in sampler2D shadow_map) {
  vec2 shadowuv = shadow_coord.xy/shadow_coord.w * 0.5 + 0.5;
  vec4 lit = vec4(1.0);
  if (shadowuv.y >= 0.0 && shadowuv.y <= 1.0) {
    lit.xyz = vec3(textureLod(shadow_map, shadowuv.xy, 0.0).x);
  }
  return vec4(lit.xyz, shadowuv.y);
}
#endif
#endif

#if BASE_STAGELIGHTING_ENABLE
vec3 blend_linear_burn(vec3 base, vec3 blend) {
  return max(base + blend - vec3(1.0), vec3(0.0));
}
#endif

#if BASE_RIMLIGHTING_ENABLE
vec3 blend_add(vec3 base, vec3 blend) {
  return base + blend;
}
vec3 blend_multiply(vec3 base, vec3 blend) {
  return base * blend;
}
vec3 blend_rim_light(vec3 base, vec3 blend, float rate) {
  return mix(base, blend_add(base, blend * Material(base_rimadd_rate).x), rate);
}
vec3 blend_rim_dark(vec3 base, vec3 blend, float rate) {
  return mix(base, blend_multiply(base, blend), rate * Material(base_rimmul_rate).x);
}
vec3 blendShade(vec3 base, vec3 shade, vec3 dark, float shade_rate, float rim_rate) {
  return mix(base, mix(base, shade, shade_rate) * dark, rim_rate * Material(base_rimmul_rate).x);
}
#endif

// program
void main() {
  vec4 lit = vec4(1.0);
#if SYS_SHADOW_COUNT && USE_PROJ_SHADOW
#if SYS_SHADOW_TYPE == 0 || SYS_SHADOW_TYPE == 1
  lit = calc_shadow(ShadowCoordDir0_0, proj_map0);
#if SYS_SHADOW_COUNT >= 2
  vec4 lit2 = calc_shadow(ShadowCoordDir0_1, proj_map1);
  lit = mix(vec4(lit.xyz, lit2.w), lit2, step(1.0, lit.w));
#endif
  lit.xyz = max(lit.xyz, smoothstep(0.9, 1.0, lit.w));
#endif
#endif

#if USE_EYE_DIRECTION
  vec3 eye_direction = normalize(EyeDirection);
#endif  // USE_EYE_DIRECTION

#if USE_NORMAL
  vec3 normal    = normalize(Normal);
#endif  // USE_NORMAL
  vec3 normal2   = normalize(Normal2);

#if USE_TEXCOORD
#if USE_NORMAL_TEXTURE
  vec3 binormal  = normalize(Binormal);
  vec3 tangent   = normalize(Tangent);
#endif  // USE_NORMAL_TEXTURE
  vec2 base_uv   = BaseUV;
#if USE_BASE_TEXTURE
  vec4 tex_base = texture(base_map, base_uv.xy);
#else
  vec4 tex_base = vec4(1.0);
#endif
#if USE_NORMAL_TEXTURE
  vec2 normal_uv = BaseUV;
  vec3 tex_normal = normalize(texture(normal_map, normal_uv.xy).rgb * 2.0 - 1.0);
  mat3 tangent_matrix = mat3(tangent, binormal, normal);
  normal = normalize(tangent_matrix * tex_normal);
#endif  // USE_NORMAL_TEXTURE
  vec3 base_color = tex_base.xyz;
#else  // USE_TEXCOORD
  vec4 tex_base = vec4(1.0);
  vec3 base_color = tex_base.xyz;
#endif  // USE_TEXCOORD
#if !USE_VTX_COLOR
  vec4 Color = vec4(1.0);
#endif  // USE_VTX_COLOR
#if USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT
  vec3 diffuse_light  = vec3(0.0);
  vec3 specular_light  = vec3(0.0);
  parallel_specular_light(diffuse_light,specular_light,normal,eye_direction,specular_power.x, lit.xyz);
  point_specular_light(diffuse_light,specular_light,Position,normal,eye_direction,specular_power.x);
  spot_specular_light(diffuse_light,specular_light,Position,normal,eye_direction,specular_power.x);
  out_FragColor.xyz = vec3(0.0);
#if USE_DIFFUSE_LIGHT
  out_FragColor.xyz += base_color.xyz * Material(diffuse_color).xyz/* * Color.xyz*/ * diffuse_light;
#endif
#if USE_SPECULAR_LIGHT
  out_FragColor.xyz += specular_color.xyz * specular_light;
#endif
#else
  out_FragColor.xyz = base_color.xyz * Material(diffuse_color).xyz/* * Color.xyz*/;
#endif
#if USE_REFLECT_TEXTURE
  vec3 reflect_vector = -reflect(eye_direction, normal);
  vec4 tex_reflect = texture(reflection_map, reflect_vector);
  out_FragColor.xyz += tex_reflect.xyz * Material(reflection_color).xyz * Material(reflection_color).w;
#endif  // USE_REFLECT_TEXTURE

#if USE_PROJ_COLOR && SYS_PROJ_COLOR
  vec3 ambient_scale = textureLod(proj_color_map, ProjColorCoord.xy/ProjColorCoord.w * 0.5 + 0.5, 0.0).xyz;
#else
  vec3 ambient_scale = vec3(1.0);
#endif
#if USE_DIFFUSE_LIGHT
#if USE_REFLECT_AMBIENT_LIGHT
  out_FragColor.xyz += tex_base.xyz * (Material(reflect_ambient_light_color).xyz * Material(reflect_ambient_light_intensity).x);
#else
  out_FragColor.xyz += tex_base.xyz * Scene(ambient_light).xyz * ambient_scale.xyz;
#endif
#endif  // USE_DIFFUSE_LIGHT
  out_FragColor.xyz += Material(emissive_color).xyz;
  out_FragColor.w = tex_base.a/* * Color.a*/;

  vec3 color = vec3(1.0);
#if BASE_TEXTURE_ALPHA_MODE == 0
  float alpha = 1.0;
#elif BASE_TEXTURE_ALPHA_MODE == 1
  float alpha = tex_base.a * Material(base_tex_alpha_rate).x;
#endif  // BASE_TEXTURE_ALPHA_MODE
  if (Color.b < Material(base_outline_expand_ratio).x) {
    color = Material(base_outline_color).xyz;
  }

  color *= out_FragColor.xyz;

#if USE_REFLECT_AMBIENT_LIGHT
  color *= Material(reflect_ambient_light_color).xyz * Material(reflect_ambient_light_intensity).x;
#elif USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT || BASE_RIMLIGHTING_ENABLE
  color *= Scene(ambient_light).xyz * ambient_scale.xyz;
#endif

#if BASE_STAGELIGHTING_ENABLE
#if USE_REFLECT_POINT_LIGHT
  vec3 light_vector = normalize(-Material(reflect_point_light_direction).xyz);
#elif USE_REFLECT_DIRECTIONAL_LIGHT
  vec3 light_vector = normalize(-Material(reflect_directional_light_direction).xyz);
#elif USE_DEFAULT_DIRECTIONAL_LIGHT
  vec3 light_vector = normalize(-Material(env_directionallight_0_vector).xyz);
#elif SYS_DIRECTIONAL_LIGHT_NUM > 0
  vec3 light_vector = normalize(-SceneArray(directional_light_direction, 0).xyz);
#else
  vec3 light_vector = vec3(0.0, 0.0, 1.0);
#endif
  vec3 rim_normal_stage = normalize(normal2.xyz);

  float stage_light_value = (dot(rim_normal_stage, light_vector) + 1.0) * 0.5;
#if USE_VTX_COLOR_TO_STAGE_LIGHT
  stage_light_value *= Color.a;
#endif
  stage_light_value += Material(base_stagelightshade_bias).x;
  stage_light_value = smoothstep(0.5 - Material(base_stagelightborder_width).x, 0.5 + Material(base_stagelightborder_width).x, stage_light_value);

  vec3 light_color = color;
  vec3 shade_color = blend_linear_burn(color, Material(base_stagelightshade_color).xyz);
  color = mix(shade_color, light_color, stage_light_value);
#endif

#if BASE_RIMLIGHTING_ENABLE
  vec2 tex_rim_shade_uv = base_uv.xy;
  vec4 tex_rim_shade = texture(base_rimshade_map, tex_rim_shade_uv);

#if BASE_RIMMASK_MODE == 0
  float rim_area_rate = Color.a;
  float rim_density_rate = 1.0;
#elif BASE_RIMMASK_MODE == 1
  float rim_area_rate = 1.0;
  float rim_density_rate = Color.a;
#endif  // BASE_RIMMASK_MODE

  vec3 rim_normal = normal2;
  float rim_value = (1.0 - clamp(dot(rim_normal, eye_direction), 0.0, 1.0)) * rim_area_rate;
  float front_tol = smoothstep(Material(base_rimlight_front_tol).x - Material(base_rimlight_front_smooth).x,
                               Material(base_rimlight_front_tol).x + Material(base_rimlight_front_smooth).x,
                               rim_value);
  float back_tol = smoothstep(Material(base_rimlight_back_tol).x - Material(base_rimlight_back_smooth).x,
                              Material(base_rimlight_back_tol).x + Material(base_rimlight_back_smooth).x,
                              rim_value);

#if BASE_RIMFRONTSHADE_ENABLE
  float shade_tol = smoothstep(Material(base_rimfront_shade_tol).x - Material(base_rimfront_shade_smooth).x,
                               Material(base_rimfront_shade_tol).x + Material(base_rimfront_shade_smooth).x,
                               rim_value);
#endif  // BASE_RIMFRONTSHADE_ENABLE

#if USE_REFLECT_POINT_LIGHT
  float light_value = dot(rim_normal, normalize(-Material(reflect_point_light_direction).xyz));
#elif USE_REFLECT_DIRECTIONAL_LIGHT
  float light_value = dot(rim_normal, normalize(-Material(reflect_directional_light_direction).xyz));
#elif USE_DEFAULT_DIRECTIONAL_LIGHT
  float light_value = dot(rim_normal, normalize(-Material(env_directionallight_0_vector).xyz));
#elif SYS_DIRECTIONAL_LIGHT_NUM > 0
  float light_value = dot(rim_normal, normalize(-SceneArray(directional_light_direction, 0).xyz));
#else
  float light_value = 1.0;
#endif

  float front_rim = front_tol * clamp(light_value, 0.0, 1.0);
  float back_rim = back_tol * clamp(-light_value, 0.0, 1.0);

#if BASE_RIMFRONTSHADE_ENABLE
  float shade_rim = Material(base_rimfrontshade_intensity).x * shade_tol * clamp(light_value, 0.0, 1.0) * (1.0 - clamp(front_rim, 0.0, 1.0));
#endif  // BASE_RIMFRONTSHADE_ENABLE

  // front dark
  color = blendShade(color,
                     tex_rim_shade.rgb,
                     Material(base_rimlight_front_mul_color).rgb,
                     Material(base_rimshadefrontblend_rate).x,
                     front_rim * rim_density_rate);
  // back dark
  color = blendShade(color,
                     tex_rim_shade.rgb,
                     Material(base_rimlight_back_mul_color).rgb,
                     Material(base_rimshadebackblend_rate).x,
                     back_rim * rim_density_rate);
#if BASE_RIMFRONTSHADE_ENABLE
  color = blendShade(color,
                     tex_rim_shade.rgb,
                     Material(base_rimlight_back_mul_color).rgb * Material(base_rimfront_shade_mul_color).rgb,
                     Material(base_rimshadebackblend_rate).x * Material(base_rimfrontshadeblend_rate).x,
                     shade_rim * rim_density_rate);
#endif  // BASE_RIMFRONTSHADE_ENABLE

#if USE_REFLECT_POINT_LIGHT
  // front light
  color = blend_rim_light(color,
                          Material(base_rimlight_front_add_color).rgb * Material(reflect_point_light_color).xyz * Material(reflect_point_light_intensity).x * rim_density_rate,
                          front_rim);
  // back dark
  color = blend_rim_light(color,
                          Material(base_rimlight_back_add_color).rgb * Material(reflect_point_light_color).xyz * Material(reflect_point_light_intensity).x * rim_density_rate,
                          back_rim);
#if BASE_RIMFRONTSHADE_ENABLE
  color = blend_rim_light(color,
                          (Material(base_rimlight_back_add_color).rgb + Material(base_rimfront_shade_add_color).rgb) * Material(reflect_point_light_color).xyz * Material(reflect_point_light_intensity).x * rim_density_rate,
                          shade_rim);
#endif  // BASE_RIMFRONTSHADE_ENABLE
#elif USE_REFLECT_DIRECTIONAL_LIGHT
  // front light
  color = blend_rim_light(color,
                          Material(base_rimlight_front_add_color).rgb * Material(reflect_directional_light_color).xyz * Material(reflect_directional_light_intensity).x * rim_density_rate,
                          front_rim);
  // back dark
  color = blend_rim_light(color,
                          Material(base_rimlight_back_add_color).rgb * Material(reflect_directional_light_color).xyz * Material(reflect_directional_light_intensity).x * rim_density_rate,
                          back_rim);
#if BASE_RIMFRONTSHADE_ENABLE
  color = blend_rim_light(color,
                          (Material(base_rimlight_back_add_color).rgb + Material(base_rimfront_shade_add_color).rgb) * Material(reflect_directional_light_color).xyz * Material(reflect_directional_light_intensity).x * rim_density_rate,
                          shade_rim);
#endif  // BASE_RIMFRONTSHADE_ENABLE
#elif USE_DEFAULT_DIRECTIONAL_LIGHT
  // front light
  color = blend_rim_light(color,
                          Material(base_rimlight_front_add_color).rgb * Material(env_directionallight_0_color).xyz * Material(env_directionallight_0_intensity).x * rim_density_rate,
                          front_rim);
  // back dark
  color = blend_rim_light(color,
                          Material(base_rimlight_back_add_color).rgb * Material(env_directionallight_0_color).xyz * Material(env_directionallight_0_intensity).x * rim_density_rate,
                          back_rim);
#if BASE_RIMFRONTSHADE_ENABLE
  color = blend_rim_light(color,
                          (Material(base_rimlight_back_add_color).rgb + Material(base_rimfront_shade_add_color).rgb) * Material(env_directionallight_0_color).xyz * Material(env_directionallight_0_intensity).x * rim_density_rate,
                          shade_rim);
#endif  // BASE_RIMFRONTSHADE_ENABLE
#elif SYS_DIRECTIONAL_LIGHT_NUM > 0
  // front light
  color = blend_rim_light(color,
                          Material(base_rimlight_front_add_color).rgb * SceneArray(directional_light_color_and_intensity, 0).xyz * SceneArray(directional_light_color_and_intensity, 0).w * Color.a,
                          front_rim);
  // back dark
  color = blend_rim_light(color,
                          Material(base_rimlight_back_add_color).rgb * SceneArray(directional_light_color_and_intensity, 0).xyz * SceneArray(directional_light_color_and_intensity, 0).w * Color.a,
                          back_rim);
#if BASE_RIMFRONTSHADE_ENABLE
  color = blend_rim_light(color,
                          (Material(base_rimlight_back_add_color).rgb + Material(base_rimfront_shade_add_color).rgb) * SceneArray(directional_light_color_and_intensity, 0).xyz * SceneArray(directional_light_color_and_intensity, 0).w * Color.a,
                          shade_rim);
#endif  // BASE_RIMFRONTSHADE_ENABLE
#endif
#endif

#if BASE_SPECULARLIGHTING_ENABLE
#if USE_REFLECT_SPECULAR_LIGHT
  vec3 specular = Material(reflect_specular_light_color).xyz;
  vec3 specular_light_vector = Material(reflect_specular_light_direction).xyz;
  float specular_power = Material(reflect_specular_light_intensity).x;
#else
  vec3 specular = Material(base_specularcolor).xyz;
  vec3 specular_light_vector = eye_direction;
  float specular_power = Material(base_specularpower).x;
#endif // USE_REFLECT_SPECULAR_LIGHT
  vec3 rim_normal_specular = normalize(normal2.xyz);
  float specular_value = pow(max(dot(rim_normal_specular, normalize(eye_direction + specular_light_vector)), 0.0), specular_power);
  color += (specular * specular_value * (1.0 - tex_base.a));
#endif

  out_FragColor = vec4(color, alpha);

#if USE_OUTLINE
  out_FragColor = vec4(1.0, 1.0, 1.0, alpha);
#if USE_BASE_TEXTURE
  out_FragColor.xyz *= tex_base.xyz * Material(base_outline_color).xyz;
#if USE_REFLECT_AMBIENT_LIGHT
  out_FragColor.xyz *= Material(reflect_ambient_light_color).xyz * Material(reflect_ambient_light_intensity).x;
#elif USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT || BASE_RIMLIGHTING_ENABLE
  out_FragColor.xyz *= Scene(ambient_light).xyz * ambient_scale.xyz;
#endif
#else
  out_FragColor.xyz *= Material(base_outline_color).xyz;
#if USE_REFLECT_AMBIENT_LIGHT
  out_FragColor.xyz *= Material(reflect_ambient_light_color).xyz * Material(reflect_ambient_light_intensity).x;
#elif USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT || BASE_RIMLIGHTING_ENABLE
  out_FragColor.xyz *= Scene(ambient_light).xyz * ambient_scale.xyz;
#endif // USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT || BASE_RIMLIGHTING_ENABLE
#endif // USE_BASE_TEXTURE
#endif // USE_OUTLINE

#if USE_NOSELINE
#if !NOSELINE_SHOW_ENABLE
  discard;
#endif
  vec3 eye = normalize(vec3(eye_direction.x, 0.0, eye_direction.z));
  float cv = dot(normal, eye_direction);
  cv = (cv + 1.0) * 0.5;

  if (Color.a > 0.5) {
    cv += Material(base_nose_displayright_bias).x;
  } else {
    cv += Material(base_nose_displayleft_bias).x;
  }
  vec3 nose_color = Material(base_outline_color).xyz;
  float nose_alpha = 1.0;

#if BASE_TEX_BASE_ENABLE
  float vis = smoothstep(Color.r, Color.g, cv);
  nose_color = base_color.xyz * Material(base_outline_color).xyz;
#if USE_REFLECT_AMBIENT_LIGHT
  nose_color *= Material(reflect_ambient_light_color).xyz * Material(reflect_ambient_light_intensity).x;
#elif USE_DIFFUSE_LIGHT || USE_SPECULAR_LIGHT || BASE_RIMLIGHTING_ENABLE
  nose_color *= Scene(ambient_light).xyz * ambient_scale.xyz;
#endif
  nose_alpha = vis;
#endif

  if (nose_alpha < 1.0) {
    discard;
  }
  out_FragColor = vec4(nose_color, alpha);
#endif

#if USE_EYELID_LINE
#if !BASE_ELELIDLINE_SHOWRIGHT_ENABLE
  if (Color.a < 0.5) {
    discard;
  }
#endif  // BASE_ELELIDLINE_SHOWRIGHT_ENABLE
#if !BASE_EYELIDLINE_SHOWLEFT_ENABLE
  if (Color.a > 0.5) {
    discard;
  }
#endif  // BASE_EYELIDLINE_SHOWLEFT_ENABLE
#endif  // USE_EYELID_LINE

#if USE_FACE_SHADOW
  out_FragColor = Material(face_shadow_color);
  out_FragColor.w *= alpha;
#endif

#if USE_SPHERE_FOG
#if SPHERE_FOG_TARGET
  float sphere_fog_ratio = clamp((SphereFogDistance[0] - u_sphere_fog.sphere_fog_parameter[0].y) * u_sphere_fog.sphere_fog_parameter[0].x, 0.0, 1.0) * u_sphere_fog.sphere_fog_density[0].y;
#else  // SPHERE_FOG_TARGET
  float sphere_fog_ratio = clamp((SphereFogDistance[0] - u_sphere_fog.sphere_fog_parameter[0].y) * u_sphere_fog.sphere_fog_parameter[0].x, 0.0, 1.0) * u_sphere_fog.sphere_fog_density[0].x;
#endif  // SPHERE_FOG_TARGET
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - sphere_fog_ratio), u_sphere_fog.sphere_fog_parameter[0].z)) + (u_sphere_fog.sphere_fog_color[0].xyz * sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, u_sphere_fog.sphere_fog_color[0].xyz, sphere_fog_ratio);
#if SPHERE_FOG_COUNT >= 2
#if SPHERE_FOG_TARGET_2
  sphere_fog_ratio = clamp((SphereFogDistance[1] - u_sphere_fog.sphere_fog_parameter[1].y) * u_sphere_fog.sphere_fog_parameter[1].x, 0.0, 1.0) * u_sphere_fog.sphere_fog_density[1].y;
#else  // SPHERE_FOG_TARGET_2
  sphere_fog_ratio = clamp((SphereFogDistance[1] - u_sphere_fog.sphere_fog_parameter[1].y) * u_sphere_fog.sphere_fog_parameter[1].x, 0.0, 1.0) * u_sphere_fog.sphere_fog_density[1].x;
#endif  // SPHERE_FOG_TARGET_2
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - sphere_fog_ratio), u_sphere_fog.sphere_fog_parameter[1].z)) + (u_sphere_fog.sphere_fog_color[1].xyz * sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, u_sphere_fog.sphere_fog_color[1].xyz, sphere_fog_ratio);
#endif
#endif  // USE_SPHERE_FOG

#if USE_SPHERE_FOG_REVERSE
#if SPHERE_FOG_REVERSE_TARGET
  float rev_sphere_fog_ratio = clamp((u_sphere_fog.rev_sphere_fog_parameter[0].y - RevSphereFogDistance[0]) * u_sphere_fog.rev_sphere_fog_parameter[0].x, 0.0, 1.0) * u_sphere_fog.rev_sphere_fog_density[0].y;
#else  // SPHERE_FOG_REVERSE_TARGET
  float rev_sphere_fog_ratio = clamp((u_sphere_fog.rev_sphere_fog_parameter[0].y - RevSphereFogDistance[0]) * u_sphere_fog.rev_sphere_fog_parameter[0].x, 0.0, 1.0) * u_sphere_fog.rev_sphere_fog_density[0].x;
#endif  // SPHERE_FOG_REVERSE_TARGET
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - rev_sphere_fog_ratio), u_sphere_fog.rev_sphere_fog_parameter[0].z)) + (u_sphere_fog.rev_sphere_fog_color[0].xyz * rev_sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, u_sphere_fog.rev_sphere_fog_color[0].xyz, rev_sphere_fog_ratio);
#if SPHERE_FOG_REVERSE_COUNT >= 2
#if SPHERE_FOG_REVERSE_TARGET_2
  rev_sphere_fog_ratio = clamp((u_sphere_fog.rev_sphere_fog_parameter[1].y - RevSphereFogDistance[1]) * u_sphere_fog.rev_sphere_fog_parameter[1].x, 0.0, 1.0) * u_sphere_fog.rev_sphere_fog_density[1].y;
#else  // SPHERE_FOG_REVERSE_TARGET_2
  rev_sphere_fog_ratio = clamp((u_sphere_fog.rev_sphere_fog_parameter[1].y - RevSphereFogDistance[1]) * u_sphere_fog.rev_sphere_fog_parameter[1].x, 0.0, 1.0) * u_sphere_fog.rev_sphere_fog_density[1].x;
#endif  // SPHERE_FOG_REVERSE_TARGET_2
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - rev_sphere_fog_ratio), u_sphere_fog.rev_sphere_fog_parameter[1].z)) + (u_sphere_fog.rev_sphere_fog_color[1].xyz * rev_sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, u_sphere_fog.rev_sphere_fog_color[1].xyz, rev_sphere_fog_ratio);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 3
#if SPHERE_FOG_REVERSE_TARGET_3
  rev_sphere_fog_ratio = clamp((u_sphere_fog.rev_sphere_fog_parameter[2].y - RevSphereFogDistance[2]) * u_sphere_fog.rev_sphere_fog_parameter[2].x, 0.0, 1.0) * u_sphere_fog.rev_sphere_fog_density[2].y;
#else  // SPHERE_FOG_REVERSE_TARGET_3
  rev_sphere_fog_ratio = clamp((u_sphere_fog.rev_sphere_fog_parameter[2].y - RevSphereFogDistance[2]) * u_sphere_fog.rev_sphere_fog_parameter[2].x, 0.0, 1.0) * u_sphere_fog.rev_sphere_fog_density[2].x;
#endif  // SPHERE_FOG_REVERSE_TARGET_3
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - rev_sphere_fog_ratio), u_sphere_fog.rev_sphere_fog_parameter[2].z)) + (u_sphere_fog.rev_sphere_fog_color[2].xyz * rev_sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, u_sphere_fog.rev_sphere_fog_color[2].xyz, rev_sphere_fog_ratio);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 4
#if SPHERE_FOG_REVERSE_TARGET_4
  rev_sphere_fog_ratio = clamp((u_sphere_fog.rev_sphere_fog_parameter[3].y - RevSphereFogDistance[3]) * u_sphere_fog.rev_sphere_fog_parameter[3].x, 0.0, 1.0) * u_sphere_fog.rev_sphere_fog_density[3].y;
#else  // SPHERE_FOG_REVERSE_TARGET_4
  rev_sphere_fog_ratio = clamp((u_sphere_fog.rev_sphere_fog_parameter[3].y - RevSphereFogDistance[3]) * u_sphere_fog.rev_sphere_fog_parameter[3].x, 0.0, 1.0) * u_sphere_fog.rev_sphere_fog_density[3].x;
#endif  // SPHERE_FOG_REVERSE_TARGET_4
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - rev_sphere_fog_ratio), u_sphere_fog.rev_sphere_fog_parameter[3].z)) + (u_sphere_fog.rev_sphere_fog_color[3].xyz * rev_sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, u_sphere_fog.rev_sphere_fog_color[3].xyz, rev_sphere_fog_ratio);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 5
#if SPHERE_FOG_REVERSE_TARGET_5
  rev_sphere_fog_ratio = clamp((u_sphere_fog.rev_sphere_fog_parameter[4].y - RevSphereFogDistance[4]) * u_sphere_fog.rev_sphere_fog_parameter[4].x, 0.0, 1.0) * u_sphere_fog.rev_sphere_fog_density[4].y;
#else  // SPHERE_FOG_REVERSE_TARGET_5
  rev_sphere_fog_ratio = clamp((u_sphere_fog.rev_sphere_fog_parameter[4].y - RevSphereFogDistance[4]) * u_sphere_fog.rev_sphere_fog_parameter[4].x, 0.0, 1.0) * u_sphere_fog.rev_sphere_fog_density[4].x;
#endif  // SPHERE_FOG_REVERSE_TARGET_5
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - rev_sphere_fog_ratio), u_sphere_fog.rev_sphere_fog_parameter[4].z)) + (u_sphere_fog.rev_sphere_fog_color[4].xyz * rev_sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, u_sphere_fog.rev_sphere_fog_color[4].xyz, rev_sphere_fog_ratio);
#endif
#if SPHERE_FOG_REVERSE_COUNT >= 6
#if SPHERE_FOG_REVERSE_TARGET_6
  rev_sphere_fog_ratio = clamp((u_sphere_fog.rev_sphere_fog_parameter[5].y - RevSphereFogDistance[5]) * u_sphere_fog.rev_sphere_fog_parameter[5].x, 0.0, 1.0) * u_sphere_fog.rev_sphere_fog_density[5].y;
#else  // SPHERE_FOG_REVERSE_TARGET_6
  rev_sphere_fog_ratio = clamp((u_sphere_fog.rev_sphere_fog_parameter[5].y - RevSphereFogDistance[5]) * u_sphere_fog.rev_sphere_fog_parameter[5].x, 0.0, 1.0) * u_sphere_fog.rev_sphere_fog_density[5].x;
#endif  // SPHERE_FOG_REVERSE_TARGET_6
  out_FragColor.xyz = (out_FragColor.xyz * max((1.0 - rev_sphere_fog_ratio), u_sphere_fog.rev_sphere_fog_parameter[5].z)) + (u_sphere_fog.rev_sphere_fog_color[5].xyz * rev_sphere_fog_ratio);
  // out_FragColor.xyz = mix(out_FragColor.xyz, u_sphere_fog.rev_sphere_fog_color[5].xyz, rev_sphere_fog_ratio);
#endif
#endif  // USE_SPHERE_FOG_REVERSE

  out_FragColor *= Camera(color_scale);

#if USE_DITHER
  out_FragColor.w *= calc_dither(Material(dither_param).x);
#elif USE_ALPHA_TO_COVERAGE
  out_FragColor.w *= Material(a2c_param.x);
#endif // USE_DITHER

#if USE_ALPHA_CUTOFF
  if (out_FragColor.w < Material(alpha_cutoff).x) {
    discard;
  }
#elif USE_DITHER
  if (out_FragColor.w < 1.0/255.0) {
    discard;
  }
#endif
}
   	   Positions�p   position   Normals�   normal   Biormals:�   binormal   TangentsE   tangent   Colorss   color   Normals2.   color2   Uvs3r�   texcoord   SkinIndicesU|	   skinindex   SkinWeightsq�
   skinweight   Worlds|�   world
   UvRegions1�i	   uvregion1
   UvRegions2�j	   uvregion2/      Model��   model	   ModelView�@	   modelview
   Projection.
   projection   View��   view   EyePositiony�   eye_position
   ColorScale�/   color_scale   BindPoseW   bindpose   InvBindPoseB�   bindpose_inverse   Jointsx6   matrix_palette   FogColorJ	   fog_color   FogNear�)
   fog_near   FogFar6w   fog_far
   FogDensity��   fog_density   FogExp2|
   fog_exp2   FogParameter��   fog_parameter   ModelViewProjection��J   modelviewprojection   VertexCount��   vertex_count   AmbientLight��   ambient_light   DirectionalLight0�D<   directional_light0   DirectionalLight1�E<   directional_light1   DirectionalLight2�F<   directional_light2   DirectionalLight3�G<   directional_light3   DirectionalLight4�H<   directional_light4   DirectionalLight5�I<   directional_light5   DirectionalLight6�J<   directional_light6   DirectionalLight7�K<   directional_light7   PointLight03�   point_light0   PointLight14�   point_light1   PointLight25�   point_light2   PointLight36�   point_light3   PointLight47�   point_light4   PointLight58�   point_light5   PointLight69�   point_light6   PointLight7:�   point_light7
   SpotLight0��   spot_light0
   SpotLight1��   spot_light1
   SpotLight2��   spot_light2
   SpotLight3��   spot_light3
   SpotLight4��   spot_light4
   SpotLight5��   spot_light5
   SpotLight6��   spot_light6
   SpotLight7��   spot_light7   ProjMatrix0A�   proj_matrix0   ProjTexture0�]	   proj_map0   ProjMatrix1B�   proj_matrix1   ProjTexture1�^	   proj_map1   ProjColorMatrixR/   proj_color_matrix<      DitherParamRm   dither_param  �?  �?  �?  �?      AlphaToCoverageParam�sP	   a2c_param  �?                  AlphaCutoffN   alpha_cutoff   ?               	   BaseColor{�   diffuse_color  �?  �?  �?          EmissiveColorE5$   emissive_color                      ReplaceColor�!   replace_color                       Env_DirectionalLight_0_Intensity�a�    env_directionallight_0_intensity  �?                  Env_DirectionalLight_0_Color�
s�   env_directionallight_0_color  �?  �?  �?          Env_DirectionalLight_0_VectorP�   env_directionallight_0_vector          �?          Base_StageLightBorder_Width�
��   base_stagelightborder_width
�#<                  Base_StageLightShade_Bias�	&{   base_stagelightshade_bias��L�                  Base_StageLightShade_Color

X�   base_stagelightshade_color  �?  �?  �?          Base_RimAdd_Rate��1   base_rimadd_rate  �?                  Base_RimMul_Rate�2   base_rimmul_rate��L?                  Base_RimLightFrontAdd_Colork
��   base_rimlight_front_add_color                      Base_RimLightFrontMul_Color�
��   base_rimlight_front_mul_color                      Base_RimLightBackAdd_Color�	Ղ   base_rimlight_back_add_color                      Base_RimLightBackMul_Color�	�   base_rimlight_back_mul_color                      Base_RimFrontShadeAdd_ColorX
/�   base_rimfront_shade_add_color                      Base_RimFrontShadeMul_Color}
[�   base_rimfront_shade_mul_color  �?  �?  �?          Base_Tex_Base_Alpha_Rate	/p   base_tex_alpha_rate  �?                  UvShift��
   uv_shift                      Base_OutlineReviseDistanceT
��   base_outline_revise_distance                      Base_OutlineReviseRatio(	�k   base_outline_revise_ratio                      Base_OutlineWidth�#;   base_outline_width                      Base_OutlineShift�
;   base_outline_shift                      Base_OutlineExpandRatio	fk   base_outline_expand_ratio                      Base_OutlineColor��:   base_outline_color                      Base_RimLightFront_Tol�?`   base_rimlight_front_tol                      Base_RimLightBack_Tol�}V   base_rimlight_back_tol                      Base_RimFrontShade_Tol>`   base_rimfront_shade_tol                      Base_RimLightFront_Smooth�	�|   base_rimlight_front_smooth                      Base_RimLightBack_SmoothE	q   base_rimlight_back_smooth                      Base_RimFrontShade_Smooth�	T|   base_rimfront_shade_smooth                      Base_RimShadeFrontBlend_Rate�
�   base_rimshadefrontblend_rate                      Base_RimShadeBackBlend_Rate)
��   base_rimshadebackblend_rate  �?                  Base_RimFrontShadeBlend_Rate�
��   base_rimfrontshadeblend_rate  �?                  Base_RimFrontShadeIntensity�
J�   base_rimfrontshade_intensity  �?                  Base_SpecularColor�A   base_specularcolor                      Base_SpecularPower'�A   base_specularpower   @                  Base_NoseDisplayLeft_Bias�	�|   base_nose_displayleft_bias                      Base_NoseDisplayRight_Bias"
-�   base_nose_displayright_bias                      FaceShadowColor��,   face_shadow_color                      FaceShadowShift��,   face_shadow_shift                      FaceShadowFront��,   face_shadow_front                      BlendShapeRatio��-   blend_shape_ratio                      BlendShapeEyeRatio��@   blend_shape_eye_ratio                      BlendShapeIndex0�X3   blend_shape_index0                      BlendShapeIndex1 Y3   blend_shape_index1                      ReflectDirectionalLightColor+2�   reflect_directional_light_color                       ReflectDirectionalLightIntensity�\�#   reflect_directional_light_intensity                       ReflectDirectionalLightDirection���#   reflect_directional_light_direction                      ReflectPointLightColor��c   reflect_point_light_color                      ReflectPointLightIntensity�
9�   reflect_point_light_intensity                      ReflectPointLightDirectioni
��   reflect_point_light_direction                      ReflectAmbientLightColor}	�t   reflect_ambient_light_color                      ReflectAmbientLightIntensityED�   reflect_ambient_light_intensity                      ReflectSpecularLightColor�	m�   reflect_specular_light_color                      ReflectSpecularLightIntensity�۬    reflect_specular_light_intensity                      ReflectSpecularLightDirection�0�    reflect_specular_light_direction                             BoneTexturev�   bone_map   Base_Tex_Base��!   base_map   Base_Tex_RimShadexs9   base_rimshade_map      SphereFogBuffer��.��          u_sphere_fog         UVOffset   UVRepeat   UVRotatea   texcoord_matrix]�2   /      UsesBaseTexture&/   USE_BASE_TEXTURE         UsesDiffuseLight_�5   USE_DIFFUSE_LIGHT          UsesProjColor;$   USE_PROJ_COLOR          UsesProjShadow��)   USE_PROJ_SHADOW          Base_StageLighting_Enable�	?|   BASE_STAGELIGHTING_ENABLE          Base_RimLighting_Enable�i   BASE_RIMLIGHTING_ENABLE          Base_RimFrontShade_Enable�	�{   BASE_RIMFRONTSHADE_ENABLE          Base_Tex_Base_Enable�?N   BASE_TEX_BASE_ENABLE          Base_Tex_RimShade_Enable	�p   BASE_TEX_RIMSHADE_ENABLE          Base_OutlineRevise_Enable�	�~   BASE_OUTLINEREVISE_ENABLE          Base_Tex_RimShade_UseUV2�q   BASE_TEX_RIMSHADE_USEUV2          Base_RimLight_UseCustomNormalk5�   BASE_RIMLIGHT_USECUSTOMNORMAL          Base_SpecularLighting_Enable�
��   BASE_SPECULARLIGHTING_ENABLE          Base_RimMask_Modes#9   BASE_RIMMASK_MODE       
   UsesDither�
   USE_DITHER          UsesAlphaToCoveragev�I   USE_ALPHA_TO_COVERAGE          UsesVertexColorQ0   USE_VTX_COLOR          UsesVertexColorToStageLight�
��   USE_VTX_COLOR_TO_STAGE_LIGHT          Base_Tex_Base_Alpha_Mode	%p   BASE_TEXTURE_ALPHA_MODE          UsesAlphaTest'~#   USE_ALPHA_CUTOFF          UvShiftEnable?#   UV_SHIFT_ENABLE          UsesOutline��   USE_OUTLINE          UsesNoseLine��   USE_NOSELINE          UsesEyelidLine�])   USE_EYELID_LINE          Base_Eyelidline_ShowLeft_Enableܿ   BASE_EYELIDLINE_SHOWLEFT_ENABLE           Base_Eyelidline_ShowRight_Enable���    BASE_ELELIDLINE_SHOWRIGHT_ENABLE          NoseLine_Show_Enable�8Q   NOSELINE_SHOW_ENABLE          UsesFaceShadowv7(   USE_FACE_SHADOW          UsesBlendShapew�(   USE_BLEND_SHAPE          UsesReflectDirectionalLight�
�   USE_REFLECT_DIRECTIONAL_LIGHT          UsesReflectPointLighth�[   USE_REFLECT_POINT_LIGHT          UsesDefaultDirectionalLight�
��   USE_DEFAULT_DIRECTIONAL_LIGHT          UsesReflectAmbientLight	�l   USE_REFLECT_AMBIENT_LIGHT          UsesReflectSpecularLight�	Kw   USE_REFLECT_SPECULAR_LIGHT          UseFogJ�   USE_FOG          UseSphereFog�q   USE_SPHERE_FOG          SphereFogCount��(   SPHERE_FOG_COUNT         SphereFogTarget��.   SPHERE_FOG_TARGET          SphereFogTarget2�4   SPHERE_FOG_TARGET_2          UseSphereFogReverse�gJ   USE_SPHERE_FOG_REVERSE          SphereFogReverseCounti�Z   SPHERE_FOG_REVERSE_COUNT         SphereFogReverseTarget��c   SPHERE_FOG_REVERSE_TARGET          SphereFogReverseTarget2��l   SPHERE_FOG_REVERSE_TARGET_2          SphereFogReverseTarget3��l   SPHERE_FOG_REVERSE_TARGET_3          SphereFogReverseTarget4��l   SPHERE_FOG_REVERSE_TARGET_4          SphereFogReverseTarget5��l   SPHERE_FOG_REVERSE_TARGET_5          SphereFogReverseTarget6��l   SPHERE_FOG_REVERSE_TARGET_6          chara �