define(['utilities/window','three','sprite-material','object3d'],function(window) {
	/**
	 * @author mikael emtinger / http://gomo.se/
	 * @author alteredq / http://alteredqualia.com/
	 */

	window.THREE.Sprite = function ( material ) {

		THREE.Object3D.call( this );

		this.material = ( material !== undefined ) ? material : new THREE.SpriteMaterial();

		this.rotation3d = this.rotation;
		this.rotation = 0;
		this.color = new THREE.Color();

	};

	window.THREE.Sprite.prototype = Object.create( THREE.Object3D.prototype );

	/*
	 * Custom update matrix
	 */

	window.THREE.Sprite.prototype.updateMatrix = function () {

		this.rotation3d.set( 0, 0, this.rotation );
		this.quaternion.setFromEuler( this.rotation3d, this.eulerOrder );
		this.matrix.makeFromPositionQuaternionScale( this.position, this.quaternion, this.scale );

		this.matrixWorldNeedsUpdate = true;

	};

	window.THREE.Sprite.prototype.clone = function ( object ) {

		if ( object === undefined ) object = new THREE.Sprite( this.material );

		THREE.Object3D.prototype.clone.call( this, object );

		return object;

	};

});
