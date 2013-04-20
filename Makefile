all:
	# Started CoffeeScript Compile
	coffee --output ./public/js/ --compile ./public/coffee/
	coffee --output ./ --compile ./public/coffee/
	stylus  -o ./public/css/ -c ./public/styl/main.styl
	# Finished CoffeeScript Compile
