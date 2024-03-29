/*
 * Copyright � 1996 - 2017 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors. 
 *
 * Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG. 
*/
function validateSearchCriteria(name){
    var searchConnectionName=document.getElementById(name).value;
    if(searchConnectionName=="" || searchConnectionName == null || trim(searchConnectionName).length==0){
	alert("Please enter Filter criteria");
    }else if(specialCharacterCheck(searchConnectionName) == true){
    	form.submit();
    }
}

function specialCharacterCheck(searchConnectionName){
    var error = true;
    var iChars = "!@#$%^&()+=-[]\\\';,/{}|\"<>?";
    //var iChars = "!@#$%^&()+=-[]\\\';,./{}|\"<>?";	
    if(!searchConnectionName.match(/^\S+$/)) {
	//white space check.
	alert ("Filter criteria has special characters. \nThese are not allowed.\n Please remove them and try again.");
	error=false;
    }else{		
	for (var i = 0; i < searchConnectionName.length; i++) {
	    if (iChars.indexOf(searchConnectionName.charAt(i)) != -1) {
		alert ("Filter criteria has special characters. \nThese are not allowed.\n Please remove them and try again.");
		error=false;
		break;
	    }
	}
    }
    return error;	
}

function showFilterPanel(){
    var filtercontainer = document.getElementById("filterContainer");
    var showall = document.getElementById("showall");
    var showfew = document.getElementById("showfew");
    showall.style.display="";
    showfew.style.display="none";
    filtercontainer.style.display="";

}
function trim(a){
    return a.replace(/^\s+|\s+$|\n+$/gm, '');

}

//After submitting the form searchConnectionName,pStart and pEnd variables were not getting displayed.
function submitURL(url){
    var searchConnectionName = 	document.getElementById('searchConnectionName').value;
    if(url!=null || url.length>0){
    	if(searchConnectionName == null && trim(searchConnectionName.value).length==0){
            alert('Please enter search criteria');
        }	
    }    
    url=url+"&searchConnectionName="+searchConnectionName;
    //document.location.href=url;
    if(is_csrf_guard_enabled && needToInsertToken) {
	document.location.href=url+"&" + _csrfTokenNm_ + "=" + _csrfTokenVal_;
    } else {
	document.location.href=url;
    }
}

function submitURLFromSubFrame(url){
	
    var searchConnectionName = 	window.parent.document.getElementById('searchConnectionName').value;
    if(url!=null || url.length>0){
    	if(searchConnectionName == null && trim(searchConnectionName.value).length==0){
            alert('Please enter search criteria');
        }	
    }    
    url=url+"&searchConnectionName="+searchConnectionName;
    //document.location.href=url;
    if(is_csrf_guard_enabled && needToInsertToken) {
	window.parent.document.location.href=url+"&" + _csrfTokenNm_ + "=" + _csrfTokenVal_;
    } else {
	window.parent.document.location.href=url;
    }
}

function appendSecurityTokenIfCSRFEnabled() {
    if( typeof is_csrf_guard_enabled == "undefined") {
	return "";
    }
    if(is_csrf_guard_enabled && needToInsertToken) {
	return ('&' + _csrfTokenNm_ + '=' + _csrfTokenVal_);
    } else {
	return "";
    }
}

function showHideFilterCriteria(name) 
{
    var filtercontainer = document.getElementById("filterContainer");
    var searchConnectionName=document.getElementById(name);            	               	    	 
    var showall = document.getElementById("showall");
    var showfew = document.getElementById("showfew");                  
    if(searchConnectionName!=null && searchConnectionName.value!="" && searchConnectionName.value!=undefined && searchConnectionName.value.length > 0){                                       
        showall.style.display="";
        showfew.style.display="none";
        filtercontainer.style.display="";
        //In order to encode the value so that %3A won't get displayed in case of :
        document.getElementById(name).value=unescape(searchConnectionName.value);
    }
} 

function showHidePageCriteria(){
    var pgContain = document.getElementById("paginationContainer");
    var goContain = document.getElementById("goContainer");
    goContain.style.display="";
    pgContain.style.display="none";
}

function jumpToPage(comand){
    var pgNumber=comand.previousSibling.previousSibling.value;
    var pageSize=document.form.pageSize.value;
    if(pgNumber>eval(pageSize)){
	alert('Please specify page number less or equal to '+pageSize+'.');
	return false;
    }else{	
	document.form.submit();
	return true;		
    }			

} 
function isNumberKey(myForm,evt)
{
    var charCode = (evt.which) ? evt.which : event.keyCode;     
    if(charCode == 13) { 
        myForm.Go.click();
        return false;
    }
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
}

function processKey(e)
{
    if (null == e)
        e = window.event ;
    if (e.keyCode == 13)  {
        document.getElementById("submitButton").click();
        return false;
    }
}
