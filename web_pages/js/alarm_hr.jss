/*
**
** File: alarm_hr.js
**
**
**
**
**
**
*/


/*
**
** Top level control
**
**
**
**
**
**
*/

var currentIndex;
var Jsondata
var masterObject = {}
var nullTime = "00:00"

var backUpObject;

masterObject.number = 1
masterObject.creationTime = getGmt()
masterObject.name = "walgreens"
masterObject.alarm = 1

masterObject.Sunday = {}
masterObject.Sunday.times = new Array()
masterObject.Sunday.number = 0
masterObject.Sunday.times[0] = [ nullTime, nullTime]
masterObject.Sunday.times[1] = [ nullTime, nullTime]

masterObject.Monday = {}
masterObject.Monday.number = 0
masterObject.Monday.times = new Array()
masterObject.Monday.times[0] = [ nullTime, nullTime]
masterObject.Monday.times[1] = [ nullTime, nullTime]

masterObject.Tuesday = {}
masterObject.Tuesday.number = 0
masterObject.Tuesday.times = new Array()
masterObject.Tuesday.times[0] = [nullTime, nullTime]
masterObject.Tuesday.times[1] = [nullTime, nullTime]

masterObject.Wednesday = {}
masterObject.Wednesday.number = 0
masterObject.Wednesday.times = new Array()
masterObject.Wednesday.times[0] = [nullTime, nullTime]
masterObject.Wednesday.times[1] = [nullTime, nullTime]

masterObject.Thursday = {}
masterObject.Thursday.number = 0
masterObject.Thursday.times = new Array()
masterObject.Thursday.times[0] = [nullTime,nullTime]
masterObject.Thursday.times[1] = [nullTime,nullTime]

masterObject.Friday = {}
masterObject.Friday.number = 0
masterObject.Friday.times = new Array()
masterObject.Friday.times[0] = [nullTime,nullTime]
masterObject.Friday.times[1] = [nullTime,nullTime]

masterObject.Saturday = {}
masterObject.Saturday.number = 0 
masterObject.Saturday.times = new Array()
masterObject.Saturday.times[0] = [nullTime, nullTime]
masterObject.Saturday.times[1] = [nullTime, nullTime]



 

function toJson( temp)
{
  return JSON.stringify( temp );

}


function parseJson( temp )
{
  return JSON.parse( temp );
 
}



//stringObject.split(separator, howmany)
function getData()
{
  var data
  var lines
  data = getText( "data/alarmhrs.txd" )
  if( data != null )
  {
    lines = data.split("\n")
    if( lines[0] != null )
    {
       fields = lines[0].split("|")
       masterObject.creationTime = fields[1]
     
    }
    if( lines[2] != null )
    {
       lines[2] = trim( lines[2])
       parseDataLine( lines[2] )
    }
  }
 

}


function saveData()
{
  var saveTime;
  var textData;
  var line3;
  
  saveControls();
  textData = "null|alarmhrs.txd"+"|"+masterObject.creationTime+"|"+getGmt()+"\r\n"
  textData = textData+"\r\n"
  line3 = ""+ masterObject.number+"|"+masterObject.name+"|"+masterObject.alarm 
  line3 = line3 + packObject(masterObject.Sunday)
  line3 = line3 + packObject(masterObject.Monday)
  line3 = line3 + packObject(masterObject.Tuesday)
  line3 = line3 + packObject(masterObject.Wednesday)
  line3 = line3 + packObject(masterObject.Thursday)
  line3 = line3 + packObject(masterObject.Friday)
  line3 = line3 + packObject(masterObject.Saturday)
  line3 = line3 + "\r\n"
  textData = textData+ line3
  alert("text data =="+textData+"==");
  post( "/alarmhr.cgi",textData );

}

function resetData()
{
  masterObject =  parseJson( backUpObject );
  loadControls();
}

function ready()
{

$('#save').bind( 'click',saveData)
$('#reset').bind('click',resetData)
$("[name=radio_1]").bind('click',radio_1)
$("[name=radio_2]").bind('click',radio_2)
$("[name=radio_3]").bind('click',radio_3)
$("[name=radio_4]").bind('click',radio_4)
$("[name=radio_5]").bind('click',radio_5)
$("[name=radio_6]").bind('click',radio_6)
$("[name=radio_7]").bind('click',radio_7)

 $.mask.definitions['~']='[012]';

 $("#input_a_1").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_b_1").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_c_1").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_d_1").mask("~9:99", {completed:function(){validateTime(this);}});

   $("#input_a_2").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_b_2").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_c_2").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_d_2").mask("~9:99", {completed:function(){validateTime(this);}});

   $("#input_a_3").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_b_3").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_c_3").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_d_3").mask("~9:99", {completed:function(){validateTime(this);}});


   $("#input_a_4").mask("~9:99", {completed:function(){validateTime(this)}});
   $("#input_b_4").mask("~9:99", {completed:function(){validateTime(this)}});
   $("#input_c_4").mask("~9:99", {completed:function(){validateTime(this)}});
   $("#input_d_4").mask("~9:99", {completed:function(){validateTime(this)}});


   $("#input_a_5").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_b_5").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_c_5").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_d_5").mask("~9:99", {completed:function(){validateTime(this);}});

   $("#input_a_6").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_b_6").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_c_6").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_d_6").mask("~9:99", {completed:function(){validateTime(this);}});

   $("#input_a_7").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_b_7").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_c_7").mask("~9:99", {completed:function(){validateTime(this);}});
   $("#input_d_7").mask("~9:99", {completed:function(){validateTime(this);}});


$("#tabs").tabs();
getData()
backUpObject = toJson( masterObject );
loadControls();
}



$(document).ready( ready);

function saveControls()
{
  var name;

  masterObject.Sunday.number = checkButton( $("input[name='radio_1']"))
  masterObject.Sunday.times[0][0] = $("#input_a_1").attr("value")
  masterObject.Sunday.times[0][1] = $("#input_b_1").attr("value")
  masterObject.Sunday.times[1][0] = $("#input_c_1").attr("value")
  masterObject.Sunday.times[1][1] = $("#input_d_1").attr("value")


  masterObject.Monday.number = checkButton( $("input[name='radio_2']"))
  masterObject.Monday.times[0][0] = $("#input_a_2").attr("value")
  masterObject.Monday.times[0][1] = $("#input_b_2").attr("value")
  masterObject.Monday.times[1][0] = $("#input_c_2").attr("value")
  masterObject.Monday.times[1][1] = $("#input_d_2").attr("value")


  masterObject.Tuesday.number = checkButton( $("input[name='radio_3']"))
  masterObject.Tuesday.times[0][0] = $("#input_a_3").attr("value")
  masterObject.Tuesday.times[0][1] = $("#input_b_3").attr("value")
  masterObject.Tuesday.times[1][0] = $("#input_c_3").attr("value")
  masterObject.Tuesday.times[1][1] = $("#input_d_3").attr("value")


  masterObject.Wednesday.number = checkButton( $("input[name='radio_4']"))
  masterObject.Wednesday.times[0][0] = $("#input_a_4").attr("value")
  masterObject.Wednesday.times[0][1] = $("#input_b_4").attr("value")
  masterObject.Wednesday.times[1][0] = $("#input_c_4").attr("value")
  masterObject.Wednesday.times[1][1] = $("#input_d_4").attr("value")


  masterObject.Thursday.number = checkButton( $("input[name='radio_5']"))
  masterObject.Thursday.times[0][0] = $("#input_a_5").attr("value")
  masterObject.Thursday.times[0][1] = $("#input_b_5").attr("value")
  masterObject.Thursday.times[1][0] = $("#input_c_5").attr("value")
  masterObject.Thursday.times[1][1] = $("#input_d_5").attr("value")


  masterObject.Friday.number = checkButton( $("input[name='radio_6']"))
  masterObject.Friday.times[0][0] = $("#input_a_6").attr("value")
  masterObject.Friday.times[0][1] = $("#input_b_6").attr("value")
  masterObject.Friday.times[1][0] = $("#input_c_6").attr("value")
  masterObject.Friday.times[1][1] = $("#input_d_6").attr("value")


  masterObject.Saturday.number = checkButton( $("input[name='radio_7']"))
  masterObject.Saturday.times[0][0] = $("#input_a_7").attr("value")
  masterObject.Saturday.times[0][1] = $("#input_b_7").attr("value")
  masterObject.Saturday.times[1][0] = $("#input_c_7").attr("value")
  masterObject.Saturday.times[1][1] = $("#input_d_7").attr("value")


}


function loadControls()
{
  setButton( $("input[name='radio_1']"), masterObject.Sunday.number )
  $("input[@name='radio_1']:checked").val(masterObject.Sunday.number)
  $("#input_a_1").attr("value",masterObject.Sunday.times[0][0])
  $("#input_b_1").attr("value",masterObject.Sunday.times[0][1])
  $("#input_c_1").attr("value",masterObject.Sunday.times[1][0])
  $("#input_d_1").attr("value",masterObject.Sunday.times[1][1])

  setButton( $("input[name='radio_2']"), masterObject.Monday.number )
  $("#input_a_2").attr("value",masterObject.Monday.times[0][0])
  $("#input_b_2").attr("value",masterObject.Monday.times[0][1])
  $("#input_c_2").attr("value",masterObject.Monday.times[1][0])
  $("#input_d_2").attr("value",masterObject.Monday.times[1][1])

  setButton( $("input[name='radio_3']"), masterObject.Tuesday.number )
  $("#input_a_3").attr("value",masterObject.Tuesday.times[0][0])
  $("#input_b_3").attr("value",masterObject.Tuesday.times[0][1])
  $("#input_c_3").attr("value",masterObject.Tuesday.times[1][0])
  $("#input_d_3").attr("value",masterObject.Tuesday.times[1][1])


  setButton( $("input[name='radio_4']"), masterObject.Wednesday.number )
  $("#input_a_4").attr("value",masterObject.Wednesday.times[0][0])
  $("#input_b_4").attr("value",masterObject.Wednesday.times[0][1])
  $("#input_c_4").attr("value",masterObject.Wednesday.times[1][0])
  $("#input_d_4").attr("value",masterObject.Wednesday.times[1][1])


  setButton( $("input[name='radio_5']"), masterObject.Thursday.number )
  $("#input_a_5").attr("value",masterObject.Thursday.times[0][0])
  $("#input_b_5").attr("value",masterObject.Thursday.times[0][1])
  $("#input_c_5").attr("value",masterObject.Thursday.times[1][0])
  $("#input_d_5").attr("value",masterObject.Thursday.times[1][1])


  setButton( $("input[name='radio_6']"), masterObject.Friday.number )
  $("#input_a_6").attr("value",masterObject.Friday.times[0][0])
  $("#input_b_6").attr("value",masterObject.Friday.times[0][1])
  $("#input_c_6").attr("value",masterObject.Friday.times[1][0])
  $("#input_d_6").attr("value",masterObject.Friday.times[1][1])


  setButton( $("input[name='radio_7']"), masterObject.Saturday.number )
  $("#input_a_7").attr("value",masterObject.Saturday.times[0][0])
  $("#input_b_7").attr("value",masterObject.Saturday.times[0][1])
  $("#input_c_7").attr("value",masterObject.Saturday.times[1][0])
  $("#input_d_7").attr("value",masterObject.Saturday.times[1][1])

  radio_1()
  radio_2()
  radio_3()
  radio_4()
  radio_5()
  radio_6()
  radio_7()

}




function radio_1()
{
  var val
  var name;
  name = $("input[name='radio_1']")
  
  val = checkButton( name)
  if( val == 0 )
  {
   $("#group_a_1").hide()
   $("#group_b_1").hide()
  }
  else if( val == 1 )
  {
   $("#group_a_1").show()
   $("#group_b_1").hide()
  }
  else
  {
   $("#group_a_1").show()
   $("#group_b_1").show()
  }

}

function radio_2()
{
  var val
  var name;
  name = $("input[name='radio_2']")
  
  val = checkButton( name)
  if( val == 0 )
  {
   $("#group_a_2").hide()
   $("#group_b_2").hide()
  }
  else if( val == 1 )
  {
   $("#group_a_2").show()
   $("#group_b_2").hide()
  }
  else
  {
   $("#group_a_2").show()
   $("#group_b_2").show()
  }
}

function radio_3()
{
  var val
  var name;
  name = $("input[name='radio_3']")
  
  val = checkButton( name)
  if( val == 0 )
  {
   $("#group_a_3").hide()
   $("#group_b_3").hide()
  }
  else if( val == 1 )
  {
   $("#group_a_3").show()
   $("#group_b_3").hide()
  }
  else
  {
   $("#group_a_3").show()
   $("#group_b_3").show()
  }$.mask.definitions['~']='[+-]';
}

function radio_4()
{
  var val
  var name;
  name = $("input[name='radio_4']")
  
  val = checkButton( name)
  if( val == 0 )
  {
   $("#group_a_4").hide()
   $("#group_b_4").hide()
  }
  else if( val == 1 )
  {
   $("#group_a_4").show()
   $("#group_b_4").hide()
  }
  else
  {
   $("#group_a_4").show()
   $("#group_b_4").show()
  }
}

function radio_5()
{
  var val
  var name;
  name = $("input[name='radio_5']")
  
  val = checkButton( name)
  if( val == 0 )
  {
   $("#group_a_5").hide()
   $("#group_b_5").hide()
  }
  else if( val == 1 )
  {
   $("#group_a_5").show()
   $("#group_b_5").hide()
  }
  else
  {
   $("#group_a_5").show()
   $("#group_b_5").show()
  }
}

function radio_6()
{
  var val
  var name;
  name = $("input[name='radio_6']")
  
  val = checkButton( name)
  
  if( val == 0 )
  {
   $("#group_a_6").hide()
   $("#group_b_6").hide()
  }
  else if( val == 1 )
  {
   $("#group_a_6").show()
   $("#group_b_6").hide()
  }
  else
  {
   $("#group_a_6").show()
   $("#group_b_6").show()
  }
}

function radio_7()
{
  var val
  var name;
  name = $("input[name='radio_7']")
  
  val = checkButton( name)
 


  if( val == 0 )
  {
   $("#group_a_7").hide()
   $("#group_b_7").hide()
  }
  else if( val == 1 )
  {
   $("#group_a_7").show()
   $("#group_b_7").hide()
  }
  else
  {
   $("#group_a_7").show()
   $("#group_b_7").show()
  }
}


function checkButton( btn)
{
  var returnValue;
  var i;

  returnValue = -1;

  for( i = 0; i < btn.length; i++ )
  {
    if( btn[i].checked )
    {
        returnValue = i;
        return returnValue;
    }
 }
 return returnValue
}


function setButton( btn,i )
{
  
  if( i < btn.length )
  {
    
    btn[i].checked = true;
  }
}


function validateTime( inputVal )
{
  if( inputVal.val() > "23:59" )
  {
     alert(inputVal.val()+" is greater than 23:59 try again");
     inputVal.val(nullTime);
    
  }
}


/*

jQuery(function($){
   $("#product").mask("99/99/9999",{placeholder:" "});
});


jQuery(function($){
   $("#product").mask("99/99/9999",{completed:function(){alert("You typed the following: "+this.val());}});
});


jQuery(function($){
   $.mask.definitions['~']='[+-]';
   $("#eyescript").mask("~9.99 ~9.99 999");
});

*/

function getText( url )
{
  
  $.ajax(
  {
     url: url,
     type: 'GET',
     dataType: 'html',
     success: ajaxSuccessData,
     async: false,
     error: ajaxError_1,
    
  }); // making Jason call
  
  return Jsondata;

}

function ajaxSuccessData( data )
{
 
  Jsondata = data;
}


function ajaxSuccess( data )
{
   alert("ajax success data =="+data);
  //alert("ajax successfull transfer")
}
function ajaxError( e, xhr, settings, exception )
{
  alert("ajax error " );
  //throw("bad URL");
   
}
function ajaxError_1( e, xhr, settings, exception )
{
 // alert("ajax error " );
  //throw("bad URL");
   
}
function post( url, data )
{

 
 
  $.ajax(
  {
     url: url,
     type: 'POST',
     data: data,
     dataType: 'text',
     success: ajaxSuccess,
     async: false,
     error: ajaxError,
    
  }); // making Jason call
  
  
}
 
function GetMonth(intMonth)
{
    var MonthArray = new Array("January", "February", "March",
                               "April", "May", "June",
                               "July", "August", "September",
                               "October", "November", "December") 
    return MonthArray[intMonth] 	  	 
}
 
function getGmt()
{
   var returnValue
   var time = new Date()
   var gmtMS = time.getTime() 
              + (time.getTimezoneOffset() * 60000)
   var gmtTime =  new Date(gmtMS)
   var hr = gmtTime.getHours()
   var min = gmtTime.getMinutes()
   var sec = gmtTime.getSeconds()
   var day = gmtTime.getDate()
   var month = gmtTime.getMonth()
   var year = gmtTime.getYear()
   returnValue = " "+day +" "+ GetMonth( month)+ " "+ ( year+1900) + "  " + hr + ":" + min + ":" + sec + "  GMT "
   
   return returnValue
}

function packObject( dataObj)
{
  var returnValue
  returnValue = "|"
  if( dataObj.number == 0 )
  {
    ; // do nothing
  }
  if( dataObj.number == 1 )
  {
    returnValue = returnValue +dataObj.times[0][0] +"~"+dataObj.times[0][1]
  }
  if( dataObj.number == 2)
  {
    returnValue = returnValue + dataObj.times[0][0] +"~"+dataObj.times[0][1] +"~"+
                  dataObj.times[1][0] +"~"+dataObj.times[1][1]
  }
  return returnValue
}


function parseDataLine( dataLine )
{
  var fields
  fields = dataLine.split("|")
  if( fields.length != 10 ){ return; }
 
  parseField(fields[3],masterObject.Sunday)
  parseField(fields[4],masterObject.Monday)
  parseField(fields[5],masterObject.Tuesday)
  parseField(fields[6],masterObject.Wednesday)
  parseField(fields[7],masterObject.Thursday)
  parseField(fields[8],masterObject.Friday)
  parseField(fields[9],masterObject.Saturday)

} 


function parseField( data, object)
{
  var fields
  
  fields = data.split("~")
  
  if( fields.length == 4 )
  {
    object.number = 2
    object.times[0][0] = trim( fields[0] );
    object.times[0][1] = trim( fields[1] );
    object.times[1][0] = trim( fields[2] );
    object.times[1][1] = trim( fields[3] );
    return;
  }
  if( fields.length == 2 )
  {
    object.number = 1
    object.times[0][0] = trim( fields[0] );
    object.times[0][1] = trim( fields[1] );
    return;
  }
  object.number = 0
}
    
 


function trim(stringToTrim) {
	return stringToTrim.replace(/^\s+|\s+$/g,"");
}
function ltrim(stringToTrim) {
	return stringToTrim.replace(/^\s+/,"");
}
function rtrim(stringToTrim) {
	return stringToTrim.replace(/\s+$/,"");
}
