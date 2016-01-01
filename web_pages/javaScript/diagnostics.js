/*
**  File: diagnostics.js
**
**
**
**
**
**
**
**
**
*/

var inputArray;
var alarmArray;
var waveFileArray;
var textPageArray;
var audioPageArray;


function ready()
{
 
  $('#tabs').tabs();
  loadData();
if( textPageArray.length > 0 )
{
    load_select_composite_values( "textPage1", textPageArray, textPageArray[0][1])
}
if( audioPageArray.length > 0 )
{
  load_select_composite_values( "audioPage1", audioPageArray, audioPageArray[0][1])
}

if( waveFileArray.length > 0 )
{
  load_select( "waveSelect1", waveFileArray, waveFileArray[0])
}

if( inputArray.length > 0 )
{
  load_select_composite_values( "input1", inputArray, inputArray[0][1])
}
if( alarmArray.length > 0 )
{
    load_select_composite_values( "alarm1", alarmArray, alarmArray[0][1])
}
if( textPageArray.length > 0 )
{
  load_select_composite_values( "textPage2", textPageArray, textPageArray[0][1])
}
$("#textPageInput1").attr("value","Test Message")
$("#textPageInput2").attr("value","Test Message")
$("#alarm1").bind("click",function(){ $("#alarmStatus1").attr("value","") } );
$("#input1").bind("click",function(){ $("#inputStatus1").attr("value","") } );
$("#button1").bind("click",generateTextPage );
$("#button2").bind("click",generateAudioPage);
$("#button3").bind("click",setInput );
$("#button4").bind("click",clearInput);
$("#button5").bind("click",setAlarm);
$("#button6").bind("click",clearAlarm);
$("#button7").bind("click",startCoverageTest);
$("#button8").bind("click",stopCoverageTest);
$("#button9").bind("click",sendQuickLink);
$("#termId").bind("keypress",numericInput );
$("#keyId").bind("keypress",numericInput );

}











$(document).ready( ready);

function loadData()
{
  inputArray = getInputsData()
 
  alarmArray = getAlarmData()



  
  waveFileArray = getJson("/waveArray.json");

  textPageArray  = getJson("/getTextPagers.json")  

  audioPageArray  = getJson("/getAudioPagers.json")  



}


 

function generateTextPage()
{
  var pagerId;
  var textMessage;
  var returnMessage

  pagerId =     get_singleSelect( "textPage1");
  textMessage = $("#textPageInput1").attr("value");

  data = pushJason_a( "/generateTextPage.json", [ pagerId , textMessage ] )
 
}




function generateAudioPage()
{
  var pagerId;
  var waveFile;
  var data;

  pagerId = get_singleSelect("audioPage1");
  waveFile = get_singleSelect("waveSelect1");
  data = pushJason_a( "/generateAudioPage.json", [ pagerId , waveFile ] )
  
}

function setInput()
{
  var inputId;
  var data;

  inputId = get_singleSelect("input1");
  data = pushJason_a( "/clearSetInput.json", [ inputId , 1 ] )


  $("#inputStatus1").html("Input #"+inputId+" is High");
 
}

function clearInput()
{
  var inputId;
  var data;


  inputId = get_singleSelect("input1");
  data = pushJason_a( "/clearSetInput.json", [ inputId , 0 ] )
 

  $("#inputStatus1").html("Input #"+inputId+" is Low");

}


function setAlarm()
{
  var alarmId;
  var data; 

  alarmId = get_singleSelect("alarm1");
  data = pushJason_a( "/clearSetAlarm.json", [ alarmId , 1 ] )
 

  $("#alarmStatus1").html("Alarm #"+alarmId+" is High");
 
}

function clearAlarm()
{
  var alarmId;
  var data;

  alarmId = get_singleSelect("alarm1");
 

  data = pushJason_a( "/clearSetAlarm.json", [ alarmId , 0 ] )
 
  $("#alarmStatus1").html("Alarm #"+alarmId+" is Low");

}

function sendQuickLink()
{
  var termId;
  var keyId;

  termId = $("#termId").attr("value");
  keyId  = $("#keyId").attr("value"); 

  data = pushJason_a( "/quickLink.json", [ termId , keyId ] )
  

}



var timeInterval;
var coveragePageId;
var coverageTextMsg;
var coverageId;
var stopFlag;
var timerId;
var pageCnt;

function startCoverageTest()
{

  stopFlag = 0;
  pageCnt  = 0;
  coveragePagerId = get_singleSelect("textPage2");
  coverageTextMsg = $("#textPageInput2").attr("value");
  timeInterval = get_singleSelect("Repeat_Time");
  timeInterval = timeInterval * 1000; // convert to ms
  timerId =  setTimeout("coverageTimeFunction()",timeInterval);
  $("#button7").attr("disabled", "disabled");
 
}

function stopCoverageTest()
{
  clearTimeout( timerId );
  stopFlag = 1;
  $("#button7").removeAttr("disabled");
}


function coverageTimeFunction()
{
  if( stopFlag !== 0 ){ return; }
  $("#coverageStatus1").html("Sending Page");
  data = pushJason_a( "/generateTextPage.json", [ coveragePagerId , coverageTextMsg ] )
  pageCnt = pageCnt + 1;
  $("#coverageStatus1").html("Page Complete ---"+pageCnt+" Pages Sent");
  if( stopFlag == 0 )
  {
    timerId =  setTimeout("coverageTimeFunction()",timeInterval);
  }
}
