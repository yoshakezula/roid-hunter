define(['utilities/window','three','object3d'],function(window) {
	/**
	 * @author mrdoob / http://mrdoob.com/
	 * @author alteredq / http://alteredqualia.com/
	 */

	window.THREE.Light = function ( hex ) {

		THREE.Object3D.call( this );

		this.color = new THREE.Color( hex );

	};

	window.THREE.Light.prototype = Object.create( THREE.Object3D.prototype );

	window.THREE.Light.prototype.clone = function ( light ) {

		if ( light === undefined ) light = new THREE.Light();

		THREE.Object3D.prototype.clone.call( this, light );

		light.color.copy( this.color );

		return light;

	};
});
