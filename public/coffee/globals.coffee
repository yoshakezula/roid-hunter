define ['utilities/window'], (window) ->

	window.WEB_GL_ENABLED = true

	window.MAX_NUM_ORBITS = 4000
	window.CANVAS_NUM_ORBITS = 30  # gimped version orbits
	window.PIXELS_PER_AU = 50
	window.NUM_BIG_PARTICLES = 30   # show this many asteroids with orbits

	window.stats = false
	window.scene = false
	window.renderer = false
	window.composer = false
	window.camera = false
	window.cameraControls = false
	window.pi = Math.PI
	window.using_webgl = false
	window.camera_fly_around = true
	window.object_movement_on = true
	window.lastHovered = false
	window.added_objects = []
	window.planets = []
	window.planet_orbits_visible = true
	window.jed = false
	window.particle_system_geometry = null
	window.asteroids_loaded = false
	window.featured_2012_da14 = false
	window.eph = {
		e: false
	}

	# Lock/feature stuff
	window.feature_map = {}       # map from object full name to Orbit3D instance
	window.locked_object = null
	window.locked_object_ellipse = null
	window.locked_object_idx = -1
	window.locked_object_size = -1
	window.locked_object_color = -1

	# 2012 da14
	window.featured_2012_da14 = false

	# workers stuff
	window.works = []
	window.workers = []
	window.NUM_WORKERS = 3
	window.worker_path = '/js/position_worker.js'
	window.workers_initialized = false
	window.particleSystem = false

	# glsl stuff
	window.attributes = false
	window.uniforms = false

	window.Ephemeris = false
	window.pi = Math.PI
	window.PIXELS_PER_AU = 50
	window.positions = []

	window.jed = false
	window.jed_threshold = false
	window.running = true
	window.simulationData = null

	window.pi = Math.PI
	window.PIXELS_PER_AU = 50
	window.USE_REAL_ELLIPSE = true

	window.attributes = false
	window.uniforms = false
