%comment%-- LG TRAX 1-MHXP3 --%endcomment%
%comment%-- Created New DSP For COPY OF LISTENERS --%endcomment%
%comment%-- This is a new .dsp for Elbe Release --%endcomment%
%ifvar listenerData%
    <script>setNavigation('ListResources.dsp', '%value TemplateURL%', 'foo');</script>

    <tr class="subheading2"><td colspan=2>Listener Copy Properties</td></tr>


    %comment%-- edit mode --%endcomment%
    %loop listenerData%
		%comment%-- start trax# 1-13CREJ --%endcomment%
		%ifvar isHidden%
			%comment%-- set a hidden value --%endcomment%
			<input type=hidden name=".CPROP.%value -urlencode systemName%" value="%value value%"> </input>
		%else%
		%comment%-- end trax# 1-13CREJ --%endcomment%

        <tr>
            <script>writeTD('row');</script>%value displayName%</td>
            %ifvar isPassword%
                <script>writeTD('rowdata-l');swapRows();</script>
		%comment%-- LG TRAX 1-MHXFJ --%endcomment%
		%comment%-- Change PWD value from "******" to "" --%endcomment%
    		%comment%-- This is a new .dsp for LISTENER COPY ONLY --%endcomment%
		%comment%-- LG TRAX 1-I49V9 --%endcomment%
		%comment%----- Added second argument to passwordChange() function -----%endcomment%
		%comment%----- to support artconnjs.txt for multiple password fields -----%endcomment%
                <input size=60
                           type=password
                           name=".CPROP.%value -urlencode systemName%"
                           value=""
                           onchange= "passwordChanged(this.form, '%value -urlencode systemName%')"</input></td></tr>
                <script>writeTD('row');</script>Retype %value displayName%</td>
                <script>writeTD('rowdata-l');swapRows();</script>
		%comment%-- LG TRAX 1-MHXFJ --%endcomment%
		%comment%-- Change Retype from "******" to "" --%endcomment%
                <input size=60 type=password name="PWD.CPROP.%value -urlencode systemName%" value=""></input></td>
            %else%
                %ifvar resourceDomain -notEmpty%
		   <script>writeTD('rowdata-l');swapRows();</script>
                   <select name=".CPROP.%value systemName%" %ifvar systemName equals('sncMode')%onchange="handleSNCChange1(this.form);"%endif% %ifvar systemName equals('haMode')%onchange="handleHighAvailabilityChange(this.form);"%endif%>
                        %loop resourceDomain%
                            <option width = 300 value="%value resourceDomain%" %ifvar resourceDomain vequals(value)%selected="true"%endif%>
					%value resourceDomain%
			    </option>
                        %endloop%
                    </select></td>
                %else%
        	    %ifvar parameterType equals('boolean')%
          		<script>writeTDspan('rowdata-l');swapRows();</script>      
          		<select name=".CPROP.%value -urlencode systemName%">
                        <option value="true"  %ifvar value equals('true')%selected="true"%endif%>true</option>
                        <option value="false" %ifvar value equals('false')%selected="true"%endif%>false</option>
          		</select></td>
        	    %else%
    			<script>writeTDspan('rowdata-l');swapRows();</script>
                        <input size=60 name=".CPROP.%value -urlencode systemName%" value="%value value%"></input></td>
		    %endif% 
                %endif%
            %endif%
        </tr>
        %endif%
    %endloop%

    <tr class="subheading2"><td colspan=2">Last Error</td></tr>

    <tr>
        <script>writeTD('row');</script></td><script>writeTD('rowdata-l')</script>%value lastError%</td>
    </tr>
%else%
    <tr><td class="message" colspan=4>Listener Copy Properties Not Found</td></tr>
%endif%
