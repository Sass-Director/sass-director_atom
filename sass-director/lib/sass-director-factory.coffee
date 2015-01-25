{CompositeDisposable} = require 'atom'

fs = require 'fs'
path = require 'path'

module.exports =
class SassDirectorFactory
    # Single Factory instance
    factory: null

    # Generator V
    root_path: ""
    manifest_files: []
    strip_list: [';', '@import', '\'', '\"']

    constructor: ->
        # Build Paths
        # Obtain Imports from Active View
        return @factory if @factory != null
        @__buildPaths__()

    __buildPaths__: ->
        @root_path = atom.project.getPaths()[0]
        @addManifestFile()

    __obtainImports__: ->
        p = atom.workspace.getActiveEditor()
        body = p.getText()
        imports = (line for line in body.split('\n') when line.indexOf("@import") > -1)

    addManifestFile: ->
        console.log @manifest_files
        manifest_path = atom.workspace.getActiveEditor().getPath()
        if @manifest_files.indexOf(manifest_path) >= 0
            # Notify user that file exists in watch already
            atom.confirm
                message: 'Manifest File already exists'
                detailedMessage: "PATH: #{manifest_path}"
                buttons:
                    Cancel: -> console.log "#{manifest_path} already exists in #{@manifest_files}"
        else
            @manifest_files.push(manifest_path)
            atom.confirm
                message: 'Added new Manifest File'
                detailedMessage: "PATH: #{manifest_path}"
                buttons:
                    Dismiss: -> console.log "#{manifest_path} was added to the list of manifest files"

    generate: ->
        console.log "Generating..."
