define(['utilities/window','three','object3d'],function(window) {

	/**
	 * @author alteredq / http://alteredqualia.com/
	 */

	window.THREE.ImmediateRenderObject = function () {

		THREE.Object3D.call( this );

		this.render = function ( renderCallback ) { };

	};

	window.THREE.ImmediateRenderObject.prototype = Object.create( THREE.Object3D.prototype );
});
