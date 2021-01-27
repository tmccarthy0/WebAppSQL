<!--- If new or timeout request login. --->
<cfif session.orgID LT 0>
	<cflocation URL="../_login.cfm" addtoken="no">
	<cfabort>
</cfif>

<link rel="stylesheet" href="../../_style.css" media="screen" type="text/css">
<link rel="stylesheet" media="print" href="../print.css" type="text/css" />
</head>

<cfoutput>
<cfquery datasource="#session.orgData#" name="TheEmps">
SELECT * FROM employees, locations, departments
WHERE employees.orgID=#session.orgID# AND employees.locID=locations.locID AND employees.deptID=departments.deptID AND year(empEnd)=#session.repTime# AND empActive='a' AND ldgAvail AND ldgOK
	<cfif session.locAdmin> AND locations.locID=#session.locID#</cfif>
	<cfif session.deptAdmin> AND departments.locID=#session.locID#</cfif>
ORDER BY locAbbrev, deptAbbrev, empLast, empFirst
</cfquery>

<h1 align="center"><cfoutput>#session.siteName#</cfoutput><br /><font class="text"><b>Employee Housing Preferences by Department</b></font></h1>
</cfoutput>

<table border="1" align="center" cellpadding="3" cellspacing="0">
<cfset tCtr = 0>
<tr>
	<td class="text" align="center"><b>Location</b></td>
	<td class="text" align="center"><b>Employee</b></td>
	<td class="text" align="center"><b>Meals/Day</b></td>
	<td class="text" align="center"><b>Meals/Each</b></td>
	<td class="text" align="center"><b>Meal Disc</b></td>
	<td class="text" align="center"><b>Housing Cost</b></td>
	<td class="text" align="center"><b>Smoking</b></td>
	<td class="text" align="center"><b>Roomie</b></td>
	<td class="text" align="center"><b>Other</b></td>
</tr>
<cfoutput query="TheEmps">
<tr>
	<td class="text" align="right">#locAbbrev# | #deptAbbrev#</td>
	<td class="text" align="left">#empLast#, #empFirst# #empMiddle#</td>
	<td class="text" align="center"><cfif foodCostDay GT 0>#dollarformat(foodCostDay)#<cfelse>&nbsp;</cfif></td>
	<td class="text" align="center"><cfif foodCostEach GT 0>#dollarformat(foodCostEach)#<cfelse>&nbsp;</cfif></td>
	<td class="text" align="center"><cfif foodDiscount GT 0>#foodDiscount#%<cfelse>&nbsp;</cfif></td>
	<td class="text" align="center"><cfif ldgCost GT 0>#dollarformat(ldgCost)#<cfelse>&nbsp;</cfif></td>
	<td class="text" align="center"><cfif empSmoke EQ 0>Nonsmoker<cfelse>Smoker</cfif></td>
	<td class="text" align="center">#empRoomie#&nbsp;</td>
	<td class="text" align="center">#ldgSleep#, #ldgNeat#, #ldgBunk#&nbsp;</td>
</tr>
<cfset tCtr = tCtr+1>
</cfoutput>

<cfoutput>
<tr>
	<td align="left" class="text" colspan="3"><b>#dateformat(now(),'mm/dd/yy')#</b></td>
	<td align="right" class="text" colspan="6"><b>#tCtr# Total Records</b></td>
</tr>
</cfoutput>
</table>
