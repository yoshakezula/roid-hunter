all:
	# Started CoffeeScript Compile
	coffee --output ./target --compile ./coffee/
	stylus  -o ./public/css/ -c ./public/styl/style.styl
	# Finished CoffeeScript Compile
