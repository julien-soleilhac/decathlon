%comment%------ Display configured connection node ------%endcomment%
%comment%----- LG TRAX 1-MHXZY -----%endcomment%
%comment%----- Move occurrances of swaprows() to make alternate -----%endcomment%
%comment%----- display lines in form have alternating colors -----%endcomment%
<HTML>
    <head>
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
    <meta http-equiv="Expires" CONTENT="-1">
    <title>Connection Details</title>
    <link rel="stylesheet" TYPE="text/css" HREF="../WmRoot/webMethods.css"></link>
	<link rel="stylesheet" TYPE="text/css" HREF="../WmART/webMethods.css"></link>    
	
    <SCRIPT SRC="/WmRoot/webMethods.js"></SCRIPT>
    <script src="/WmART/artconnjs.txt"></script>
    <script src="sap.js"></script>
	<script type="text/javascript" src="/WmART/csrfGuard.js"></script>
    </head>


<body onload="init();">
<form name="form" action="ListResources.dsp" method="POST" onsubmit="enableAll(form);">
%ifvar ISVersionGTE equals('107')%<input type="hidden" name="ISVersionGTE" value="107">%endif%
%ifvar lt8%<input type="hidden" name="lt8" value="true">%endif%
<input type="hidden" name="action" value="saveConnection">
<input type="hidden" name="passwordChange" value="false">
<input type="hidden" name="searchConnectionName" value="%value searchConnectionName%">

    %invoke wm.art.admin:retrieveAdapterTypeData%
    %onerror%
    %endinvoke%
	
	%ifvar ISVersionGTE equals('107')%
		%ifvar test equals(true)%
			<INPUT NAME="test" TYPE="hidden" VALUE="true">
		%else%
			%ifvar test equals(completed)%
				<INPUT NAME="test" TYPE="hidden" VALUE="completed">
			%else%
				<INPUT NAME="test" TYPE="hidden" VALUE="false">
			%endif%
		%endif%
	%endif%
	
    <table width=100%>
    <tr>
    <td class="breadcrumb" colspan=4>Adapters &gt; %value displayName% &gt; Copy Connection</td>
    </tr>
	
	%ifvar ISVersionGTE equals('107')%
		%ifvar test equals(true)%
		  %invoke wm.art.admin.connection:testResource% 
		  <SCRIPT>testSAPCompleted();</SCRIPT>
		  %ifvar message%
			<TR><TD class="message" colspan="8">%value message encode(html)%</TD></TR>
		  %else%
		  %endif%
		  %onerror%
			 %ifvar localizedMessage%
					<tr><td class="message" colspan=8>Error encountered <pre>%value localizedMessage%</pre></td></tr>
			 %else%
				   %ifvar error%
						<tr><td class="message" colspan=8>Error encountered <pre>%value errorMessage%</pre></td></tr>
				   %endif%
			 %endif%				
		  %endinvoke%
		%endif%
	%endif%
	
    <tr>
    <td colspan=2>
        <ul>
        <li><A id="Return_to_%value displayName%_Connections" HREF="ListResources.dsp?%ifvar lt8%lt8=true&amp;%endif%adapterTypeName=%value -urlencode adapterTypeName%&searchConnectionName=%value -urlencode searchConnectionName%&dspName=.LISTRESOURCES&ISVersionGTE=%value -urlencode ISVersionGTE%">Return to %value displayName% Connections</A>
		<script>updateURL("Return_to_%value displayName%_Connections", "Return to %value displayName% Connections");</script>
		</li>
        </ul>
    </td>
    </tr>
	
	<td>
	<tr>
	<table class="tableView" width="100%">
	<tbody>
    %invoke wm.art.admin.connection:getResourceConfiguration%
    <tr>
        <td class="heading" colspan=2>Configure Connection Type &gt; %value mcfDisplayName% Copy</td>
    </tr>


    <script>setNavigation('ListResources.dsp', '%value encode(javascript)TemplateURL%', 'foo');</script>
    <script>resetRows();</script>
    <tr>
        %include ../../WmART/pub/GetISPackages.dsp%
            <script>swapRows();writeTD('row');</script>
             Folder Name</td>
            <script>writeTD('rowdata-l');</script>
            <input size=30 name="resourceFolderName" value="%value -urlencode resourceFolderName%"></input></td>          
    </tr>
%comment%----- 
    <tr>
            <script>swapRows();writeTD('row');</script>
            Connection Name</td>
            <script>writeTD('rowdata-l');</script>
            <input size=30 name="resourceName" value="%value -urlencode resourceName%"></input></td>
    </tr>       
-----%endcomment%
    %comment%-- LG TRAX 1-MHXP3 --%endcomment%
    %comment%-- Changed to point to NEW COPY ONLY .dsp --%endcomment%
    %comment%-- Changed for Elbe Release    --%endcomment%
	
	%ifvar ISVersionGTE equals('107')%
		%ifvar test equals(true)%
			%include EditConnectionProperties.dsp%  
		%else%
			%include EditConnectionCopyProperties.dsp%
		%endif%
	%else%
		%include EditConnectionCopyProperties.dsp%
    %endif%
	
    %comment%----------------------ConnectionManagerProperties--------------%endcomment%    
    %include ../../WmART/pub/EditConnectionManagerProperties.dsp%
    %comment%----------------------End ConnectionManagerProperties--------------%endcomment%  
    
    %onerror%
      %ifvar localizedMessage%
        %comment%-- Localized error message supplied --%endcomment%
        <tr><td class="message">Error encountered <%value error%> %value localizedMessage%</td></tr>
      %else%
        %ifvar error%
          <tr><td class="message">Error encountered <%value error%> %value errorMessage%</td></tr>
        %endif%
      %endif%
    %endinvoke%
	</tbody>
	</table>
	</tr>
	</td>
    </table>
       
    <table width=100%>
    <tr>
    <td class="action" colspan="2">        
		%ifvar ISVersionGTE equals('107')%
			<input type="submit" name="SUBMIT" value="Save Connection Copy" width=100 onclick="return validateSAPConnectionForm(this.form)"></input>
			<input type="submit" name="TEST" value="Test Connection" onClick="return testSAPConnection('CopyConnection.dsp');" />
			<input type="hidden" name="resourceName" value=""></input>
		%else%
			<input type="submit" name="SUBMIT" value="Save Connection Copy" width=100 onclick="return validateForm(this.form)"></input>
		%endif%
        <input type="hidden" name="adapterTypeName" value="%value adapterTypeName%">
        <input type="hidden" name="connectionFactoryType" value="%value connectionFactoryType%">           
    </TD>    
    </tr>
    </table>
    </form>    
</body>
</HTML>