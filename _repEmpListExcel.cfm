<cfquery datasource="#session.orgData#" name="TheEmps">
SELECT * FROM employees, departments, locations, jobs
WHERE employees.orgID=#session.orgID# AND employees.deptID=departments.deptID AND departments.locID=locations.locID AND employees.jobID=jobs.jobID and employees.empBirth is not null and employees.empAddress1 is not null
	<cfif session.deptAdmin> AND employees.deptID=#session.deptID#</cfif>
	<cfif session.locAdmin> AND departments.locID=#session.locID#</cfif>
	<cfif URL.y EQ year(now())>AND empActive='a'<cfelse>AND empActive='t' <cfif isdate('empTerminate')>AND #year(empTerminate)#=#URL.y#</cfif></cfif>
ORDER BY locAbbrev, deptAbbrev, empLast, empFirst
</cfquery>

<cfsavecontent variable="report">
<table border="1">
<tr>
	<td class="little" align="center"><b>EHire ID</b></td>
	<td class="little" align="center"><b>Location</b></td>
	<td class="little" align="center"><b>Department</b></td>
	<td class="little" align="center"><b>Last</b></td>
	<td class="little" align="center"><b>First</b></td>
	<td class="little" align="center"><b>Middle</b></td>
	<td class="little" align="center"><b>Birthdate</b></td>
	<td class="little" align="center"><b>Position</b></td>
	<td class="little" align="center"><b>PCN</b></td>
	<td class="little" align="center"><b>Training Wage</b></td>
	<td class="little" align="center"><b>Wage</b></td>
	<td class="little" align="center"><b>Training</b></td>
	<td class="little" align="center"><b>Beg Work</b></td>
	<td class="little" align="center"><b>End Work</b></td>
	<td class="little" align="center"><b>Address</b></td>
	<td class="little" align="center"><b>City</b></td>
	<td class="little" align="center"><b>State</b></td>
	<td class="little" align="center"><b>Zip</b></td>
	<td class="little" align="center"><b>Province</b></td>
	<td class="little" align="center"><b>Country</b></td>
	<td class="little" align="center"><b>Phone</b></td>
	<td class="little" align="center"><b>Email</b></td>
	<td class="little" align="center"><b>Photo Release</b></td>
	<td class="little" align="center"><b>Bonus Type</b></td>
	<td class="little" align="center"><b>Service Years</b></td>
	<td class="little" align="center"><b>Longevity</b></td>
	<td class="little" align="center"><b>Bonus Percentage</b></td>
</tr>
<cfoutput query="TheEmps">
<tr>
	<td class="little">#empID#</td>
	<td class="little">#locAbbrev#</td>
	<td class="little">#deptAbbrev#</td>
	<td class="little">#empLast#</td>
	<td class="little">#empFirst#</td>
	<td class="little">#empMiddle#</td>
	<td class="little">#dateformat(empBirth, 'mm/dd/yy')#</td>
	<td class="little">#jobName#</td>
	<td class="little">#jobCode#</td>
	<td class="little">#dollarformat(wageT1)#</td>
	<td class="little">#dollarformat(wageHr)#</td>
	<td class="little">#dateformat(empTrain,'mm/dd/yy')#</td>
	<td class="little">#dateformat(empBeg,'mm/dd/yy')#</td>
	<td class="little">#dateformat(empEnd,'mm/dd/yy')#</td>
	<td class="little">#empAddress1#</td>
	<td class="little">#empCity#</td>
	<td class="little">#empState#</td>
	<td class="little">#empZip#</td>
	<td class="little">#empProvince#</td>
	<td class="little">#empCountry#</td>
	<td class="little">#empPhone#</td>
	<td class="little">#empEmail#</td>
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
		</td>
	<td class="little">#wageIncYrs#</td>
	<td class="little">#wageIncLng#</td>
	<td class="little">#wageIncPct#</td>
	
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