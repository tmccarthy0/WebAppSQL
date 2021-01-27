<!--- Report parameters. ---><head>
<link rel="stylesheet" href="../../_style.css" media="screen" type="text/css">
<link rel="stylesheet" media="print" href="../print.css" type="text/css" />
</head>


<!--- Queries needed for form fields. --->
<cfquery datasource="#session.orgData#" name="theDept">
SELECT deptName FROM departments
WHERE deptID = #theEmp.deptID#
</cfquery>

<cfquery datasource="#session.orgData#" name="hireDat">
SELECT flogDate FROM formlog
WHERE empID=#theEmp.empID#
ORDER BY flogDate
</cfquery>


<!--- Create form document. --->
<cfoutput>
<cfset fLink = 'http://www.hapdox.com/_emps/' & year(now()) & '/' & theEmp.empID & '/' & lcase(theEmp.empLast) & '_' & lcase(theEmp.empFirst) & '_W4_' & dateformat(now(),'mmdd') & LSTimeFormat(now(),'HHMMSS') & '.pdf'>
<cfset dPath = 'e:\web\hapdox.com\_emps\' & year(now()) & '\' & theEmp.empID & '\'>
<cfset fPath = dPath & lcase(theEmp.empLast) & '_' & lcase(theEmp.empFirst) & '_W4_' & dateformat(now(),'mmdd') & LSTimeFormat(now(),'HHMMSS') & '.pdf'>
<cfif NOT directoryexists(dpath)><cfdirectory directory="#dpath#" action="create"></cfif>

<cfdocument format="pdf" filename="#fPath#" overwrite="true">
<table width="800" align="center" cellpadding="10" cellspacing="0" border="1">
<tr>
    <td align="left" class="little"><h1>Form W-4</h1>Dept of the Treasury<br />Internal Revenue Svc</td>
    <td align="center" class="little" colspan="4"><h1>Employee's Withholding Certificate</h1><li>Complete Form W-4 so that your employer can withhold the correc t federal income tax from your pay.</li><li>Give Form W-4 to your employer</li><li>Your withholding is subject to review by the IRS</li></td>
    <td align="right" class="little"><u>OMB 1545-0074</u><h1>#year(now())#</h1></td>
</tr>
<tr>
    <td width="17%" class="tiny"></td>
    <td width="16%" class="tiny"></td>
    <td width="17%" class="tiny"></td>
    <td width="16%" class="tiny"></td>
    <td width="17%" class="tiny"></td>
    <td width="16%" class="tiny"></td>
</tr>
<tr>
    <td align="left" class="text" colspan="2">
        <b>[1] </b>Your first name and middle initial
        <br />#theEmp.w4name1#
    </td>
    <td align="left" colspan="2" class="text">Last name<br />#theEmp.w4name2#</td>
    <td align="left" colspan="2" class="text"><b>[2] </b>Your social security number<br>#theEmp.empEIN#</td>
</tr>
<tr>
    <td align="left" class="text" colspan="2">Home address (number and street or rural route)<br />#theEmp.w4addr1#</td>
    <td align="left" class="little" colspan="4">
        <b>[3] Marital status</b>
        <br />#theEmp.w4status#
        <br><b>Note.</b> If married, but legally separated, or spouse is nonresident alien, check "Single" box.
    </td>
</tr>
<tr>
    <td align="left" class="text" colspan="2">
        City or town, state and ZIP code
        <br />#theEmp.w4addr2#
    </td>
    <td align="left" class="little" colspan="4">
        <b>[4] </b>
        <b>If your last name differs from that shown on your social security card, 
        check here. You must call 1-800-772-1213 for a replacement card.</b>
        <br><cfif theEmp.w4name EQ 1>Yes, my name differs.<cfelse>No, my name is the same.</cfif>
    </td>
</tr>
<tr>
    <td align="left" class="text" colspan="5"><b>[5] </b>Total number of allowances you are claiming. <font class="little"><a href="http://www.irs.gov/Individuals/IRS-Withholding-Calculator" target="_blank">IRS Deductions & Adjustments Worksheet</a></font></td>
    <td align="left" class="little">#theEmp.w4allow#</td>
</tr>
<tr>
    <td align="left" class="text" colspan="5"><b>[6] </b>Additional amount, if any, you want withheld from each paycheck.</td>
    <td align="left" class="little">#theEmp.w4amount#</td>
</tr>
<tr valign="bottom">
    <td align="left" class="text" colspan="6">
        <b>[7] </b>
        I claim exemption from withholding in #year(now())#, and I certify that I meet <b>both</b> of the following conditions for exemption.
        <ul>
        <li> Last year I had a right to a refund of all federal income tax withheld because I had no tax liability and, </li>
        <li> This year I expect a refund of all federal income tax withheld because I expect to have no tax liability.</li>
        </ul>
        If you meet both conditions, type "Exempt" here. #theEmp.w4exempt#
    </td>
</tr>
<tr><td class="little" align="left" colspan="6"><br /><b>By typing the security characters below along with my name as my online signature, I declare under penalty of perjury that I have examined this certificate and to the best of my knowledge and belief, it is true, correct, and complete.</td></tr>
<tr>
    <td align="left" colspan="3" class="little">
        <b>Employee's signature</b> #theEmp.w4sig#            
        <br>(This form is not valid unless you sign it.)
    </td>
    <td align="left" class="little" colspan="3"><b>Date</b> #dateformat(theEmp.w4date,'mm/dd/yy')#</td>
</tr>
<tr>
    <td align="left" class="little" colspan="3">For Privacy Act and Paperwork Reduction Notice, <a href="http://www.irs.gov/pub/irs-pdf/fw4.pdf" target="_blank">see page 2</a>.</td>
    <td align="center" class="little">Cat. No. 10220Q</td>
    <td align="right" class="little" colspan="2">Form <b>W-4</b> (#year(now())#)</td>
</tr>
</table>
</cfdocument>
</cfoutput>
