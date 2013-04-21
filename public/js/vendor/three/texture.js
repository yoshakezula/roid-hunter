define(['utilities/window','three','event-dispatcher'],function(window) {
	/**
	 * @author mrdoob / http://mrdoob.com/
	 * @author alteredq / http://alteredqualia.com/
	 * @author szimek / https://github.com/szimek/
	 */

	THREE.Texture = function ( image, mapping, wrapS, wrapT, magFilter, minFilter, format, type, anisotropy ) {

		this.id = THREE.TextureIdCount ++;

		this.name = '';

		this.image = image;
		this.mipmaps = [];

		this.mapping = mapping !== undefined ? mapping : new THREE.UVMapping();

		this.wrapS = wrapS !== undefined ? wrapS : THREE.ClampToEdgeWrapping;
		this.wrapT = wrapT !== undefined ? wrapT : THREE.ClampToEdgeWrapping;

		this.magFilter = magFilter !== undefined ? magFilter : THREE.LinearFilter;
		this.minFilter = minFilter !== undefined ? minFilter : THREE.LinearMipMapLinearFilter;

		this.anisotropy = anisotropy !== undefined ? anisotropy : 1;

		this.format = format !== undefined ? format : THREE.RGBAFormat;
		this.type = type !== undefined ? type : THREE.UnsignedByteType;

		this.offset = new THREE.Vector2( 0, 0 );
		this.repeat = new THREE.Vector2( 1, 1 );

		this.generateMipmaps = true;
		this.premultiplyAlpha = false;
		this.flipY = true;
		this.unpackAlignment = 4; // valid values: 1, 2, 4, 8 (see http://www.khronos.org/opengles/sdk/docs/man/xhtml/glPixelStorei.xml)

		this.needsUpdate = false;
		this.onUpdate = null;

	};

	THREE.Texture.prototype = {

		constructor: THREE.Texture,

		addEventListener: THREE.EventDispatcher.prototype.addEventListener,
		hasEventListener: THREE.EventDispatcher.prototype.hasEventListener,
		removeEventListener: THREE.EventDispatcher.prototype.removeEventListener,
		dispatchEvent: THREE.EventDispatcher.prototype.dispatchEvent,

		clone: function ( texture ) {

			if ( texture === undefined ) texture = new THREE.Texture();

			texture.image = this.image;
			texture.mipmaps = this.mipmaps.slice(0);

			texture.mapping = this.mapping;

			texture.wrapS = this.wrapS;
			texture.wrapT = this.wrapT;

			texture.magFilter = this.magFilter;
			texture.minFilter = this.minFilter;

			texture.anisotropy = this.anisotropy;

			texture.format = this.format;
			texture.type = this.type;

			texture.offset.copy( this.offset );
			texture.repeat.copy( this.repeat );

			texture.generateMipmaps = this.generateMipmaps;
			texture.premultiplyAlpha = this.premultiplyAlpha;
			texture.flipY = this.flipY;
			texture.unpackAlignment = this.unpackAlignment;

			return texture;

		},

		dispose: function () {

			this.dispatchEvent( { type: 'dispose' } );

		}

	};

	THREE.TextureIdCount = 0;
});
