/*
**
**
** File: AudioFiles.html
**
**
**
**
**
*/





var currentIndex;
var masterObject = {}

	

function getData()
{
  
  
  masterObject.inputs            = new Array();

  masterObject.inputs[0]         = loadAudioData();
  masterObject.backup            = toJson( masterObject.inputs );
 

}





function ready()
{

  
  getData();
  showFunction();
  $("#TOP_CH-0").bind("click",MasterCheck);
  $("#delete-0").bind("click",deleteButton);
  $("#refresh-0").bind("click",refreshButton);
  new AjaxUpload("upload",
   {

   action: "/advanced/audioUpload.html",
   onSubmit: function( file, ext)
          {
            
             if( ( ext != "wav" ) && ( ext != "WAV"))
             {
                alert("expecting a .wav or .WAV format")
                return false;
             }
             return true;
          },

  onComplete: function( file, response )
            {
              alert("Upload Result for  "+file+ " "+response );
            }
  });


}


$(function(){$('#tabs').tabs();});
$(document).ready( ready);






function showFunction( )
{
   var temp;
   currentIndex = 0;

   drawLines( currentIndex ); 
  // bind to delete button delete function
}




function  drawLines(  index )
{ 
   var i
   var tempData;
   var tempTable;
   var tempString;

   tempTable = "#table-"+index;

   $(tempTable).find("tr:gt(0)").remove()
 
   tempData = masterObject.inputs[index];
   if( tempData === null) { return;}
   for( i = 0; i <= tempData.length ;i++)
   {
      if( tempData[i] != null )
      {
         tempString = drawButtons2( index, i);
         tempString = tempString + "<td>"+tempData[i]+"</td><td></td>"
         tempString = tempString +   ' </tr> '
         $(tempTable).append(tempString)
         addFunctions(index, i);
      }
   }
   stripTable(tempTable);
}


function stripTable(table)
{
  $(table+' tr:eq(0)').addClass('header')
  $(table+' tbody tr:odd').addClass('odd')
  $(table+' tbody tr:even').addClass('even')
}


function drawButtons2( index, number )
{
  var temp;

  temp = '<tr align= center id ="tr'+ number+'" >';
  temp = temp + ' <td> ';
  temp = temp + ' <input type="checkbox"   id="CH'+index+"_"+number+'" >';
  temp = temp +  ' </td>  ';
  temp = temp +   ' <td align=right>  ';
  temp = temp +   ' <button id= "DEL'+index+"_"+number+'"  type = "button" style="font-family:Arial;font-size:10pt;padding-bottom:1px">Delete</button>'
  temp = temp +    '</td> '
  temp = temp +    '<td align=left> '
  temp = temp +    '<button id = "PLAY'+index+"_"+number+'"  type = "button" style="font-family:Arial;font-size:10pt;padding-bottom:1px">Play</button>'
  temp = temp +    '</td>' 
  return temp
}


function addFunctions( index, number )
{
  var answer;
  
  $('#DEL'+index+"_"+number).bind( 'click',
   function( )
   {  
     answer = confirm("delete wave file "+ masterObject.inputs[index][number]);
     if(answer)
     {
        deleteObject( "/audio/"+masterObject.inputs[index][number] )
        masterObject.inputs[index][number] = null;
        // make ajax call to delete object
        drawLines(  index );
     }
   }
  );
  $('#PLAY'+index+"_"+number).bind( 'click', 

     function(  ) 
     { 
       
       window.open("/audio/"+masterObject.inputs[index][number] )
      }

      );
}

function loadAudioData()
{
   temp = getJson("/waveArray.json");
   return temp;
}

function MasterCheck()
{
   var i;
   
   var tempData;
   var maxNumber;
   var state;

 
   tempData = masterObject.inputs[0];
   maxNumber = tempData.length;
  
   state = $("#TOP_CH-0").attr("checked");

   for( i = 0; i < maxNumber; i++ )
   {
    
     if( state === true )
     {
  
        $('#CH0'+"_"+i).attr("checked",true);
    
     }
     else
     {
        $('#CH0'+"_"+i).attr("checked",false);
    
 
     }
   }

}

function refreshButton()
{
  $("#table-0").find("tr:gt(0)").remove()
  getData();
  showFunction();
}


function deleteButton()
{
  var i;

  var maxNumber;
  var tempData;
  var answer;

  answer = confirm("Delete selected audio file(s) ?");
  if( answer )
  {
    
     tempData = masterObject.inputs[0];
     maxNumber = tempData.length;
     for( i = 0; i < maxNumber; i++ )
     {
         if( $('#CH0'+"_"+i).attr("checked") == true )
         {   
             // make ajax call to delete wave file
             tempData[i] = null;
          }
      }
      drawLines( 0 );
  }
  $("#TOP_CH-0").attr("checked",false);
}
