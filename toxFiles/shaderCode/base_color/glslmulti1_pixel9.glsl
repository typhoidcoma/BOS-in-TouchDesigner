// The Book of Shaders | https://thebookofshaders.com/
// Patricio Gonzalez Vivo | http://patriciogonzalezvivo.com/
// Jen Lowe | http://jenlowe.net/

// Ported to TouchDesigner by Matthew Ragan
// matthewragan.com

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// As a disclaimer, I don't own any of this code. This is really
// just a passion project to help build bridges between the larger
// GL community and TouchDesigner developers. If you're new to GLSL
// this is a great place to get a handle on how things work and
// experiment.
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

#define PI 3.14159265359
#define TWO_PI 6.28318530718

// uniforms
uniform float u_time;

// functions
// Author: Patricio Gonzalez Vivo

// Title: Interaction of color - IV
// Chapter: A color has many faces - the relativity of color

// "To begin the study of how color deceives and how to make use of this,
// the first excercise is
// to make one and the same color look different."
// 															Josef Albers

float rect(in vec2 st, in vec2 size){
	size = 0.25-size*0.25;
    vec2 uv = smoothstep(size,size+size*vec2(0.002),st*(1.0-st));
	return uv.x*uv.y;
}

out vec4 fragColor;
void main()
{
	// TouchDesigner provides us with a built in variable
	// that already holds the uvs for our texutre. Normally we'd 
	// you'll see this done other places with fragcoord and the
	// resolution of the scene. We could similarly derive this value
	// like this:
	// vec2 st 		= gl_FragCoord.xy / uTD2DInfos[0].res.zw;
	// here gl_FragCoord provides the pixel value, and uTD2DInfos[0].res.zw
	// provides the xy resolution of our first input.
	vec2 st 					= vUV.st;
	st.y 						= 1.0-st.y;
			
	vec3 color 					= vec3( 0.0 );

    vec3 influenced_color 		= vec3(0.745,0.696,0.529);
    
    vec3 influencing_color_A 	= vec3(0.418,0.735,0.780);
    vec3 influencing_color_a 	= vec3(0.065,0.066,0.290);
    vec3 influencing_color_b 	= vec3(0.865,0.842,0.162);
    vec3 influencing_color_B 	= vec3(0.980,0.603,0.086);
    
    color 						= mix(mix(influencing_color_A,
            					             influencing_color_a,
            					             step(.3,st.y)),
            					         mix(influencing_color_b,
            					             influencing_color_B,
            					             step(.7,st.y)),
            					         step(.5,st.y));

    color						= mix(color,
         						     influenced_color,
         						     rect(abs((st-vec2(.0,.5))*vec2(1.,1.75)),vec2(.025,.09)));

	// TDOutputSwizzle is a TouchDesigner function that helps ensure 
	// consistent behavior between mac and pc versions of touch. What's
	// important to know here is that you need to provide this function
	// with a vec4. Because our example above doesn't consider alpha, 
	// we can construct a vec4 out of our variable color, and an additional
	// value of 1.0 for the alpha channel.
	fragColor 		= TDOutputSwizzle(vec4( color, 1.0 ));
}
