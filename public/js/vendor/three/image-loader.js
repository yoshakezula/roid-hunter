define(['utilities/window','three','event-dispatcher'],function(window) {
	/**
	 * @author mrdoob / http://mrdoob.com/
	 */

	window.THREE.ImageLoader = function () {

		this.crossOrigin = null;

	};

	window.THREE.ImageLoader.prototype = {

		constructor: THREE.ImageLoader,

		addEventListener: THREE.EventDispatcher.prototype.addEventListener,
		hasEventListener: THREE.EventDispatcher.prototype.hasEventListener,
		removeEventListener: THREE.EventDispatcher.prototype.removeEventListener,
		dispatchEvent: THREE.EventDispatcher.prototype.dispatchEvent,

		load: function ( url, image ) {

			var scope = this;

			if ( image === undefined ) image = new Image();

			image.addEventListener( 'load', function () {

				scope.dispatchEvent( { type: 'load', content: image } );

			}, false );

			image.addEventListener( 'error', function () {

				scope.dispatchEvent( { type: 'error', message: 'Couldn\'t load URL [' + url + ']' } );

			}, false );

			if ( scope.crossOrigin ) image.crossOrigin = scope.crossOrigin;

			image.src = url;

		}

	}
});
