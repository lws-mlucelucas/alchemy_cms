#= require alchemy/alchemy.jquery_loader
#= require alchemy/alchemy.inplace_edit
#= require alchemy/alchemy.browser
#= require alchemy/alchemy.i18n

window.Alchemy = {} if typeof(Alchemy) is 'undefined'

# Loaded when jQuery is loaded
onload = ($) ->

  # Setting jQueryUIs global animation duration
  $.fx.speeds._default = 400

  # The Alchemy JavaScript Object contains all Functions
  $.extend Alchemy,
    ElementSelector:

      # defaults
      scrollOffset: 80

      styles:
        reset:
          outline: ""
          "outline-offset": ""
          "-moz-outline-radius": ""

        default_hover:
          outline: "0 none"
          "outline-offset": "4px"
          cursor: "pointer"

        webkit_hover:
          outline: "0 none"

        moz_hover:
          "-moz-outline-radius": "3px"

        default_selected:
          outline: "0 none"
          "outline-offset": "4px"

        webkit_selected:
          outline: "0 none"

        moz_selected:
          "-moz-outline-radius": "3px"

      init: (selector = '[data-alchemy-element]') ->
        $elements = $(selector)
        @$previewElements = $elements
        $elements.mouseover (e) =>
          $el = $(e.delegateTarget)
          $el.attr("title", Alchemy._t('click_to_edit'))
          $el.css(@getStyle("hover")) unless $el.hasClass("selected")
        $elements.mouseout (e) =>
          $el = $(e.delegateTarget)
          $el.removeAttr("title")
          $el.css(@getStyle("reset")) unless $el.hasClass("selected")
        $elements.on "Alchemy.SelectElement", (e) =>
          @selectElement(e)
        $elements.click (e) =>
          @clickElement(e)

      selectElement: (e) ->
        $el = $(e.delegateTarget)
        $elements = @$previewElements
        offset = @scrollOffset
        window.parent.Alchemy.currentPreviewElement = $el
        e.preventDefault()
        $elements.removeClass("selected").css(@getStyle("reset"))
        $el.addClass("selected").css(@getStyle("selected"))
        # $("html, body").animate
        #   scrollTop: $el.offset().top - offset
        #   scrollLeft: $el.offset().left - offset
        # , 400
        return

      clickElement: (e) ->
        $el = $(e.delegateTarget)
        parent$ = window.parent.jQuery
        window.parent.Alchemy.currentPreviewElement = $el
        target_id = $el.data("alchemy-element")
        $element_editor = parent$("#element_area .element_editor").closest("[id='element_#{target_id}']")
        elementsWindow = window.parent.Alchemy.ElementsWindow
        e.preventDefault()
        $element_editor.trigger("Alchemy.SelectElementEditor", target_id)
        $el.trigger("Alchemy.SelectElement")
        return

      getStyle: (state) ->
        if state == "reset"
          @styles["reset"]
        else
          default_state_style = @styles["default_#{state}"]
          browser = "webkit" if Alchemy.Browser.isWebKit
          browser = "moz" if Alchemy.Browser.isFirefox
          if browser
            $.extend(default_state_style, @styles["#{browser}_#{state}"])
          else
            default_state_style

  Alchemy.ElementSelector.init()

if typeof(jQuery) is 'undefined'
  Alchemy.loadjQuery(onload)
else
  onload(jQuery)