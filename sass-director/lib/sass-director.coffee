# SassDirectorView = require './sass-director-view'
SassDirectorFactory = require './sass-director-factory'

module.exports =
  activate: ->
    @factory = new SassDirectorFactory()
    atom.commands.add 'atom-workspace', 'sass-director:toggle', => @toggle()
    atom.commands.add 'atom-workspace', 'sass-director:generate-sass-from-manifest', => @generate()
    atom.commands.add 'atom-workspace', 'sass-director:add-manifest-file', => @addManifest()

  generate: ->
      @factory.generate()

  addManifest: ->
      @factory.addManifestFile()

  toggle: ->
      console.log "Sass-Director is alive!"
      console.log window.location.pathname
