define(['utilities/window','three','particle-basic-material','object3d'],function(window) {


	/**
	 * @author alteredq / http://alteredqualia.com/
	 */

	window.THREE.ParticleSystem = function ( geometry, material ) {

		THREE.Object3D.call( this );

		this.geometry = geometry;
		this.material = ( material !== undefined ) ? material : new THREE.ParticleBasicMaterial( { color: Math.random() * 0xffffff } );

		this.sortParticles = false;

		if ( this.geometry ) {

			// calc bound radius

			if( this.geometry.boundingSphere === null ) {

				this.geometry.computeBoundingSphere();

			}

		}

		this.frustumCulled = false;

	};

	window.THREE.ParticleSystem.prototype = Object.create( THREE.Object3D.prototype );

	window.THREE.ParticleSystem.prototype.clone = function ( object ) {

		if ( object === undefined ) object = new THREE.ParticleSystem( this.geometry, this.material );
		object.sortParticles = this.sortParticles;

		THREE.Object3D.prototype.clone.call( this, object );

		return object;

	};
});
