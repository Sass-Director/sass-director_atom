# SassDirectorView = require './sass-director-view'
SassDirectorFactory = require './sass-director-factory'

module.exports =
  activate: (state) ->
    @factory = new SassDirectorFactory(state)
    atom.commands.add 'atom-workspace', 'sass-director:toggle', => @toggle()
    atom.commands.add 'atom-workspace', 'sass-director:generate', => @generate()
    atom.commands.add 'atom-workspace', 'sass-director:add-manifest-file', => @addManifestFile()
    atom.commands.add 'atom-workspace', 'sass-director:remove-manifest-file', => @removeManifestFile()

  generate: ->
      @factory.generate()

  addManifestFile: ->
      @factory.addManifestFile(@__getManifest__())

  removeManifestFile: ->
      @factory.removeManifestFile(@__getManifest__())

  __getManifest__: ->
      obj = {}
      obj.path = atom.workspace.getActiveEditor().getPath()
      obj.name = obj.path.split("/")[obj.path.split("/").length - 1]
      return obj

  toggle: ->
      console.log "Sass-Director: Ready, Set, ACTION!"
