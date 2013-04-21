define(['utilities/window','three','material'],function(window) {

	/**
	 * @author mrdoob / http://mrdoob.com/
	 *
	 * parameters = {
	 *  opacity: <float>,
	 *
	 *  shading: THREE.FlatShading,
	 *  blending: THREE.NormalBlending,
	 *  depthTest: <bool>,
	 *  depthWrite: <bool>,
	 *
	 *  wireframe: <boolean>,
	 *  wireframeLinewidth: <float>
	 * }
	 */

	window.THREE.MeshNormalMaterial = function ( parameters ) {

		THREE.Material.call( this, parameters );

		this.shading = THREE.FlatShading;

		this.wireframe = false;
		this.wireframeLinewidth = 1;

		this.morphTargets = false;

		this.setValues( parameters );

	};

	window.THREE.MeshNormalMaterial.prototype = Object.create( THREE.Material.prototype );

	window.THREE.MeshNormalMaterial.prototype.clone = function () {

		var material = new THREE.MeshNormalMaterial();

		THREE.Material.prototype.clone.call( this, material );

		material.shading = this.shading;

		material.wireframe = this.wireframe;
		material.wireframeLinewidth = this.wireframeLinewidth;

		return material;

	};

});


