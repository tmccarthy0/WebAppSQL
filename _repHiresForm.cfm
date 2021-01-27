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

<cfset appRep = 0><cfset resRep = 0><cfset reqRep = 0><cfset ovrRep = 0>
<h1 align="center"><cfoutput>#session.siteName# - Hiring Progress</cfoutput>

<cfoutput query="theEmps" group="deptName">
<cfset appTot = 0><cfset resTot = 0><cfset reqTot = 0><cfset ovrTot = 0>
<h2 align="center">#locName# - #deptName#</h2>
<table width="600" border="1" align="center" cellpadding="3" cellspacing="0">
<cfoutput group="formID">
<cfset appCtr = 0><cfset resCtr = 0><cfset reqCtr = 0><cfset ovrCtr = 0>
<cfoutput group="empID">
<tr>
	<td class="little" align="left">#formName#</td>
	<td class="little" align="left">#empLast#, #empFirst# #empMiddle#</td>
	<td class="little" align="left">#jobName#</td>
	<td class="little" align="left">
    	<cfif flogType EQ 'app'>Approved
			<cfset appCtr = appCtr + 1><cfset appTot = appTot + 1><cfset appRep = appRep + 1>
        <cfelseif flogType EQ 'req'>
			<cfif dateadd('d',-10,now()) GT flogDate>Overdue
				<cfset ovrCtr = ovrCtr + 1><cfset ovrTot = ovrTot + 1><cfset ovrRep = ovrRep + 1>
            <cfelse>Awaiting Response
				<cfset reqCtr = reqCtr + 1><cfset reqTot = reqTot + 1><cfset reqRep = reqRep + 1>
            </cfif>
		<cfelse>Awaiting Approval
			<cfset resCtr = resCtr + 1><cfset resTot = resTot + 1><cfset resRep = resRep + 1>
		</cfif> 
        #dateformat(flogDate,'mm/dd/yy')#           
	</td>
</tr>
</cfoutput>
<cfset totCtr = appCtr + reqCtr + resCtr + ovrCtr>
<tr><td class="little" align="right" colspan="4"><b>Form: Appr #appCtr# (#int(appCtr/totCtr*100)#%) | Need Resp #reqCtr# (#int(reqCtr/totCtr*100)#%) | Need Appr #resCtr# (#int(resCtr/totCtr*100)#%) | Overdue #ovrCtr# (#int(ovrCtr/totCtr*100)#%) | Tot #totCtr#</b></td></tr>
</cfoutput>
<cfset totTot = appTot + reqTot + resTot + ovrTot>
<tr><td class="little" align="right" colspan="4"><b>Dept: Appr #appTot# (#int(appTot/totTot*100)#%) | Need Resp #reqTot# (#int(reqTot/totTot*100)#%) | Need Appr #resTot# (#int(resTot/totTot*100)#%) | Overdue #ovrTot# (#int(ovrTot/totTot*100)#%) | Tot #totTot#</b></td></tr>
</table>
</cfoutput>

<cfoutput>
<cfset totRep = appRep + reqRep + resRep + ovrRep>
<table width="600" border="0" align="center" cellpadding="3" cellspacing="0">
<tr><td class="little" align="right"><b>Report: Appr #appRep# (#int(appRep/totRep*100)#%) | Need Resp #reqRep# (#int(reqRep/totRep*100)#%) | Need Appr #resRep# (#int(resRep/totRep*100)#%) | Overdue #ovrRep# (#int(ovrRep/totRep*100)#%) | Tot #totRep#</b></td></tr>
</table>
</cfoutput>