const { environment } = require('@rails/webpacker')

const handlebars = require('./loaders/handlebars')

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

environment.loaders.prepend('handlebars', handlebars)

module.exports = environment
