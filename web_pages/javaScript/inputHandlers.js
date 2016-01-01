/*
**
** Form inputHandlers.js
** Handles various input handlers based upon key stroke
**
**
**
*/


/*
** Function to 
**
**
**
*/

function numericInput( event)
{
  
  if( event.which && (event.which < 48 || event.which > 57 ) &&( event.which != 8) )
  {
    event.preventDefault();
  }
}

function networkInput(event)
{
  
  if( event.which && (event.which < 48 || event.which > 57 ) &&( event.which != 8) )
  {
    if( event.which != 46 ) // allow . to pass
    {
      event.preventDefault();
    }
  }
}