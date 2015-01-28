{CompositeDisposable} = require 'atom'
_ = require 'underscore-plus'

fs = require 'fs'
path = require 'path'

module.exports =
class SassDirectorFactory
    # Single Factory instance
    factory: null

    # Generator Variables
    root_path: ""
    manifest_files: []
    strip_list: [';', '@import', '\'', '\"']

    constructor: (state) ->
        # @SassDirectorView = new SassDirectorView(state.sassDirectorViewState)
        return @factory if @factory isnt null
        # First Run
        @__buildPaths__()

    __buildPaths__: ->
        @root_path = atom.project.getPaths()[0]

    __getImports__: ->
        console.log 'Obtaining Imports now...'
        # Needs to exist local to function
        imports = []
        # Read each file from the @manifest_files
        for path in @manifest_files
            console.log('Path: ', path)
            buffer = fs.readFileSync path
            body = buffer.toString();
            lines = body.split('\n')
            imports = (line for line in lines when line.match(/^@import/gi) != null)
            for el in imports
                index = imports.indexOf(el)
                for strip in @strip_list
                    imports[index] = imports[index].split(strip).join('').trim()
        return imports

    addManifestFile: (manifest) ->
        if _.contains(@manifest_files, manifest.path)
            atom.notifications.addError('This Manifest File already exists in Sass Director')
        else if manifest.name.match(/(\.sass$)|(\.scss$)/gi) == null
            atom.notifications.addError(manifest.name + ' is not a valid filetype')
        else
            @manifest_files.push(manifest.path)
            atom.notifications.addSuccess(manifest.name + ' was added to Sass Director')

    removeManifestFile: (manifest) ->
        if @manifest_files.length == 0
            atom.notifications.addError('No Manifest Files are being watched')
            return false
        else
            if _.contains(@manifest_files, manifest.path)
                i = @manifest_files.indexOf(manifest.path)
                @manifest_files.splice(i, 1)
                atom.notifications.addSuccess(manifest.name + ' was removed')
        console.log "Watched Manifest Files: ", @manifest_files
        return true

    generate: ->
        console.log "Begin Generating Sequence..."
        if @manifest_files.length == 0
            atom.confirm
                message: 'No Manifest Files are registered'
                buttons:
                    Dismiss: -> console.log "Abort Generate due to no manifest files logged"
            return false
        else
            imports = @__getImports__()
            console.log('Imports: ', imports)
