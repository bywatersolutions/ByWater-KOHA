function display_pickup_location (state) {
    var $text;
    if ( state.needs_override === true ) {
        $text = $(
            '<span>' + state.text + '</span> <span style="float:right;" title="' +
            __("This pickup location is not allowed according to circulation rules") +
            '"><i class="fa fa-exclamation-circle" aria-hidden="true"></i></span>'
        );
    }
    else {
        $text = $('<span>'+state.text+'</span>');
    }

    return $text;
};

(function ($) {

    /**
     * Generate a Select2 dropdown for pickup locations
     *
     * It expects the select object to contain several data-* attributes
     * - data-pickup-location-source: 'biblio', 'item' or 'hold' (default)
     * - data-patron-id: required for 'biblio' and 'item'
     * - data-biblio-id: required for 'biblio' only
     * - data-item-id: required for 'item' only
     *
     * @return {Object} The Select2 instance
     */

    $.fn.pickup_locations_dropdown = function () {
        var select = $(this);
        var pickup_location_source = $(this).data('pickup-location-source');
        var patron_id = $(this).data('patron-id');
        var biblio_id = $(this).data('biblio-id');
        var item_id = $(this).data('item-id');
        var hold_id = $(this).data('hold-id');

        var url;

        if ( pickup_location_source === 'biblio' ) {
            url = '/api/v1/biblios/' + encodeURIComponent(biblio_id) + '/pickup_locations';
        }
        else if ( pickup_location_source === 'item' ) {
            url = '/api/v1/items/' + encodeURIComponent(item_id) + '/pickup_locations';
        }
        else { // hold
            url = '/api/v1/holds/' + encodeURIComponent(hold_id) + '/pickup_locations';
        }

        select.select2({
            width: 'style',
            allowClear: false,
            ajax: {
                url: url,
                delay: 300, // wait 300 milliseconds before triggering the request
                cache: true,
                dataType: 'json',
                data: function (params) {
                    var search_term = (params.term === undefined) ? '' : params.term;
                    var query = {
                        "q": JSON.stringify({"name":{"-like":'%'+search_term+'%'}}),
                        "_order_by": "name",
                        "_page": params.page
                    };

                    if ( pickup_location_source !== 'hold' ) {
                        query["patron_id"] = patron_id;
                    }

                    return query;
                },
                processResults: function (data) {
                    var results = [];
                    data.results.forEach( function ( pickup_location ) {
                        results.push(
                            {
                                "id": pickup_location.library_id.escapeHtml(),
                                "text": pickup_location.name.escapeHtml(),
                                "needs_override": pickup_location.needs_override
                            }
                        );
                    });
                    return { "results": results, "pagination": { "more": data.pagination.more } };
                },
                transport: kohaSelect2Transport,
            },
            templateResult: display_pickup_location
        });

        return select;
    };
})(jQuery);

/* global __ dataTablesDefaults borrowernumber SuspendHoldsIntranet */
$(document).ready(function() {
    var holdsTable;

    // Don't load holds table unless it is clicked on
    $("#holds-tab").on( "click", function(){ load_holds_table() } );

    // If the holds tab is preselected on load, we need to load the table
    if ( $("#holds-tab").parent().hasClass('ui-state-active') ) { load_holds_table() }

    function load_holds_table() {
        var holds = new Array();
        if ( ! holdsTable ) {
            var title;
            holdsTable = $("#holds-table").dataTable($.extend(true, {}, dataTablesDefaults, {
                "bAutoWidth": false,
                "sDom": "rt",
                "columns": [
                    {
                        "data": { _: "reservedate_formatted", "sort": "reservedate" }
                    },
                    {
                        "mDataProp": function ( oObj ) {
                            title = "<a href='/cgi-bin/koha/reserve/request.pl?biblionumber="
                                  + oObj.biblionumber
                                  + "'>"
                                  + oObj.title.escapeHtml();

                            $.each(oObj.subtitle, function( index, value ) {
                                title += " " + value.escapeHtml();
                            });

                            title += " " + oObj.part_number + " " + oObj.part_name;

                            if ( oObj.enumchron ) {
                                title += " (" + oObj.enumchron.escapeHtml() + ")";
                            }

                            title += "</a>";

                            if ( oObj.author ) {
                                title += " " + __("by _AUTHOR_").replace("_AUTHOR_", oObj.author.escapeHtml());
                            }

                            if ( oObj.itemnotes ) {
                                var span_class = "";
                                if ( flatpickr.formatDate( new Date(oObj.issuedate), "Y-m-d" ) == ymd ){
                                    span_class = "circ-hlt";
                                }
                                title += " - <span class='" + span_class + "'>" + oObj.itemnotes.escapeHtml() + "</span>"
                            }

                            return title;
                        }
                    },
                    {
                        "mDataProp": function( oObj ) {
                            return oObj.itemcallnumber && oObj.itemcallnumber.escapeHtml() || "";
                        }
                    },
                    {
                        "mDataProp": function( oObj ) {
                            var data = "";
                            if ( oObj.barcode ) {
                                data += " <a href='/cgi-bin/koha/catalogue/moredetail.pl?biblionumber="
                                  + oObj.biblionumber
                                  + "&itemnumber="
                                  + oObj.itemnumber
                                  + "#item"
                                  + oObj.itemnumber
                                  + "'>"
                                  + oObj.barcode.escapeHtml()
                                  + "</a>";
                            }
                            return data;
                        }
                    },
                    {
                        "mDataProp": function( oObj ) {
                            if( oObj.branches.length > 1 && oObj.found !== 'W' && oObj.found !== 'T' ){
                                var branchSelect='<select priority='+oObj.priority+' class="hold_location_select" data-hold-id="'+oObj.reserve_id+'" reserve_id="'+oObj.reserve_id+'" name="pick-location" data-pickup-location-source="hold">';
                                for ( var i=0; i < oObj.branches.length; i++ ){
                                    var selectedbranch;
                                    var setbranch;
                                    if( oObj.branches[i].selected ){

                                        selectedbranch = " selected='selected' ";
                                        setbranch = __(" (current) ");
                                    } else if ( oObj.branches[i].pickup_location == 0 ) {
                                        continue;
                                    } else{
                                        selectedbranch = '';
                                        setbranch = '';
                                    }
                                    branchSelect += '<option value="'+ oObj.branches[i].branchcode.escapeHtml() +'"'+selectedbranch+'>'+oObj.branches[i].branchname.escapeHtml()+setbranch+'</option>';
                                }
                                branchSelect +='</select>';
                                return branchSelect;
                            }
                            else { return oObj.branchcode.escapeHtml() || ""; }
                        }
                    },
                    { "data": { _: "expirationdate_formatted", "sort": "expirationdate" } },
                    {
                        "mDataProp": function( oObj ) {
                            if ( oObj.priority && parseInt( oObj.priority ) && parseInt( oObj.priority ) > 0 ) {
                                return oObj.priority;
                            } else {
                                return "";
                            }
                        }
                    },
                    {
                        "bSortable": false,
                        "mDataProp": function( oObj ) {
                            return "<select name='rank-request'>"
                                 +"<option value='n'>" + __("No") + "</option>"
                                 +"<option value='del'>" + __("Yes") + "</option>"
                                 + "</select>"
                                 + "<input type='hidden' name='biblionumber' value='" + oObj.biblionumber + "'>"
                                 + "<input type='hidden' name='borrowernumber' value='" + borrowernumber + "'>"
                                 + "<input type='hidden' name='reserve_id' value='" + oObj.reserve_id + "'>";
                        }
                    },
                    {
                        "bSortable": false,
                        "visible": SuspendHoldsIntranet,
                        "mDataProp": function( oObj ) {
                            holds[oObj.reserve_id] = oObj; //Store holds for later use

                            if ( oObj.found ) {
                                return "";
                            } else if ( oObj.suspend == 1 ) {
                                return "<a class='hold-resume btn btn-default btn-xs' id='resume" + oObj.reserve_id + "'>"
                                     +"<i class='fa fa-play'></i> " + __("Resume") + "</a>";
                            } else {
                                return "<a class='hold-suspend btn btn-default btn-xs' id='suspend" + oObj.reserve_id + "'>"
                                     +"<i class='fa fa-pause'></i> " + __("Suspend") + "</a>";
                            }
                        }
                    },
                    {
                        "mDataProp": function( oObj ) {
                            var data = "";

                            if ( oObj.suspend == 1 ) {
                                data += "<p>" + __("Hold is <strong>suspended</strong>");
                                if ( oObj.suspend_until ) {
                                    data += " " + __("until %s").format(oObj.suspend_until_formatted);
                                }
                                data += "</p>";
                            }

                            if ( oObj.itemtype_limit ) {
                                data += __("Next available %s item").format(oObj.itemtype_limit);
                            }

                            if ( oObj.volume_id ) {
                                data += _("Next available volume <strong>%s</strong> item").format( oObj.volume_description );
                            }

                            if ( oObj.barcode ) {
                                data += "<em>";
                                if ( oObj.found == "W" ) {

                                    if ( oObj.waiting_here ) {
                                        data += __("Item is <strong>waiting here</strong>");
                                        if (oObj.desk_name) {
                                            data += ", " + __("at %s").format(oObj.desk_name.escapeHtml());
                                        }
                                    } else {
                                        data += __("Item is <strong>waiting</strong>");
                                        data += " " + __("at %s").format(oObj.waiting_at);
                                        if (oObj.desk_name) {
                                            data += ", " + __("at %s").format(oObj.desk_name.escapeHtml());
                                        }

                                    }

                                } else if ( oObj.transferred ) {
                                    data += __("Item is <strong>in transit</strong> from %s since %s").format(oObj.from_branch, oObj.date_sent);
                                } else if ( oObj.not_transferred ) {
                                    data += __("Item hasn't been transferred yet from %s").format(oObj.not_transferred_by);
                                }
                                data += "</em>";
                            }
                            return data;
                        }
                    }
                ],
                "bPaginate": false,
                "bProcessing": true,
                "bServerSide": false,
                "ajax": {
                    "url": '/cgi-bin/koha/svc/holds',
                    "data": function ( d ) {
                        d.borrowernumber = borrowernumber;
                    }
                },
            }));

            $('#holds-table').on( 'draw.dt', function () {
                $(".hold-suspend").on( "click", function() {
                    var id = $(this).attr("id").replace("suspend", "");
                    var hold = holds[id];
                    $("#suspend-modal-title").html( hold.title );
                    $("#suspend-modal-reserve_id").val( hold.reserve_id );
                    $('#suspend-modal').modal('show');
                });

                $(".hold-resume").on( "click", function() {
                    var id = $(this).attr("id").replace("resume", "");
                    var hold = holds[id];
                    $.post('/cgi-bin/koha/svc/hold/resume', { "reserve_id": hold.reserve_id }, function( data ){
                      if ( data.success ) {
                          holdsTable.api().ajax.reload();
                      } else {
                        if ( data.error == "HOLD_NOT_FOUND" ) {
                            alert( __("Unable to resume, hold not found") );
                            holdsTable.api().ajax.reload();
                        }
                      }
                    });
                });

                $(".hold_location_select").each(function(){ $(this).pickup_locations_dropdown(); });

                $(".hold_location_select").on("change", function(){
                    $(this).prop("disabled",true);
                    var cur_select = $(this);
                    var res_id = $(this).attr('reserve_id');
                    $(this).after('<div id="updating_reserveno'+res_id+'" class="waiting"><img src="/intranet-tmpl/prog/img/spinner-small.gif" alt="" /><span class="waiting_msg"></span></div>');
                    var api_url = '/api/v1/holds/' + encodeURIComponent(res_id) + '/pickup_location';
                    $.ajax({
                        method: "PUT",
                        url: api_url,
                        data: JSON.stringify({ "pickup_library_id": $(this).val() }),
                        headers: { "x-koha-override": "any" },
                        success: function( data ){ holdsTable.api().ajax.reload(); },
                        error: function( jqXHR, textStatus, errorThrown) {
                            alert('There was an error:'+textStatus+" "+errorThrown);
                            cur_select.prop("disabled",false);
                            $("#updating_reserveno"+res_id).remove();
                            cur_select.val( cur_select.children('option[selected="selected"]').val() );
                        },
                    });
                });

            });

            if ( $("#holds-table").length ) {
                $("#holds-table_processing").position({
                    of: $( "#holds-table" ),
                    collision: "none"
                });
            }
        }
    }

    $("body").append("\
        <div id='suspend-modal' class='modal fade' role='dialog' aria-hidden='true'>\
            <div class='modal-dialog'>\
            <div class='modal-content'>\
            <form id='suspend-modal-form' class='form-inline'>\
                <div class='modal-header'>\
                    <button type='button' class='closebtn' data-dismiss='modal' aria-hidden='true'>×</button>\
                    <h3 id='suspend-modal-label'>" + __("Suspend hold on") + " <i><span id='suspend-modal-title'></span></i></h3>\
                </div>\
\
                <div class='modal-body'>\
                    <input type='hidden' id='suspend-modal-reserve_id' name='reserve_id' />\
\
                    <label for='suspend-modal-until'>" + __("Suspend until:") + "</label>\
                    <input name='suspend_until' id='suspend-modal-until' class='suspend-until flatpickr' data-flatpickr-futuredate='true' size='10' />\
\
                    <p><a class='btn btn-link' id='suspend-modal-clear-date' >" + __("Clear date to suspend indefinitely") + "</a></p>\
\
                </div>\
\
                <div class='modal-footer'>\
                    <button id='suspend-modal-submit' class='btn btn-primary' type='submit' name='submit'>" + __("Suspend") + "</button>\
                    <a href='#' data-dismiss='modal' aria-hidden='true' class='cancel'>" + __("Cancel") + "</a>\
                </div>\
            </form>\
            </div>\
            </div>\
        </div>\
    ");

    $("#suspend-modal-clear-date").on( "click", function() { $("#suspend-modal-until").val(""); } );

    $("#suspend-modal-submit").on( "click", function( e ) {
        e.preventDefault();
        $.post('/cgi-bin/koha/svc/hold/suspend', $('#suspend-modal-form').serialize(), function( data ){
          $('#suspend-modal').modal('hide');
          if ( data.success ) {
              holdsTable.api().ajax.reload();
          } else {
            if ( data.error == "INVALID_DATE" ) {
                alert( __("Unable to suspend hold, invalid date") );
            }
            else if ( data.error == "HOLD_NOT_FOUND" ) {
                alert( __("Unable to suspend hold, hold not found") );
                holdsTable.api().ajax.reload();
            }
          }
        });
    });

    $(".toggle-suspend").on('click', function(e) {
        e.preventDefault();
        let reserve_id     = $(this).data('reserve-id');
        let biblionumber   = $(this).data('biblionumber');
        let suspend_until  = $('#suspend_until_' + reserve_id).val();
        window.location.href='request.pl?action=toggleSuspend&amp;reserve_id=' + reserve_id + '&amp;biblionumber=' + biblionumber + '&amp;suspend_until=' + suspend_until;
        return false;
    });
});
