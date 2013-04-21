
	# script(src="js/vendor/jquery/jquery-2.0.0.js")
	# script(src="js/Worker.js")
	# script(src="js/ephemeris.js")
	# script(src="js/ellipse.js")
	# script(src="js/util.js")
	# script(src="js/main.js")


define [
	'utilities/window'
	'globals'
	'worker'
	'ephemeris'
	'ellipse'
	'util'
	'jquery'
	'detector'
	'three'
	'domevent'
	'window-resize'
	'vector3'
	'full-screen'
	'scene'
	'sprite'
	'cube-geometry'
	'mesh'
	'quaternion'
	'webglrenderer'
	'shader-utils'
	'trackball'
	'perspective-camera'
	'image-utils'
	], (window) ->

	'use strict'

	window.polling = (callback) ->
		window.setTimeout(callback, 1000 / 60)

	window.frame = () ->
		window.requestAnimationFrame       ||
		window.webkitRequestAnimationFrame ||
		window.mozRequestAnimationFrame    ||
		window.oRequestAnimationFrame      ||
		window.msRequestAnimationFrame     ||
		polling

	window.initGUI = () ->
		ViewUI = () ->
			this['Cost effective'] = () ->
				runAsteroidQuery('score')
			this['Most valuable'] = () ->
				runAsteroidQuery('price')
			this['Most accessible'] = () ->
				runAsteroidQuery('closeness')
			this.movement = object_movement_on
			this['planet orbits'] = planet_orbits_visible
			this['display date'] = '12/26/2012'
		window.onload = () ->
			text = new ViewUI()
			gui = new dat.GUI()
			gui.add(text, 'Cost effective')
			gui.add(text, 'Most valuable')
			gui.add(text, 'Most accessible')
			gui.add(text, 'movement').onChange(() ->
				object_movement_on = !object_movement_on
				toggleSimulation(object_movement_on)
			)
			gui.add(text, 'planet orbits').onChange(() ->
				togglePlanetOrbits()
			)
			gui.add(text, 'display date').onChange((val) ->
				newdate = Date.parse(val)
				if (newdate)
					newjed = toJED(newdate)
					changeJED(newjed)
					if (!object_movement_on)
						render(true) # force rerender even if simulation isn't running
			).listen()
			window.datgui = text

	window.togglePlanetOrbits = () ->
		if (planet_orbits_visible)
			for i of planets
				scene.remove(planets[i].getEllipse())
		else
			for i of planets
				scene.add(planets[i].getEllipse())
		planet_orbits_visible = !planet_orbits_visible

	window.init = () ->
		$('#loading-text').html('renderer')
		if (WEB_GL_ENABLED && Detector.webgl)
			renderer = new THREE.WebGLRenderer({
				antialias		: true	# to get smoother output
				#preserveDrawingBuffer	: true	# to allow screenshot)
			})
			renderer.setClearColor(0x000000, 1)
			using_webgl = true
			window.gl = renderer.getContext()
		else
			renderer	= new THREE.CanvasRenderer()
			$('#not-supported').show()
		renderer.setSize(window.innerWidth, window.innerHeight)
		document.getElementById('container').appendChild(renderer.domElement)

		# /*
		# # # Set up stats
		# # stats = new Stats()
		# # stats.domElement.style.position	= 'absolute'
		# # stats.domElement.style.bottom	= '0px'
		# # document.body.appendChild(stats.domElement)
		# */

		# create a scene
		scene = new THREE.Scene()

		# put a camera in the scene
		cameraH	= 3
		cameraW	= cameraH / window.innerHeight * window.innerWidth
		window.cam = camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 5000)
		setDefaultCameraPosition()
		#camera.position.set(22.39102192510384, -124.78460848134833, -55.29382439584528)
		#camera.position.set(12.39102192510384, -124.78460848134833, -75.29382439584528)

		#camera.position.set(-145, 41, -31)
		# 77, -155, 23

		THREE.Object3D._threexDomEvent.camera(camera)    # camera mouse handler
		THREEx.WindowResize(renderer, camera)    # handle window resize
		# Fullscreen api
		if (THREEx.FullScreen.available())
			THREEx.FullScreen.bindKey()

		scene.add(camera)

		cameraControls	= new THREE.TrackballControlsX(camera)
		cameraControls.staticMoving = true
		cameraControls.panSpeed = 2
		cameraControls.zoomSpeed = 3
		cameraControls.maxDistance = 1100
		# Rendering stuff
		# "sun" - 0,0 marker
		if (using_webgl)
			$('#loading-text').html('sun')
			sun = new THREE.Object3D()
			texture = THREE.ImageUtils.loadTexture("/img/sunsprite.png")
			sprite = new THREE.Sprite({
				map: texture,
				blending: THREE.AdditiveBlending,
				useScreenCoordinates: false,
				color: 0xffffff})
			sprite.scale.x = 50
			sprite.scale.y = 50
			sprite.scale.z = 1
			sprite.color.setHSL(1.0, 0.0, 1.0)
			sun.add(sprite)
			scene.add(sun)
		else
			material = new THREE.ParticleBasicMaterial({
				map: new THREE.Texture( starTexture(0xfff2a1,1) ),
				blending: THREE.AdditiveBlending})
			particle = new THREE.Particle(material)
			particle.isClickable = false
			scene.add(particle)

		# Ellipses
		runAsteroidQuery()

		$('#loading-text').html('planets')
		mercury = new Orbit3D(Ephemeris.mercury,
				{
					color: 0x913CEE, width: 1, jed: jed, object_size: 1.7,
					texture_path: '/img/texture-mercury.jpg',
					display_color: new THREE.Color(0x913CEE),
					particle_geometry: particle_system_geometry,
					name: 'Mercury'}, !using_webgl)
		scene.add(mercury.getEllipse())
		if (!using_webgl)
			scene.add(mercury.getParticle())
		venus = new Orbit3D(Ephemeris.venus,
				{
					color: 0xFF7733, width: 1, jed: jed, object_size: 1.7,
					texture_path: '/img/texture-venus.jpg',
					display_color: new THREE.Color(0xFF7733),
					particle_geometry: particle_system_geometry,
					name: 'Venus'}, !using_webgl)
		scene.add(venus.getEllipse())
		if (!using_webgl)
			scene.add(venus.getParticle())
		earth = new Orbit3D(Ephemeris.earth,
				{
					color: 0x009ACD, width: 1, jed: jed, object_size: 1.7,
					texture_path: '/img/texture-earth.jpg',
					display_color: new THREE.Color(0x009ACD),
					particle_geometry: particle_system_geometry,
					name: 'Earth'}, !using_webgl)
		scene.add(earth.getEllipse())
		if (!using_webgl)
			scene.add(earth.getParticle())
		feature_map['earth'] = {
			orbit: earth,
			idx: 2}
		mars = new Orbit3D(Ephemeris.mars,
				{
					color: 0xA63A3A, width: 1, jed: jed, object_size: 1.7,
					texture_path: '/img/texture-mars.jpg',
					display_color: new THREE.Color(0xA63A3A),
					particle_geometry: particle_system_geometry,
					name: 'Mars'}, !using_webgl)
		scene.add(mars.getEllipse())
		if (!using_webgl)
			scene.add(mars.getParticle())
		jupiter = new Orbit3D(Ephemeris.jupiter,
				{
					color: 0xFF7F50, width: 1, jed: jed, object_size: 1.7,
					texture_path: '/img/texture-jupiter.jpg',
					display_color: new THREE.Color(0xFF7F50),
					particle_geometry: particle_system_geometry,
					name: 'Jupiter'}, !using_webgl)
		scene.add(jupiter.getEllipse())
		if (!using_webgl)
			scene.add(jupiter.getParticle())

		planets = [mercury, venus, earth, mars, jupiter]
		if (featured_2012_da14)
			# Special: 2012 DA14
			asteroid_2012_da14 = new Orbit3D(Ephemeris.asteroid_2012_da14,
					{
						color: 0xff0000, width: 1, jed: jed, object_size: 1.7,
					texture_path: '/img/cloud4.png',
					display_color: new THREE.Color(0xff0000),
					particle_geometry: particle_system_geometry,
					name: '2012 DA14'}, !using_webgl)
			scene.add(asteroid_2012_da14.getEllipse())
			if (!using_webgl)
				scene.add(asteroid_2012_da14.getParticle())
			feature_map['2012 DA14'] = {
				orbit: asteroid_2012_da14,
				idx: 5}
			planets.push(asteroid_2012_da14)

		# Sky
		if (using_webgl)
			path = "/img/dark-s_"
			format = '.jpg'
			urls = [
					path + 'px' + format, path + 'nx' + format,
					path + 'py' + format, path + 'ny' + format,
					path + 'pz' + format, path + 'nz' + format
				]
			reflectionCube = THREE.ImageUtils.loadTextureCube( urls )
			reflectionCube.format = THREE.RGBFormat

			shader = THREE.ShaderUtils.lib[ "cube" ]
			shader.uniforms[ "tCube" ].value = reflectionCube

			material = new THREE.ShaderMaterial({
				fragmentShader: shader.fragmentShader,
				vertexShader: shader.vertexShader,
				uniforms: shader.uniforms,
				depthWrite: false,
				side: THREE.BackSide})

			mesh = new THREE.Mesh( new THREE.CubeGeometry( 5000, 5000, 5000 ), material )
			scene.add(mesh)

		$('#container').on('mousedown', () ->
			camera_fly_around = false
		)

		window.renderer = renderer

	window.setNeutralCameraPosition = () ->
		# Follow floating path around
		timer = 0.0001 * Date.now()
		cam.position.x = Math.sin(timer) * 25
		#cam.position.y = Math.sin( timer ) * 100
		cam.position.z = -100 + Math.cos(timer) * 20

	# camera highlight fns
	window.setHighlight = (full_name) ->
		# Colors the object differently, but doesn't follow it.
		mapped_obj = feature_map[full_name]
		orbit_obj = mapped_obj['orbit']
		if (!orbit_obj)
			alert("Sorry, something went wrong and I can't highlight this object.")
			return
		idx = mapped_obj['idx'] # this is the object's position in the added_objects array
		if (using_webgl)
			attributes.value_color.value[idx] = new THREE.Color(0x0000ff)
			attributes.size.value[idx] = 30.0
			attributes.locked.value[idx] = 1.0

	# camera locking fns
	window.clearLock = (set_default_camera) ->
		return if (!locked_object)

		if (set_default_camera)
			setDefaultCameraPosition()

		cameraControls.target = new THREE.Vector3(0,0,0)

		# restore color and size
		if (using_webgl)
			attributes.value_color.value[locked_object_idx] = locked_object_color
			attributes.size.value[locked_object_idx] = locked_object_size
			attributes.locked.value[locked_object_idx] = 0.0
		if (locked_object_idx > planets.length)
			# not a planet
			scene.remove(locked_object_ellipse)

		locked_object = null
		locked_object_ellipse = null
		locked_object_idx = -1
		locked_object_size = -1
		locked_object_color = null

		# reset camera pos so subsequent locks don't get into crazy positions
		setNeutralCameraPosition()

	window.setLock = (full_name) ->
		if (locked_object)
			clearLock()

		mapped_obj = feature_map[full_name]
		orbit_obj = mapped_obj['orbit']
		if (!orbit_obj)
			alert("Sorry, something went wrong and I can't lock on this object.")
			return
		locked_object = orbit_obj
		locked_object_idx = mapped_obj['idx'] # this is the object's position in the added_objects array
		if (using_webgl)
			locked_object_color = attributes.value_color.value[locked_object_idx]
			attributes.value_color.value[locked_object_idx] = new THREE.Color(0xff0000)
			if (full_name == 'earth')
				attributes.value_color.value[locked_object_idx] = new THREE.Color(0x00ff00)
			locked_object_size = attributes.size.value[locked_object_idx]
			attributes.size.value[locked_object_idx] = 30.0
			attributes.locked.value[locked_object_idx] = 1.0

		locked_object_ellipse = locked_object.getEllipse()
		scene.add(locked_object_ellipse)
		camera_fly_around = true

	window.startSimulation = () ->
		if (!asteroids_loaded)
			throw "couldn't start simulation: asteroids not loaded"
		if (!workers_initialized)
			throw "couldn't start simulation: simulation not initialized"

		for i of workers
			# trigger work
			particles = works[i]
			obj_ephs = []
			for j of particles
				obj_ephs.push(particles[j].eph)
			workers[i].postMessage({
				command: 'start',
				particle_ephemeris: obj_ephs,
				start_jed: jed})

	stopSimulation = () ->
		toggleSimulation(false)

	toggleSimulation = (run) ->
		for i of workers
			workers[i].postMessage({
				command: 'toggle_simulation',
				val: run})

	initSimulation = () ->
		l = added_objects.length
		objects_per_worker = Math.ceil(l / NUM_WORKERS)
		remainder = l % NUM_WORKERS
		i = 0
		while(i < NUM_WORKERS)
			workers[i] = new Worker(worker_path)
			start = i*objects_per_worker
			works[i] = added_objects.slice(start, Math.min(start + objects_per_worker, l))
			i++

		$.each(works, (idx) ->
			work = this
			workers[idx].onmessage = (e) ->
				handleSimulationResults(e, work.slice())
		)
		workers_initialized = true

	window.handleSimulationResults = (e, particles) ->
		data = e.data
		switch data.type
			when 'result'
				# queue simulation results
				positions = data.value.positions

				for i of positions
					particles[i].MoveParticleToPosition(positions[i])

				if (typeof datgui != 'undefined')
					# update with date
					now = new Date().getTime()
					if (now - display_date_last_updated > 500)
						georgian_date = fromJED(data.value.jed)
						datgui['display date'] = georgian_date.getMonth()+1 + "/" + georgian_date.getDate() + "/" + georgian_date.getFullYear()
						display_date_last_updated = now
				break
			when 'debug'
				console.log(data.value)
				break
			else
				console.log('Invalid data type', data.type)

	window.runAsteroidQuery = (sort) ->
		sort = sort || 'score'
		$('#loading').show()

		# Remove any old setup
		for i of added_objects
			scene.remove(added_objects[i].getParticle())
		clearLock(true)
		if (particleSystem)
			scene.remove(particleSystem)
			particleSystem = null
		if (asteroids_loaded)
			stopSimulation()

		if (lastHovered)
			scene.remove(lastHovered)

		# Get new data points
		$('#loading-text').html('asteroids database')
		query = '/top?sort=' + sort + '&n=' + (using_webgl ? MAX_NUM_ORBITS : CANVAS_NUM_ORBITS) + '&use3d=true&compact=true'
		$.getJSON(query, (data) ->
				if (!data.results)
					alert('Sorry, something went wrong and the server failed to return data.')
					return
				n = data.results.rankings.length
				# add planets
				added_objects = planets.slice()
				particle_system_geometry = new THREE.Geometry()

				useBigParticles = !using_webgl
				featured_count = 0
				featured_html = ''
				while (i < n)
					if (i == NUM_BIG_PARTICLES)
						if (!using_webgl)
							# only show objects of interest if there's no particlesystem support
							break
						useBigParticles = false
					roid_data = data.results.rankings[i]
					roid = {}
					for j of data.results.fields
						roid[data.results.fields[j]] = roid_data[j]
					locked = false
					orbit = new Orbit3D(roid, {
						color: 0xcccccc,
						display_color: displayColorForObject(roid),
						width: 2,
						object_size: 1.5,
						jed: jed,
						particle_geometry: particle_system_geometry # will add itself to this geometry, useBigParticles)
					})
					if (useBigParticles)
						# bind information/orbit mouseover - only for canvas mode
						((roid, orbit, i) ->
							orbit.getParticle().on('mouseover', (e) ->
								scene.remove(lastHovered) if (lastHovered)
								lastHovered = orbit.getEllipse()
								scene.add(lastHovered)
								if (roid.price < 1e10)
									$('#main-caption').html(roid.full_name + ' - no significant value')
								else
									$('#main-caption').html(roid.full_name
												+ ' - $' + roid.fuzzed_price + ' in potential value')
								$('#other-caption').html('(ranked #' + (i+1) + ')')
							)
						)(roid, orbit, i)
						particle_to_add = orbit.getParticle()
						scene.add(particle_to_add) # end bigParticle logic

					if (featured_count++ < NUM_BIG_PARTICLES)
						# Add it to featured list
						feature_map[roid.full_name] = {
							'orbit': orbit,
							'idx': added_objects.length
						}
						featured_html += '<tr data-full-name="' + roid.full_name + '"><td><a href="#">' + (roid.prov_des || roid.full_name) + '</a></td><td>' + (roid.price < 1 ? 'N/A' : '$' + roid.fuzzed_price) + '</td></tr>'

					# Add to list of objects in scene
					added_objects.push(orbit) # end asteroid results for loop
					i++

				# handle when view mode is switched - need to clear every row but the sun
				if (featured_2012_da14)
					$('#objects-of-interest tr:gt(2)').remove()
				else
					$('#objects-of-interest tr:gt(1)').remove()
				$('#objects-of-interest').append(featured_html).on('click', 'tr', () ->
					$('#objects-of-interest tr').css('background-color', '#000')
					$e = $(this)
					full_name = $e.data('full-name')
					$('#sun-selector').css('background-color', 'green')
					switch (full_name)
						# special when full names
						when 'sun'
							clearLock(true)
							return false
						when '2012 DA14'
							# highlight the earth too
							#setHighlight('earth')
							break
					clearLock()

					# set new lock
					$e.css('background-color', 'green')
					$('#sun-selector').css('background-color', '#000')
					setLock(full_name)

					return false
				)
				$('#objects-of-interest-container').show()

				if (using_webgl)
					createParticleSystem()
				else
					initSimulation()
					startSimulation()

				#console.log('Starting with', NUM_WORKERS, 'workers for', n, 'from request of', MAX_NUM_ORBITS)

				if (!asteroids_loaded)
					asteroids_loaded = true
					if (featured_2012_da14)
						setLock('earth')
						$('#sun-selector').css('background-color', 'black')
						$('#earth-selector').css('background-color', 'green')
					animate()

				$('#loading').hide()
		)

	window.createParticleSystem = () ->
		# attributes
		attributes = {
			a:
				type: 'f'
				value: []
			e:
				type: 'f'
				value: []
			i:
				type: 'f'
				value: []
			o:
				type: 'f'
				value: []
			ma:
				type: 'f'
				value: []
			n:
				type: 'f'
				value: []
			w:
				type: 'f'
				value: []
			P:
				type: 'f'
				value: []
			epoch:
				type: 'f'
				value: []
			value_color :
				type: 'c'
				value: []
			size:
				type: 'f'
				value: []
			locked:
				type: 'f'
				value: []  # attributes can't be bool or int in some versions of opengl
		}
		uniforms = {
			color:
				type: "c"
				value: new THREE.Color( 0xffffff )
			jed:
				type: 'f'
				value: jed
			earth_i:
				type: "f"
				value: Ephemeris.earth.i
			earth_om:
				type: "f"
				value: Ephemeris.earth.om
			small_roid_texture:
				type: "t"
				value: THREE.ImageUtils.loadTexture("/img/cloud4.png")
			small_roid_circled_texture:
				type: "t",
				value: THREE.ImageUtils.loadTexture("/img/cloud4-circled.png")
		}

		vertexshader = document.getElementById( 'vertexshader' ).textContent
			.replace('{{PIXELS_PER_AU}}',
			PIXELS_PER_AU.toFixed(1))
		particle_system_shader_material = new THREE.ShaderMaterial( {
			uniforms:       uniforms,
			attributes:     attributes,
			vertexShader:   vertexshader,
			fragmentShader: document.getElementById( 'fragmentshader' ).textContent
			})
		particle_system_shader_material.depthTest = false
		particle_system_shader_material.vertexColor = true
		particle_system_shader_material.transparent = true
		particle_system_shader_material.blending = THREE.AdditiveBlending

		for i of particle_system_geometry.vertices
			attributes.size.value[i] = i < 30 ? 50 : 15

			attributes.a.value[i] = added_objects[i].eph.a
			attributes.e.value[i] = added_objects[i].eph.e
			attributes.i.value[i] = added_objects[i].eph.i
			attributes.o.value[i] = added_objects[i].eph.om
			attributes.ma.value[i] = added_objects[i].eph.ma
			attributes.n.value[i] = added_objects[i].eph.n || -1.0
			attributes.w.value[i] = added_objects[i].eph.w_bar || (added_objects[i].eph.w + added_objects[i].eph.om)
			attributes.P.value[i] = added_objects[i].eph.P || -1.0
			attributes.epoch.value[i] = added_objects[i].eph.epoch
			# http:#threejsdoc.appspot.com/doc/three.js/examples.source/webgl_custom_attributes_lines.html.html
			attributes.value_color.value[i] = added_objects[i].opts.display_color
			attributes.locked.value[i] = 0.0

		particleSystem = new THREE.ParticleSystem(
			particle_system_geometry,
			#particle_system_material
			particle_system_shader_material
		)
		window.ps = particleSystem

		# add it to the scene
		particleSystem.sortParticles = true
		scene.add(particleSystem)

	window.starTexture = (color, size) ->
		if size
			size = parseInt(size*24)
		else
			size = 24
		canvas = document.createElement( 'canvas' )
		canvas.width = size
		canvas.height = size
		col = new THREE.Color(color)

		context = canvas.getContext( '2d' )
		gradient = context.createRadialGradient( canvas.width / 2, canvas.height / 2, 0, canvas.width / 2, canvas.height / 2, canvas.width / 2 )
		rgbaString = 'rgba(' + ~~ ( col.r * 255 ) + ',' + ~~ ( col.g * 255 ) + ',' + ~~ ( col.b * 255 ) + ',' + (1) + ')'
		gradient.addColorStop( 0, rgbaString)
		gradient.addColorStop( 0.1, rgbaString)
		gradient.addColorStop( 0.6, 'rgba(125, 20, 0, 0.2)' )
		gradient.addColorStop( .92, 'rgba(0,0,0,0)' )
		context.fillStyle = gradient
		context.fillRect( 0, 0, canvas.width, canvas.height )
		return canvas

	window.changeJED = (new_jed) ->
		jed = new_jed

	window.setDefaultCameraPosition = () ->
		cam.position.set(0, -155, 32)

	# animation loop
	window.animate = () ->
		if (!asteroids_loaded)
			render()
			requestAnimFrame(animate)
			return

		if (camera_fly_around)
			if (locked_object)
				# Follow locked object
				pos = locked_object.getPosAtTime(jed)
				if (featured_2012_da14 && locked_object.name == 'Earth')
					cam.position.set(pos[0]-20, pos[1]+20, pos[2]+20)
				else
					cam.position.set(pos[0]+50, pos[1]+50, pos[2]+50)
				cameraControls.target = new THREE.Vector3(pos[0], pos[1], pos[2])
			else
				setNeutralCameraPosition()

		render()
		requestAnimFrame(animate)

	# render the scene
	window.render = (force) ->
		# update camera controls
		cameraControls.update()

		# update display date
		now = new Date().getTime()
		if (now - display_date_last_updated > 500 && typeof datgui != 'undefined')
			georgian_date = fromJED(jed)
			datgui['display date'] = georgian_date.getMonth()+1 + "/" + georgian_date.getDate() + "/" + georgian_date.getFullYear()
			display_date_last_updated = now

		if (using_webgl && (object_movement_on || force))
			# update shader vals for asteroid cloud
			uniforms.jed.value = jed
			jed += .25

		# actually render the scene
		renderer.render(scene, camera)

	window.requestAnimFrame = (frame)()

	init()
	initGUI()

	$('#btn-toggle-movement').on('click', () ->
		object_movement_on = !object_movement_on
	)
	$('#controls .js-sort').on('click', () ->
		runAsteroidQuery($(this).data('sort'))
		$('#controls .js-sort').css('font-weight', 'normal')
		$(this).css('font-weight', 'bold')
	)

	# 2012 Da14 feature
	if (featured_2012_da14)
		jed = toJED(new Date('2012-11-01'))
		mixpanel.track('2012_da14 special')
