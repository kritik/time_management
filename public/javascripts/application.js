String.prototype.startsWith = function(str)
{return (this.match("^"+str)==str)}

jQuery(document).ready(function(){
    $.datepicker.setDefaults({
        dateFormat: 'dd-mm-yy',
//        showOtherMonths: true,
        selectOtherMonths: true,
        firstDay: 1
    });
    $('.datepicker').datepicker();

    //will be an array for dates
    var dates;
    
    $('#calendar').datepicker({
        defaultDate: $('#calendar').attr("data-month-to-show"),
        gotoCurrent: true,
        beforeShowDay: function(date){
            //getting an array of dates in which work is created
            dates = jQuery(this).attr('data-have-dates').split(",");
            var pos = jQuery.inArray(timestamp2date(date.getTime()), dates);
            allowed_calendarMarkedDays = new Array();
            if (pos>-1)
            {
                ret = new Array(true, 'ui-state-active','has already date');
            }else{
                ret = new Array(true, 'create-new', '');
            }
            return ret;

        },
        onChangeMonthYear: function(year, month, inst) {
            change_showed_month(year, month);
            return false;
        },
        onSelect: function(dateText,inst){
            var pos = jQuery.inArray(dateText, dates);
            if(pos == -1)
                window.location = $(this).attr("data-new-record_path")+"/"+dateText;
        }
    });

    $(".MonthPicker").monthpicker({
        elements: [
            {tpl:"year",opt:{
                range: "-5~5"
            }},
            {tpl:"month",opt:{
            }}
        ],
        onChanged: function (data,$e){
            change_showed_month(data.year, data.month)
        }
    });

    // collecting data of times for time-autocompletation
    var data = new Array();
    var k = 0;
    for(var i=0; i<24; i++){
        for(var j=0; j<60; j+=15){
            data[k++] = i+":"+j;
        }
    }

    $('.autotime').autocomplete({
        delay: 0,
        source:function(request, response){
            var to_return = new Array();
            var time;
            var i = 0;
            for(time in data){
                if(data[time].startsWith(request.term)) to_return[i++] = data[time];
            }
            response(to_return);
        }
    });

    $('form.button_to').hide();
    $container = $("#container").notify();
});

function change_showed_month(year, month){
     change_location($(".MonthPicker").attr("data-url_to_go").replace('%y',year).replace('%m',month));
}

/* to move to another page */
function change_location(location){
    window.location = location;
}

/* function to create notifier */
function create( template, vars, opts ){
    return $container.notify("create", template, vars, opts);
}

function set_todos_parameter_to_edit(title,description,date,time){
    $("#todo_title").val(title || "");
    $("#todo_description").val(description || "");
    $("#todo_date").val(date || "");
    $("#todo_time").val(time || "");
}

var dateFormat = function () {
	var	token = /d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g,
		timezone = /\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g,
		timezoneClip = /[^-+\dA-Z]/g,
		pad = function (val, len) {
			val = String(val);
			len = len || 2;
			while (val.length < len) val = "0" + val;
			return val;
		};

	// Regexes and supporting functions are cached through closure
	return function (date, mask, utc) {
		var dF = dateFormat;

		// You can't provide utc if you skip other args (use the "UTC:" mask prefix)
		if (arguments.length == 1 && Object.prototype.toString.call(date) == "[object String]" && !/\d/.test(date)) {
			mask = date;
			date = undefined;
		}

		// Passing date through Date applies Date.parse, if necessary
		date = date ? new Date(date) : new Date;
		if (isNaN(date)) throw SyntaxError("invalid date");

		mask = String(dF.masks[mask] || mask || dF.masks["default"]);

		// Allow setting the utc argument via the mask
		if (mask.slice(0, 4) == "UTC:") {
			mask = mask.slice(4);
			utc = true;
		}

		var	_ = utc ? "getUTC" : "get",
			d = date[_ + "Date"](),
			D = date[_ + "Day"](),
			m = date[_ + "Month"](),
			y = date[_ + "FullYear"](),
			H = date[_ + "Hours"](),
			M = date[_ + "Minutes"](),
			s = date[_ + "Seconds"](),
			L = date[_ + "Milliseconds"](),
			o = utc ? 0 : date.getTimezoneOffset(),
			flags = {
				d:    d,
				dd:   pad(d),
				ddd:  dF.i18n.dayNames[D],
				dddd: dF.i18n.dayNames[D + 7],
				m:    m + 1,
				mm:   pad(m + 1),
				mmm:  dF.i18n.monthNames[m],
				mmmm: dF.i18n.monthNames[m + 12],
				yy:   String(y).slice(2),
				yyyy: y,
				h:    H % 12 || 12,
				hh:   pad(H % 12 || 12),
				H:    H,
				HH:   pad(H),
				M:    M,
				MM:   pad(M),
				s:    s,
				ss:   pad(s),
				l:    pad(L, 3),
				L:    pad(L > 99 ? Math.round(L / 10) : L),
				t:    H < 12 ? "a"  : "p",
				tt:   H < 12 ? "am" : "pm",
				T:    H < 12 ? "A"  : "P",
				TT:   H < 12 ? "AM" : "PM",
				Z:    utc ? "UTC" : (String(date).match(timezone) || [""]).pop().replace(timezoneClip, ""),
				o:    (o > 0 ? "-" : "+") + pad(Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60, 4),
				S:    ["th", "st", "nd", "rd"][d % 10 > 3 ? 0 : (d % 100 - d % 10 != 10) * d % 10]
			};

		return mask.replace(token, function ($0) {
			return $0 in flags ? flags[$0] : $0.slice(1, $0.length - 1);
		});
	};
}();

// Some common format strings
dateFormat.masks = {
	"default":      "ddd mmm dd yyyy HH:MM:ss",
	shortDate:      "m/d/yy",
	mediumDate:     "mmm d, yyyy",
	longDate:       "mmmm d, yyyy",
	fullDate:       "dddd, mmmm d, yyyy",
	shortTime:      "h:MM TT",
	mediumTime:     "h:MM:ss TT",
	longTime:       "h:MM:ss TT Z",
	isoDate:        "yyyy-mm-dd",
	isoTime:        "HH:MM:ss",
	isoDateTime:    "yyyy-mm-dd'T'HH:MM:ss",
	isoUtcDateTime: "UTC:yyyy-mm-dd'T'HH:MM:ss'Z'"
};

// Internationalization strings
dateFormat.i18n = {
	dayNames: [
		"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
		"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
	],
	monthNames: [
		"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
		"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
	]
};

// For convenience...
Date.prototype.format = function (mask, utc) {
	return dateFormat(this, mask, utc);
};
function timestamp2date(timestamp, format) {
  if(format == null) format = "dd-mm-yyyy";
  var theDate = new Date(timestamp);
  return theDate.format(format);
}
