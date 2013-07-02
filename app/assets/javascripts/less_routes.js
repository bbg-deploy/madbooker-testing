function less_json_eval(json){return eval('(' +  json + ')')}  

function jq_defined(){return typeof(jQuery) != "undefined"}

function less_get_params(obj){
 
if (jq_defined()) { return obj }
if (obj == null) {return '';}
return less_params_to_string(obj);
}

function less_params_to_string(obj){
  var s = [];
  for (prop in obj){
  s.push(prop + "=" + obj[prop]);
  }
  return s.join('&') + '';
}

function less_params_to_query(obj){
  s = less_params_to_string(obj);
  if (s.length > 0) {
    return "?" + s
  }
  else {
    return "";
  }
}

function less_merge_objects(a, b){
 
if (b == null) {return a;}
z = new Object;
for (prop in a){z[prop] = a[prop]}
for (prop in b){z[prop] = b[prop]}
return z;
}

function less_ajax(url, verb, params, options){
 
if (verb == undefined) {verb = 'get';}
if (options == undefined) {options = {}};
var done = function(r){eval(r.responseText)};
var error = function(r, status, error_thrown){alert(status + ": " + error_thrown)}
if (jq_defined()){
v = verb.toLowerCase() == 'get' ? 'GET' : 'POST'
if (verb.toLowerCase() == 'get' || verb.toLowerCase() == 'post'){p = less_get_params(params);}
else{p = less_get_params(less_merge_objects({'_method': verb.toLowerCase()}, params))} 
 
 
if (options['success'] == undefined && options['complete'] == undefined) {options['success'] = done}
if (options['error'] == undefined) {options['error'] = error;}

jQuery.ajax(less_merge_objects({ url: url, type: v, data: p}, options));
} else {  
if (options['onSuccess'] == undefined && options['onComplete'] == undefined) {options['onComplete'] = done}
if (options['onFailure'] == undefined) {options['onFailure'] = error;}
new Ajax.Request(url, less_merge_objects({method: verb, parameters: less_get_params(params)}, options));
}
}
function less_check_parameter(param) {
if (param === undefined) {
param = '';
}
return param;
}
function less_check_format(param) {
if (param === undefined || param == '' || param == null) {
return '';
} else {
return '.'+ param;
}
}
function booking_path(id, format, params){ var _id = less_check_parameter(id);var _format = less_check_format(format);return '/bookings' + '/' + _id + _format +  less_params_to_query(params)}
function booking_ajax(id, format, verb, params, options){ var _id = less_check_parameter(id);var _format = less_check_format(format);return less_ajax('/bookings' + '/' + _id + _format, verb, params, options)}
function check_in_hotel_booking_path(hotel_id, id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + '/check_in' + _format +  less_params_to_query(params)}
function check_in_hotel_booking_ajax(hotel_id, id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + '/check_in' + _format, verb, params, options)}
function check_out_hotel_booking_path(hotel_id, id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + '/check_out' + _format +  less_params_to_query(params)}
function check_out_hotel_booking_ajax(hotel_id, id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + '/check_out' + _format, verb, params, options)}
function cancel_hotel_booking_path(hotel_id, id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + '/cancel' + _format +  less_params_to_query(params)}
function cancel_hotel_booking_ajax(hotel_id, id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + '/cancel' + _format, verb, params, options)}
function open_hotel_booking_path(hotel_id, id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + '/open' + _format +  less_params_to_query(params)}
function open_hotel_booking_ajax(hotel_id, id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + '/open' + _format, verb, params, options)}
function no_show_hotel_booking_path(hotel_id, id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + '/no_show' + _format +  less_params_to_query(params)}
function no_show_hotel_booking_ajax(hotel_id, id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + '/no_show' + _format, verb, params, options)}
function pay_hotel_booking_path(hotel_id, id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + '/pay' + _format +  less_params_to_query(params)}
function pay_hotel_booking_ajax(hotel_id, id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + '/pay' + _format, verb, params, options)}
function hotel_bookings_path(hotel_id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/bookings' + _format +  less_params_to_query(params)}
function hotel_bookings_ajax(hotel_id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/bookings' + _format, verb, params, options)}
function new_hotel_booking_path(hotel_id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/bookings' + '/new' + _format +  less_params_to_query(params)}
function new_hotel_booking_ajax(hotel_id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/bookings' + '/new' + _format, verb, params, options)}
function edit_hotel_booking_path(hotel_id, id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + '/edit' + _format +  less_params_to_query(params)}
function edit_hotel_booking_ajax(hotel_id, id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + '/edit' + _format, verb, params, options)}
function hotel_booking_path(hotel_id, id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + _format +  less_params_to_query(params)}
function hotel_booking_ajax(hotel_id, id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/bookings' + '/' + _id + _format, verb, params, options)}
function hotel_check_ins_path(hotel_id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/check_ins' + _format +  less_params_to_query(params)}
function hotel_check_ins_ajax(hotel_id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/check_ins' + _format, verb, params, options)}
function new_hotel_check_in_path(hotel_id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/check_ins' + '/new' + _format +  less_params_to_query(params)}
function new_hotel_check_in_ajax(hotel_id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/check_ins' + '/new' + _format, verb, params, options)}
function edit_hotel_check_in_path(hotel_id, id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/check_ins' + '/' + _id + '/edit' + _format +  less_params_to_query(params)}
function edit_hotel_check_in_ajax(hotel_id, id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/check_ins' + '/' + _id + '/edit' + _format, verb, params, options)}
function hotel_check_in_path(hotel_id, id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/check_ins' + '/' + _id + _format +  less_params_to_query(params)}
function hotel_check_in_ajax(hotel_id, id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/check_ins' + '/' + _id + _format, verb, params, options)}
function form_hotel_inventories_path(hotel_id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/inventories' + '/form' + _format +  less_params_to_query(params)}
function form_hotel_inventories_ajax(hotel_id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/inventories' + '/form' + _format, verb, params, options)}
function for_month_hotel_inventories_path(hotel_id, year, month, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _year = less_check_parameter(year);var _month = less_check_parameter(month);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/inventories' + '/' + _year + '/' + _month + _format +  less_params_to_query(params)}
function for_month_hotel_inventories_ajax(hotel_id, year, month, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _year = less_check_parameter(year);var _month = less_check_parameter(month);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/inventories' + '/' + _year + '/' + _month + _format, verb, params, options)}
function for_year_hotel_inventories_path(hotel_id, year, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _year = less_check_parameter(year);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/inventories' + '/' + _year + _format +  less_params_to_query(params)}
function for_year_hotel_inventories_ajax(hotel_id, year, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _year = less_check_parameter(year);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/inventories' + '/' + _year + _format, verb, params, options)}
function hotel_inventories_path(hotel_id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/inventories' + _format +  less_params_to_query(params)}
function hotel_inventories_ajax(hotel_id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/inventories' + _format, verb, params, options)}
function new_hotel_inventory_path(hotel_id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/inventories' + '/new' + _format +  less_params_to_query(params)}
function new_hotel_inventory_ajax(hotel_id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/inventories' + '/new' + _format, verb, params, options)}
function edit_hotel_inventory_path(hotel_id, id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/inventories' + '/' + _id + '/edit' + _format +  less_params_to_query(params)}
function edit_hotel_inventory_ajax(hotel_id, id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/inventories' + '/' + _id + '/edit' + _format, verb, params, options)}
function hotel_inventory_path(hotel_id, id, format, params){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return '/hotels' + '/' + _hotel_id + '/inventories' + '/' + _id + _format +  less_params_to_query(params)}
function hotel_inventory_ajax(hotel_id, id, format, verb, params, options){ var _hotel_id = less_check_parameter(hotel_id);var _id = less_check_parameter(id);var _format = less_check_format(format);return less_ajax('/hotels' + '/' + _hotel_id + '/inventories' + '/' + _id + _format, verb, params, options)}
