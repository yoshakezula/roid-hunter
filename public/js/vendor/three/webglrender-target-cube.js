define(['utilities/window','three','webglrender-target'],function(window) {

	/**
	 * @author alteredq / http://alteredqualia.com
	 */

	window.THREE.WebGLRenderTargetCube = function ( width, height, options ) {

		THREE.WebGLRenderTarget.call( this, width, height, options );

		this.activeCubeFace = 0; // PX 0, NX 1, PY 2, NY 3, PZ 4, NZ 5

	};

	window.THREE.WebGLRenderTargetCube.prototype = Object.create( THREE.WebGLRenderTarget.prototype );
});