// Generated by CoffeeScript 1.6.2
(function() {
  var BundleUp, DEV_PORT, IS_PRODUCTION, PROD_PORT, app, connect, express, fs, lookup, mailer, nib, port, renderWithContext, stylus, _;

  express = require('express');

  connect = require('connect');

  app = express.createServer();

  _ = require('underscore');

  BundleUp = require('bundle-up');

  lookup = require('./lookup.js');

  mailer = require('./mailer.js');

  fs = require('fs');

  nib = require('nib');

  stylus = require('stylus');

  app.use(stylus.middleware({
    src: __dirname + '/public',
    compile: function(str, path) {
      return stylus(str).set('filename', path).set('warn', true).set('compress', true).use(nib());
    }
  }));

  app.set('views', __dirname + '/views');

  app.set('view engine', 'jade');

  app.set('view options', {
    layout: false
  });

  app.use(express.cookieParser());

  app.use(express["static"](__dirname + '/public'));

  app.use(express.bodyParser());

  DEV_PORT = 3000;

  PROD_PORT = 80;

  IS_PRODUCTION = process.env.NODE_ENV === 'production';

  console.log('Bundling....');

  BundleUp(app, __dirname + '/assets', {
    staticRoot: __dirname + '/public/',
    staticUrlRoot: '/',
    bundle: IS_PRODUCTION,
    minifyCss: false,
    minifyJs: false
  });

  console.log('Finished bundling');

  app.get('/', function(req, res) {
    return lookup.homepage(function(err, summary_result) {
      return renderWithContext(res, 'index', {
        nosocial: req.query.nosocial !== void 0,
        summary: summary_result
      });
    });
  });

  app.get('/top', function(req, res) {
    return fs.readFile('top.json', function(err, data) {
      return res.send(JSON.parse(data));
    });
  });

  app.get('/top-targets', function(req, res) {
    return fs.readFile('json/targets.json', function(err, data) {
      return res.send(JSON.parse(data));
    });
  });

  renderWithContext = function(res, template, obj) {
    if (!obj) {
      obj = {};
    }
    obj.context = {
      layout: 'layout',
      production: IS_PRODUCTION
    };
    return res.render(template, obj);
  };

  if (process.env.PORT) {
    port = process.env.PORT;
  } else {
    port = DEV_PORT;
    if (IS_PRODUCTION) {
      port = PROD_PORT;
    }
  }

  app.listen(port);

  console.log('Running in context:', process.env.NODE_ENV);

  console.log('Started listening on port ' + port);

}).call(this);
