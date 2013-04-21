define(['utilities/window','three','object3d'],function(window) {
	/**
	 * @author mikael emtinger / http://gomo.se/
	 * @author alteredq / http://alteredqualia.com/
	 */

	window.THREE.Bone = function( belongsToSkin ) {

		THREE.Object3D.call( this );

		this.skin = belongsToSkin;
		this.skinMatrix = new THREE.Matrix4();

	};

	window.THREE.Bone.prototype = Object.create( THREE.Object3D.prototype );

	window.THREE.Bone.prototype.update = function ( parentSkinMatrix, forceUpdate ) {

		// update local

		if ( this.matrixAutoUpdate ) {

			forceUpdate |= this.updateMatrix();

		}

		// update skin matrix

		if ( forceUpdate || this.matrixWorldNeedsUpdate ) {

			if( parentSkinMatrix ) {

				this.skinMatrix.multiplyMatrices( parentSkinMatrix, this.matrix );

			} else {

				this.skinMatrix.copy( this.matrix );

			}

			this.matrixWorldNeedsUpdate = false;
			forceUpdate = true;

		}

		// update children

		var child, i, l = this.children.length;

		for ( i = 0; i < l; i ++ ) {

			this.children[ i ].update( this.skinMatrix, forceUpdate );

		}

	};

});