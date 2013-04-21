define(['utilities/window','three','material'],function(window) {



	/**
	 * @author mrdoob / http://mrdoob.com/
	 * @author alteredq / http://alteredqualia.com/
	 *
	 * parameters = {
	 *  opacity: <float>,
	 *
	 *  blending: THREE.NormalBlending,
	 *  depthTest: <bool>,
	 *  depthWrite: <bool>,
	 *
	 *  wireframe: <boolean>,
	 *  wireframeLinewidth: <float>
	 * }
	 */

	window.THREE.MeshDepthMaterial = function ( parameters ) {

		THREE.Material.call( this );

		this.wireframe = false;
		this.wireframeLinewidth = 1;

		this.setValues( parameters );

	};

	window.THREE.MeshDepthMaterial.prototype = Object.create( THREE.Material.prototype );

	window.THREE.MeshDepthMaterial.prototype.clone = function () {

		var material = new THREE.MeshDepthMaterial();

		THREE.Material.prototype.clone.call( this, material );

		material.wireframe = this.wireframe;
		material.wireframeLinewidth = this.wireframeLinewidth;

		return material;

	};


});

