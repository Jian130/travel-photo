(function ($) {
// Default settings
var DEFAULTS = {
	// Search settings
    method: "GET",
    contentType: "json",
    queryParam: "q",
    locationParam: 'll',
	searchDelay: 300,
    minChars: 2,
	idKey: 'id',
	valueKey: 'name',
	descriptionKey: 'description',
	
	// Display settings
	addText: "Click here to add a location",
    hintText: "Type in a search term",
    noResultsText: "No results",
    searchingText: "Searching...",
    deleteText: "&times;",
	createText: "Add This Place...",
	offText: "Do not include location",
	privateText: 'No Location',
    animateDropdown: true,
	overrideToKeep: 3,

	// Tokenization settings
    tokenLimit: null,
    tokenDelimiter: ",",
    preventDuplicates: false,

	// Output settings
    tokenValue: "id",

	// Prepopulation settings
    prePopulate: null,
    processPrePopulate: false,

	// Manipulation settings
    idPrefix: "token-input-",

	// Callbacks
    onResult: null,
    onAdd: null,
    onDelete: null,
    onReady: null,
	onLocation: function () { return ''; }
};

var CLASSES = {
	geolocation: 'geolocation',
	dropdown: 'geolocation-dropdown',
	search: 'geolocation-search',
	status: 'geolocation-status',
	list: 'geolocation-list',
	create: 'geolocation-add',
	off: 'geolocation-off',
	item: 'geolocation-item',
	name: 'geolocation-name',
	detail: 'geolocation-detail',
	selected: 'geolocation-selected',
	highlighted: 'geolocation-highlighted',
	override: 'geolocation-override',
	locked: 'geolocation-locked',
	searching: 'geolocation-searching',
	private: 'geolocation-private',
	separator: 'geolocation-separator'
};

var KEY = {
    BACKSPACE: 8,
    TAB: 9,
    ENTER: 13,
    ESCAPE: 27,
    SPACE: 32,
    PAGE_UP: 33,
    PAGE_DOWN: 34,
    END: 35,
    HOME: 36,
    LEFT: 37,
    UP: 38,
    RIGHT: 39,
    DOWN: 40,
    NUMPAD_ENTER: 108,
    COMMA: 188
};

var methods = {
    init: function(url, options) {
        var settings = $.extend({}, DEFAULTS, options || {});

        return this.each(function () {
            $(this).data("GeolocationInputs", new $.GeolocationSearchInput(this, url, settings));
        });
    },
    clear: function() {
        this.data("GeolocationInputs").clear();
        return this;
    },
    add: function(item) {
        this.data("GeolocationInputs").add(item);
        return this;
    },
    remove: function(item) {
        this.data("GeolocationInputs").remove(item);
        return this;
    },
    get: function() {
    	return this.data("GeolocationInputs").getTokens();
   	},
	select: function(index) {
    	return this.data("GeolocationInputs").select(index);
   	},

}

// Expose the .tokenInput function to jQuery as a plugin
$.fn.GeolocationSearch = function (method) {
    // Method calling and initialization logic
    if(methods[method]) {
        return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else {
        return methods.init.apply(this, arguments);
    }
};


$.GeolocationSearchInput = function (input, url, settings) {
	settings.url = url;
    if (settings.classes) {
        settings.classes = $.extend({}, CLASSES, settings.classes);
    } else {
        settings.classes = CLASSES;
    }

	var timeout;
	var last_query = '';
	var highlighted = null;
	var selected = null;
	var opened = false;
	
	var elements = {
		geolocation: $('<span>').addClass(CLASSES.geolocation),
		input: $(input),
		label: $('<a href="#">').addClass(CLASSES.name).text(settings.addText),
		dropdown: $('<div>').addClass(CLASSES.dropdown),
		search: $('<input type="text">').addClass(CLASSES.search),
		status: $('<p>').addClass(CLASSES.status).text(settings.hintText),
		list: $('<ul>').addClass(CLASSES.list),
		create: $('<li>').addClass(CLASSES.create).text(settings.createText).hide(),
		off: $('<li>').addClass(CLASSES.off).text(settings.offText)
		 
	};
	
	$('html').mousedown(function (event) {
		if (! $(event.target).closest('.' + CLASSES.dropdown + ',.' + CLASSES.geolocation).length) dropdown_close();
	});
	
	elements.geolocation
		.insertBefore(elements.input)
		.append(elements.input)
		.append(elements.label)
	
	elements.label
		.click(function (event) {
			event.preventDefault();
			if (opened)
				dropdown_close();
			else
				dropdown_open();
		});
	
	elements.dropdown
		.append(elements.search)
		.append(elements.status)
		.append(elements.list)
		.appendTo('body')
		.hide();
	
	elements.list
		.append(elements.create)
		.append(elements.off)
		.mouseover(function (event) {
             highlight($(event.target).closest("li"));
         })
        .mousedown(function (event) {
            dropdown_select($(event.target).closest("li"));
			dropdown_close();
            elements.input.change();
            return false;
         });
	
	elements.off	
		.attr('data-location-id', '')
		.attr('data-location-value', settings.privateText);
		
	elements.input
		.hide()
		.val('')
		.focus(function () {
		    elements.search.focus();
		})
		.blur(function () {
		    elements.search.blur();
		});

    elements.search
        .css({ outline: "none" })
        .attr("id", settings.idPrefix + input.id)
        .focus(function () { 
		})
		.change(function() {
			if (! $(this).val().length) elements.create.hide();
		})
        .keydown(function (event) {
			$(this).change();
            switch(event.keyCode) {
                case KEY.UP:
                case KEY.DOWN:
                    if ($(this).val()) {
                        if (event.keyCode === KEY.DOWN) {
                            highlight(highlighted.next());
						} else {
                            highlight(highlighted.prev());
                        }
                        return false;
                    }
                    break;

                case KEY.ENTER:
                case KEY.NUMPAD_ENTER:
                  if (highlight && last_query == getquery()) {
                    dropdown_select(highlighted);
                    elements.input.change();
                    return false;
                  } else {
					search(5);
				  }
                  break;

                case KEY.ESCAPE:
                  dropdown_close();
                  return true;

                default:
                    if (String.fromCharCode(event.which)) {
                        // set a timeout just long enough to let this function finish.
                        setTimeout(function(){ search(); }, 5);
                    }
                    break;
            }
        });
	

    this.clear = function() {
        elements.list.children('.' + CLASSES.override).remove();
	    elements.list.children('.' + CLASSES.item).remove();
    }

    this.add = function(value, override) {
       	var li = format_value(value);
        li.addClass(override? CLASSES.override : CLASSES.item);
		li.insertAfter(elements.off);
		
        if (! li.next()) {
            highlight(li);
        }
    }
    this.select = function(index) {
		e = elements.off.nextUntil().eq(index);
		if (e) dropdown_select(e);
    }
		
    // Do a search and show the "searching" dropdown if the input is longer
    // than settings.minChars
    function search (delay) {
    	var query = getquery();

     	if (query && query.length >= settings.minChars) {
             clearTimeout(timeout);
			 elements.create.show();
             timeout = setTimeout(function () { 
	         	dropdown_status(settings.searchingText);
				elements.dropdown.addClass(CLASSES.searching);
				dehighlight();
                process_request(query);
             }, delay || settings.searchDelay);
         }
     }

    // Do the actual search
    function process_request (query) {
    /*    var cache_key = query + computeURL();
        var cached_results = cache.get(cache_key);
        if(cached_results) {
            populate_dropdown(query, cached_results);
        } else {
      */

        // Prepare the request
		var params = { data: {}};
		params.url = settings.url;
		params.data[settings.locationParam] = settings.onLocation();
        params.data[settings.queryParam] = query;
        params.type = settings.method;
        params.dataType = settings.contentType;
        if (settings.crossDomain) {
            params.dataType = 'jsonp';
        }

        // Attach the success callback
        params.success = function (results) {
          if ($.isFunction(settings.onSuccess)) {
              results = settings.onSuccess.call(elements.input, results);
		  }
		  elements.dropdown.removeClass(CLASSES.searching);
          dropdown_status('');
         // cache.add(cache_key, settings.jsonContainer ? results[settings.jsonContainer] : results);
          dropdown_results(query, results);
		  
		};

        // Make the request
        $.ajax(params);
    }
	
	function getquery() {
		return elements.search.val().toLowerCase();
	}
	
	function dropdown_close() {
		elements.dropdown.hide();
		elements.search.change().val('');
		dehighlight();
		opened = false;
	}
	
	function dropdown_open() {
		elements.dropdown
			.slideDown('fast')
            .css({
                position: "absolute",
                top: elements.geolocation.offset().top + elements.geolocation.outerHeight(),
                left: elements.geolocation.offset().left,
                zindex: 999
            });
		elements.search.focus();
		opened = true;
	}
	
	function dropdown_status(status) {
		if (status) {
			elements.status
				.text(status)
				.show();
		} else {
			elements.status.hide();
		}
	}
	
	function format_value(value) {
		var li = $('<li>');
		li.append('<div class="' + CLASSES.name + '">' + value[settings.valueKey] + '</div>');
		li.append('<div class="' + CLASSES.detail + '">' + value[settings.descriptionKey] + '</div>');
		
		li.attr('data-location-id', value[settings.idKey]);
		li.attr('data-location-value', value[settings.valueKey]);
		return li;
	}
	
	function dropdown_select(item) {
		highlight(item);
		selected = item;
		
		elements.list.children('.' + CLASSES.selected).removeClass(CLASSES.selected);
		elements.input.val(item.attr('data-location-id'));
		elements.label.text(item.attr('data-location-value'));		
		selected.addClass(CLASSES.selected);
			
		dropdown_close();
	}
	
	function highlight(item) {
		if (item && ! item.length) return false;
		dehighlight();
		highlighted = item.eq(0).addClass(CLASSES.highlighted);
	}
	
	function dehighlight() {
		if (highlighted) {
			highlighted.removeClass(CLASSES.highlighted);
			highlighted = null;
		}
	}
	
	function dropdown_results (query, results) {
        if (results && results.length) {
            if (selected) selected.removeClass(CLASSES.item).addClass(CLASSES.override);

			elements.list
				.children('.' + CLASSES.item).remove();
			elements.list
				.children('.' + CLASSES.override + ':gt(' + (settings.overrideToKeep-1) + ')').remove();
			
			position = elements.off;
			$.each(results, function(index, value) {
               	var li = format_value(value);
                li.addClass(CLASSES.item);
				li.insertAfter(position);
				position = li;
				
                if (index === 0) {
                    highlight(li);
                }
            });
			last_query = query;
            dropdown_open();
        } else {
			dropdown_status(settings.noResultsText);
        }
	}
	/*
	<span class='geolocation'>
		<input class='text' style='display: none' value='12345'/>
		<span class='geolocation-name'>Vancouver, BC</span>
	</span>
	
	<div class='geolocation-dropdown'>
		<input type='text' class='geolocation-search'>
		<p class='geolocation-status'>No Results found</p>
		<ul class='geolocation-list'>
			<li class='geolocation-add'>Add this location...</li>	
			<li class='geolocation-item' data-location-id='123' data-location-label='Paris'>
				<span class='geolocation-name'>Paris</span>
				<span class='geolocation-detail'>France</span>
			</li>
			<li class='geolocation-selected geolocation-override geolocation-locked' data-location-id='123' data-location-label='Paris'>
				<span class='geolocation-item'>Vancouver, BC</span>
				<span class='geolocation-detail'>Canada</span>
			</li>
			<li class='geolocation-off separator'>Do not include location</li>
		</ul>
	</div>
	*/
}
}(jQuery));
