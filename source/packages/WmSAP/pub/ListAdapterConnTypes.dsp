%comment%------ List connection factory types ------%endcomment%
<HTML>
    <head>
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
    <META HTTP-EQUIV="Expires" CONTENT="-1">
    <TITLE>List Adapter Connection Types</TITLE>
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
	

    <BODY onLoad="setNavigation('ListResources.dsp', '%value encode(javascript) helpsys%', 'foo');">
    
    <input type="hidden" name="searchConnectionName" value="%value searchConnectionName%">
        <table width="100%">  
        <tr>
            <td class="breadcrumb" colspan=7>Adapters &gt; %value displayName% &gt; Connection Types</td>
        </tr>
    
        <tr>
        <td colspan=2>
            <ul>
            <li><a id="Return_to_%value displayName%_Connections" href="ListResources.dsp?%ifvar lt8%lt8=true&amp;%endif%adapterTypeName=%value -urlencode adapterTypeName%&searchConnectionName=%value -urlencode searchConnectionName%&dspName=.LISTRESOURCES&ISVersionGTE=%value -urlencode ISVersionGTE%">Return to %value displayName% Connections
            </a>
			<script>updateURL("Return_to_%value displayName%_Connections", "Return to %value displayName% Connections");</script>
			</li>
			</ul>
        </td>
        </tr>
  
  
		<tr>
		<td>
		<table class="tableView" width="100%">
		<tbody>
        <tr>
            <td class="heading" colspan=2>Connection Types</td>
        </tr>
   
        <tr class="subheading2">
            <td class="oddcol-l">Connection Type</td>
            <td class="oddcol-l">Description</td>    
        </tr>
        
        %invoke wm.art.admin.connection:retrieveConnectionTypes%
        %ifvar mgdConnTypes%
            %loop mgdConnTypes%
            %ifvar connectionFactoryType equals('com.wm.adapter.sap.spi.SAPConnectionFactory')%
            <tr>
            <script>writeTD('rowdata-l');</script>   
            <a id="%value mgdConnFactoryDisplay%" href="GetConnProperties.dsp?%ifvar ../lt8%lt8=true&amp;%endif%adapterTypeName=%value -urlencode adapterTypeName%&connectionFactoryType=%value -urlencode connectionFactoryType%&searchConnectionName=%value -urlencode ../searchConnectionName%&ISVersionGTE=%value -urlencode ../ISVersionGTE%">%value mgdConnFactoryDisplay%</a>
			<script>updateURL("%value mgdConnFactoryDisplay%", "%value mgdConnFactoryDisplay%");</script>
			</td>
            <script>writeTD('rowdata-l');swapRows();</script>
            %value mgdConnFactoryDesc%</td>
            </tr>
            %endif%
			</tbody>
		</table>
		</td>
		</tr>
            %endloop%
        %else%
            <tr>
            <td class="message" colspan=2>No connection types found</td></tr>
        %endif%                       
        
        %onerror%
          %ifvar localizedMessage%
            %comment%-- Localized error message supplied --%endcomment%
            <tr><td class="message">Error encountered <PRE>%value localizedMessage%</PRE></td></tr>
          %else%
            %ifvar error%
              <tr><td class="message">Error encountered <PRE>%value errorMessage%</PRE></td></tr>
            %endif%
          %endif%
       
        %endinvoke%
        </table>
       
    </body>
</HTML>