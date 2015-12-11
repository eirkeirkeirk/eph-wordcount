WordCounterView = require './eph-wordcount-view'
{CompositeDisposable} = require 'atom'

module.exports = WordCounter =
  wordCounterView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @wordCounterView = new WordCounterView(state.wordCounterViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @wordCounterView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'eph-wordcount:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @wordCounterView.destroy()

  serialize: ->
    wordCounterViewState: @wordCounterView.serialize()

  toggle: ->
    console.log 'WordCounter was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      editor = atom.workspace.getActiveTextEditor();
      words = editor.getText().split(/\s+/).length
      characters = editor.getText().split("").length
      lines = editor.getText().split(/\n/).length
      @wordCounterView.setCount(words, characters, lines)
      @modalPanel.show()
