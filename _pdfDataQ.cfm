<!--- Report parameters. ---><head>
<link rel="stylesheet" href="../../_style.css" media="screen" type="text/css">
<link rel="stylesheet" media="print" href="../print.css" type="text/css" />
</head>


<!--- Queries needed for form fields. --->
<cfquery datasource="#session.orgData#" name="theDept">
SELECT deptName FROM departments
WHERE deptID = #theEmp.deptID#
</cfquery>

<cfquery datasource="#session.orgData#" name="hireDat">
SELECT flogDate FROM formlog
WHERE empID=#theEmp.empID#
ORDER BY flogDate
</cfquery>


<!--- Create form document. --->
<cfoutput>
<cfset fLink = 'http://www.hapdox.com/_emps/' & year(now()) & '/' & theEmp.empID & '/' & lcase(theEmp.empLast) & '_' & lcase(theEmp.empFirst) & '_dataquest_' & dateformat(now(),'mmdd') & LSTimeFormat(now(),'HHMMSS') & '.pdf'>
<cfset dPath = 'e:\web\hapdox.com\_emps\' & year(now()) & '\' & theEmp.empID & '\'>
<cfset fPath = dPath & lcase(theEmp.empLast) & '_' & lcase(theEmp.empFirst) & '_dataquest_' & dateformat(now(),'mmdd') & LSTimeFormat(now(),'HHMMSS') & '.pdf'>
<cfif NOT directoryexists(dpath)><cfdirectory directory="#dpath#" action="create"></cfif>

<cfdocument format="pdf" filename="#fPath#" overwrite="true">
<p><b>Emp ID #theEmp.empID#</b></p>
<h1 align="center">Data Questionnaire</h1>
<table width="800" align="center" cellpadding="10" cellspacing="0" border="1">
<tr>
	<td align="left" class="text" width="25%"><b>First Name</b><br />#theEmp.empFirst#</td>
	<td align="left" class="text" width="25%"><b>Middle Name</b><br />#theEmp.empMiddle#</td>
	<td align="left" class="text" width="25%"><b>Last Name</b><br />#theEmp.empLast#</td>
	<td align="left" class="text" width="25%"><b>SSN</b><br />#theEmp.empEIN#</td>
</tr>
<tr><td align="center" class="head" colspan="4">Mailing Address & Contact Information</td></tr>
<tr>
	<td align="left" class="text" width="25%"><b>Address 1</b><br />#theEmp.empAddress1#</td>
	<td align="left" class="text" width="25%"><b>Address 2</b><br />#theEmp.empAddress2#</td>
	<td align="left" class="text" width="25%"><b>Address 3</b><br />#theEmp.empAddress3#</td>
	<td align="left" class="text" width="25%"><b>City</b><br />#theEmp.empCity#</td>
</tr>
<tr>
	<td align="left" class="text" width="50%"><b>State or Prov/Country</b><br />#theEmp.empState# #theEmp.empCountry#</td>
	<td align="left" class="text" width="50%"><b>Zip</b><br />#theEmp.empZip#</td>
</tr>

<tr>
	<td align="left" class="text" width="25%"><b>Phone</b><br />#theEmp.empPhone#</td>
	<td align="left" class="text" width="25%"><b>Fax</b><br />#theEmp.empFax#</td>
	<td align="left" class="text" width="25%"><b>Cell</b><br />#theEmp.empCell#</td>
	<td align="left" class="text" width="25%"><b>Email</b><br />#theEmp.empEmail#</td>
</tr>
<tr><td align="center" class="head" colspan="4">Confidential Employee Information</td></tr>
<tr>
	<td align="left" class="text" colspan="2"><b>Department: </b>#theDept.deptName#</td>
	<td align="left" class="text" colspan="2"><b>Date of Hire: </b>#dateformat(hireDat.flogDate,'mm/dd/yy')#<br>
DOB:#dateformat(theEmp.empBirth,'m/d/yy')#
</td>
</tr>
<tr>
	<td align="left" class="text" width="25%"><b>Marital</b><br />#theEmp.empStatus#</td>
	<td align="left" class="text" width="25%"><b>Gender</b><br />#theEmp.empGender#</td>
	<td align="left" class="text" width="25%"><b>EEOC</b><br />#theEmp.empEEOC#</td>
	<td align="left" class="text" width="25%"><b>Disabled?</b><br /><cfif theEmp.empDis EQ "1">Yes<cfelse>No</cfif>
</tr>
<tr>
	<td align="left" class="text" width="25%"><b>Vet?</b><br /><cfif theEmp.empVet EQ "1">Yes<cfelse>No</cfif>
	<td align="left" class="text" width="25%"><b>Emergency Contact</b><br>#theEmp.emerName#</td>
	<td align="left" class="text" width="25%"><b>Emergency Phone</b><br>#theEmp.emerTel#</td>
	<td align="left" class="text" width="25%"><b>Relationship</b><br>#theEmp.emerRel#</td>
</tr>
<tr>
	<td align="left" class="text" width="25%"><b>Roommate</b><br />#theEmp.empRoomie#</td>
	<td align="left" class="text" width="25%"><b>Smoke?</b><br /><cfif theEmp.empSmoke EQ "1">Yes<cfelse>No</cfif></td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td align="left" class="text" width="25%"><b>Sleeping?</b><br>#theEmp.ldgSleep#</td>
	<td align="left" class="text" width="25%"><b>Neat?</b><br>#theEmp.ldgNeat#</td>
	<td align="left" class="text" width="25%"><b>Bunk?</b><br>#theEmp.ldgBunk#</td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td align="left" class="text" width="25%"><b>DL Valid?</b><br /><cfif theEmp.dlValid EQ "1">Yes<cfelse>No</cfif></td>
	<td align="left" class="text" width="25%"><b>License</b><br>#theEmp.dlNum#</td>
	<td align="left" class="text" width="25%"><b>State</b><br>#theEmp.dlState#</td>
	<td>&nbsp;</td>
</tr>
</table>
</cfdocument>
</cfoutput>