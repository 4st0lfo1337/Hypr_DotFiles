precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec2 uv = v_texcoord;
    
    // Curvatura suave
    vec2 curved = uv * 2.0 - 1.0;
    vec2 offset = curved.yx / 12.0;
    curved += curved * offset * offset;
    curved = curved * 0.5 + 0.5;
    
    if (curved.x < 0.0 || curved.x > 1.0 || curved.y < 0.0 || curved.y > 1.0) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }
    
    // RGB split bem sutil
    float aberration = 0.0008;
    float r = texture2D(tex, vec2(curved.x + aberration, curved.y)).r;
    float g = texture2D(tex, vec2(curved.x, curved.y)).g;
    float b = texture2D(tex, vec2(curved.x - aberration, curved.y)).b;
    vec3 color = vec3(r, g, b);
    
    // Scanlines muito sutis
    float scanline = sin(curved.y * 1200.0) * 0.02;
    color -= scanline;
    
    // Vinheta suave
    vec2 vig = curved * (1.0 - curved.yx);
    float vignette = pow(vig.x * vig.y * 20.0, 0.15);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}