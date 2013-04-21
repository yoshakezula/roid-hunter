sendmail = require('sendmail')()

# /**
#  * Sends mail to me!
#  */
mail = (text) ->
	sendmail({
		from: 'feedback@asterank.com',
		to: 'typppo@gmail.com',
		subject: 'Asterank Feedback',
		content: text,
	}, (err, reply) ->
			# console.log(err && err.stack)
			# console.dir(reply)
	)


module.exports = {
	mail: mail,
}
