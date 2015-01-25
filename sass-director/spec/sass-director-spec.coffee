SassDirector = require '../lib/sass-director'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "SassDirector", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('sass-director')

  describe "when the sass-director:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.sass-director')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'sass-director:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.sass-director')).toExist()

        sassDirectorElement = workspaceElement.querySelector('.sass-director')
        expect(sassDirectorElement).toExist()

        sassDirectorPanel = atom.workspace.panelForItem(sassDirectorElement)
        expect(sassDirectorPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'sass-director:toggle'
        expect(sassDirectorPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.sass-director')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'sass-director:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        sassDirectorElement = workspaceElement.querySelector('.sass-director')
        expect(sassDirectorElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'sass-director:toggle'
        expect(sassDirectorElement).not.toBeVisible()
