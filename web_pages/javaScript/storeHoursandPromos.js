/*
**
** File: input_page.js
**
**
**
**
**
**
**
*/

var currentIndex;
var masterObject = {}

$(function(){

// Tabs
var tabOpts = 
{
   show: showFunction
};
$('#tabs').tabs( tabOpts );

});
		

function getData()
{
  
  
  masterObject.inputs    = new Array();
  masterObject.inputs[0]   = getStoreHours();
  masterObject.inputs[1]    = getAnswerSets();
  masterObject.inputs[2]    = getHolidayHours();
  masterObject.inputs[3]    = getPromos();
  
  masterObject.backup       = toJson( masterObject.inputs );
 

}

function saveData()
{
  saveStoreHours();
  saveHolidayHours();
  savePromos();
  saveAnswerSets();
}

function showFunction( event, tab)
{
   var temp;
   currentIndex = tab.index;
   if( masterObject.init[ tab.index] == 0 )
   {
     masterObject.init[tab.index] = 1;
    
   }
   initLocalControls( tab.index  );
   registerControlButtons( tab.index );

   drawLines( tab.index ); 
   temp = "#edit-"+tab.index;
   $(temp).hide();

}

function ready()
{

  masterObject = {}
  masterObject.init  =  [0,0,0];
  masterObject.initFunctions     = [ initStoreHrs  , initAnswerSets,  initPromos,initHolidayHrs ]
  masterObject.loadControl    = [ loadStoreHrs, loadAnswerSets, loadPromos, loadHolidayHrs  ];
  masterObject.loadCreate     =  [ createStoreHrs,  createAnswerSets,  createPromos,createHolidayHrs ];
  masterObject.saveData       = [ saveStoreHrs, saveAnswerSets,  savePromos,saveHolidayHrs ];

  masterObject.drawLines = [ drawStoreHrs,drawAnswerSets,  drawPromos,drawHolidayHrs ] 
  getData();
  $("#reset").bind("click",resetData);
  $("#save").bind("click",saveData);


}





$(document).ready( ready);


function getCurrentTab()
{
 
  return currentIndex;
}

