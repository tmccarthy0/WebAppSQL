<cfinclude template="../_ptsT.cfm">
<cfinclude template="../_ptsIntro.cfm">

<!--- Initialize specific form fields. --->
<cfoutput>
<cfparam name="form.empID" default="#theEmp.empID#">
<cfparam name="form.empEIN" default="#theEmp.empEIN#">
<cfparam name="form.empFirst" default="#theEmp.empFirst#">
<cfparam name="form.empMiddle" default="#theEmp.empMiddle#">
<cfparam name="form.empLast" default="#theEmp.empLast#">
<cfparam name="form.empAddress1" default="#theEmp.empAddress1#">
<cfparam name="form.empAddress2" default="#theEmp.empAddress2#">
<cfparam name="form.empAddress3" default="#theEmp.empAddress3#">
<cfparam name="form.empCountry" default="#theEmp.empCountry#">
<cfparam name="form.empState" default="#theEmp.empState#">
<cfparam name="form.empProvince" default="#theEmp.empProvince#">
<cfparam name="form.empCity" default="#theEmp.empCity#">
<cfparam name="form.empZip" default="#theEmp.empZip#">
<cfparam name="form.empPhone" default="#theEmp.empPhone#">
<cfparam name="form.empCell" default="#theEmp.empCell#">
<cfparam name="form.empFax" default="#theEmp.empFax#">
<cfparam name="form.empEmail" default="#theEmp.empEmail#">
<cfparam name="form.empStatus" default="#theEmp.empStatus#">
<cfparam name="form.empGender" default="#theEmp.empGender#">
<cfparam name="form.empBirth" default="#theEmp.empBirth#">
<cfparam name="form.empEEOC" default="#theEmp.empEEOC#">
<cfparam name="form.empDis" default="#theEmp.empDis#">
<cfparam name="form.empVet" default="#theEmp.empVet#">
<cfparam name="form.emerName" default="#theEmp.emerName#">
<cfparam name="form.emerTel" default="#theEmp.emerTel#">
<cfparam name="form.emerRel" default="#theEmp.emerRel#">
<cfparam name="form.empTrans" default="#theEmp.empTrans#">
<cfparam name="form.vehMake" default="#theEmp.vehMake#">
<cfparam name="form.vehColor" default="#theEmp.vehColor#">
<cfparam name="form.vehPlate" default="#theEmp.vehPlate#">
<cfparam name="form.empSmoke" default="#theEmp.empSmoke#">
<cfparam name="form.empRoomie" default="#theEmp.empRoomie#">
<cfparam name="form.ldgSleep" default="#theEmp.ldgSleep#">
<cfparam name="form.ldgNeat" default="#theEmp.ldgNeat#">
<cfparam name="form.ldgBunk" default="#theEmp.ldgBunk#">
<cfparam name="form.dlValid" default="#theEmp.dlValid#">
<cfparam name="form.dlNum" default="#theEmp.dlNum#">
<cfparam name="form.dlState" default="#theEmp.dlState#">

<cfif len(form.empDis) EQ 0><cfset form.empDis = 0></cfif>
<cfif len(form.empVet) EQ 0><cfset form.empVet = 0></cfif>
<cfif len(form.empSmoke) EQ 0><cfset form.empSmoke = 0></cfif>

<!--- Set existing form values for logging. --->
<cfset oName = #form.empFirst# & " " & #form.empMiddle# & " " & #form.empLast#>
<cfparam name="form.oLogName" default="#oName#">
<cfset oAddr1 = #form.empAddress1# & ", " & #form.empCity# & ", " & #form.empState# & "," & #form.empZip#>
<cfparam name="form.oLogAddr1" default="#oAddr1#">
<cfset oAddr2 = #form.empAddress2# & ", " & #form.empAddress3# >
<cfparam name="form.oLogAddr2" default="#oAddr2#">
<cfset oCon = "Tel=" & #form.empPhone# & ", Cell=" & #form.empCell# & ", Fax=" & #form.empFax#  & ", Eml=" & #form.empEmail#>
<cfparam name="form.oLogCon" default="#oCon#">
<cfset oID = "SSN=" & #form.empEIN# & ", Birth=" & #dateformat(form.empBirth,'m/d/yy')#>
<cfparam name="form.oLogID" default="#oID#">
<cfset oStat = "Stat=" & #form.empStatus# & ", Gend=" & #form.empGender# & ", EEO=" & #form.empEEOC#>
<cfif form.empDis><cfset oStat = oStat & ", Disabled=Yes"><cfelse><cfset oStat = oStat & ", Disabled=No"></cfif>
<cfif form.empVet><cfset oStat = oStat & ", Veteran=Yes"><cfelse><cfset oStat = oStat & ", Veteran=No"></cfif>
<cfparam name="form.oLogStat" default="#oStat#">
<cfset oEmer = "Contact=" & #form.emerName# & ", Tel=" & #form.emerTel# & ", Rel=" & #form.emerRel#>
<cfparam name="form.oLogEmer" default="#oEmer#">
<cfset oLdg = "Roomie=" & #form.empRoomie# & ", Sleep=" & #form.ldgSleep# & ",Neat= " & #form.ldgNeat# & ",Bunk= " & #form.ldgBunk#>
<cfif form.empSmoke><cfset oLdg = oLdg & ", Smoker"><cfelse><cfset oLdg = oLdg & "Nonsmoker"></cfif>
<cfparam name="form.oLogLdg" default="#oLdg#">
<cfset oDrive = "Contact=" & #form.emerName# & ", Tel=" & #form.emerTel# & ", Rel=" & #form.emerRel#>
<cfparam name="form.oLogDrive" default="#oDrive#">
</cfoutput>


<!--- Check for post-form errors and process form submittal or approval. --->
<cfif isdefined('send')>
	<cfset errors = "">

	<!--- Check for space-bar fields. --->
	<cfset sBad = 0>
	<cfif len(trim(form.empFirst)) EQ 0><cfset form.empFirst=trim(form.empFirst)><cfset sBad = 1></cfif>
	<cfif len(trim(form.empLast)) EQ 0><cfset form.empLast=trim(form.empLast)><cfset sBad = 1></cfif>
	<cfif len(trim(form.empAddress1)) EQ 0><cfset form.empAddress1=trim(form.empAddress1)><cfset sBad = 1></cfif>
	<cfif len(trim(form.empAddress2)) EQ 0><cfset form.empAddress2=trim(form.empAddress2)><cfset sBad = 0></cfif>
	<cfif len(trim(form.empAddress3)) EQ 0><cfset form.empAddress3=trim(form.empAddress3)><cfset sBad = 0></cfif>
	<cfset form.empProvince=trim(form.empProvince)>
	<cfset form.empState=trim(form.empState)>
	<cfset stLen = len(form.empState) + len(form.empProvince)>
	<cfif stLen EQ 0><cfset sBad = 1></cfif>
	<cfif len(trim(form.empCity)) EQ 0><cfset form.empCity=trim(form.empCity)><cfset sBad = 1></cfif>
	<cfif len(trim(form.empZip)) EQ 0><cfset form.empZip=trim(form.empZip)><cfset sBad = 1></cfif>
	<cfif len(trim(form.empPhone)) EQ 0><cfset form.empPhone=trim(form.empPhone)><cfset sBad = 1></cfif>
	<cfif len(trim(form.empEmail)) EQ 0><cfset form.empEmail=trim(form.empEmail)><cfset sBad = 1></cfif>
	<cfif len(trim(form.emerName)) EQ 0><cfset form.emerName=trim(form.emerName)><cfset sBad = 1></cfif>
	<cfif len(trim(form.emerTel)) EQ 0><cfset form.emerTel=trim(form.emerTel)><cfset sBad = 1></cfif>
	<cfif len(trim(form.emerRel)) EQ 0><cfset form.emerRel=trim(form.emerRel)><cfset sBad = 1></cfif>
	<cfif sBad><cfset errors = errors & "Please enter visible data for all required (bold) fields.<br />"></cfif>

	<!--- Check for invalid SSN. --->
	<cfif len(form.empEIN) GT 0>
		<!--- <cfif NOT isnumeric(form.empEIN)><cfset sBad = 1></cfif> --->
		<cfif len(form.empEIN) NEQ 9><cfset sBad = 1></cfif>
		<cfif sBad><cfset errors = errors & "Social security number must be 9 numbers.<br />"></cfif>
	</cfif>	


	<!--- Check for null EEOC, if US. --->
	<cfif theEmp.locCountry EQ 'US'><cfif len(form.empEEOC) EQ 0><cfset errors = errors & "Please select an EEOC status.<br />"></cfif></cfif>


	<!--- Check for invalid email addr. --->
	<cfset form.empEmail = trim(form.empEmail)>
	<cfif find(' ',form.empEmail) GT 0><cfset errors = errors & "Please enter a valid email address.<br />">
	<cfelseif find('.',form.empEmail) EQ 0><cfset errors = errors & "Please enter a valid email address.<br />">
	<cfelseif find('@',form.empEmail) EQ 0><cfset errors = errors & "Please enter a valid email address.<br />">
	</cfif>

	<cfif hash(ucase(form.captcha)) NEQ form.captchaHash><cfset errors = errors & "Please correctly enter the security code below.<br />"></cfif>
	<!--- If no errors, process form data. --->
	<cfif errors IS "">
	
		<!--- Log form data. --->
		<cfset form.appDate = now()>
		<cfset form.accID = session.accID><cfset form.appUser = session.appUser>
		<cfset nName = #form.empFirst# & " " & #form.empMiddle# & " " & #form.empLast#>
		<cfif nName NEQ form.oLogName>
			<cfset form.appType = "DQ: Name">
			<cfset form.appFrom = form.oLogName>
			<cfset form.appTo = nName>
			<cfinsert datasource="#session.orgData#" tablename="appLog" formfields="appType, empID, accID, appUser, appDate, appFrom, appTo">
               		</cfif>
		<cfset nAddr1 = #form.empAddress1# & ", " & #form.empAddress2# & ", " & #form.empAddress3# & "," &#form.empCity# & ", " & #form.empState# & "," & #form.empZip#>
		<cfif nAddr1 NEQ form.oLogAddr1>
			<cfset form.appType = "DQ: Address">
			<cfset form.appFrom = form.oLogAddr1>
			<cfset form.appTo = nAddr1>
			<cfinsert datasource="#session.orgData#" tablename="appLog" formfields="appType, empID, accID, appUser, appDate, appFrom, appTo">
		</cfif>
		<cfset nAddr2 = #form.empAddress2# & ", " & #form.empAddress3#>
            		<cfif nAddr1 NEQ form.oLogAddr2>
            			<cfset form.appType = "DQ: Address">
            			<cfset form.appFrom = form.oLogAddr2>
            			<cfset form.appTo = nAddr2>
			<cfinsert datasource="#session.orgData#" tablename="appLog" formfields="appType, empID, accID, appUser, appDate, appFrom, appTo">
		</cfif>
		<cfset nCon = "Tel=" & #form.empPhone# & ", Cell=" & #form.empCell# & ", Fax=" & #form.empFax#  & ", Eml=" & #form.empEmail#>
		<cfif nCon NEQ form.oLogCon>
			<cfset form.appType = "DQ: Contact">
			<cfset form.appFrom = form.oLogCon>
			<cfset form.appTo = nCon>
			<cfinsert datasource="#session.orgData#" tablename="appLog" formfields="appType, empID, accID, appUser, appDate, appFrom, appTo">
		</cfif>
		<cfset nID = "SSN=" & #form.empEIN# & ", Birth=" & #dateformat(form.empBirth,'m/d/yy')#>
		<cfif nID NEQ form.oLogID>
			<cfset form.appType = "DQ: Emp ID">
			<cfset form.appFrom = form.oLogID>
			<cfset form.appTo = nID>
			<cfinsert datasource="#session.orgData#" tablename="appLog" formfields="appType, empID, accID, appUser, appDate, appFrom, appTo">
		</cfif>
		<cfset nStat = "Stat=" & #form.empStatus# & ", Gend=" & #form.empGender# & ", EEO=" & #form.empEEOC#>
		<cfif form.empDis><cfset nStat = nStat & ", Disabled=Yes"><cfelse><cfset nStat = nStat & ", Disabled=No"></cfif>
		<cfif form.empVet><cfset nStat = nStat & ", Veteran=Yes"><cfelse><cfset nStat = nStat & ", Veteran=No"></cfif>
		<cfif nStat NEQ form.oLogStat>
			<cfset form.appType = "DQ: Status">
			<cfset form.appFrom = form.oLogStat>
			<cfset form.appTo = nStat>
			<cfinsert datasource="#session.orgData#" tablename="appLog" formfields="appType, empID, accID, appUser, appDate, appFrom, appTo">
		</cfif>
		<cfset nEmer = "Contact=" & #form.emerName# & ", Tel=" & #form.emerTel# & ", Rel=" & #form.emerRel#>
		<cfif nEmer NEQ form.oLogEmer>
			<cfset form.appType = "DQ: Emergency">
			<cfset form.appFrom = form.oLogEmer>
			<cfset form.appTo = nEmer>
			<cfinsert datasource="#session.orgData#" tablename="appLog" formfields="appType, empID, accID, appUser, appDate, appFrom, appTo">
		</cfif>
		<cfset nLdg = "Roomie=" & #form.empRoomie# & ", Sleep=" & #form.ldgSleep# & ",Neat= " & #form.ldgNeat# & ",Bunk= " & #form.ldgBunk#>
		<cfif form.empSmoke><cfset nLdg = nLdg & ", Smoker"><cfelse><cfset nLdg = nLdg & "Nonsmoker"></cfif>
		<cfif nLdg NEQ form.oLogLdg>
			<cfset form.appType = "DQ: Ldg Pref">
			<cfset form.appFrom = form.oLogLdg>
			<cfset form.appTo = nLdg>
			<cfinsert datasource="#session.orgData#" tablename="appLog" formfields="appType, empID, accID, appUser, appDate, appFrom, appTo">
		</cfif>
		<cfset nDrive = "Contact=" & #form.emerName# & ", Tel=" & #form.emerTel# & ", Rel=" & #form.emerRel#>
		<cfif nDrive NEQ form.oLogDrive>
			<cfset form.appType = "DQ: Driver">
			<cfset form.appFrom = form.oLogDrive>
			<cfset form.appTo = nDrive>
			<cfinsert datasource="#session.orgData#" tablename="appLog" formfields="appType, empID, accID, appUser, appDate, appFrom, appTo">
		</cfif>

		<cfset showForm = false>
		<!--- Take action on form data, if employee. --->
		<cfif URL.AFX EQ 0>
			<cfset form.appUpdate = now()>
			<cfupdate datasource="#session.orgData#" tablename="employees" formfields="empID, empEIN, empFirst, empMiddle, empLast, empAddress1, empAddress2, empAddress3, empCity, empState, empZip, empPhone, empCell, empFax, empEmail, empBirth, empStatus, empGender, empEEOC, empDis, empVet, emerName, emerTel, emerRel, empTrans, vehMake, vehColor, vehPlate, empSmoke, empRoomie, ldgSleep, ldgNeat, ldgBunk, dlValid, dlNum, dlState">
			<cfinclude template="../_ptsSubmit.cfm">
		
		<!--- Take action on form data, if supervisor. --->
		<cfelseif URL.AFX EQ 1>
			<cfset form.appUpdate = now()>
			<cfupdate datasource="#session.orgData#" tablename="employees" formfields="empID, empEIN, empFirst, empMiddle, empLast, empAddress1, empAddress2, empAddress3, empCity, empState, empZip, empPhone, empCell, empFax, empEmail, empBirth, empStatus, empGender, empEEOC, empDis, empVet, emerName, emerTel, emerRel, empTrans, vehMake, vehColor, vehPlate, empSmoke, empRoomie, ldgSleep, ldgNeat, ldgBunk, dlValid, dlNum, dlState">
			<cfinclude template="../_ptsApprove.cfm">
		</cfif>
	</cfif>
</cfif>


<!--- Display specific form. --->
<cfif showform>
	<cfoutput>
	<cfset captcha = makeRandomString()>
	<cfset captchaHash = hash(captcha)>

	<cfset sURL = #cgi.script_name# & "?FFX=" & #URL.FFX# & "&CFX=" & #URL.CFX#>
	<cfif URL.AFX GT 0><cfset sURL = sURL & "&AFX=" & #URL.AFX#></cfif>
	
	<cfform action="#sURL#" method="post">
	<cfif len(errors) GT 0>
		<h2 align="center" style="color: red">Form not submitted - please resubmit after correcting errors in red below.</h2>
	<cfelse>
		<cfquery datasource="#session.orgData#" name="theInstr">
		SELECT docContent1 FROM documents
		WHERE docID = #theForm.formHead#
		</cfquery>
		<cfif theInstr.recordcount GT 0>
			<table width="800" align="center" cellpadding="5" cellspacing="0" border="0">
			<tr><td class="text">#theInstr.docContent1#</td></tr>
			</table>
		</cfif>			
	</cfif>
	
	<cfquery datasource="#session.orgData#" name="theDept">
	SELECT deptName FROM departments
	WHERE deptID = #theEmp.deptID#
	</cfquery>

	<cfquery datasource="#session.orgData#" name="hireDat">
	SELECT flogDate FROM formlog
	WHERE empID=#theEmp.empID#
	ORDER BY flogDate
	</cfquery>

	<h1 align="center">Data Questionnaire / Change Notification</h1>
	<table width="800" align="center" cellpadding="10" cellspacing="0" border="1">
	<tr><td align="center" class="head" colspan="4">Identification as Shown on <cfif theEmp.locCountry EQ 'US'>Social Security Card<cfelse>Social Insurance Card</cfif><br /><font class="text">Note: Enter <cfif theEmp.locCountry EQ 'US'>social security<cfelse>social insurance</cfif> number as 9 digits without hyphens.</font></td></tr>
	<tr>
		<td align="left" class="text" width="25%"><b>First Name</b><br /><cfinput type="Text" class="text" name="empFirst" value="#form.empFirst#" size="25" maxlength="25" required="yes" message="Please enter your first name."></td>
		<td align="left" class="text" width="25%">Middle Name<br /><cfinput type="Text" class="text" name="empMiddle" value="#form.empMiddle#" size="25" maxlength="15"></td>
		<td align="left" class="text" width="25%"><b>Last Name</b><br /><cfinput type="Text" class="text" name="empLast" value="#form.empLast#" size="25" maxlength="25" required="yes" message="Please enter your last name."></td>
		<td align="left" class="text" width="25%"><b><cfif theEmp.locCountry EQ 'US'>SSN<cfelse>SIN</cfif></b><br /><cfinput type="text" name="empEIN" message="Please enter a valid social security number (9 numbers, no hyphens)." required="no" class="text" value="#form.empEIN#" size="25" maxlength="9"></td>
	</tr>
	<tr><td align="center" class="head" colspan="4">Mailing Address & Contact Information</td></tr>
	<tr>
		<td align="left" class="text" width="25%"><b>Address</b><br /><cfinput type="Text" class="text" name="empAddress1" value="#form.empAddress1#" size="26" maxlength="26" required="yes" message="Please enter your mailing address."></td>
		<td align="left" class="text" width="25%"><b>City</b><br /><cfinput type="Text" class="text" name="empCity" value="#form.empCity#" size="25" maxlength="25" required="yes" message="Please enter your city."></td>
		<td align="left" class="text" width="25%">
			<cfif theEmp.locCountry NEQ 'CA'>
                <b>State/Country</b><br><cfinput type="text" name="empState" class="little" value="#form.empState#" size="2" maxlength="2" required="yes" message="Please enter your state code.">
				<cfinput type="text" name="empCountry" class="little" value="#form.empCountry#" size="3" maxlength="3">
                <input type="hidden" name="empProvince" value="#form.empProvince#">
            <cfelse>
                <b>Province/Country</b><br><cfinput type="text" name="empProvince" class="little" value="#form.empProvince#" size="2" maxlength="3" required="yes" message="Please enter your province.">
				<cfinput type="text" name="empCountry" class="little" value="#form.empCountry#" size="3" maxlength="3">
                <input type="hidden" name="empState" value="#form.empState#">
            </cfif>
		</td>		
		<td align="left" class="text" width="25%"><b>Postal Code</b><br /><cfinput type="Text" class="text" name="empZip" value="#form.empZip#" size="6" maxlength="6" required="yes" message="Please enter your postal code."></td>
	</tr>
	<tr>
    		<td align="left" class="text" width="25%"><b>Address Line 2 and 3</b><br /><cfinput type="Text" class="text" name="empAddress2" value="#form.empAddress2#" size="26" maxlength="26"><p><cfinput type="Text" class="text" name="empAddress3" value="#form.empAddress3#" size="26" maxlength="26"></p></td>
    </tr>
	<tr>
		<td align="left" class="text" width="25%"><b>Phone</b><br /><cfinput type="Text" class="text" name="empPhone" value="#form.empPhone#" size="25" maxlength="15" required="yes" message="Please enter your phone."></td>
		<td align="left" class="text" width="25%">Fax<br /><cfinput type="Text" class="text" name="empFax" value="#form.empFax#" size="25" maxlength="15"></td>
		<td align="left" class="text" width="25%">Cell<br /><cfinput type="Text" class="text" name="empCell" value="#form.empCell#" size="25" maxlength="15"></td>
		<td align="left" class="text" width="25%"><b>Email</b><br /><cfinput type="Text" class="text" name="empEmail" value="#form.empEmail#" size="25" maxlength="75" required="yes" message="Please enter your email address."></td>
	</tr>
	<tr><td align="center" class="head" colspan="4">Confidential Employee Information</td></tr>
	<tr>
		<td align="left" class="text" colspan="2"><b>Department: </b>#theDept.deptName#</td>
		<td align="left" class="text" colspan="2"><b>Date of Hire: </b>#dateformat(hireDat.flogDate,'mm/dd/yy')#</td>
	</tr>
	<tr>
		<td align="left" class="text" colspan="2">
			Marital Status<br />
			<font class="little">
			<cfif form.empStatus EQ "Married">
				<cfinput type="radio" name="empStatus" value="Single">Single
				<cfinput type="radio" name="empStatus" value="Married" checked>Married
				<cfinput type="radio" name="empStatus" value="Divorced">Divorced
				<cfinput type="radio" name="empStatus" value="Legally Separated">Legally Separated 
				<cfinput type="radio" name="empStatus" value="Widowed">Widowed
			<cfelseif form.empStatus EQ "Divorced">
				<cfinput type="radio" name="empStatus" value="Single">Single
				<cfinput type="radio" name="empStatus" value="Married">Married
				<cfinput type="radio" name="empStatus" value="Divorced" checked>Divorced
				<cfinput type="radio" name="empStatus" value="Legally Separated">Legally Separated 
				<cfinput type="radio" name="empStatus" value="Widowed">Widowed
			<cfelseif form.empStatus EQ "Legally Separated">
				<cfinput type="radio" name="empStatus" value="Single">Single
				<cfinput type="radio" name="empStatus" value="Married">Married
				<cfinput type="radio" name="empStatus" value="Divorced">Divorced
				<cfinput type="radio" name="empStatus" value="Legally Separated" checked>Legally Separated 
				<cfinput type="radio" name="empStatus" value="Widowed">Widowed
			<cfelseif form.empStatus EQ "Widowed">
				<cfinput type="radio" name="empStatus" value="Single">Single
				<cfinput type="radio" name="empStatus" value="Married">Married
				<cfinput type="radio" name="empStatus" value="Divorced">Divorced
				<cfinput type="radio" name="empStatus" value="Legally Separated">Legally Separated 
				<cfinput type="radio" name="empStatus" value="Widowed" checked>Widowed
			<cfelse>
				<cfinput type="radio" name="empStatus" value="Single" checked>Single
				<cfinput type="radio" name="empStatus" value="Married">Married
				<cfinput type="radio" name="empStatus" value="Divorced">Divorced
				<cfinput type="radio" name="empStatus" value="Legally Separated">Legally Separated 
				<cfinput type="radio" name="empStatus" value="Widowed">Widowed
			</cfif>
			</font>
		</td>
		<td align="left" class="text">
			Gender<br />
			<font class="little">
			<cfif form.empGender EQ "Male">
				<cfinput type="radio" name="empGender" value="Male" checked>Male
				<cfinput type="radio" name="empGender" value="Female">Female
			<cfelse>
				<cfinput type="radio" name="empGender" value="Male">Male
				<cfinput type="radio" name="empGender" value="Female" checked>Female
			</cfif>
			</font>
		</td>
		<td align="left" class="text"><b>Date of Birth</b> (mm/dd/yy)<br /><cfinput type="Text" class="text" name="empBirth" value="#dateformat(form.empBirth,'mm/dd/yy')#" size="25" maxlength="10" validate="date" required="yes" message="Please enter birth date in format mm/dd/yy"></td>
	</tr>
	<cfif theEmp.locCountry EQ 'US'>
        <tr>
            <td align="left" class="text" colspan="2">
                EEOC Status<br />
                <font class="little">
                <cfif form.empEEOC EQ "American Indian/Alaska Native">
                    <cfinput type="radio" name="empEEOC" value="American Indian/Alaska Native" checked>American Indian/Alaska Native
                    <cfinput type="radio" name="empEEOC" value="Asian">Asian
                    <cfinput type="radio" name="empEEOC" value="Black or African American">Black or African American<br />
                    <cfinput type="radio" name="empEEOC" value="Hispanic or Latino">Hispanic or Latino
                    <cfinput type="radio" name="empEEOC" value="I choose not to self identify">I choose not to self identify<br />
                    <cfinput type="radio" name="empEEOC" value="Nat Hawaiian/Other Pac Islander">Nat Hawaiian/Other Pac Islander
                    <cfinput type="radio" name="empEEOC" value="Not applicable (Non-US)">Not applicable (Non-US)<br />
                    <cfinput type="radio" name="empEEOC" value="Two or more races">Two or more races
                    <cfinput type="radio" name="empEEOC" value="White">White
                <cfelseif form.empEEOC EQ "Asian">
                    <cfinput type="radio" name="empEEOC" value="American Indian/Alaska Native">American Indian/Alaska Native
                    <cfinput type="radio" name="empEEOC" value="Asian" checked>Asian
                    <cfinput type="radio" name="empEEOC" value="Black or African American">Black or African American<br />
                    <cfinput type="radio" name="empEEOC" value="Hispanic or Latino">Hispanic or Latino
                    <cfinput type="radio" name="empEEOC" value="I choose not to self identify">I choose not to self identify<br />
                    <cfinput type="radio" name="empEEOC" value="Nat Hawaiian/Other Pac Islander">Nat Hawaiian/Other Pac Islander
                    <cfinput type="radio" name="empEEOC" value="Not applicable (Non-US)">Not applicable (Non-US)<br />
                    <cfinput type="radio" name="empEEOC" value="Two or more races">Two or more races
                    <cfinput type="radio" name="empEEOC" value="White">White
                <cfelseif form.empEEOC EQ "Black or African American">
                    <cfinput type="radio" name="empEEOC" value="American Indian/Alaska Native">American Indian/Alaska Native
                    <cfinput type="radio" name="empEEOC" value="Asian">Asian
                    <cfinput type="radio" name="empEEOC" value="Black or African American" checked>Black or African American<br />
                    <cfinput type="radio" name="empEEOC" value="Hispanic or Latino">Hispanic or Latino
                    <cfinput type="radio" name="empEEOC" value="I choose not to self identify">I choose not to self identify<br />
                    <cfinput type="radio" name="empEEOC" value="Nat Hawaiian/Other Pac Islander">Nat Hawaiian/Other Pac Islander
                    <cfinput type="radio" name="empEEOC" value="Not applicable (Non-US)">Not applicable (Non-US)<br />
                    <cfinput type="radio" name="empEEOC" value="Two or more races">Two or more races
                    <cfinput type="radio" name="empEEOC" value="White">White
                <cfelseif form.empEEOC EQ "Hispanic or Latino">
                    <cfinput type="radio" name="empEEOC" value="American Indian/Alaska Native">American Indian/Alaska Native
                    <cfinput type="radio" name="empEEOC" value="Asian">Asian
                    <cfinput type="radio" name="empEEOC" value="Black or African American">Black or African American<br />
                    <cfinput type="radio" name="empEEOC" value="Hispanic or Latino" checked>Hispanic or Latino
                    <cfinput type="radio" name="empEEOC" value="I choose not to self identify">I choose not to self identify<br />
                    <cfinput type="radio" name="empEEOC" value="Nat Hawaiian/Other Pac Islander">Nat Hawaiian/Other Pac Islander
                    <cfinput type="radio" name="empEEOC" value="Not applicable (Non-US)">Not applicable (Non-US)<br />
                    <cfinput type="radio" name="empEEOC" value="Two or more races">Two or more races
                    <cfinput type="radio" name="empEEOC" value="White">White
                <cfelseif form.empEEOC EQ "I choose not to self identify">
                    <cfinput type="radio" name="empEEOC" value="American Indian/Alaska Native">American Indian/Alaska Native
                    <cfinput type="radio" name="empEEOC" value="Asian">Asian
                    <cfinput type="radio" name="empEEOC" value="Black or African American">Black or African American<br />
                    <cfinput type="radio" name="empEEOC" value="Hispanic or Latino">Hispanic or Latino
                    <cfinput type="radio" name="empEEOC" value="I choose not to self identify" checked>I choose not to self identify<br />
                    <cfinput type="radio" name="empEEOC" value="Nat Hawaiian/Other Pac Islander">Nat Hawaiian/Other Pac Islander
                    <cfinput type="radio" name="empEEOC" value="Not applicable (Non-US)">Not applicable (Non-US)<br />
                    <cfinput type="radio" name="empEEOC" value="Two or more races">Two or more races
                    <cfinput type="radio" name="empEEOC" value="White">White
                <cfelseif form.empEEOC EQ "Nat Hawaiian/Other Pac Islander">
                    <cfinput type="radio" name="empEEOC" value="American Indian/Alaska Native">American Indian/Alaska Native
                    <cfinput type="radio" name="empEEOC" value="Asian">Asian
                    <cfinput type="radio" name="empEEOC" value="Black or African American">Black or African American<br />
                    <cfinput type="radio" name="empEEOC" value="Hispanic or Latino">Hispanic or Latino
                    <cfinput type="radio" name="empEEOC" value="I choose not to self identify">I choose not to self identify<br />
                    <cfinput type="radio" name="empEEOC" value="Nat Hawaiian/Other Pac Islander" checked>Nat Hawaiian/Other Pac Islander
                    <cfinput type="radio" name="empEEOC" value="Not applicable (Non-US)">Not applicable (Non-US)<br />
                    <cfinput type="radio" name="empEEOC" value="Two or more races">Two or more races
                    <cfinput type="radio" name="empEEOC" value="White">White
                <cfelseif form.empEEOC EQ "Not applicable (Non-US)">
                    <cfinput type="radio" name="empEEOC" value="American Indian/Alaska Native">American Indian/Alaska Native
                    <cfinput type="radio" name="empEEOC" value="Asian">Asian
                    <cfinput type="radio" name="empEEOC" value="Black or African American">Black or African American<br />
                    <cfinput type="radio" name="empEEOC" value="Hispanic or Latino">Hispanic or Latino
                    <cfinput type="radio" name="empEEOC" value="I choose not to self identify">I choose not to self identify<br />
                    <cfinput type="radio" name="empEEOC" value="Nat Hawaiian/Other Pac Islander">Nat Hawaiian/Other Pac Islander
                    <cfinput type="radio" name="empEEOC" value="Not applicable (Non-US)" checked>Not applicable (Non-US)<br />
                    <cfinput type="radio" name="empEEOC" value="Two or more races">Two or more races
                    <cfinput type="radio" name="empEEOC" value="White">White
                <cfelseif form.empEEOC EQ "Two or more races">
                    <cfinput type="radio" name="empEEOC" value="American Indian/Alaska Native">American Indian/Alaska Native
                    <cfinput type="radio" name="empEEOC" value="Asian">Asian
                    <cfinput type="radio" name="empEEOC" value="Black or African American">Black or African American<br />
                    <cfinput type="radio" name="empEEOC" value="Hispanic or Latino">Hispanic or Latino
                    <cfinput type="radio" name="empEEOC" value="I choose not to self identify">I choose not to self identify<br />
                    <cfinput type="radio" name="empEEOC" value="Nat Hawaiian/Other Pac Islander">Nat Hawaiian/Other Pac Islander
                    <cfinput type="radio" name="empEEOC" value="Not applicable (Non-US)">Not applicable (Non-US)<br />
                    <cfinput type="radio" name="empEEOC" value="Two or more races" checked>Two or more races
                    <cfinput type="radio" name="empEEOC" value="White">White
                <cfelseif form.empEEOC EQ "White">
                    <cfinput type="radio" name="empEEOC" value="American Indian/Alaska Native">American Indian/Alaska Native
                    <cfinput type="radio" name="empEEOC" value="Asian">Asian
                    <cfinput type="radio" name="empEEOC" value="Black or African American">Black or African American<br />
                    <cfinput type="radio" name="empEEOC" value="Hispanic or Latino">Hispanic or Latino
                    <cfinput type="radio" name="empEEOC" value="I choose not to self identify">I choose not to self identify<br />
                    <cfinput type="radio" name="empEEOC" value="Nat Hawaiian/Other Pac Islander">Nat Hawaiian/Other Pac Islander
                    <cfinput type="radio" name="empEEOC" value="Not applicable (Non-US)">Not applicable (Non-US)<br />
                    <cfinput type="radio" name="empEEOC" value="Two or more races">Two or more races
                    <cfinput type="radio" name="empEEOC" value="White" checked>White
                <cfelse>
                    <cfset form.empID = #session.empID#>
                    <cfset form.empEEOC = "">
                    <cfupdate datasource="#session.orgData#" tablename="employees" formfields="empID, empEEOC"> 
                    <cfinput type="radio" name="empEEOC" value="American Indian/Alaska Native">American Indian/Alaska Native
                    <cfinput type="radio" name="empEEOC" value="Asian">Asian
                    <cfinput type="radio" name="empEEOC" value="Black or African American">Black or African American<br />
                    <cfinput type="radio" name="empEEOC" value="Hispanic or Latino">Hispanic or Latino
                    <cfinput type="radio" name="empEEOC" value="I choose not to self identify">I choose not to self identify<br />
                    <cfinput type="radio" name="empEEOC" value="Nat Hawaiian/Other Pac Islander">Nat Hawaiian/Other Pac Islander
                    <cfinput type="radio" name="empEEOC" value="Not applicable (Non-US)">Not applicable (Non-US)<br />
                    <cfinput type="radio" name="empEEOC" value="Two or more races">Two or more races
                    <cfinput type="radio" name="empEEOC" value="White">White
                </cfif>
                </font>
            </td>
            <td align="left" class="text">
                Disability Status<br />
                <font class="little">
                <cfif form.empDis EQ "1">
                    <cfinput type="radio" name="empDis" value="1" checked>Yes
                    <cfinput type="radio" name="empDis" value="0">No
                <cfelse>
                    <cfinput type="radio" name="empDis" value="1">Yes
                    <cfinput type="radio" name="empDis" value="0" checked>No
                </cfif>
                </font>
            </td>
            <td align="left" class="text">
                Veteran Status<br />
                <font class="little">
                <cfif form.empVet EQ "1">
                    <cfinput type="radio" name="empVet" value="1" checked>Yes
                    <cfinput type="radio" name="empVet" value="0">No
                <cfelse>
                    <cfinput type="radio" name="empVet" value="1">Yes
                    <cfinput type="radio" name="empVet" value="0" checked>No
                </cfif>
                </font>
            </td>
        </tr>
    <cfelse>
		<input type="hidden" name="empEEOC" value="n/a">
		<input type="hidden" name="empDis" value="0">
		<input type="hidden" name="empVet" value="0">
    </cfif>
	<tr><td align="center" class="head" colspan="4">Emergency Contact Information</td></tr>
	<tr>
		<td align="left" class="text" colspan="2" width="50%"><b>Emergency Contact Name</b><br><cfinput type="Text" class="text" name="emerName" value="#form.emerName#" size="50" maxlength="50" required="yes" message="Please enter an emergency contact name."></td>
		<td align="left" class="text" width="25%"><b>Emergency Phone</b><br /><cfinput type="Text" class="text" name="emerTel" value="#form.emerTel#" size="25" maxlength="15" required="yes" message="Please enter and emergency contact phone."></td>
		<td align="left" class="text" width="25%"><b>Relationship</b><br /><cfinput type="Text" class="text" name="emerRel" value="#form.emerRel#" size="25" maxlength="15" required="yes" message="Please enter relationship to your emergency contact."></td>
	</tr>
	<cfif theEmp.ldgAvail>
		<cfif theEmp.ldgOK>
			<tr><td align="center" class="head" colspan="4">Roommate/Housing Preferences</td></tr>
			<tr><td align="left" class="text" colspan="4">Preferred Roommate Name<br><cfinput type="Text" class="text" name="empRoomie" value="#form.empRoomie#" size="50" maxlength="50"></td></tr>
			<tr valign="top">
				<td align="left" class="text" width="25%">
					Smoking Habits<br />
					<font class="little">
					<cfif form.empSmoke EQ "1">
						<cfinput type="radio" name="empSmoke" value="1" checked> I am a smoker.<br /><cfinput type="radio" name="empSmoke" value="0"> I am a non-smoker.
					<cfelse>
						<cfinput type="radio" name="empSmoke" value="1"> I am a smoker.<br /><cfinput type="radio" name="empSmoke" value="0" checked> I am a non-smoker.
					</cfif>
					</font>
				</td>
				<td align="left" class="text" width="25%">
					Sleeping Habits<br />
					<font class="little">
					<cfif form.ldgSleep EQ "Early Bird">
						<cfinput type="radio" name="ldgSleep" value="Early Bird" checked>Early Bird<br />
						<cfinput type="radio" name="ldgSleep" value="Late Riser">Late Riser<br />
						<cfinput type="radio" name="ldgSleep" value="No Pref">No Preference
					<cfelseif form.ldgSleep EQ "Late Riser">
						<cfinput type="radio" name="ldgSleep" value="Early Bird">Early Bird<br />
						<cfinput type="radio" name="ldgSleep" value="Late Riser" checked>Late Riser<br />
						<cfinput type="radio" name="ldgSleep" value="No Pref">No Preference
					<cfelse>
						<cfinput type="radio" name="ldgSleep" value="Early Bird">Early Bird<br />
						<cfinput type="radio" name="ldgSleep" value="Late Riser">Late Riser<br />
						<cfinput type="radio" name="ldgSleep" value="No Pref" checked>No Preference
					</cfif>
					</font>
				</td>
				<td align="left" class="text" width="25%">
					Housekeeping Habits<br />
					<font class="little">
					<cfif form.ldgNeat EQ "Neat Freak">
						<cfinput type="radio" name="ldgNeat" value="Neat Freak" checked>Neat Freak<br />
						<cfinput type="radio" name="ldgNeat" value="Freestyle">Freestyle<br />
						<cfinput type="radio" name="ldgNeat" value="No Pref">No Preference
					<cfelseif form.ldgNeat EQ "Freestyle">
						<cfinput type="radio" name="ldgNeat" value="Neat Freak">Neat Freak<br />
						<cfinput type="radio" name="ldgNeat" value="Freestyle" checked>Freestyle<br />
						<cfinput type="radio" name="ldgNeat" value="No Pref">No Preference
					<cfelse>
						<cfinput type="radio" name="ldgNeat" value="Neat Freak">Neat Freak<br />
						<cfinput type="radio" name="ldgNeat" value="Freestyle">Freestyle<br />
						<cfinput type="radio" name="ldgNeat" value="No Pref" checked>No Preference
					</cfif>
					</font>
				</td>
				<td align="left" class="text" width="25%">
					Battle of the Bunk<br />
					<font class="little">
					<cfif form.ldgBunk EQ "Top Bunk is Mine">
						<cfinput type="radio" name="ldgBunk" value="Top Bunk is Mine" checked>Top Bunk is Mine<br />
						<cfinput type="radio" name="ldgBunk" value="Afraid of Heights">Afraid of Heights<br />
						<cfinput type="radio" name="ldgBunk" value="No Pref">No Preference
					<cfelseif form.ldgBunk EQ "Afraid of Heights">
						<cfinput type="radio" name="ldgBunk" value="Top Bunk is Mine">Top Bunk is Mine<br />
						<cfinput type="radio" name="ldgBunk" value="Afraid of Heights" checked>Afraid of Heights<br />
						<cfinput type="radio" name="ldgBunk" value="No Pref">No Preference
					<cfelse>
						<cfinput type="radio" name="ldgBunk" value="Top Bunk is Mine">Top Bunk is Mine<br />
						<cfinput type="radio" name="ldgBunk" value="Afraid of Heights">Afraid of Heights<br />
						<cfinput type="radio" name="ldgBunk" value="No Pref" checked>No Preference
					</cfif>
					</font>
				</td>
			</tr>
		</cfif>
	</cfif>
	<tr><td align="center" class="head" colspan="4">Driver Information</td></tr>
	<tr>
		<td align="left" class="text">
			Valid driver's license?<br />
			<font class="little">
			<cfif form.dlValid EQ "1">
				<cfinput type="radio" name="dlValid" value="1" checked>Yes
				<cfinput type="radio" name="dlValid" value="0">No
			<cfelse>
				<cfinput type="radio" name="dlValid" value="1">Yes
				<cfinput type="radio" name="dlValid" value="0" checked>No
			</cfif>
			</font>
		</td>
		<td align="left" class="text" width="25%">License Number<br /><cfinput type="Text" class="text" name="dlNum" value="#form.dlNum#" size="20" maxlength="20"></td>
		<td align="left" class="text" width="25%">License <cfif theEmp.locCountry EQ 'US'>State<cfelse>Province</cfif><br /><cfinput type="Text" class="text" name="dlState" value="#form.dlState#" size="20" maxlength="20"></td>
		<td>&nbsp;</td>
	</tr>
	<!---
	<tr><td align="center" class="head" colspan="4">Commute Information (Seattle Only)</td></tr>
	<tr>
		<td align="left" class="text">
			Mode of Transport<br />
			<font class="little">
			<cfif form.empTrans EQ "Rideshare/Commute">
				<cfinput type="radio" name="empTrans" value="Rideshare/Commute" checked>Rideshare/Commute<br />
				<cfinput type="radio" name="empTrans" value="Drive to Work">Drive to Work
				<cfinput type="radio" name="empTrans" value="Other">Other
			<cfelseif form.empTrans EQ "Drive to Work">
				<cfinput type="radio" name="empTrans" value="Rideshare/Commute">Rideshare/Commute<br />
				<cfinput type="radio" name="empTrans" value="Drive to Work" checked>Drive to Work
				<cfinput type="radio" name="empTrans" value="Other">Other
			<cfelse>
				<cfinput type="radio" name="empTrans" value="Rideshare/Commute">Rideshare/Commute<br />
				<cfinput type="radio" name="empTrans" value="Drive to Work">Drive to Work
				<cfinput type="radio" name="empTrans" value="Other" checked>Other
			</cfif>
			</font>
		</td>
		<td align="left" class="text" width="25%">Make/Year of Vehicle<br /><cfinput type="Text" class="text" name="vehMake" value="#form.vehMake#" size="25" maxlength="25"></td>
		<td align="left" class="text" width="25%">Color of Vehicle<br /><cfinput type="Text" class="text" name="vehColor" value="#form.vehColor#" size="25" maxlength="15"></td>
		<td align="left" class="text" width="25%">Plate Number<br /><cfinput type="Text" class="text" name="vehPlate" value="#form.vehPlate#" size="25" maxlength="15"></td>
	</tr>
	--->
	<tr>
		<td class="text" align="left" colspan="2" width="50%">
			<cfif URL.AFX EQ 1>
				<b>By typing the security characters at right as my online signature I approve this hiring form.</b>
			<cfelse>
				<b>By typing the security characters at right as my online signature I acknowledge the above to be true.</b>
			</cfif>
		</td>
		<td align="left" colspan="2" class="little" width="50%">
			<cfif len(errors) GT 0><font color="red"><b>#errors#</b></font><br /></cfif>
			<input type="hidden" name="formID" value="#form.formID#">
			<input type="hidden" name="empID" value="#form.empID#">
			<cfimage action="captcha" text="#captcha#">
			<input type="hidden" name="captchaHash" value="#captchaHash#">
			<input type="text" name="captcha">
			
			<input type="hidden" name="oLogName" value="#form.oLogName#">
			<input type="hidden" name="oLogAddr1" value="#form.oLogAddr1#">
			<input type="hidden" name="oLogCon" value="#form.oLogCon#">
			<input type="hidden" name="oLogID" value="#form.oLogID#">
			<input type="hidden" name="oLogStat" value="#form.oLogStat#">
			<input type="hidden" name="oLogEmer" value="#form.oLogEmer#">
			<input type="hidden" name="oLogLdg" value="#form.oLogLdg#">
			<input type="hidden" name="oLogDrive" value="#form.oLogDrive#">
		</td>
	</tr>
	</table>
	<p align="center" class="text">
	<cfif URL.AFX EQ 1>
		<input type="submit" class="text" name="send" value="Approve Form"> Any Revisions Will be Saved
	<cfelse>
		<a href="JavaScript:window.print();">Print this Form</a> <input type="submit" class="text" name="send" value="Submit Form"> <a href="JavaScript:window.print();">Print this Form</a>
	</cfif>
	</p>
	</cfform>
	</cfoutput>
</cfif>

<cfoutput>
<cfinclude template="../_ptsB.cfm">
</cfoutput>