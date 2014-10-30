#!/usr/local/bin/node

fs          = require("fs")
path        = require("path")
marked      = require("marked")
jade        = require("jade")
renderer    = new marked.Renderer()

firstSingleSlide  = true
firstVerticalSlide  = true
inVerticalSlide = false

renderer.paragraph = (text) ->
  if text is "!slide" and firstSingleSlide
    firstSingleSlide = false
    "<section>\n"
  else if text is "!slide" and inVerticalSlide
    inVerticalSlide = false
    "</section>\n</section>\n<section>\n"
  else if text is "!slide"
    "</section>\n<section>\n"
  else if text is "!!slide" and firstVerticalSlide
    inVerticalSlide = true
    firstVerticalSlide = false
    "<section>\n<section>\n"
  else if text is "!!slide"
    "</section>\n<section>\n"
  else
    "<p>" + text + "</p>\n"

highlight = (code, lang, callback) ->
  require("pygmentize-bundled")
    lang: lang
    format: "html", code, (err, result) ->
      callback err, result.toString()

marked.setOptions
  highligh: highlight
  renderer: renderer

slides = path.join(__dirname + '/../presentation/templates/slides.md')
template = path.join(__dirname + '/../presentation/templates/index.jade')
presentation = path.join(__dirname + '/../presentation/index.html')

fs.readFile slides, (err, data) ->
  throw err if err
  marked data.toString(), (err, content) ->
    throw err if err
    jade.renderFile template,
      content: content
      pretty: true, (err, html) ->
        throw err if err
        fs.writeFile presentation, html, (err) ->
          if err
            console.log err
          else
            console.log "File was written."
