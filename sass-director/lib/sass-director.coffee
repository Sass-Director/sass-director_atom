# SassDirectorView = require './sass-director-view'
SassDirectorFactory = require './sass-director-factory'

module.exports =
  activate: (state) ->
    @factory = new SassDirectorFactory(state)
    atom.commands.add 'atom-workspace', 'sass-director:toggle', => @toggle()
    atom.commands.add 'atom-workspace', 'sass-director:generate', => @generate()
    atom.commands.add 'atom-workspace', 'sass-director:add-manifest-file', => @addManifestFile()

  generate: ->
      @factory.generate()

  addManifestFile: ->
      @factory.addManifestFile()

  toggle: ->
      console.log ""
      console.log "Sass-Director: Ready, Set, ACTION!"
