<!--- If new or timeout request login. --->
<cfif session.orgID LT 0>
	<cflocation URL="../_login.cfm" addtoken="no">
	<cfabort>
</cfif>

<!--- Report parameters. --->
<cfparam name="URL.d" default="0">
<link rel="stylesheet" href="../../_style.css" media="screen" type="text/css">
<link rel="stylesheet" media="print" href="../print.css" type="text/css" />
</head>

<cfoutput>
<cfquery datasource="#session.orgData#" name="TheEmps">
SELECT deptContact, employees.empID, empFirst, empMiddle, empLast, empEIN, empPhone, empEmail, employees.jobID, locAbbrev, flogDate, jobs.jobName, jobs.locID, jobs.deptID, locations.locName, departments.deptName, formlog.formID, formName, formlog.flogType, forms.formType FROM employees, jobs, locations, departments, formlog, forms
WHERE employees.orgID=#session.orgID# AND empActive='a' AND empType='s' AND employees.jobID=jobs.jobID AND employees.deptID=departments.deptID
	AND employees.locID=locations.locID AND employees.empID=formlog.empID AND forms.formID=formlog.formID AND year(flogDate)=#year(now())#
	<cfif session.deptAdmin> AND employees.deptID=#session.deptID#</cfif>
	<cfif session.locAdmin> AND locations.locID=#session.locID#</cfif>
	AND (forms.locCountry='all' OR forms.locCountry=locations.locCountry) AND formActive='a'
ORDER BY locations.locName, departments.deptID, jobs.jobID, empLast, employees.empID, formID, flogDate DESC</cfquery>

<cfset gCtr = 0>
<cfset tCtr = 0>
<h1 align="center"><cfoutput>#session.siteName#</cfoutput><br /><font class="text"><b>Seasonal Employee Listing by Department / Position</b></font></h1>
</cfoutput>

<table width="750" border="1" align="center" cellpadding="3" cellspacing="0">
<cfoutput query="TheEmps" group="deptID">
<cfset gCtr = 0>
<cfset cCtr = 0>
<tr><td align="center" class="text" colspan="4">Loc: #locName# | Dept: #deptName# (#deptContact#)</td></tr>
<cfoutput group="empID">
<tr>
	<td class="little">#jobName#&nbsp;</td>
	<td class="little">#empLast#, #empFirst# #empMiddle#&nbsp;</td>
	<td class="little" align="center"><a href="mailto:#empEmail#">#empEmail#</a> | #empPhone#&nbsp;</td>
	<td class="little" align="left">
		<cfset appCtr = 0><cfset resCtr = 0><cfset dueCtr = 0><cfset reqCtr = 0>
		<cfoutput group="formID">
		<cfif formType NEQ 'z'>
			<cfset dCtr=0>
			<cfoutput>
			<cfif dCtr EQ 0>
				<!--- #flogType#(#dateformat(flogDate,'m/d')#)<br />--->
				<cfif flogType EQ 'app'>
					<cfset appCtr = appCtr + 1>
				<cfelseif flogType EQ 'res'>
					<cfset resCtr = resCtr + 1>
				<cfelseif flogType EQ 'req'>
					<cfif dateadd('d',-10,now()) GT flogDate>
						<cfset dueCtr = dueCtr + 1>	
					<cfelse>
						<cfset reqCtr = reqCtr + 1>
					</cfif>
				</cfif>
				<cfset dCtr=1>
			</cfif>
			</cfoutput>
		</cfif>
		</cfoutput>
		<cfif dueCtr GT 0>
			<font color="red">Overdue</font>
		<cfelseif reqCtr GT 0>
			<font color="purple">Employee Forms Sent</font>
		<cfelseif resCtr GT 0>
			<font color="blue">Employee Forms Returned</font>
		<cfelseif appCtr GT 0>
			<font color="green">Forms Approved</font>
		</cfif>
	</td>
</tr>
<cfset gCtr = gCtr+1>
<cfset tCtr = tCtr+1>
</cfoutput>
<tr><td align="right" colspan="6" class="little"><b>#gCtr# Group Records</b></td></tr>
</cfoutput>
</table>

<cfoutput>
<table width="750" border="0" align="center" cellpadding="3" cellspacing="0">
<tr>
	<td align="left" colspan="3" class="little"><b>#dateformat(now(),'mm/dd/yy')# #timeformat(now(),'long')#</b></td>
	<td align="right" colspan="3" class="little"><b>#tCtr# Total Records</b></td>
</tr>
</table>
</cfoutput>
