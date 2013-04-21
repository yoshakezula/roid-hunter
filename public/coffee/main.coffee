requirejs.config {
	baseUrl: '/js',
	paths:
		'jquery'                         : 'vendor/jquery/jquery-2.0.0'
		'underscore'                     : 'vendor/underscore'
		'three'                          : 'vendor/three/three'
		'detector'                       : 'vendor/three/detector'
		'csg'                            : 'vendor/three/csg'
		'bsp'                            : 'vendor/three/bsp'
		'dragpan-controls'               : 'vendor/three/x/dragpan-controls'
		'trackball'                      : 'vendor/three/x/trackball'
		'domevent'                       : 'vendor/three/x/domevent'
		'gl-capability'                  : 'vendor/three/x/gl-capability'
		'window-resize'                  : 'vendor/three/x/window-resize'
		'full-screen'                    : 'vendor/three/x/full-screen'
		'vector3'                        : 'vendor/three/vector'
		'quaternion'                     : 'vendor/three/quaternion'
		'object3d'                       : 'vendor/three/object3d'
		'matrix4'                        : 'vendor/three/matrix4'
}

require ['app']