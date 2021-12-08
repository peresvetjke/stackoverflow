const { environment } = require('@rails/webpacker')

const path = require('path');

const webpack = require('webpack')

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Handlebars: 'handlebars'
  })
)

environment.loaders.prepend('Handlebars', {
  test: /\.hbs$/,
  use: {
    loader: 'handlebars-loader',
    query: {
      knownHelpersOnly: false,
      helperDirs: [ path.resolve(__dirname, "../../app/assets/templates/helpers/") ],
      templateDirs: [ path.resolve(__dirname, "../../app/assets/templates/partials") ]
    }
  }
});

module.exports = environment