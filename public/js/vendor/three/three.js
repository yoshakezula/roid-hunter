define(['utilities/window'],function(window) {
	/**
	 * @author mrdoob / http://mrdoob.com/
	 * @author Larry Battle / http://bateru.com/news
	 */

	window.THREE = { REVISION: '58' };

	window.self.console = self.console || {

		info: function () {},
		log: function () {},
		debug: function () {},
		warn: function () {},
		error: function () {}

	};

	window.self.Int32Array = self.Int32Array || Array;
	window.self.Float32Array = self.Float32Array || Array;

	window.String.prototype.trim = String.prototype.trim || function () {

		return this.replace( /^\s+|\s+$/g, '' );

	};

	// based on https://github.com/documentcloud/underscore/blob/bf657be243a075b5e72acc8a83e6f12a564d8f55/underscore.js#L767
	window.THREE.extend = function ( obj, source ) {

		// ECMAScript5 compatibility based on: http://www.nczonline.net/blog/2012/12/11/are-your-mixins-ecmascript-5-compatible/
		if ( Object.keys ) {

			var keys = Object.keys( source );

			for (var i = 0, il = keys.length; i < il; i++) {

				var prop = keys[i];
				Object.defineProperty( obj, prop, Object.getOwnPropertyDescriptor( source, prop ) );

			}

		} else {

			var safeHasOwnProperty = {}.hasOwnProperty;

			for ( var prop in source ) {

				if ( safeHasOwnProperty.call( source, prop ) ) {

					obj[prop] = source[prop];

				}

			}

		}

		return obj;

	};

	// http://paulirish.com/2011/requestanimationframe-for-smart-animating/
	// http://my.opera.com/emoller/blog/2011/12/20/requestanimationframe-for-smart-er-animating

	// requestAnimationFrame polyfill by Erik Möller
	// fixes from Paul Irish and Tino Zijdel

	( function () {

		var lastTime = 0;
		var vendors = [ 'ms', 'moz', 'webkit', 'o' ];

		for ( var x = 0; x < vendors.length && !window.requestAnimationFrame; ++ x ) {

			window.requestAnimationFrame = window[ vendors[ x ] + 'RequestAnimationFrame' ];
			window.cancelAnimationFrame = window[ vendors[ x ] + 'CancelAnimationFrame' ] || window[ vendors[ x ] + 'CancelRequestAnimationFrame' ];

		}

		if ( window.requestAnimationFrame === undefined ) {

			window.requestAnimationFrame = function ( callback ) {

				var currTime = Date.now(), timeToCall = Math.max( 0, 16 - ( currTime - lastTime ) );
				var id = window.setTimeout( function() { callback( currTime + timeToCall ); }, timeToCall );
				lastTime = currTime + timeToCall;
				return id;

			};

		}

		window.cancelAnimationFrame = window.cancelAnimationFrame || function ( id ) { window.clearTimeout( id ) };

	}() );

	// GL STATE CONSTANTS

	window.THREE.CullFaceNone = 0;
	window.THREE.CullFaceBack = 1;
	window.THREE.CullFaceFront = 2;
	window.THREE.CullFaceFrontBack = 3;

	window.THREE.FrontFaceDirectionCW = 0;
	window.THREE.FrontFaceDirectionCCW = 1;

	// SHADOWING TYPES

	window.THREE.BasicShadowMap = 0;
	window.THREE.PCFShadowMap = 1;
	window.THREE.PCFSoftShadowMap = 2;

	// MATERIAL CONSTANTS

	// side

	window.THREE.FrontSide = 0;
	window.THREE.BackSide = 1;
	window.THREE.DoubleSide = 2;

	// shading

	window.THREE.NoShading = 0;
	window.THREE.FlatShading = 1;
	window.THREE.SmoothShading = 2;

	// colors

	window.THREE.NoColors = 0;
	window.THREE.FaceColors = 1;
	window.THREE.VertexColors = 2;

	// blending modes

	window.THREE.NoBlending = 0;
	window.THREE.NormalBlending = 1;
	window.THREE.AdditiveBlending = 2;
	window.THREE.SubtractiveBlending = 3;
	window.THREE.MultiplyBlending = 4;
	window.THREE.CustomBlending = 5;

	// custom blending equations
	// (numbers start from 100 not to clash with other
	//  mappings to OpenGL constants defined in Texture.js)

	window.THREE.AddEquation = 100;
	window.THREE.SubtractEquation = 101;
	window.THREE.ReverseSubtractEquation = 102;

	// custom blending destination factors

	window.THREE.ZeroFactor = 200;
	window.THREE.OneFactor = 201;
	window.THREE.SrcColorFactor = 202;
	window.THREE.OneMinusSrcColorFactor = 203;
	window.THREE.SrcAlphaFactor = 204;
	window.THREE.OneMinusSrcAlphaFactor = 205;
	window.THREE.DstAlphaFactor = 206;
	window.THREE.OneMinusDstAlphaFactor = 207;

	// custom blending source factors

	//THREE.ZeroFactor = 200;
	//THREE.OneFactor = 201;
	//THREE.SrcAlphaFactor = 204;
	//THREE.OneMinusSrcAlphaFactor = 205;
	//THREE.DstAlphaFactor = 206;
	//THREE.OneMinusDstAlphaFactor = 207;
	window.THREE.DstColorFactor = 208;
	window.THREE.OneMinusDstColorFactor = 209;
	window.THREE.SrcAlphaSaturateFactor = 210;


	// TEXTURE CONSTANTS

	window.THREE.MultiplyOperation = 0;
	window.THREE.MixOperation = 1;
	window.THREE.AddOperation = 2;

	// Mapping modes

	window.THREE.UVMapping = function () {};

	window.THREE.CubeReflectionMapping = function () {};
	window.THREE.CubeRefractionMapping = function () {};

	window.THREE.SphericalReflectionMapping = function () {};
	window.THREE.SphericalRefractionMapping = function () {};

	// Wrapping modes

	window.THREE.RepeatWrapping = 1000;
	window.THREE.ClampToEdgeWrapping = 1001;
	window.THREE.MirroredRepeatWrapping = 1002;

	// Filters

	window.THREE.NearestFilter = 1003;
	window.THREE.NearestMipMapNearestFilter = 1004;
	window.THREE.NearestMipMapLinearFilter = 1005;
	window.THREE.LinearFilter = 1006;
	window.THREE.LinearMipMapNearestFilter = 1007;
	window.THREE.LinearMipMapLinearFilter = 1008;

	// Data types

	window.THREE.UnsignedByteType = 1009;
	window.THREE.ByteType = 1010;
	window.THREE.ShortType = 1011;
	window.THREE.UnsignedShortType = 1012;
	window.THREE.IntType = 1013;
	window.THREE.UnsignedIntType = 1014;
	window.THREE.FloatType = 1015;

	// Pixel types

	//THREE.UnsignedByteType = 1009;
	window.THREE.UnsignedShort4444Type = 1016;
	window.THREE.UnsignedShort5551Type = 1017;
	window.THREE.UnsignedShort565Type = 1018;

	// Pixel formats

	window.THREE.AlphaFormat = 1019;
	window.THREE.RGBFormat = 1020;
	window.THREE.RGBAFormat = 1021;
	window.THREE.LuminanceFormat = 1022;
	window.THREE.LuminanceAlphaFormat = 1023;

	// Compressed texture formats

	window.THREE.RGB_S3TC_DXT1_Format = 2001;
	window.THREE.RGBA_S3TC_DXT1_Format = 2002;
	window.THREE.RGBA_S3TC_DXT3_Format = 2003;
	window.THREE.RGBA_S3TC_DXT5_Format = 2004;
});
