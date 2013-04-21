define(['utilities/window','three','material'],function(window) {


	/**
	 * @author mrdoob / http://mrdoob.com/
	 * @author alteredq / http://alteredqualia.com/
	 *
	 * parameters = {
	 *  color: <hex>,
	 *  opacity: <float>,
	 *  map: new THREE.Texture( <Image> ),
	 *
	 *  size: <float>,
	 *
	 *  blending: THREE.NormalBlending,
	 *  depthTest: <bool>,
	 *  depthWrite: <bool>,
	 *
	 *  vertexColors: <bool>,
	 *
	 *  fog: <bool>
	 * }
	 */

	window.THREE.ParticleBasicMaterial = function ( parameters ) {

		THREE.Material.call( this );

		this.color = new THREE.Color( 0xffffff );

		this.map = null;

		this.size = 1;
		this.sizeAttenuation = true;

		this.vertexColors = false;

		this.fog = true;

		this.setValues( parameters );

	};

	window.THREE.ParticleBasicMaterial.prototype = Object.create( THREE.Material.prototype );

	window.THREE.ParticleBasicMaterial.prototype.clone = function () {

		var material = new THREE.ParticleBasicMaterial();

		THREE.Material.prototype.clone.call( this, material );

		material.color.copy( this.color );

		material.map = this.map;

		material.size = this.size;
		material.sizeAttenuation = this.sizeAttenuation;

		material.vertexColors = this.vertexColors;

		material.fog = this.fog;

		return material;

	};

});
