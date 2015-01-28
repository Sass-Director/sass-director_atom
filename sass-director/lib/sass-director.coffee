# SassDirectorView = require './sass-director-view'
SassDirectorFactory = require './sass-director-factory'

module.exports =
    @SassDirector = null

    activate: (state) ->
        @SassDirector = new SassDirectorFactory(state)
        atom.commands.add 'atom-workspace', 'sass-director:toggle', => @toggle()
        atom.commands.add 'atom-workspace', 'sass-director:generate', => @generate()
        atom.commands.add 'atom-workspace', 'sass-director:add-manifest-file', => @addManifestFile()
        atom.commands.add 'atom-workspace', 'sass-director:remove-manifest-file', => @removeManifestFile()

    generate: ->
        @SassDirector.generate()

    addManifestFile: ->
        @SassDirector.addManifestFile(@__getManifest__())

    removeManifestFile: ->
        @SassDirector.removeManifestFile(@__getManifest__())

    #########################################################################
    ######################### Helper Functions ##############################
    #########################################################################

    __getManifest__: ->
        obj = {}
        obj.path = atom.workspace.getActiveEditor().getPath()
        obj.name = obj.path.split("/")[obj.path.split("/").length - 1]
        return obj

    #########################################################################
    ######################## End Helper Functions ###########################
    #########################################################################

    toggle: ->
        console.log "Sass-Director: Ready, Set, ACTION!"
