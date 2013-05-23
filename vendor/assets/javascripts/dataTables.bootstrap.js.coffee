# Set the defaults for DataTables initialisation
$.extend true, $.fn.dataTable.defaults,
  sDom: "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>"
  sPaginationType: "bootstrap"
  oLanguage:
    sLengthMenu: "_MENU_ records per page"


# Default class modification
$.extend $.fn.dataTableExt.oStdClasses,
  sWrapper: "dataTables_wrapper form-inline"


# API method to get paging information
$.fn.dataTableExt.oApi.fnPagingInfo = (oSettings) ->
  iStart: oSettings._iDisplayStart
  iEnd: oSettings.fnDisplayEnd()
  iLength: oSettings._iDisplayLength
  iTotal: oSettings.fnRecordsTotal()
  iFilteredTotal: oSettings.fnRecordsDisplay()
  iPage: (if oSettings._iDisplayLength is -1 then 0 else Math.ceil(oSettings._iDisplayStart / oSettings._iDisplayLength))
  iTotalPages: (if oSettings._iDisplayLength is -1 then 0 else Math.ceil(oSettings.fnRecordsDisplay() / oSettings._iDisplayLength))


# Bootstrap style pagination control
$.extend $.fn.dataTableExt.oPagination,
  bootstrap:
    fnInit: (oSettings, nPaging, fnDraw) ->
      oLang = oSettings.oLanguage.oPaginate
      fnClickHandler = (e) ->
        e.preventDefault()
        fnDraw oSettings  if oSettings.oApi._fnPageChange(oSettings, e.data.action)

      $(nPaging).addClass("pagination").append "<ul><li class=\"prev disabled\"><a href=\"#\">&larr; #{oLang.sPrevious}</a></li><li class=\"next disabled\"><a href=\"#\">#{oLang.sNext} &rarr; </a></li></ul>"
      els = $("a", nPaging)
      $(els[0]).bind "click.DT",
        action: "previous"
      , fnClickHandler
      $(els[1]).bind "click.DT",
        action: "next"
      , fnClickHandler

    fnUpdate: (oSettings, fnDraw) ->
      iListLength = 5
      oPaging = oSettings.oInstance.fnPagingInfo()
      an = oSettings.aanFeatures.p
      i = undefined
      ien = undefined
      j = undefined
      sClass = undefined
      iStart = undefined
      iEnd = undefined
      iHalf = Math.floor(iListLength / 2)
      if oPaging.iTotalPages < iListLength
        iStart = 1
        iEnd = oPaging.iTotalPages
      else if oPaging.iPage <= iHalf
        iStart = 1
        iEnd = iListLength
      else if oPaging.iPage >= (oPaging.iTotalPages - iHalf)
        iStart = oPaging.iTotalPages - iListLength + 1
        iEnd = oPaging.iTotalPages
      else
        iStart = oPaging.iPage - iHalf + 1
        iEnd = iStart + iListLength - 1
      i = 0
      ien = an.length

      while i < ien

        # Remove the middle elements
        $("li:gt(0)", an[i]).filter(":not(:last)").remove()

        # Add the new list items and their event handlers
        j = iStart
        while j <= iEnd
          sClass = (if (j is oPaging.iPage + 1) then "class=\"active\"" else "")
          $("<li #{sClass}><a href=\"#\">#{j}</a></li>").insertBefore($("li:last", an[i])[0]).bind "click", (e) ->
            e.preventDefault()
            oSettings._iDisplayStart = (parseInt($("a", this).text(), 10) - 1) * oPaging.iLength
            fnDraw oSettings

          j++

        # Add / remove disabled classes from the static elements
        if oPaging.iPage is 0
          $("li:first", an[i]).addClass "disabled"
        else
          $("li:first", an[i]).removeClass "disabled"
        if oPaging.iPage is oPaging.iTotalPages - 1 or oPaging.iTotalPages is 0
          $("li:last", an[i]).addClass "disabled"
        else
          $("li:last", an[i]).removeClass "disabled"
        i++


#
# * TableTools Bootstrap compatibility
# * Required TableTools 2.1+
#
if $.fn.DataTable.TableTools

  # Set the classes that TableTools uses to something suitable for Bootstrap
  $.extend true, $.fn.DataTable.TableTools.classes,
    container: "DTTT btn-group"
    buttons:
      normal: "btn"
      disabled: "disabled"

    collection:
      container: "DTTT_dropdown dropdown-menu"
      buttons:
        normal: ""
        disabled: "disabled"

    print:
      info: "DTTT_print_info modal"

    select:
      row: "active"


  # Have the collection use a bootstrap compatible dropdown
  $.extend true, $.fn.DataTable.TableTools.DEFAULTS.oTags,
    collection:
      container: "ul"
      button: "li"
      liner: "a"
