<cfquery datasource="#session.orgData#" name="TheEmps">
SELECT deptContact, employees.empID, empFirst, empMiddle, empLast, empEIN, empPhone, empEmail, employees.jobID, locAbbrev, flogDate, jobs.jobName, jobs.locID, jobs.deptID, locations.locName, departments.deptName, formlog.formID, formName, formlog.flogType, forms.formType FROM employees, jobs, locations, departments, formlog, forms
WHERE employees.orgID=#session.orgID# AND empActive='a' AND empType='s' AND employees.jobID=jobs.jobID AND employees.deptID=departments.deptID
	AND employees.locID=locations.locID AND employees.empID=formlog.empID AND forms.formID=formlog.formID AND year(flogDate)=#year(now())#
	<cfif session.deptAdmin> AND employees.deptID=#session.deptID#</cfif>
	<cfif session.locAdmin> AND locations.locID=#session.locID#</cfif>
	AND (forms.locCountry='all' OR forms.locCountry=locations.locCountry) AND formActive='a'
ORDER BY locations.locName, departments.deptID, jobs.jobID, empLast, employees.empID, formID, flogDate DESC</cfquery>

<cfsavecontent variable="report">
<table border="1">
<tr>
	<td>EHireID</td>
	<td>Location</td>
	<td>Dept</td>
	<td>Contact</td>
	<td>Position</td>
	<td>Last</td>
	<td>First</td>
	<td>Middle</td>
	<td>Email</td>
	<td>Phone</td>
	<td>Status</td>
</tr>
<cfoutput query="TheEmps" group="empID">
<tr>
	<td>#empID#</td>
	<td>#locName#</td>
	<td>#deptName#</td>
	<td>#deptContact#</td>
	<td>#jobName#</td>
	<td>#empLast#</td>
	<td>#empFirst#</td>
	<td>#empMiddle#</td>
	<td><a href="mailto:#empEmail#">#empEmail#</a></td>
	<td>#empPhone#</td>
	<td>
		<cfset appCtr = 0><cfset resCtr = 0><cfset dueCtr = 0><cfset reqCtr = 0>
		<cfoutput group="formID">
		<cfif formType NEQ 'z'>
			<cfset dCtr=0>
			<cfoutput>
			<cfif dCtr EQ 0>
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
</cfoutput>
</table>
</cfsavecontent>

<cfoutput>
<cfset fLink = #session.siteLoc# & '_PTS/_results/' & dateformat(now(),'yymmdd') & '_' & LSTimeFormat(now(),'HHMMSS') & '.xls'>
<cfset fPath = expandpath("../../_PTS/_results") & "\" & dateformat(now(),'yymmdd') & '_' & LSTimeFormat(now(),'HHMMSS') & '.xls'>
<cffile action="write" file="#fPath#" output="#report#">
<h2 align="center"><a href="#fLink#">Download Excel File </a></h2>
</cfoutput>
