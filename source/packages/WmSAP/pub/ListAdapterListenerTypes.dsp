%comment%------ List Listener types ------%endcomment%
<html>
    <head>
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
        <META HTTP-EQUIV="Expires" CONTENT="-1">
        <TITLE>List Adapter Listener Types</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="../WmRoot/webMethods.css"></LINK>
		<Link REL="stylesheet" TYPE="text/css" HREF="../WmART/webMethods.css"></LINK>
		
        <SCRIPT SRC="/WmRoot/webMethods.js"></SCRIPT>
		<script type="text/javascript" src="/WmART/csrfGuard.js"></script>
    </head>

    %invoke wm.art.admin:getAdapterTypeOnlineHelp%
    %onerror%
    %endinvoke%
    
    %invoke wm.art.admin:retrieveAdapterTypeData%
    %onerror%
    %endinvoke%
    <body onLoad="setNavigation('ListResources.dsp', '%value encode(javascript) helpsys%', 'foo');">
		<input type="hidden" name="searchListenerName" value="%value searchListenerName%">
        <table width="100%">
            <tr>
                <td class="breadcrumb" colspan=7>Adapters &gt; %value displayName% &gt; Listener Types</td>
            </tr>

            <tr>
                <td colspan=2>
                    <ul>
                        <li>
                            <a id="Return_to_%value displayName%_Listeners" href="ListListeners.dsp?%ifvar lt8%lt8=true&amp;%endif%adapterTypeName=%value -urlencode adapterTypeName%&searchListenerName=%value -urlencode searchListenerName%&dspName=.LISTRESOURCES">
                                Return to %value displayName% Listeners
                            </a>
							<script>updateURL("Return_to_%value displayName%_Listeners", "Return to %value displayName% Listeners");</script>
                        </li>
                    </ul>
                </td>
            </tr>
			
			<tr>
			<td>
			<table class="tableView" width="100%">
			<tbody>
            <tr>
                <td class="heading" colspan=2>Listener Types</td>
            </tr>

            <tr class="subheading2">
                <td class="oddcol-l">Listener Type</td>
                <td class="oddcol-l">Description</td>
            </tr>

            %invoke wm.art.admin:retrieveListenerTypes%
                %ifvar listenerTypes%
                    %loop listenerTypes%
                        <tr>
                            <script>writeTD('rowdata-l');</script>
                                <a id="listener_type_%value $index%" href="SetListenerProperties.dsp?%ifvar ../lt8%lt8=true&amp;%endif%adapterTypeName=%value -urlencode adapterTypeName%&listenerTypeName=%value -urlencode listenerTypeName%">%value listenerDisplay%</a>
								<script>updateURL("listener_type_%value $index%", "%value listenerDisplay%");</script>
                            </td>
                            <script>writeTD('rowdata-l');swapRows();</script>
                                %value listenerDescription%
                            </td>
                        </tr>
                    %endloop%
                %else%
                    <tr><td class="message" colspan=2>No Listener types found</td></tr>
                %endif%
            %onerror%
                %ifvar localizedMessage%
                    %comment%-- Localized error message supplied --%endcomment%
                    <tr><td class="message">Error: <pre>%value localizedMessage%</pre></td></tr>
                %else%
                    %ifvar error%
                        <tr><td class="message">Error: <pre>%value errorMessage%</pre></td></tr>
                    %else%
                        <tr><td class="message">Error: no message</td></tr>
                    %endif%
                %endif%
            %endinvoke%
			</tbody>
			</table>
			</td>
		</tr>
        </table>
    </body>
</html>
