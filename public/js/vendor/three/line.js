define(['utilities/window','three','line-basic-material','object3d'],function(window) {
	/**
	 * @author mrdoob / http://mrdoob.com/
	 */

	window.THREE.Line = function ( geometry, material, type ) {

		THREE.Object3D.call( this );

		this.geometry = geometry;
		this.material = ( material !== undefined ) ? material : new THREE.LineBasicMaterial( { color: Math.random() * 0xffffff } );
		this.type = ( type !== undefined ) ? type : THREE.LineStrip;

		if ( this.geometry ) {

			if ( ! this.geometry.boundingSphere ) {

				this.geometry.computeBoundingSphere();

			}

		}

	};

	window.THREE.LineStrip = 0;
	window.THREE.LinePieces = 1;

	window.THREE.Line.prototype = Object.create( THREE.Object3D.prototype );

	window.THREE.Line.prototype.clone = function ( object ) {

		if ( object === undefined ) object = new THREE.Line( this.geometry, this.material, this.type );

		THREE.Object3D.prototype.clone.call( this, object );

		return object;

	};
});