<cfquery datasource="#session.orgData#" name="TheEmps">
SELECT employees.empID, empLast, empMiddle, empFirst, jobName, locAbbrev, empEIN, empEmail, empPhone, refName, refLoc FROM employees, locations, jobs
WHERE employees.orgID=#session.orgID# AND empActive='a' AND employees.locID=locations.locID AND employees.jobID=jobs.jobID AND employees.empID>28274
	<cfif session.locAdmin> AND employees.locID=#session.locID#</cfif>
ORDER BY empLast, empFirst
</cfquery>

<cfsavecontent variable="report">
<table border="1">
<tr>
	<td class="little" align="center"><b>empID</b></td>
	<td class="little" align="center"><b>Last</b></td>
	<td class="little" align="center"><b>First</b></td>
	<td class="little" align="center"><b>Middle</b></td>
	<td class="little" align="center"><b>Job Name</b></td>
	<td class="little" align="center"><b>Location</b></td>
	<td class="little" align="center"><b>Refer Name</b></td>
	<td class="little" align="center"><b>Refer Loc</b></td>
	<td class="little" align="center"><b>Email</b></td>
	<td class="little" align="center"><b>Phone</b></td>
</tr>
<cfoutput query="TheEmps">
<cfif len(refName) GT 0>
	<tr>
		<td class="little" align="center">#empID#</td>
		<td class="little" align="center">#empLast#</td>
		<td class="little" align="center">#empFirst#</td>
		<td class="little" align="center">#empMiddle#</td>
		<td class="little" align="center">#jobName#</td>
		<td class="little" align="center">#locAbbrev#</td>
		<td class="little" align="center">#refName#</td>
		<td class="little" align="center">#refLoc#</td>
		<td class="little" align="center">#empEmail#</td>
		<td class="little" align="center">#empPhone#</td>
	</tr>
</cfif>
</cfoutput>
</table>
</cfsavecontent>

<cfoutput>
<cfset fLink = #session.siteLoc# & '_PTS/_results/' & dateformat(now(),'yymmdd') & '_' & LSTimeFormat(now(),'HHMMSS') & '.xls'>
<cfset fPath = expandpath("../../_PTS/_results") & "\" & dateformat(now(),'yymmdd') & '_' & LSTimeFormat(now(),'HHMMSS') & '.xls'>
<cffile action="write" file="#fPath#" output="#report#">
<h2 align="center"><a href="#fLink#">Download Excel File </a></h2>
</cfoutput>