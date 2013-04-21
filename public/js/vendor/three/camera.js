define(['utilities/window','three','object3d'],function(window) {
	/**
	 * @author mrdoob / http://mrdoob.com/
	 * @author mikael emtinger / http://gomo.se/
	 * @author WestLangley / http://github.com/WestLangley
	*/

	window.THREE.Camera = function () {

		THREE.Object3D.call( this );

		this.matrixWorldInverse = new THREE.Matrix4();

		this.projectionMatrix = new THREE.Matrix4();
		this.projectionMatrixInverse = new THREE.Matrix4();

	};

	window.THREE.Camera.prototype = Object.create( THREE.Object3D.prototype );

	window.THREE.Camera.prototype.lookAt = function () {

		// This routine does not support cameras with rotated and/or translated parent(s)

		var m1 = new THREE.Matrix4();

		return function ( vector ) {

			m1.lookAt( this.position, vector, this.up );

			if ( this.useQuaternion === true )  {

				this.quaternion.setFromRotationMatrix( m1 );

			} else {

				this.rotation.setEulerFromRotationMatrix( m1, this.eulerOrder );

			}

		};

	}();
});
