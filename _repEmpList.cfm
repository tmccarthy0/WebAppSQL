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
WHERE employees.orgID=#session.orgID# AND employees.deptID=departments.deptID AND departments.locID=locations.locID AND employees.jobID=jobs.jobID and employees.empBirth is not null and employees.empAddress1 is not null
	<cfif session.deptAdmin> AND employees.deptID=#session.deptID#</cfif>
	<cfif session.locAdmin> AND departments.locID=#session.locID#</cfif>
	<cfif URL.y EQ year(now())>AND empActive='a'<cfelse>AND empActive='t' <cfif isdate('empTerminate')>AND #year(empTerminate)#=#URL.y#</cfif></cfif>
ORDER BY locName, deptName, empLast, empFirst
</cfquery>

<cfoutput>
<h1 align="center">#session.orgName#</h1>
<h2 align="center"><cfif URL.y LT year(now())>Unhired Employees from #URL.y#<cfelse>#URL.y# Active Employee Listing</cfif></h2>
</cfoutput>

<table width="800" border="1" align="center" cellpadding="1" cellspacing="0">
<cfset eCtr = 0>
<cfoutput query="TheEmps" group="locName">
<cfset lCtr = 0>
<cfoutput group="deptName">
<cfset dCtr = 0>
<tr><td class="text" colspan="14"><b>#locName# - #deptName#</b></td></tr>
<tr>
	<td class="little" align="center"><b>EHire ID</b></td>
	<td class="little" align="center"><b>Emp Name<br />Status</b></td>
	<td class="little" align="center"><b>Birthdate</b></td>
	<td class="little" align="center"><b>Position</b></td>
	<td class="little" align="center"><b>PCN</b></td>
	<td class="little" align="center"><b>Training Wage/ Hourly Rate</b></td>
	<td class="little" align="center"><b>Training Date<br />Contract Beg to End</b></td>
	<td class="little" align="center"><b>Country</b></td>
	<td class="little" align="center"><b>Phone<br />Email</b></td>
	<td class="little" align="center"><b>Photo Release</b></td>
	<td class="little" align="center"><b>Type of Bonus</b></td>
	<td class="little" align="center"><b>Service Years</b></td>
	<td class="little" align="center"><b>Longevity</b></td>
	<td class="little" align="center"><b>Bonus Percentage</b></td>
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
	<td class="little">#jobName#</td>
	<td class="little">#jobCode#</td>
	<td class="little">#dollarformat(wageT1)#&nbsp;<br />/#dollarformat(wageHr)#</td>
	<td class="little" align="center">#dateformat(empTrain,'m/d/y')#&nbsp;<br />#dateformat(empBeg,'m/d/y')# to #dateformat(empEnd,'m/d/y')#</td>
	<td class="little">#empCountry#&nbsp;</td>
	<td class="little" align="center">#empPhone#&nbsp;<br /><a href="mailto:empEmail">#empEmail#</a></td>
	<td class="little"><cfif photoOK EQ "1">
			Yes
		<cfelse>
			No
		</cfif></td>
<td class="little"><cfif wageIncAvl EQ "1">
			Non-Driver Bonus </cfif>
	
		<cfif wageIncAvl EQ "2">	
			Driver Bonus
		</cfif>
		<cfif wageIncAvl EQ "0">	
			No Bonus
		</cfif></td>
	<td class="little">#wageIncYrs#</td>
	<td class="little">#wageIncLng#</td>
	<td class="little">#wageIncPct#</td>
</tr>
<cfset eCtr = eCtr+1>
<cfset dCtr = dCtr+1>
<cfset lCtr = lCtr+1>
</cfoutput>
<tr><td align="right" colspan="14" class="little"><b>#dCtr# Dept</b></td></tr>
</cfoutput>
<tr><td align="right" colspan="14" class="little"><b>#lCtr# Loc</b></td></tr>
</cfoutput>

<cfoutput>
<tr><td align="right" colspan="14" class="little"><b>#eCtr# Total</b></td></tr>
</table>
</cfoutput>
