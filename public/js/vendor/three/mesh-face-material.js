define(['utilities/window','three'],function(window) {

	/**
	 * @author mrdoob / http://mrdoob.com/
	 */

	window.THREE.MeshFaceMaterial = function ( materials ) {

		this.materials = materials instanceof Array ? materials : [];

	};

	window.THREE.MeshFaceMaterial.prototype.clone = function () {

		return new THREE.MeshFaceMaterial( this.materials.slice( 0 ) );

	};

});