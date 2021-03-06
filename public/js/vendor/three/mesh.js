define(['utilities/window','three','object3d','mesh-basic-material'],function(window) {
	/**
	 * @author mrdoob / http://mrdoob.com/
	 * @author alteredq / http://alteredqualia.com/
	 * @author mikael emtinger / http://gomo.se/
	 * @author jonobr1 / http://jonobr1.com/
	 */

	window.THREE.Mesh = function ( geometry, material ) {

		THREE.Object3D.call( this );

		this.geometry = null;
		this.material = null;

		this.setGeometry( geometry );
		this.setMaterial( material );

	};

	window.THREE.Mesh.prototype = Object.create( THREE.Object3D.prototype );

	window.THREE.Mesh.prototype.setGeometry = function ( geometry ) {

		if ( geometry !== undefined ) {

			this.geometry = geometry;

			if ( this.geometry.boundingSphere === null ) {

				this.geometry.computeBoundingSphere();

			}

			this.updateMorphTargets();

		}

	};

	window.THREE.Mesh.prototype.setMaterial = function ( material ) {

		if ( material !== undefined ) {

			this.material = material;

		} else {

			this.material = new THREE.MeshBasicMaterial( { color: Math.random() * 0xffffff, wireframe: true } );

		}

	};

	window.THREE.Mesh.prototype.updateMorphTargets = function () {

		if ( this.geometry.morphTargets.length > 0 ) {

			this.morphTargetBase = -1;
			this.morphTargetForcedOrder = [];
			this.morphTargetInfluences = [];
			this.morphTargetDictionary = {};

			for ( var m = 0, ml = this.geometry.morphTargets.length; m < ml; m ++ ) {

				this.morphTargetInfluences.push( 0 );
				this.morphTargetDictionary[ this.geometry.morphTargets[ m ].name ] = m;

			}

		}

	};

	window.THREE.Mesh.prototype.getMorphTargetIndexByName = function ( name ) {

		if ( this.morphTargetDictionary[ name ] !== undefined ) {

			return this.morphTargetDictionary[ name ];

		}

		console.log( "THREE.Mesh.getMorphTargetIndexByName: morph target " + name + " does not exist. Returning 0." );

		return 0;

	};

	window.THREE.Mesh.prototype.clone = function ( object ) {

		if ( object === undefined ) object = new THREE.Mesh( this.geometry, this.material );

		THREE.Object3D.prototype.clone.call( this, object );

		return object;

	};
});
