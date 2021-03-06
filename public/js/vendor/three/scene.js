define(['utilities/window','three','object3d','light','camera','bone'],function(window) {

	/**
	 * @author mrdoob / http://mrdoob.com/
	 */

	window.THREE.Scene = function () {

		THREE.Object3D.call( this );

		this.fog = null;
		this.overrideMaterial = null;

		this.autoUpdate = true; // checked by the renderer
		this.matrixAutoUpdate = false;

		this.__objects = [];
		this.__lights = [];

		this.__objectsAdded = [];
		this.__objectsRemoved = [];

	};

	window.THREE.Scene.prototype = Object.create( THREE.Object3D.prototype );

	window.THREE.Scene.prototype.__addObject = function ( object ) {

		if ( object instanceof THREE.Light ) {

			if ( this.__lights.indexOf( object ) === - 1 ) {

				this.__lights.push( object );

			}

			if ( object.target && object.target.parent === undefined ) {

				this.add( object.target );

			}

		} else if ( !( object instanceof THREE.Camera || object instanceof THREE.Bone ) ) {

			if ( this.__objects.indexOf( object ) === - 1 ) {

				this.__objects.push( object );
				this.__objectsAdded.push( object );

				// check if previously removed

				var i = this.__objectsRemoved.indexOf( object );

				if ( i !== -1 ) {

					this.__objectsRemoved.splice( i, 1 );

				}

			}

		}

		for ( var c = 0; c < object.children.length; c ++ ) {

			this.__addObject( object.children[ c ] );

		}

	};

	window.THREE.Scene.prototype.__removeObject = function ( object ) {

		if ( object instanceof THREE.Light ) {

			var i = this.__lights.indexOf( object );

			if ( i !== -1 ) {

				this.__lights.splice( i, 1 );

			}

		} else if ( !( object instanceof THREE.Camera ) ) {

			var i = this.__objects.indexOf( object );

			if( i !== -1 ) {

				this.__objects.splice( i, 1 );
				this.__objectsRemoved.push( object );

				// check if previously added

				var ai = this.__objectsAdded.indexOf( object );

				if ( ai !== -1 ) {

					this.__objectsAdded.splice( ai, 1 );

				}

			}

		}

		for ( var c = 0; c < object.children.length; c ++ ) {

			this.__removeObject( object.children[ c ] );

		}

	};
});
