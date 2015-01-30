{CompositeDisposable} = require 'atom'
_ = require 'underscore-plus'

fs = require 'fs'
path = require 'path'

module.exports =
class SassDirectorFactory
    # Generator Variables
    root_path: ''
    manifest_files: []
    strip_list: [';', '@import', '\"', '\'']

    constructor: (state) ->
        @__buildPaths__()

    __buildPaths__: ->
        @root_path = atom.project.getPaths()[0]

    __getImports__: ->
        # Needs to exist local to function
        imports = []
        # Read each file from the @manifest_files
        for path in @manifest_files
            buffer = fs.readFileSync path
            body = buffer.toString();
            lines = body.split('\n')
            imports = (line for line in lines when line.match(/^@import/gi) != null)
            for el in imports
                index = imports.indexOf(el)
                for strip in @strip_list
                    imports[index] = imports[index].split(strip).join('').trim()
        return imports

    __expandImports__: (imports) ->
        dir_paths = []
        for el in imports
            index = imports.indexOf(el)
            imports[index] = el.split('/')
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
        return true

    generate: ->
        if @manifest_files.length == 0
            atom.confirm
                message: 'No Manifest Files are registered'
                buttons:
                    Dismiss: -> console.log 'Abort Generate due to no manifest files logged'
            return false
        else
            imports = @__getImports__()
            dirs = @__expandImports__(imports)
            # Get the working path of the manifest
            return false if @manifest_files.length == 0

            path = require 'path'
            mkdirp = require 'mkdirp'

            manifest = String(@manifest_files[0])
            root_path = path.dirname(manifest)
            # Construct dirs and Files using fs
            for dir in dirs
                file_name = '_' + dir.pop() + '.scss'
                file_path = dir_path = root_path

                for directory_name in dir
                    file_path = path.join(file_path, directory_name)
                    dir_path = path.join(dir_path, directory_name)
                    # Check if dir exists -> produce error
                    if !fs.existsSync(path.join(root_path, directory_name))
                        # Dir doesnt exist -> create it
                        # Update dir_path
                        mkdirp.sync dir_path
                        atom.notifications.addSuccess 'Directory ' + dir_path + ' was created'
                    else
                        continue if dir_path is root_path
                        atom.notifications.addError 'Directory ' + dir_path + ' already exists'

                if !fs.existsSync(path.join(file_path, file_name))
                    fs.writeFileSync(path.join(file_path, file_name))
                    atom.notifications.addSuccess 'File ' + path.join(file_path, file_name) + ' was written'
                else
                    atom.notifications.addError 'File: ' + path.join(file_path, file_name) + ' already exists'
    # end generate ->
