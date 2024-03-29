%comment%------ Display configured Listener node ------%endcomment%
%comment%----- LG TRAX 1-MHXZY -----%endcomment%
%comment%----- Move occurrances of swaprows() to make alternate -----%endcomment%
%comment%----- display lines in form have alternating colors -----%endcomment%
<html>
    <head>
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
        <meta http-equiv="Expires" CONTENT="-1">
        <title>Connection Details</title>
        <link rel="stylesheet" TYPE="text/css" HREF="../WmRoot/webMethods.css"></link>
		<Link REL="stylesheet" TYPE="text/css" HREF="../WmART/webMethods.css"></LINK>
		
        <SCRIPT SRC="/WmRoot/webMethods.js"></SCRIPT>
        <script src="/WmART/artconnjs.txt"></script>
		<script src="/WmART/artconnjs.js"></script>
        <script src="sap.js"></script>
		<script type="text/javascript" src="/WmART/csrfGuard.js"></script>
    </head>

    <body onload="init1();">
	%comment%------ LG TRAX 1-MHXP3 ------%endcomment%
	%comment%------ Removed onSubmit="return validate(form) ------%endcomment%
        <form name="form" action="ListListeners.dsp" method="POST" onsubmit="enableAll1(form);">
            %ifvar lt8%<input type="hidden" name="lt8" value="true">%endif%
            <input type="hidden" name="action"         value="editListener">
            <input type="hidden" name="passwordChange" value="false">
        <input type="hidden" name="searchListenerName" value="%value searchListenerName%">
            %invoke wm.art.admin:retrieveAdapterTypeData%
            %onerror%
            %endinvoke%
          
            <table width="100%">
                <tr>
                    %ifvar readOnly equals('true')%
                        <td class="breadcrumb" colspan="2">Adapters &gt; %value displayName% &gt; View Listener</td>
                    %else%       
                        <td class="breadcrumb" colspan="2">Adapters &gt; %value displayName% &gt; Edit Listener</td>
                    %endif%    
                </tr>
              
                <tr>
                    <td colspan="2">
                        <ul>
                            <li>
                                <a id="Return_to_Listeners" href="ListListeners.dsp?%ifvar lt8%lt8=true&amp;%endif%adapterTypeName=%value -urlencode adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&dspName=.LISTRESOURCES">
                                    Return to %value displayName% Listeners
                                </a>
								<script>updateURL("Return_to_Listeners", "Return to %value displayName% Listeners");</script>
                            </li>
                            <li>
                                %ifvar readOnly equals('true')%
                                    <a id="View_Notification_Order" href="NotificationOrder.dsp?%ifvar lt8%lt8=true&amp;%endif%readOnly=true&adapterDisplayName=%value displayName%&adapterTypeName=%value -urlencode adapterTypeName%&listenerNodeName=%value listenerNodeName%">
                                        View Notification Order
                                    </a>
									<script>updateURL("View_Notification_Order", "View Notification Order");</script>
                                %else%       
                                    <a id="Edit_Notification_Order" href="NotificationOrder.dsp?%ifvar lt8%lt8=true&amp;%endif%readOnly=false&adapterDisplayName=%value displayName%&adapterTypeName=%value -urlencode adapterTypeName%&listenerNodeName=%value listenerNodeName%">
                                        Edit Notification Order
                                    </a>
									<script>updateURL("Edit_Notification_Order", "Edit Notification Order");</script>
                                %endif%
                            </li>
                        </ul>
                    </td>
                </tr>

                <tr>
                    %comment% this makes the columns the same in both edit and view mode. %endcomment%
                    <td width="25%"></td>
                    <td width="75%"></td>
                </tr>
				
				
				<tr>
				<td colspan="2">
				<table class="tableView" width="100%">
				<tbody>
                %invoke wm.art.ns:getListenerConfiguration%

                    <tr>
                        <td class="heading" colspan="2">%value listenerNodeName% Details</td>
                    </tr>
                      
                    <tr>
                        <script>writeTD('row');</script>Listener Type</td>
                        <script>writeTD('rowdata-l');swapRows();</script>
                            %ifvar mcfDisplayName%
                                %value mcfDisplayName%
                            %else%
                                %value connectionFactoryType%
                            %endif%
                        </td>
                    </tr>
    
                    <tr>
                        <script>writeTD('row');</script>Package Name</TD>
                        <script>writeTD('rowdata-l');swapRows();</script>%value packageName%</td>
                    </tr>    
                    
                    %ifvar requiresConnection equals('yes')%
                        <tr>
                            <script>writeTD('row');</script>Connection name</td>
                            <script>writeTD('rowdata-l');swapRows();</script>
                                %ifvar readOnly equals('true')%
                                    %value connDataNodeName%
                                %else%
                                    %invoke wm.art.admin.connection:listResources%
                                        %ifvar connDataNode -notempty%
                                            <select name="connDataNodeName" size=1 >
                                                %loop connDataNode%
                                                    <option value="%value connectionAlias%"
                                                            %ifvar ../connDataNodeName vequals(connectionAlias)% selected="true" %endif%
                                                    >
                                                        %value connectionAlias% 
                                                    </option>
                                                %endloop%
                                            </select>
                                        %else%
                                            no connections
                                        %endif%
                                    %endinvoke%
                                %endif%
                            </td>
                        </tr>
                    %endif%
                
                    <tr>
                        <script>writeTD('row');</script>Retry Limit</TD>
                        <script>writeTD('rowdata-l');swapRows();</script>
                            %ifvar readOnly equals('true')%
                                %value retryLimit%
                            %else%
                                 <input size=60 name="retryLimit" value="%value retryLimit%"></input></td>
                            %endif%
                        </td>
                    </tr>    
                    
                    <tr>
                        <script>writeTD('row');</script>Retry Backoff Timeout</TD>
                        <script>writeTD('rowdata-l');swapRows();</script>
                            %ifvar readOnly equals('true')%
                                %value retryBackoffTimeout%
                            %else%
                                 <input size=60 name="retryBackoffTimeout" value="%value retryBackoffTimeout%"></input></td>
                            %endif%
                        </td>
                    </tr>    
                    
                    %include DisplayListenerDetails.dsp%
                
                %onerror%
                    %ifvar localizedMessage%
                        %comment%-- Localized error message supplied --%endcomment%
                        <tr><td class="message">Error encountered <pre>%value localizedMessage%</pre></td></tr>
                    %else%
                        %ifvar error%
                            <tr><td class="message">Error encountered <pre>%value errorMessage% (%value error%)</pre></td></tr>
                        %endif%
                    %endif%
                %endinvoke%
			</tbody>
			</table>
			</td>
			</tr>
            </table>
              
            <table width=100%>
                <tr>
                    <td class="action" colspan="2">
                        %ifvar readOnly equals('true')%
                        %else%
                            %comment%------ LG TRAX 1-MHXP3 ------%endcomment%
                            %comment%------ Removed onclick="return setPasswordEdit() ------%endcomment%
                            %comment%------ Added onclick="return validate(this.form) ------%endcomment%
                            <input type="submit" name="SUBMIT" value="Save Changes" width=100 onclick="return validateForm(this.form)"></input>
                            <input type="hidden" name="adapterTypeName"    value="%value adapterTypeName%">
                            <input type="hidden" name="listenerTemplate"   value="%value listenerTemplate%">       
                            <input type="hidden" name="listenerNodeName"   value="%value listenerNodeName%">
                            <input type="hidden" name="requiresConnection" value="%value requiresConnection%">
                        %endif%        
                    </td>
                </tr>
            </table>
        </form>    
    </body>
</html>
