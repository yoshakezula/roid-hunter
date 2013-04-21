all:
	# Started CoffeeScript Compile
	coffee --output ./ --compile ./coffee/
	coffee --output ./public/js/ --compile ./public/coffee/
	# stylus  -o ./public/css/ -c ./public/css/style.styl
	# Finished CoffeeScript Compile
