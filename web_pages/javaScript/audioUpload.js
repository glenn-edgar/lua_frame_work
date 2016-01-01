/*
** File: audioUpload.js
**
**
**
**
**
**
*/




function ready()
{

new AjaxUpload("upload",{

action: "/advanced/audioUpload.html",
onSubmit: function( file, ext)
          {
             alert("file "+file+" ext "+ext);
             if( ( ext != "wav" ) && ( ext != "WAV"))
             {
                alert("expecting a .wav or .WAV format")
                return false;
             }
             return true;
          }

onComplete: function( file, response )
            {
              alert("file "+file+ " response "+response );
            }
}

}



$(document).ready( ready);