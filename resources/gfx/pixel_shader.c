extern vec4 mult_col;
extern vec4 add_col;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
    vec4 c = Texel(texture, texture_coords).rgba;
    c *= mult_col;
    c += add_col;
    // c.r = min(1,max(0,c.r));
    // c.g = min(1,max(0,c.g));
    // c.b = min(1,max(0,c.b));
    // c.a = min(1,max(0,c.a));
    return color * c;
}