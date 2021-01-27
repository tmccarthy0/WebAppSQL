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
SELECT employees.empID, empLast, empMiddle, empFirst, locAbbrev, empEmail, empPhone, refName, refLoc, jobName FROM employees, locations, jobs
WHERE employees.orgID=#session.orgID# AND empActive='a' AND employees.locID=locations.locID AND employees.jobID=jobs.jobID AND employees.empID>28274
	<cfif session.locAdmin> AND employees.locID=#session.locID#</cfif>
ORDER BY empLast, empFirst
</cfquery>

<h1 align="center"><cfoutput>#session.siteName#</cfoutput><br /><font class="text"><b>Employee Referrals Listing</b></font></h1>
<table width="1000" border="1" align="center" cellpadding="1" cellspacing="0">
<tr>
	<td class="little" align="center"><b>empID</b></td>
	<td class="little" align="center"><b>Emp Name</b></td>
	<td class="little" align="center"><b>Job Name</b></td>
	<td class="little" align="center"><b>Location</b></td>
	<td class="little" align="center"><b>Refer Name</b></td>
	<td class="little" align="center"><b>Refer Loc</b></td>
	<td class="little" align="center"><b>Email</b></td>
	<td class="little" align="center"><b>Phone</b></td>
</tr>
<cfset eCtr = 0>
<cfoutput query="TheEmps">
<cfif len(refName) GT 0>
	<tr>
		<td class="little" align="center">#empID#</td>
		<td class="little" align="left">#empFirst# #empMiddle# #empLast#</td>
		<td class="little" align="center">#jobName#</td>
		<td class="little" align="center">#locAbbrev#</td>
		<td class="little" align="left">#refName#&nbsp;</td>
		<td class="little" align="left">#refLoc#&nbsp;</td>
		<td class="little" align="left"><a href="mailto:empEmail">#empEmail#</a></td>
		<td class="little" align="center">#empPhone#&nbsp;</td>
	</tr>
	<cfset eCtr = eCtr+1>
</cfif>
</cfoutput>

<cfoutput>
<tr><td align="right" colspan="9" class="little"><b>#eCtr# Total</b></td></tr>
</table>
</cfoutput>
