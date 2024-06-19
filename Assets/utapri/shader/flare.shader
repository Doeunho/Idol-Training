���     ir  �SK  !x_               default�N�
7�     #r  ���  "X�                        //macros
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

uniform vec4 flare_aspect; //vec4
uniform vec4 flare_shapes[4];
uniform vec4 flare_sharpness[4];
uniform vec4 flare_colors1[4];
uniform vec4 flare_colors2[4];
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
�)  //macros
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

uniform vec4 flare_aspect; //vec4
uniform vec4 flare_shapes[4];
uniform vec4 flare_sharpness[4];
uniform vec4 flare_colors1[4];
uniform vec4 flare_colors2[4];
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
const float NOISE_GRANULARITY = 0.5 / 255.0;

vec4 FlareLinearGradation(in vec2 base_pos, in vec4 color_scale,
                          in vec4 shape, in vec4 color1, in vec4 color2) {
  vec2 midpoint = (shape.xy + shape.zw) * 0.5;
  float len = distance(midpoint, shape.zw);
  vec2 v = normalize(shape.xy - shape.zw);
  vec2 to_base = base_pos - midpoint;
  float d = dot(v, to_base);
  float power = smoothstep(-len, len, d);
  vec4 color = power * color1 * color_scale + (1.0 - power) * color2 * color_scale;
  return color;
}
vec4 FlareGradation(in vec4 aspect, in vec2 pos, in vec4 color_scale,
                    in vec4 shape, in vec4 color1, in vec4 color2) {
  float radius = distance(shape.xy, shape.zw) * 2.0;
  float d = length(pos / vec2(radius / aspect.y * 2.0, radius * 2.0));
  float power = smoothstep(0.5, 1.0, 1.0 - d);
  vec4 color = power * color1 * color_scale + (1.0 - power) * color2 * color_scale;
  return color;
}
vec4 Flare(in vec4 aspect, in vec2 pos,
           in vec4 shape, in vec4 color1, in vec4 sharpness) {
  // normal flare
  float d = length(pos / vec2(shape.z / aspect.y * 2.0, shape.w * 2.0));
  vec4 color = vec4(smoothstep(0.5, 0.5 + max(0.0, (1.0 - sharpness.x)), 1.0 - d));
  color *= color1;
  return color;
}

vec4 AddBlend(in vec4 base, in vec4 color) {
  return base + color;
}
vec4 OverBlend(in vec4 base, in vec4 color) {
  return vec4(color.xyz * color.w + base.xyz * (1.0 - color.w), 1.0);
}
float OverlayBlend(in float base, in float color) {
  return (base < 0.5 ? (2.0 * base * color) : (1.0 - 2.0 * (1.0 - base) * (1.0 - color)));
}
vec4 OverlayBlend(in vec4 base, in vec4 color, in vec4 color_scale) {
  vec4 result = color;
  result.x = OverlayBlend(base.x / color_scale.x, color.x) * color_scale.x;
  result.y = OverlayBlend(base.y / color_scale.y, color.y) * color_scale.y;
  result.z = OverlayBlend(base.z / color_scale.z, color.z) * color_scale.z;
  return OverBlend(base, result);
}
vec4 OverlayBlend2(in vec4 base, in vec4 color, in vec4 color_scale) {
  vec4 result = color;
  result.x = OverlayBlend(base.x / color_scale.x, color.x / color_scale.x) * color_scale.x;
  result.y = OverlayBlend(base.y / color_scale.y, color.y / color_scale.y) * color_scale.y;
  result.z = OverlayBlend(base.z / color_scale.z, color.z / color_scale.z) * color_scale.z;
  return OverBlend(base, result);
}
float rand(in vec2 co) {
  return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
  vec2 base_pos = BaseUV * 2.0 - 1.0;
  vec4 aspect = Material(flare_aspect);
  float aspect_ratio = aspect.x / aspect.y;
  float calcd_aspect = mix(aspect.y, aspect.x, step(1.0, aspect_ratio));
  aspect_ratio = max(1.0, aspect_ratio);
  vec4 color_scale = PostProcessPass(sys_camera_colorscale);
  out_FragColor = texture(base_map, BaseUV);

  int index = 0;
  vec4 shape = MaterialArray(flare_shapes, index);
  vec2 pos = base_pos;
  vec4 color = vec4(1.0);
  vec4 noise = vec4(mix(-NOISE_GRANULARITY, NOISE_GRANULARITY, rand(BaseUV)));
#if FLARE_ENABLE1
  pos.x -= shape.x / calcd_aspect * 2.0;
  pos.y -= shape.y / aspect_ratio * 2.0;
  pos.xy *= aspect_ratio;

#if FLARE_LINEAR_GRADATION_ENABLE1
  color = FlareLinearGradation(base_pos, color_scale, shape,
                               MaterialArray(flare_colors1, index),
                               MaterialArray(flare_colors2, index));
#elif FLARE_GRADATION_ENABLE1
  color = FlareGradation(aspect, pos, color_scale, shape,
                         MaterialArray(flare_colors1, index),
                         MaterialArray(flare_colors2, index));
#else
  color = Flare(aspect, pos, shape,
                MaterialArray(flare_colors1, index),
                MaterialArray(flare_sharpness, index));
#endif

#if FLARE_DEPTH_INDEX1 == 1
  color *= texture(base_map2, BaseUV).x;
#elif FLARE_DEPTH_INDEX1 == 2
  color *= texture(base_map3, BaseUV).x;
#elif FLARE_DEPTH_INDEX1 == 3
  color *= texture(base_map4, BaseUV).x;
#elif FLARE_DEPTH_INDEX1 == 4
  color *= texture(base_map5, BaseUV).x;
#endif

color += noise;
noise *= 0.5;

#if FLARE_BLEND_MODE1 == 1
  out_FragColor = AddBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE1 == 2
  out_FragColor = OverBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE1 == 3
  out_FragColor = OverlayBlend(out_FragColor, color, color_scale);
#elif FLARE_BLEND_MODE1 == 4
  out_FragColor = OverlayBlend2(out_FragColor, color, color_scale);
#endif  // FLARE_BLEND_MODE1
#endif  // FLARE_ENABLE1

#if FLARE_ENABLE2
  index = 1;
  shape = MaterialArray(flare_shapes, index);
  pos.x = base_pos.x - shape.x / calcd_aspect * 2.0;
  pos.y = base_pos.y - shape.y / aspect_ratio * 2.0;
  pos.xy *= aspect_ratio;

#if FLARE_LINEAR_GRADATION_ENABLE2
  color = FlareLinearGradation(base_pos, color_scale, shape,
                               MaterialArray(flare_colors1, index),
                               MaterialArray(flare_colors2, index));
#elif FLARE_GRADATION_ENABLE2
  color = FlareGradation(aspect, pos, color_scale, shape,
                         MaterialArray(flare_colors1, index),
                         MaterialArray(flare_colors2, index));
#else
  color = Flare(aspect, pos, shape,
                MaterialArray(flare_colors1, index),
                MaterialArray(flare_sharpness, index));
#endif

#if FLARE_DEPTH_INDEX2 == 1
  color *= texture(base_map2, BaseUV).x;
#elif FLARE_DEPTH_INDEX2 == 2
  color *= texture(base_map3, BaseUV).x;
#elif FLARE_DEPTH_INDEX2 == 3
  color *= texture(base_map4, BaseUV).x;
#elif FLARE_DEPTH_INDEX2 == 4
  color *= texture(base_map5, BaseUV).x;
#endif

color += noise;
noise *= 0.5;

#if FLARE_BLEND_MODE2 == 1
  out_FragColor = AddBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE2 == 2
  out_FragColor = OverBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE2 == 3
  out_FragColor = OverlayBlend(out_FragColor, color, color_scale);
#elif FLARE_BLEND_MODE2 == 4
  out_FragColor = OverlayBlend2(out_FragColor, color, color_scale);
#endif  // FLARE_BLEND_MODE2
#endif  // FLARE_ENABLE2

#if FLARE_ENABLE3
  index = 2;
  shape = MaterialArray(flare_shapes, index);
  pos.x = base_pos.x - shape.x / calcd_aspect * 2.0;
  pos.y = base_pos.y - shape.y / aspect_ratio * 2.0;
  pos.xy *= aspect_ratio;

#if FLARE_LINEAR_GRADATION_ENABLE3
  color = FlareLinearGradation(base_pos, color_scale, shape,
                               MaterialArray(flare_colors1, index),
                               MaterialArray(flare_colors2, index));
#elif FLARE_GRADATION_ENABLE3
  color = FlareGradation(aspect, pos, color_scale, shape,
                         MaterialArray(flare_colors1, index),
                         MaterialArray(flare_colors2, index));
#else
  color = Flare(aspect, pos, shape,
                MaterialArray(flare_colors1, index),
                MaterialArray(flare_sharpness, index));
#endif

#if FLARE_DEPTH_INDEX3 == 1
  color *= texture(base_map2, BaseUV).x;
#elif FLARE_DEPTH_INDEX3 == 2
  color *= texture(base_map3, BaseUV).x;
#elif FLARE_DEPTH_INDEX3 == 3
  color *= texture(base_map4, BaseUV).x;
#elif FLARE_DEPTH_INDEX3 == 4
  color *= texture(base_map5, BaseUV).x;
#endif

color += noise;
noise *= 0.5;

#if FLARE_BLEND_MODE3 == 1
  out_FragColor = AddBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE3 == 2
  out_FragColor = OverBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE3 == 3
  out_FragColor = OverlayBlend(out_FragColor, color, color_scale);
#elif FLARE_BLEND_MODE3 == 4
  out_FragColor = OverlayBlend2(out_FragColor, color, color_scale);
#endif  // FLARE_BLEND_MODE3
#endif  // FLARE_ENABLE3

#if FLARE_ENABLE4
  index = 3;
  shape = MaterialArray(flare_shapes, index);
  pos.x = base_pos.x - shape.x / calcd_aspect * 2.0;
  pos.y = base_pos.y - shape.y / aspect_ratio * 2.0;
  pos.xy *= aspect_ratio;

#if FLARE_LINEAR_GRADATION_ENABLE4
  color = FlareLinearGradation(base_pos, color_scale, shape,
                               MaterialArray(flare_colors1, index),
                               MaterialArray(flare_colors2, index));
#elif FLARE_GRADATION_ENABLE4
  color = FlareGradation(aspect, pos, color_scale, shape,
                         MaterialArray(flare_colors1, index),
                         MaterialArray(flare_colors2, index));
#else
  color = Flare(aspect, pos, shape,
                MaterialArray(flare_colors1, index),
                MaterialArray(flare_sharpness, index));
#endif

#if FLARE_DEPTH_INDEX4 == 1
  color *= texture(base_map2, BaseUV).x;
#elif FLARE_DEPTH_INDEX4 == 2
  color *= texture(base_map3, BaseUV).x;
#elif FLARE_DEPTH_INDEX4 == 3
  color *= texture(base_map4, BaseUV).x;
#elif FLARE_DEPTH_INDEX4 == 4
  color *= texture(base_map5, BaseUV).x;
#endif

color += noise;

#if FLARE_BLEND_MODE4 == 1
  out_FragColor = AddBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE4 == 2
  out_FragColor = OverBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE4 == 3
  out_FragColor = OverlayBlend(out_FragColor, color, color_scale);
#elif FLARE_BLEND_MODE4 == 4
  out_FragColor = OverlayBlend2(out_FragColor, color, color_scale);
#endif  // FLARE_BLEND_MODE4
#endif  // FLARE_ENABLE4

  out_FragColor.a = 1.0;
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
  vec4 flare_aspect; //vec4
  vec4 flare_shapes[4];
  vec4 flare_sharpness[4];
  vec4 flare_colors1[4];
  vec4 flare_colors2[4];
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
�,  #version 450
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
  vec4 flare_aspect; //vec4
  vec4 flare_shapes[4];
  vec4 flare_sharpness[4];
  vec4 flare_colors1[4];
  vec4 flare_colors2[4];
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
const float NOISE_GRANULARITY = 0.5 / 255.0;

vec4 FlareLinearGradation(in vec2 base_pos, in vec4 color_scale,
                          in vec4 shape, in vec4 color1, in vec4 color2) {
  vec2 midpoint = (shape.xy + shape.zw) * 0.5;
  float len = distance(midpoint, shape.zw);
  vec2 v = normalize(shape.xy - shape.zw);
  vec2 to_base = base_pos - midpoint;
  float d = dot(v, to_base);
  float power = smoothstep(-len, len, d);
  vec4 color = power * color1 * color_scale + (1.0 - power) * color2 * color_scale;
  return color;
}
vec4 FlareGradation(in vec4 aspect, in vec2 pos, in vec4 color_scale,
                    in vec4 shape, in vec4 color1, in vec4 color2) {
  float radius = distance(shape.xy, shape.zw) * 2.0;
  float d = length(pos / vec2(radius / aspect.y * 2.0, radius * 2.0));
  float power = smoothstep(0.5, 1.0, 1.0 - d);
  vec4 color = power * color1 * color_scale + (1.0 - power) * color2 * color_scale;
  return color;
}
vec4 Flare(in vec4 aspect, in vec2 pos,
           in vec4 shape, in vec4 color1, in vec4 sharpness) {
  // normal flare
  float d = length(pos / vec2(shape.z / aspect.y * 2.0, shape.w * 2.0));
  vec4 color = vec4(smoothstep(0.5, 0.5 + max(0.0, (1.0 - sharpness.x)), 1.0 - d));
  color *= color1;
  return color;
}

vec4 AddBlend(in vec4 base, in vec4 color) {
  return base + color;
}
vec4 OverBlend(in vec4 base, in vec4 color) {
  return vec4(color.xyz * color.w + base.xyz * (1.0 - color.w), 1.0);
}
float OverlayBlend(in float base, in float color) {
  return (base < 0.5 ? (2.0 * base * color) : (1.0 - 2.0 * (1.0 - base) * (1.0 - color)));
}
vec4 OverlayBlend(in vec4 base, in vec4 color, in vec4 color_scale) {
  vec4 result = color;
  result.x = OverlayBlend(base.x / color_scale.x, color.x) * color_scale.x;
  result.y = OverlayBlend(base.y / color_scale.y, color.y) * color_scale.y;
  result.z = OverlayBlend(base.z / color_scale.z, color.z) * color_scale.z;
  return OverBlend(base, result);
}
vec4 OverlayBlend2(in vec4 base, in vec4 color, in vec4 color_scale) {
  vec4 result = color;
  result.x = OverlayBlend(base.x / color_scale.x, color.x / color_scale.x) * color_scale.x;
  result.y = OverlayBlend(base.y / color_scale.y, color.y / color_scale.y) * color_scale.y;
  result.z = OverlayBlend(base.z / color_scale.z, color.z / color_scale.z) * color_scale.z;
  return OverBlend(base, result);
}
float rand(in vec2 co) {
  return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
  vec2 base_pos = BaseUV * 2.0 - 1.0;
  vec4 aspect = Material(flare_aspect);
  float aspect_ratio = aspect.x / aspect.y;
  float calcd_aspect = mix(aspect.y, aspect.x, step(1.0, aspect_ratio));
  aspect_ratio = max(1.0, aspect_ratio);
  vec4 color_scale = PostProcessPass(sys_camera_colorscale);
  out_FragColor = texture(base_map, BaseUV);

  int index = 0;
  vec4 shape = MaterialArray(flare_shapes, index);
  vec2 pos = base_pos;
  vec4 color = vec4(1.0);
  vec4 noise = vec4(mix(-NOISE_GRANULARITY, NOISE_GRANULARITY, rand(BaseUV)));
#if FLARE_ENABLE1
  pos.x -= shape.x / calcd_aspect * 2.0;
  pos.y -= shape.y / aspect_ratio * 2.0;
  pos.xy *= aspect_ratio;

#if FLARE_LINEAR_GRADATION_ENABLE1
  color = FlareLinearGradation(base_pos, color_scale, shape,
                               MaterialArray(flare_colors1, index),
                               MaterialArray(flare_colors2, index));
#elif FLARE_GRADATION_ENABLE1
  color = FlareGradation(aspect, pos, color_scale, shape,
                         MaterialArray(flare_colors1, index),
                         MaterialArray(flare_colors2, index));
#else
  color = Flare(aspect, pos, shape,
                MaterialArray(flare_colors1, index),
                MaterialArray(flare_sharpness, index));
#endif

#if FLARE_DEPTH_INDEX1 == 1
  color *= texture(base_map2, BaseUV).x;
#elif FLARE_DEPTH_INDEX1 == 2
  color *= texture(base_map3, BaseUV).x;
#elif FLARE_DEPTH_INDEX1 == 3
  color *= texture(base_map4, BaseUV).x;
#elif FLARE_DEPTH_INDEX1 == 4
  color *= texture(base_map5, BaseUV).x;
#endif

color += noise;
noise *= 0.5;

#if FLARE_BLEND_MODE1 == 1
  out_FragColor = AddBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE1 == 2
  out_FragColor = OverBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE1 == 3
  out_FragColor = OverlayBlend(out_FragColor, color, color_scale);
#elif FLARE_BLEND_MODE1 == 4
  out_FragColor = OverlayBlend2(out_FragColor, color, color_scale);
#endif  // FLARE_BLEND_MODE1
#endif  // FLARE_ENABLE1

#if FLARE_ENABLE2
  index = 1;
  shape = MaterialArray(flare_shapes, index);
  pos.x = base_pos.x - shape.x / calcd_aspect * 2.0;
  pos.y = base_pos.y - shape.y / aspect_ratio * 2.0;
  pos.xy *= aspect_ratio;

#if FLARE_LINEAR_GRADATION_ENABLE2
  color = FlareLinearGradation(base_pos, color_scale, shape,
                               MaterialArray(flare_colors1, index),
                               MaterialArray(flare_colors2, index));
#elif FLARE_GRADATION_ENABLE2
  color = FlareGradation(aspect, pos, color_scale, shape,
                         MaterialArray(flare_colors1, index),
                         MaterialArray(flare_colors2, index));
#else
  color = Flare(aspect, pos, shape,
                MaterialArray(flare_colors1, index),
                MaterialArray(flare_sharpness, index));
#endif

#if FLARE_DEPTH_INDEX2 == 1
  color *= texture(base_map2, BaseUV).x;
#elif FLARE_DEPTH_INDEX2 == 2
  color *= texture(base_map3, BaseUV).x;
#elif FLARE_DEPTH_INDEX2 == 3
  color *= texture(base_map4, BaseUV).x;
#elif FLARE_DEPTH_INDEX2 == 4
  color *= texture(base_map5, BaseUV).x;
#endif

color += noise;
noise *= 0.5;

#if FLARE_BLEND_MODE2 == 1
  out_FragColor = AddBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE2 == 2
  out_FragColor = OverBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE2 == 3
  out_FragColor = OverlayBlend(out_FragColor, color, color_scale);
#elif FLARE_BLEND_MODE2 == 4
  out_FragColor = OverlayBlend2(out_FragColor, color, color_scale);
#endif  // FLARE_BLEND_MODE2
#endif  // FLARE_ENABLE2

#if FLARE_ENABLE3
  index = 2;
  shape = MaterialArray(flare_shapes, index);
  pos.x = base_pos.x - shape.x / calcd_aspect * 2.0;
  pos.y = base_pos.y - shape.y / aspect_ratio * 2.0;
  pos.xy *= aspect_ratio;

#if FLARE_LINEAR_GRADATION_ENABLE3
  color = FlareLinearGradation(base_pos, color_scale, shape,
                               MaterialArray(flare_colors1, index),
                               MaterialArray(flare_colors2, index));
#elif FLARE_GRADATION_ENABLE3
  color = FlareGradation(aspect, pos, color_scale, shape,
                         MaterialArray(flare_colors1, index),
                         MaterialArray(flare_colors2, index));
#else
  color = Flare(aspect, pos, shape,
                MaterialArray(flare_colors1, index),
                MaterialArray(flare_sharpness, index));
#endif

#if FLARE_DEPTH_INDEX3 == 1
  color *= texture(base_map2, BaseUV).x;
#elif FLARE_DEPTH_INDEX3 == 2
  color *= texture(base_map3, BaseUV).x;
#elif FLARE_DEPTH_INDEX3 == 3
  color *= texture(base_map4, BaseUV).x;
#elif FLARE_DEPTH_INDEX3 == 4
  color *= texture(base_map5, BaseUV).x;
#endif

color += noise;
noise *= 0.5;

#if FLARE_BLEND_MODE3 == 1
  out_FragColor = AddBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE3 == 2
  out_FragColor = OverBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE3 == 3
  out_FragColor = OverlayBlend(out_FragColor, color, color_scale);
#elif FLARE_BLEND_MODE3 == 4
  out_FragColor = OverlayBlend2(out_FragColor, color, color_scale);
#endif  // FLARE_BLEND_MODE3
#endif  // FLARE_ENABLE3

#if FLARE_ENABLE4
  index = 3;
  shape = MaterialArray(flare_shapes, index);
  pos.x = base_pos.x - shape.x / calcd_aspect * 2.0;
  pos.y = base_pos.y - shape.y / aspect_ratio * 2.0;
  pos.xy *= aspect_ratio;

#if FLARE_LINEAR_GRADATION_ENABLE4
  color = FlareLinearGradation(base_pos, color_scale, shape,
                               MaterialArray(flare_colors1, index),
                               MaterialArray(flare_colors2, index));
#elif FLARE_GRADATION_ENABLE4
  color = FlareGradation(aspect, pos, color_scale, shape,
                         MaterialArray(flare_colors1, index),
                         MaterialArray(flare_colors2, index));
#else
  color = Flare(aspect, pos, shape,
                MaterialArray(flare_colors1, index),
                MaterialArray(flare_sharpness, index));
#endif

#if FLARE_DEPTH_INDEX4 == 1
  color *= texture(base_map2, BaseUV).x;
#elif FLARE_DEPTH_INDEX4 == 2
  color *= texture(base_map3, BaseUV).x;
#elif FLARE_DEPTH_INDEX4 == 3
  color *= texture(base_map4, BaseUV).x;
#elif FLARE_DEPTH_INDEX4 == 4
  color *= texture(base_map5, BaseUV).x;
#endif

color += noise;

#if FLARE_BLEND_MODE4 == 1
  out_FragColor = AddBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE4 == 2
  out_FragColor = OverBlend(out_FragColor, color);
#elif FLARE_BLEND_MODE4 == 3
  out_FragColor = OverlayBlend(out_FragColor, color, color_scale);
#elif FLARE_BLEND_MODE4 == 4
  out_FragColor = OverlayBlend2(out_FragColor, color, color_scale);
#endif  // FLARE_BLEND_MODE4
#endif  // FLARE_ENABLE4

  out_FragColor.a = 1.0;
}
   	   Positions�p   position   Uvs1p�   texcoord      Model��   model	   ModelView�@	   modelview
   Projection.
   projection   View��   view   BaseTextureSize�.   base_map_size   BaseTextureSize2:&5   base_map_size2   BaseTextureSize3;'5   base_map_size3   BaseTextureSize4<(5   base_map_size4   BaseTextureSize5=)5   base_map_size5   BaseTextureSize6>*5   base_map_size6   BaseTextureSize7?+5   base_map_size7   BaseTextureSize8@,5   base_map_size8   DepthTextureSize�=6   depth_map_size   sys_camera_colorscale�+`   sys_camera_colorscale      flare_aspect��   flare_aspect\��?\��?                 flare_shapes��   flare_shapes              ?   ?           ?   ?           ?   ?           ?   ?   flare_sharpnessAQ1   flare_sharpness      ?               ?               ?               ?               flare_colors1-%   flare_colors1     �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?   flare_colors2.%   flare_colors2     �?          �?  �?          �?  �?          �?  �?          �?	      BaseTexturemX   base_map   BaseTexture2��	   base_map2   BaseTexture3��	   base_map3   BaseTexture4��	   base_map4   BaseTexture5��	   base_map5   BaseTexture6��	   base_map6   BaseTexture7��	   base_map7   BaseTexture8��	   base_map8   DepthTexture��	   depth_map              FLARE_ENABLE1�2   FLARE_ENABLE1         FLARE_ENABLE2�3   FLARE_ENABLE2          FLARE_ENABLE3�4   FLARE_ENABLE3          FLARE_ENABLE4�5   FLARE_ENABLE4          FLARE_GRADATION_ENABLE1��P   FLARE_GRADATION_ENABLE1          FLARE_GRADATION_ENABLE2��P   FLARE_GRADATION_ENABLE2          FLARE_GRADATION_ENABLE3��P   FLARE_GRADATION_ENABLE3          FLARE_GRADATION_ENABLE4��P   FLARE_GRADATION_ENABLE4          FLARE_LINEAR_GRADATION_ENABLE1�
�   FLARE_LINEAR_GRADATION_ENABLE1          FLARE_LINEAR_GRADATION_ENABLE2��   FLARE_LINEAR_GRADATION_ENABLE2          FLARE_LINEAR_GRADATION_ENABLE3��   FLARE_LINEAR_GRADATION_ENABLE3          FLARE_LINEAR_GRADATION_ENABLE4��   FLARE_LINEAR_GRADATION_ENABLE4          FLARE_BLEND_MODE1��,   FLARE_BLEND_MODE1         FLARE_BLEND_MODE2��,   FLARE_BLEND_MODE2         FLARE_BLEND_MODE3��,   FLARE_BLEND_MODE3         FLARE_BLEND_MODE4��,   FLARE_BLEND_MODE4         FLARE_DEPTH_INDEX1G�2   FLARE_DEPTH_INDEX1          FLARE_DEPTH_INDEX2H�2   FLARE_DEPTH_INDEX2          FLARE_DEPTH_INDEX3I�2   FLARE_DEPTH_INDEX3          FLARE_DEPTH_INDEX4J�2   FLARE_DEPTH_INDEX4          flare