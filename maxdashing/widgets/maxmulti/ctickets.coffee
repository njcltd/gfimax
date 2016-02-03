class Dashing.Ctickets extends Dashing.Widget


  ready: ->
    super
 
  onData: (data) ->
   # clear existing "status-*" classes
    $(@get('node')).attr 'class', (i,c) ->
      c.replace /\bstatus-\S+/g, ''
    # add new class
    $(@get('node')).addClass "status-#{data.statusa}"
