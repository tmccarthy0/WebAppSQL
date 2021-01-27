<cfquery datasource="#session.orgData#" name="TheEmps">
SELECT deptContact, empFirst, empMiddle, empLast, empEIN, empPhone, empEmail, employees.jobID, locAbbrev, 
	flogDate, locName, deptName, jobName, formName, flogType, employees.empID, forms.formID
FROM employees, locations, departments, formlog, forms, jobs
WHERE employees.orgID=#session.orgID# AND empActive='a' AND empType='s' 
	AND employees.deptID=departments.deptID AND year(flogDate)=#year(now())#
	AND employees.locID=locations.locID 
	AND employees.jobID=jobs.jobID 
    AND employees.empID=formlog.empID 
    AND forms.formID=formlog.formID
	<cfif session.deptAdmin> AND employees.deptID=#session.deptID#</cfif>
	<cfif session.locAdmin> AND locations.locID=#session.locID#</cfif>
	AND (forms.locCountry='all' OR forms.locCountry=locations.locCountry) AND formActive='a'
ORDER BY locName, deptName, forms.formID, empLast, employees.empID, flogDate DESC 
</cfquery>

<cfsavecontent variable="report">
<table border="1">
<tr>
	<td class="little">Location</td>
	<td class="little">Department</td>
	<td class="little">Form</td>
	<td class="little">Employee Name</td>
	<td class="little">Position</td>
	<td class="little">Status</td>
	<td class="little">Date</td>
</tr>
<cfoutput query="theEmps" group="empID">
<tr>
	<td class="little">#locName#</td>
	<td class="little">#deptName#</td>
	<td class="little">#formName#</td>
	<td class="little">#empLast#, #empFirst# #empMiddle#</td>
	<td class="little">#jobName#</td>
	<td class="little">
    	<cfif flogType EQ 'app'>Approved
	<cfelseif flogType EQ 'res'>Forms Returned
        <cfelseif flogType EQ 'req'>
			<cfif dateadd('d',-10,now()) GT flogDate>Overdue
            <cfelse>Awaiting Response
            </cfif>
		<cfelse>Awaiting Approval
		</cfif> 
	<td class="little">#dateformat(flogDate,'mm/dd/yy')#</td>
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
