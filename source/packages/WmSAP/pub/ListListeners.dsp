%comment%----- Lists Listeners -----%endcomment%

<html>
    <head>
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
        <meta http-equiv="Expires" CONTENT="-1">
        <title>Listeners</title>
		<Link REL="stylesheet" TYPE="text/css" HREF="../WmART/webMethods.css"></LINK>
        <link rel="stylesheet" TYPE="text/css" HREF="../WmRoot/webMethods.css"></link>
		
        <style type="text/css">
        <!--
	.messageline {
	    font-family: "Courier", "Courier New";
	    padding: 5px;
	    font-size: 80%;
	    font-weight: normal;
	    background-color: #FFF0F5;
	    color: #C60829;
	    text-align: left;
	    letter-spacing: 0px;
	    border: 1px solid #C60829;
	}
        -->
        </style>
        %ifvar lt8%%else%<script src="/WmART/connectionfilter.js"></script>%endif%
        <SCRIPT LANGUAGE="JavaScript">
       function doSelect(action,aliasName,numConfiguredNotifs,numEnabledNotifs)
	{

           var s1 = null;
           if((action =='enableListener') || (action =='resumeListener'))
           {
              if(checkNotificationStatus(aliasName, numConfiguredNotifs, numEnabledNotifs))
              {
                 return action;
              }
              else
              {
                 return false;
              }
           } 
           else if(action =='disableListener')
           {
              s1 = "OK to disable the `"+aliasName+"' Listener?\n\n";
           } 
           else if(action =='suspendListener')
           {
              s1 = "OK to suspend operations for the `"+aliasName+"' Listener?\n\n";
           } 
           else if(action =='forceListener')
           {
              s1 = "OK to force the `"+aliasName+"' Listener to disabled status?\n\n";
           } 

           if(s1 == null)
           {
              alert("Script Error!");
              return false;
           }
           else
           {
              if(confirm (s1))
              {
                 return(action);
              }
              else
              {
                 return false;
              }
           }
        }

        function checkNotificationStatus (aliasName, numConfiguredNotifs, numEnabledNotifs)
        {

            var s1 = "OK to enable the `" + aliasName + "' Listener?\n\n";

            if (numConfiguredNotifs == '0')
            {
                s1 = "There are no notifications defined for the `" + aliasName + "' Listener.\n\n" +
                  "OK to enable the `" + aliasName + "' Listener anyway?\n\n";
            }
            else if ( numEnabledNotifs == '0')
            {
                s1 = "All of the notifications defined for the `" + aliasName + "' \nListener are disabled.\n\n" +
                  "OK to enable the `" + aliasName + "' Listener anyway?\n\n";
            }

            return confirm(s1);
        }

            function confirmDelete (aliasName)
            {
                var s1 = "OK to delete the `" + aliasName + "' Listener?\n\n";
                return confirm (s1);
            }
			
			function appendSecurityTokenIfCSRFEnabled()
			{
				if( typeof is_csrf_guard_enabled == "undefined") {
					return "";
				}

				if( is_csrf_guard_enabled && needToInsertToken) {
					return( '&'+_csrfTokenNm_ + '=' + _csrfTokenVal_);
				} else {
					return "";
				}
			}
			
        </SCRIPT>

        <SCRIPT SRC="/WmRoot/webMethods.js"></SCRIPT>
		<script type="text/javascript" src="/WmART/csrfGuard.js"></script>
    </head>

    %invoke wm.art.admin:getAdapterTypeOnlineHelp%
    %onerror%
    %endinvoke%

    %invoke wm.art.admin:retrieveAdapterTypeData%
    %onerror%
    %endinvoke%

    <body onLoad="setNavigation('ListListeners.dsp', '%value encode(javascript) helpsys%', 'foo');%ifvar lt8%%else%showHideFilterCriteria('searchListenerName');%endif%">
        %ifvar lt8%%else%<form name="form" action="ListListeners.dsp" method="POST">%endif%
        <table width="100%">
            <tr>
       	        <td class="breadcrumb" colspan=8>Adapters &gt; %value displayName% &gt; Listeners</td>
            </tr>

            %comment%
            -- If we arrive at this page because of an enable/disable request, or an edit save, the
            -- action field will be set, we perform the requested action before refreshing the page.
            %endcomment%

            %switch action%
                %case 'enableListener'%
                    %invoke wm.art.admin:setListenerStatus%
                    %onerror%
                        <tr><td class="message" colspan=8><pre>
                            %ifvar localizedMessage%
                                %value localizedMessage%
                            %else%
                                %value errorMessage%
                            %endif%
                        </pre></td></tr>
                    %endinvoke%

                %case 'disableListener'%
                    %invoke wm.art.admin:setListenerStatus%
                    %onerror%
                        <tr><td class="message" colspan=8><pre>
                            %ifvar localizedMessage%
                                %value localizedMessage%
                            %else%
                                %value errorMessage%
                            %endif%
                        </pre></td></tr>
                    %endinvoke%
                %case 'suspendListener'%
                    %invoke wm.art.admin:setListenerStatus%
                    %onerror%
                        <tr><td class="message" colspan=8><pre>
                            %ifvar localizedMessage%
                                %value localizedMessage%
                            %else%
                                %value errorMessage%
                            %endif%
                        </pre></td></tr>
                    %endinvoke%
                %case 'resumeListener'%
                    %invoke wm.art.admin:setListenerStatus%
                    %onerror%
                        <tr><td class="message" colspan=8><pre>
                            %ifvar localizedMessage%
                                %value localizedMessage%
                            %else%
                                %value errorMessage%
                            %endif%
                        </pre></td></tr>
                    %endinvoke%



                %case 'editListener'%
                    %invoke wm.art.admin:updateListener%
                    %onerror%
                        %ifvar localizedMessage%
                            %comment%-- Localized error message supplied --%endcomment%
                            <tr><td class="message" colspan=8>Error encountered <pre>%value localizedMessage%</pre></td></tr>
                        %else%
                            %ifvar error%
                                <tr><td class="message" colspan=8>Error encountered <pre>%value errorMessage%</pre></td></tr>
                            %endif%
                        %endif%
                    %endinvoke%

                %case 'forceListener'%
                    %invoke wm.art.admin:setListenerStatus%
                    %onerror%
                        <tr><td class="message" colspan=8><pre>
                            %ifvar localizedMessage%
                                %value localizedMessage%
                            %else%
                                %value errorMessage%
                            %endif%
                        </pre></td></tr>
                    %endinvoke%

                %case 'saveListener'%
                    %invoke wm.art.admin:saveListener%
                    %onerror%
                        %ifvar localizedMessage%
                            <tr><td class="message" colspan=8>Error encountered <pre>%value localizedMessage%</pre></td></tr>
                        %else%
                            %ifvar error%
                                <tr><td class="message" colspan=8>Error encountered <pre>%value errorMessage%</pre></td></tr>
                            %endif%
                        %endif%
                    %endinvoke%

                %case 'deleteListener'%
                    %invoke wm.art.admin:deleteListener%
                    %onerror%
                        %ifvar localizedMessage%
                            <tr><td class="message" colspan=8>Error encountered <pre>%value localizedMessage%</pre></td></tr>
                        %else%
                            %ifvar error%
                                <tr><td class="message" colspan=8>Error encountered <pre>%value errorMessage%</pre></td></tr>
                            %endif%
                        %endif%
                    %endinvoke%
                %case 'suspendAllEnabled'%
                    %invoke wm.art.admin:suspendAllListeners%
                        %onerror%
                            <TR><TD class="message" colspan=5>
                                <PRE>
                                    %ifvar localizedMessage% 
                                        %value localizedMessage%
                                    %else% 
                                        %value errorMessage%
                                    %endif%
                                </PRE>
                            </TD></TR>
                    %endinvoke%
                %case 'enableAllSuspended'%
                    %invoke wm.art.admin:resumeAllListeners%
                        %onerror%
                            <TR><TD class="message" colspan=5>
                                <PRE>
                                    %ifvar localizedMessage% 
                                        %value localizedMessage%
                                    %else% 
                                        %value errorMessage%
                                    %endif%
                                </PRE>
                            </TD></TR>
                        %endinvoke%
                %case%
                    %comment% nothing -- no action %endcomment%
            %endswitch%

            %comment% not showing the last error message any more.
	      %invoke wm.sap.Admin:listListeners%
                %ifvar listenerDataList -notempty%
                    %loop listenerDataList%
                        %ifvar lastError%
                            %ifvar lastError equals('')%
                                %comment% nothing %endcomment%
                            %else%
                                <tr><td class="message" colspan=8>%value listenerNodeName%: %value lastError%</td></tr>
                            %endif%
                        %endif%
                    %endloop%
                %endif%
            %endinvoke%
            %endcomment%

            <tr>
                <td colspan=2>
                    <ul>
                        <li>
                            %invoke wm.art.admin.connection:listResources%
                                %ifvar connDataNode%
                                    <a id="Configure_new_listener" href="ListAdapterListenerTypes.dsp?%ifvar lt8%lt8=true&amp;%endif%adapterTypeName=%value -urlencode adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&dspName=.LISTLISTENERTYPES">
                                        Configure new listener
                                    </a>
									<script>updateURL("Configure_new_listener", "Configure new listener");</script>
                                %else%
                                    Configure new listener (Cannot create listeners without connections)
                                %endif%
                            %endinvoke%
                        </li>
                        <li>
				            <a id="Suspend_all_enabled" href="ListListeners.dsp?%ifvar lt8%lt8=true&amp;%endif%adapterTypeName=%value -urlencode adapterTypeName%&action=suspendAllEnabled">
            				    Suspend all enabled</a>
								<script>updateURL("Suspend_all_enabled", "Suspend all enabled");</script>
                         </li>
                         <li>
                             <a id="Enable_all_suspended" href="ListListeners.dsp?%ifvar lt8%lt8=true&amp;%endif%adapterTypeName=%value -urlencode adapterTypeName%&action=enableAllSuspended">
                                 Enable all suspended</a>
								 <script>updateURL("Enable_all_suspended", "Enable all suspended");</script>
                         </li>
                         %ifvar lt8%%else%<li id="showfew" name="showfew"><a href="javascript:showFilterPanel(true)">Filter Listeners</a></li>
                	 <li style="display:none" id="showall" name="showall"><a id="Show_All_Listeners" href="ListListeners.dsp?adapterTypeName=%value -urlencode adapterTypeName%&dspName=.LISTLISTENERS">Show All Listeners</a>
					 <script>updateURL("Show_All_Listeners", "Show All Listeners");</script>
					 </li>
                	 <DIV id="filterContainer" name="filterContainer" style="display:none;padding-top=2mm;">
			 	<br>
			 		<table>
			 		<tr valign="top">
			 		<td>
						<span>Filter criteria</span><br>
						<input id="searchListenerName" name="searchListenerName" value="%value -urldecode searchListenerName%" onkeydown="return processKey(event)" />
			 		</td>
			 		<td>
			 			<br>
			 				<input id="submitButton" name="Submit" type="submit" value="Submit" width="15" height="15" onClick="validateSearchCriteria('searchListenerName');return false;"/>                                        
			 			</br>
			 		</td> 
			 		</tr>
			 		</table>
			 	</br>  
                	</DIV>%endif%
                    </ul>
                </td>
            </tr>
        <tr>
                    %comment% Get list of listeners that match our type %endcomment%
	
            %invoke wm.sap.Admin:listListeners%
        <td colspan=8 align="right">
        	<label style="color:#666666;font-weight:bold;text-align:inherit;">%value pageLabel%</label>
        </td>
		</tr>
            
		<tr>
			<td>
				<table class="tableView" width="100%">
				<tbody>
			<tr>		
                <td class="heading" colspan=8>%value displayName% Listeners</td>
            </tr>

            <tr class="subheading2">
                <td class="oddcol-l">Listener Name%ifvar lt8%%else%<a id="ascLN" href="ListListeners.dsp?adapterTypeName=%value -urlencode adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&sort=LN&dspName=.LISTLISTENERS"><img border="0" style="float: middle" src="/WmART/images/arrow_up.gif" width="15" height="15"></a>
				<script>updateURL("ascLN", '<img border="0" src="/WmART/images/arrow_up.gif" width="15" height="15">');</script>
            		<a id="desLN" href="ListListeners.dsp?adapterTypeName=%value -urlencode adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&sort=LN&DES=true&dspName=.LISTLISTENERS"><img border="0" src="/WmART/images/arrow_down.gif" style="float: middle" width="15" height="16"></a>
					<script>updateURL("desLN", '<img border="0" src="/WmART/images/arrow_down.gif" style="float: middle" width="15" height="16">');</script>
					%endif%</td>
                <td class="oddcol-l">Package Name%ifvar lt8%%else%<a id="ascPN" href="ListListeners.dsp?adapterTypeName=%value -urlencode adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&sort=PN&dspName=.LISTLISTENERS"><img border="0" style="float: middle" src="/WmART/images/arrow_up.gif" width="15" height="15"></a>
				<script>updateURL("ascPN", '<img border="0" src="/WmART/images/arrow_up.gif" width="15" height="15">');</script>
            		<a id="desPN" href="ListListeners.dsp?adapterTypeName=%value -urlencode adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&sort=PN&DES=true&dspName=.LISTLISTENERS"><img border="0" src="/WmART/images/arrow_down.gif" style="float: middle" width="15" height="16"></a>
					<script>updateURL("desPN", '<img border="0" src="/WmART/images/arrow_down.gif" style="float: middle" width="15" height="16">');</script>
					%endif%</td>
                <td class="oddcol">State%ifvar lt8%%else%<a id="ascState" href="ListListeners.dsp?adapterTypeName=%value -urlencode adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&sort=State&dspName=.LISTLISTENERS"><img border="0" style="float: middle" src="/WmART/images/arrow_up.gif" width="15" height="15"></a>
				<script>updateURL("ascState", '<img border="0" src="/WmART/images/arrow_up.gif" width="15" height="15">');</script>
            		<a id="desState" href="ListListeners.dsp?adapterTypeName=%value -urlencode adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&sort=State&DES=true&dspName=.LISTLISTENERS"><img border="0" src="/WmART/images/arrow_down.gif" style="float: middle" width="15" height="16"></a>
					<script>updateURL("desState", '<img border="0" src="/WmART/images/arrow_down.gif" style="float: middle" width="15" height="16">');</script>
					%endif%</td>
                <td class="oddcol">Status</td>
                <td class="oddcol">Edit</td>
                <td class="oddcol">View</td>
                <td class="oddcol">Copy</td>
                <td class="oddcol">Delete</td>
            </tr>


                %ifvar listenerDataList -notempty%
                    %loop listenerDataList%
                        <tr>
                            <script>writeTD('rowdata-l');</script>%value listenerNodeName%</td>
                            <script>writeTD('rowdata-l');</script>%value packageName%</td>

                            <script>writeTD('rowdata');</script>
                                %switch listenerEnabled%
                                %case 'enabled'%
                                	<SELECT ONCHANGE="window.location.href='ListListeners.dsp?%ifvar ../lt8%lt8=true&amp;%endif%listenerNodeName=%value -urlencode listenerNodeName%&searchListenerName=%value -urlencode searchListenerName%&adapterTypeName=%value -urlencode ../adapterTypeName%&action='+ 
                                            doSelect(this.value,'%value listenerNodeName%', '%value numConfiguredNotifs%', '%value numEnabledNotifs%') + 
											appendSecurityTokenIfCSRFEnabled();" >
                                        <OPTION SELECTED VALUE=none>Enabled</OPTION>
              	                        <OPTION VALUE=disableListener>Disabled</OPTION>
                                        <OPTION VALUE=suspendListener>Suspended</OPTION>
	                                </SELECT>
                                %case 'enablePending'%
                                	<SELECT ONCHANGE="window.location.href='ListListeners.dsp?%ifvar ../lt8%lt8=true&amp;%endif%listenerNodeName=%value -urlencode listenerNodeName%&searchListenerName=%value -urlencode searchListenerName%&adapterTypeName=%value -urlencode ../adapterTypeName%&action='+ 
                                            doSelect(this.value,'%value listenerNodeName%', '%value numConfiguredNotifs%', '%value numEnabledNotifs%') + 
											appendSecurityTokenIfCSRFEnabled();" >
                                        <OPTION SELECTED VALUE=none>Pending enabled</OPTION>
              	                        <OPTION VALUE=disableListener>Disabled</OPTION>
                                        <OPTION VALUE=suspendListener>Suspended</OPTION>
	                                </SELECT>
                                %case 'disabled'%
                                	<SELECT ONCHANGE="window.location.href='ListListeners.dsp?%ifvar ../lt8%lt8=true&amp;%endif%listenerNodeName=%value -urlencode listenerNodeName%&searchListenerName=%value -urlencode searchListenerName%&adapterTypeName=%value -urlencode ../adapterTypeName%&action='+ 
                                            doSelect(this.value,'%value listenerNodeName%', '%value numConfiguredNotifs%', '%value numEnabledNotifs%') +
											appendSecurityTokenIfCSRFEnabled() ;" >
                                        <OPTION SELECTED VALUE=none>Disabled</OPTION>
              	                        <OPTION VALUE=enableListener>Enabled</OPTION>
	                                </SELECT>
                                %case 'disablePending'%
                                	<SELECT ONCHANGE="window.location.href='ListListeners.dsp?%ifvar ../lt8%lt8=true&amp;%endif%listenerNodeName=%value -urlencode listenerNodeName%&searchListenerName=%value -urlencode searchListenerName%&adapterTypeName=%value -urlencode ../adapterTypeName%&action='+ 
                                            doSelect(this.value,'%value listenerNodeName%', '%value numConfiguredNotifs%', '%value numEnabledNotifs%') + 
											appendSecurityTokenIfCSRFEnabled() ;" >
                                        <OPTION SELECTED VALUE=none>Pending disabled</OPTION>
              	                        <OPTION VALUE=forceListener>Disabled</OPTION>
	                                </SELECT>
                                %case 'suspended'%
                                	<SELECT ONCHANGE="window.location.href='ListListeners.dsp?%ifvar ../lt8%lt8=true&amp;%endif%listenerNodeName=%value -urlencode listenerNodeName%&searchListenerName=%value -urlencode searchListenerName%&adapterTypeName=%value -urlencode ../adapterTypeName%&action='+ 
                                            doSelect(this.value,'%value listenerNodeName%', '%value numConfiguredNotifs%', '%value numEnabledNotifs%') + 
											appendSecurityTokenIfCSRFEnabled();" >
                                        <OPTION SELECTED VALUE=none>Suspended</OPTION>
                                        <OPTION VALUE=disableListener>Disabled</OPTION>
              	                        <OPTION VALUE=resumeListener>Enabled</OPTION>
	                                </SELECT>
                                %case 'suspendPending'%
                                	<SELECT ONCHANGE="window.location.href='ListListeners.dsp?%ifvar ../lt8%lt8=true&amp;%endif%listenerNodeName=%value -urlencode listenerNodeName%&searchListenerName=%value -urlencode searchListenerName%&adapterTypeName=%value -urlencode ../adapterTypeName%&action='+ 
                                            doSelect(this.value,'%value listenerNodeName%', '%value numConfiguredNotifs%', '%value numEnabledNotifs%'); + 
											appendSecurityTokenIfCSRFEnabled()" >
                                        <OPTION SELECTED VALUE=none>Pending suspended</OPTION>
                                        <OPTION VALUE=disableListener>Disabled</OPTION>
              	                        <OPTION VALUE=resumeListener>Enabled</OPTION>
	                                </SELECT>
                                %endswitch%
                            </td>

                            <script>writeTD('rowdata');</script>
                                %switch listenerEnabled%
                                %case 'enabled'%
                                    Succeeded</td>
                                %case 'enablePending'%
                                    Pending</td>
                                %case 'disabled'%
                                    %ifvar lastError%
                                        <a id="listener_status%value $index%" href="ListenerDetails.dsp?%ifvar ../lt8%lt8=true&amp;%endif%readOnly=true&adapterTypeName=%value -urlencode ../adapterTypeName%&listenerNodeName=%value -urlencode listenerNodeName%">Failed</font></a>
										<script>updateURL("listener_status%value $index%", "Failed</font>");</script>
                                    %else%
                                        Succeeded
                                    %endif%
                                    </td>
                                %case 'disablePending'%
                                    Pending</td>
                                %case 'suspended'%
                                    Succeeded</td>
                                %case 'suspendPending'%
                                    Pending</td>
                                %endswitch%
                            </td>

                            <script>writeTD('rowdata');</script>
                                %switch listenerEnabled%
                                %case 'enabled'%
                                    <img src="/WmART/icons/disabled_edit.gif" alt="Edit" border=0>
                                %case 'enablePending'%
                                    <img src="/WmART/icons/disabled_edit.gif" alt="Edit" border=0>
                                %case 'suspended'%
                                    <a id="listener_edit%value $index%" href="ListenerDetails.dsp?%ifvar ../lt8%lt8=true&amp;%endif%readOnly=some&adapterTypeName=%value -urlencode ../adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&listenerNodeName=%value -urlencode listenerNodeName%&dspName=.LISTLISTENERDETAILS">
                                        <img src="/WmART/icons/config_edit.gif" alt="Edit" border=0></a>
										<script>updateURL("listener_edit%value $index%", '<img src="/WmART/icons/config_edit.gif" alt="Edit" border=0>');</script>
                                %case 'suspendPending'%
                                    <a id="listener_edit%value $index%" href="ListenerDetails.dsp?%ifvar ../lt8%lt8=true&amp;%endif%readOnly=some&adapterTypeName=%value -urlencode ../adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&listenerNodeName=%value -urlencode listenerNodeName%&dspName=.LISTLISTENERDETAILS">
                                        <img src="/WmART/icons/config_edit.gif" alt="Edit" border=0></a>
										<script>updateURL("listener_edit%value $index%", '<img src="/WmART/icons/config_edit.gif" alt="Edit" border=0>');</script>
                                %case%
                                    <a id="listener_edit%value $index%" href="ListenerDetails.dsp?%ifvar ../lt8%lt8=true&amp;%endif%readOnly=false&adapterTypeName=%value -urlencode ../adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&listenerNodeName=%value -urlencode listenerNodeName%&dspName=.LISTLISTENERDETAILS">
                                        <img src="/WmART/icons/config_edit.gif" alt="Edit" border=0></a>
										<script>updateURL("listener_edit%value $index%", '<img src="/WmART/icons/config_edit.gif" alt="Edit" border=0>');</script>
                                %endswitch%
                            </td>

                            <script>writeTD('rowdata');</script>
                                <a id="listener_view%value $index%" href="ListenerDetails.dsp?%ifvar ../lt8%lt8=true&amp;%endif%readOnly=true&adapterTypeName=%value -urlencode ../adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&listenerNodeName=%value -urlencode listenerNodeName%&dspName=.LISTLISTENERDETAILS">
                                    <img src="/WmRoot/icons/file.gif" alt="View" border=0>
                                </a>
								<script>updateURL("listener_view%value $index%", '<img src="/WmRoot/icons/file.gif" alt="View" border=0>');</script>
								</td>

                            <script>writeTD('rowdata');</script>
                              %ifvar listenerNodeName equals('wm.sap.internal.ls:routingListener')%
                                    <img src="/WmART/icons/disabled_edit.gif" alt="Routing Listener should not be copied!" border=0>
                              %else%
                                <a id="listener_copy%value $index%" href="CopyListener.dsp?%ifvar ../lt8%lt8=true&amp;%endif%readOnly=false&adapterTypeName=%value -urlencode ../adapterTypeName%&listenerNodeName=%value -urlencode listenerNodeName%&dspName=.LISTLISTENERDETAILS">
                                    <img src="/WmART/icons/copy.gif" alt="Copy" border=0>
                                </a>
								<script>updateURL("listener_copy%value $index%", '<img src="/WmART/icons/copy.gif" alt="Copy" border=0>');</script>
								</td>
                              %endif%

                            <script>writeTD('rowdata'); swapRows();</script>
                                %ifvar listenerEnabled equals('disabled')%
                                  %ifvar listenerNodeName equals('wm.sap.internal.ls:routingListener')%
                                    <img src="/WmART/icons/delete_disabled.gif" alt="Routing Listener should not be deleted!" border=0>
                                  %else%
                                    <a id="listener_delete%value $index%" href="ListListeners.dsp?%ifvar ../lt8%lt8=true&amp;%endif%action=deleteListener&adapterTypeName=%value -urlencode ../adapterTypeName%&listenerNodeName=%value -urlencode listenerNodeName%&dspName=.LISTLISTENERDETAILS"
                                       onclick="return confirmDelete('%value listenerNodeName%');">
                                        <img src="/WmRoot/icons/delete.gif" alt="Delete" border=0>
                                    </a>
									<script>updateURL("listener_delete%value $index%", '<img src="/WmRoot/icons/delete.gif" alt="Delete" border=0>');</script>
                                  %endif%
                                %else%
                                    <img src="/WmART/icons/delete_disabled.gif" alt="Disable Listener to Delete" border=0>
                                %endif%								
                            </td>
                    %endloop%
                %else%
                    <tr><td class="message" colspan=8>No Listeners found</td></tr>
                %endif%
            %onerror%
            %ifvar localizedMessage%
                <tr><td class="message">Error encountered <pre>%value localizedMessage%</pre></td></tr>
            %else%
                %ifvar error%
                    <tr><td class="message">Error encountered <pre>%value errorMessage%</pre></td></tr>
                %endif%
            %endif%
            %endinvoke%
			</tr>
			</tbody>
			</table>
			</td>
			</tr>

        </table>
	%ifvar lt8%%else%<div class="oddrowdata" id="goContainer" name="goContainer" style="display:none;padding-top=2mm;">
        	%ifvar pStart equals('1')%
			<label style="color:#666666;font-weight:bold;text-align:inherit;">
			Page (1-<script>writeTD('rowdata-l');</script>%value pageSize% )</td></label>
		%else%		
        		<a id="listener_page_previous" href="ListListeners.dsp?adapterTypeName=%value -urlencode adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&prev=true&dspName=.LISTLISTENERS">� Previous</a>
				<script>updateURL("listener_page_previous", "&laquo; Previous");</script>
				&nbsp;<label style="color:#666666;font-weight:bold;text-align:inherit;">Page (1-
				<script>writeTD('rowdata-l');</script>%value pageSize% )</label></td>
		%endif%	
			<input type="text" name="pageNumber" value="%value pStart%" size="1" onkeypress="return isNumberKey(this.form,event);">&nbsp;<input type="submit" name="Go" value="Go" onClick="jumpToPage(this);return false;">
			%ifvar pStart vequals(pageSize)%			
				<!-- Next -->
		%else%
			<a id="listener_page_next" href="ListListeners.dsp?adapterTypeName=%value -urlencode adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&prev=false&dspName=.LISTLISTENERS">Next �</a>
			<script>updateURL("listener_page_next", "Next &raquo;");</script>
		%endif%		
	</div>
      
	<div class="oddrowdata" id="paginationContainer" name="paginationContainer" style="display:;padding-top=2mm;">

        %ifvar pStart equals('1')%
	%else%
		<a id="listener_page_no_previous" href="ListListeners.dsp?adapterTypeName=%value -urlencode adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&prev=true&dspName=.LISTLISTENERS">� Previous</a>
	<script>updateURL("listener_page_no_previous", "&laquo; Previous");</script>		
	%endif%
	       %loop totalNosOfPages%
		%ifvar totalNosOfPages -notempty%           		
		<a id="listener_page_no_%value $index%" href="ListListeners.dsp?adapterTypeName=%value -urlencode adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&pageNumber=%value -urlencode totalNosOfPages%&dspName=.LISTLISTENERS">
		%ifvar totalNosOfPages vequals(/pStart)% 
		<a>
		<script>updateURL("listener_page_no_%value $index%", "");</script>
		<label style="color:#666666;font-weight:bold;">%value totalNosOfPages%</label>
		%else%
					%ifvar totalNosOfPages equals('...')%
				</a>
				<script>updateURL("listener_page_no_%value $index%", "");</script>
				<a href="javascript:showHidePageCriteria()">%value totalNosOfPages%</a>
		%else%
		%value totalNosOfPages%<a>
		%endif%
		%endif%	
		%else%
		%value pStart%
	%endif%	
        %endloop%							
							
	%ifvar pStart vequals(pageSize)%			
		
	%else%
		<a id="listener_page_no_next" href="ListListeners.dsp?adapterTypeName=%value -urlencode adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&prev=false&dspName=.LISTLISTENERS">Next �</a>
		<script>updateURL("listener_page_no_next", "Next &raquo;");</script>
	%endif%		
	</div>
	<input type="hidden" name="adapterTypeName" value="%value adapterTypeName%">
	<input type="hidden" name="searchConnectionName" value="%value searchListenerName%">     	
	<input type="hidden" name="pStart" value="%value pStart%">
	<input type="hidden" name="totalNosOfPages" value="%value totalNosOfPages%">
    	<input type="hidden" name="pageNumber" value="%value pageNumber%">
    	<input type="hidden" value="" name="sortCriteria">
    	<input type="hidden" name="pageSize" value="%value pageSize%">
    	<input type="hidden" value="%value pageLabel%" name="pageLabel">
	</form>%endif%
    </body>
</html>
