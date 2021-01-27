<!--- If new or timeout request login. --->
<cfif session.orgID LT 0>
	<cflocation URL="../_login.cfm" addtoken="no">
	<cfabort>
</cfif>

<!--- Report parameters. --->
<cfparam name="URL.s1" default="">
<cfparam name="URL.s2" default="">
<cfparam name="URL.d" default="0">
<cfparam name="URL.y" default="#year(now())#">

<link rel="stylesheet" href="../../_style.css" media="screen" type="text/css">
<link rel="stylesheet" media="print" href="../print.css" type="text/css" />
</head>

<cfquery datasource="#session.orgData#" name="TheEmps">
SELECT * FROM employees, departments, locations, jobs
WHERE employees.orgID=#session.orgID# AND employees.deptID=departments.deptID AND departments.locID=locations.locID AND employees.jobID=jobs.jobID and employees.empAddress1 is null
	<cfif session.deptAdmin> AND employees.deptID=#session.deptID#</cfif>
	<cfif session.locAdmin> AND departments.locID=#session.locID#</cfif>
	<cfif URL.y EQ year(now())>AND empActive='a'<cfelse>AND empActive='t' <cfif isdate('empTerminate')>AND #year(empTerminate)#=#URL.y#</cfif></cfif>
ORDER BY locName, deptName, empLast, empFirst
</cfquery>

<cfoutput>
<h1 align="center">#session.orgName#</h1>
<h2 align="center"><cfif URL.y LT year(now())>Unhired Employees from #URL.y#<cfelse>#URL.y# Active Employee Missing Information Listing</cfif></h2>
</cfoutput>

<table width="800" border="1" align="center" cellpadding="1" cellspacing="0">
<cfset eCtr = 0>
<cfoutput query="TheEmps" group="locName">
<cfset lCtr = 0>
<cfoutput group="deptName">
<cfset dCtr = 0>
<tr><td class="text" colspan="14"><b>#locName# - #deptName#</b></td></tr>
<tr>
	<td class="little" align="center"><b>eHire ID</b></td>
	<td class="little" align="center"><b>Emp Name<br />Status</b></td>
	<td class="little" align="center"><b>Birthdate</b></td>
	<td class="little" align="center"><b>Address_1</b></td>
	<td class="little" align="center"><b>Address_2</b></td>
	<td class="little" align="center"><b>Address_3</b></td>
	<td class="little" align="center"><b>City</b></td>
	<td class="little" align="center"><b>State</b></td>
	<td class="little" align="center"><b>Province</b></td>
	<td class="little" align="center"><b>Country</b></td>
	<td class="little" align="center"><b>SSN</b></td>
</tr>
<cfoutput>
<tr>
	
	<td class="little">#empID#</td>
	<td class="little">
		#empLast#, #empFirst# #empMiddle#<br />
		<cfif empActive EQ "a">
			Active
		<cfelse>
			Terminated #dateformat(empTerminate,'mm/dd/yy')#
		</cfif>
	</td>
	<td class="little">#dateformat(empBirth, 'm/d/y')#</td>
	<td class="little">#empAddress1#</td>
	<td class="little">#empAddress2#</td>
	<td class="little">#empAddress3#</td>
	<td class="little">#empCity#</td>
	<td class="little">#empState#</td>
	<td class="little">#empProvince#</td>
	<td class="little">#empCountry#&nbsp;</td>
	<td class="little">#empEIN#</td>
</tr>
<cfset eCtr = eCtr+1>
<cfset dCtr = dCtr+1>
<cfset lCtr = lCtr+1>
</cfoutput>
<tr><td align="right" colspan="11" class="little"><b>#dCtr# Dept</b></td></tr>
</cfoutput>
<tr><td align="right" colspan="11" class="little"><b>#lCtr# Loc</b></td></tr>
</cfoutput>

<cfoutput>
<tr><td align="right" colspan="11" class="little"><b>#eCtr# Total</b></td></tr>
</table>
</cfoutput>
