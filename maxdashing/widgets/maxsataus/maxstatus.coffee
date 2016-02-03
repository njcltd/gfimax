clamp = (value) ->
    return Math.max(0, Math.min(Math.floor(value), 255))


gradient = (value) ->

    if value > 1 then value = 1

    start = [255, 255, 255]
    end = [255, 0, 0]

    finalColor = []
    for startChannel, i in start
        finalColor.push(startChannel * (1-value) + end[i])

    return (clamp(x) for x in finalColor)


class Dashing.Freshdesk extends Dashing.Widget
    ready: ->

    onData: (data) =>
    

Batman.mixin Batman.Filters,
    prettyTime: (dateStr) ->
        now = new Date()
        date = new Date(dateStr)

        elapsed = now.getTime() - date.getTime()

        # Percent passed 1 day
        value = elapsed / (24 * 60 * 60 * 1000)
        color = gradient(value)

        days =  Math.floor(elapsed / 24 / 60 / 60 / 1000)

        hours =  Math.floor(elapsed / 60 / 60 / 1000)
        minutes = Math.floor(elapsed / 60 / 1000)
        seconds = Math.floor(elapsed / 1000)

        if days >= 1
            plural = if days is 1 then '' else 's'
            return "<span style='color: rgb(#{color});'>#{days} day#{plural} ago</span>"

        if hours >= 1
            plural = if hours is 1 then '' else 's'
            return "<span style='color: rgb(#{color});'>#{hours} hour#{plural} ago</span>"

        if minutes >= 1
            plural = if minutes is 1 then '' else 's'
            return "<span style='color: rgb(#{color});'>#{minutes} minute#{plural} ago</span>"

        if seconds >= 0
            return "Now"

        return dateStr

    firstName: (name) ->
        name.split(' ')[0]
