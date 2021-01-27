<!--- Report parameters. ---><head>
<link rel="stylesheet" href="../../_style.css" media="screen" type="text/css">
<link rel="stylesheet" media="print" href="../print.css" type="text/css" />
</head>


<!--- Locate employer, division, location. --->
<cfquery datasource="#session.orgData#" name="theDept">
SELECT * FROM departments
WHERE deptID = #theEmp.deptID#
</cfquery>
<cfquery datasource="#session.orgData#" name="theJob">
SELECT jobName FROM jobs
WHERE jobID = #theEmp.jobID#
</cfquery>
<cfif theDept.recordcount EQ 0>
	<script type="text/javascript"> 
	var answer = confirm ("Department #theEmp.deptID# was not found.") 
	if (answer) 
	window.location="#session.siteLoc#"
	else
	window.location="#session.siteLoc#"
	</script> 
	<cfabort>
</cfif>

<!--- Queries needed for form fields. --->
<cfquery datasource="#session.orgData#" name="theEmployer">
SELECT erName FROM employers
WHERE erID = #theDept.erID#
</cfquery>
<cfquery datasource="#session.orgData#" name="theDiv">
SELECT divName FROM divisions
WHERE divID = #theDept.divID#
</cfquery>
<cfquery datasource="#session.orgData#" name="theLoc">
SELECT locName FROM locations
WHERE locID = #theDept.locID#
</cfquery>
<cfquery datasource="#session.orgData#" name="theLocs">
SELECT locName FROM locations
WHERE orgID = #theDept.orgID#
</cfquery>
<cfquery datasource="#session.orgData#" name="thePolicy">
SELECT docContent1 FROM documents
WHERE docID = 658
</cfquery>

<!--- Create form document. --->

<cfoutput>
<cfset fLink = 'http://www.hapdox.com/_emps/' & year(now()) & '/' & theEmp.empID & '/' & lcase(theEmp.empLast) & '_' & lcase(theEmp.empFirst) & '_empagreement_' & dateformat(now(),'mmdd') & LSTimeFormat(now(),'HHMMSS') & '.pdf'>
<cfset dPath = 'e:\web\hapdox.com\_emps\' & year(now()) & '\' & theEmp.empID & '\'>
<cfset fPath = dPath & lcase(theEmp.empLast) & '_' & lcase(theEmp.empFirst) & '_empagreement_' & dateformat(now(),'mmdd') & LSTimeFormat(now(),'HHMMSS') & '.pdf'>
<cfif NOT directoryexists(dpath)><cfdirectory directory="#dpath#" action="create"></cfif>

<cfdocument format="pdf" filename="#fPath#" overwrite="true">
<p><b>Emp ID #theEmp.empID#</b></p>
<h1 align="center">Canadian Temp/Seasonal Employment Agreement</h1>
<table width="800" align="center" cellpadding="10" cellspacing="0" border="1">
<tr>
    <td class="text">
        This agreement between <b><cfif len(theEmp.empHon) GT 0>#theEmp.empHon# </cfif>#theEmp.empFirst# <cfif len(theEmp.empMiddle) GT 0>#theEmp.empMiddle# </cfif>#theEmp.empLast# <cfif len(theEmp.empSuffix) GT 0>#theEmp.empSuffix#</cfif></b> (Employee) 
        and <b>#theEmployer.erName#</b> (hereinafter referred to as the Company) constitutes the entire Agreement. 
    </td>
</tr>
<tr>
    <td class="text">
        <h2>POSITION, DATES OF EMPLOYMENT (TERM) & LOCATION:</h2>
        <p><b>Position Title: </b>#theJob.jobName# <cfif len(theEmp.jobCode) GT 0>&nbsp; &nbsp; &nbsp; <b>P/R Code:</b> #theEmp.jobCode#</cfif></p>
        <p><b>Term of Temporary/Seasonal Agreement: </b><br>Start Date: #dateformat(theEmp.empBeg,'mm/dd/yy')# through Last Day of Work: #dateformat(theEmp.empEnd,'mm/dd/yy')#</p>
        <p>
        <cfif len(theEmp.empTrain) GT 0><b>Training Start Date (1): </b>#dateformat(theEmp.empTrain,'mm/dd/yy')#</cfif>
        <cfif len(theEmp.empTrain2) GT 0>&nbsp; &nbsp; &nbsp; <b>Training Start Date (2): </b>#dateformat(theEmp.empTrain2,'mm/dd/yy')#</cfif>
        </p>
        <p>This Agreement may be extended beyond specified date(s) by mutual written agreement of Employee and the division/hotel manager. A Temporary/Seasonal employee as defined in the Employee Handbook is not eligible to receive any Company benefits.</p>
        <p>The Division & Location shall be considered Employee's "Point of Hire".</p>
        <p><b>Division: </b> #theDiv.divName#&nbsp; &nbsp; &nbsp; <b>Location: </b>#theLoc.locName#</p>
        <p><b>Transportation to or from Point of Hire: </b><cfif theEmp.transCost EQ 0>Employee Responsibility<cfelse>Company Paid and Selected</cfif></p>
    </td>
</tr>
<tr>
    <td class="text">
        <h2>COMPENSATION:</h2>
        <p><b>Compensation: </b> will comply with applicable provincial/territorial and federal laws and guidelines. Hourly employees and other employees eligible by statute will be paid for hours worked at an hourly rate, with overtime at one and one-half times the hourly rate. For training purposes, the training wage is paid at an hourly rate. Training hours do not count toward the Longevity Incentive pay.</p>
        <cfif theEmp.wageT1 GT 0><p><b>Training Wage(1):</b> #dollarformat(theEmp.wageT1)# per hour. <cfif theEmp.empTrainCode GT 0>(#theEmp.empTrainCode#)</cfif></p></cfif>
        <cfif theEmp.wageT2 GT 0><p><b>Training Wage(2):</b> #dollarformat(theEmp.wageT2)# per hour. <cfif theEmp.empTrainCode2 GT 0>(#theEmp.empTrainCode2#)</cfif></p></cfif>
        <p><b>Temporary/Seasonal Agreement Rate of Pay:</b> <cfif theEmp.wageHr GT 0>Non-Managerial Status at the Hourly Rate of #dollarformat(theEmp.wageHr)#<cfelseif theEmp.wageBw GT 0>Managerial Status at the Bi-weekly rate of #dollarformat(theEmp.wageBw)#.<cfelseif theEmp.wageDay GT 0>Exempt status at the daily rate of #dollarformat(theEmp.wageDay)#.</cfif></p>
        <cfif theEmp.wageIncAvl EQ 1>
            <p><b>Longevity Incentive Program (hourly employees only):</b> Upon successful completion of this Agreement, employee (hourly employees only) may be eligible for the following:
            <ol>
            <li>Longevity Incentive at #dollarformat(theEmp.wageIncRT)# per straight time hour worked and at #dollarformat(theEmp.wageIncOT)# per overtime hour worked.</li>
            <li>Employee understands and agrees that any incentive payment is discretionary.  Successful completion of the terms of this Agreement is a requirement for incentive pay eligibility. If Employee voluntarily terminates employment at any time prior to the end of this Agreement, is dismissed for cause prior to the end of this Agreement or is dismissed, for any reason, more than four weeks prior to the end of this Agreement where the last day of work is more than four weeks prior to the end of this Agreement, the Employee will not be eligible for any incentive pay. Training periods do not count toward the longevity incentive (bonus) calculation. Eligible longevity incentive pay will be paid by October 31, or by end of Agreement, whichever comes last.</li>
            </ol>
            </p>
        <cfelseif theEmp.wageIncAvl EQ 2>
            <p>Compensation will comply with applicable state and federal laws and guidelines. Hourly employees will be paid for hours worked at an hourly rate, with overtime at one and one-half times the hourly rate. For training purposes, the training wage is paid at an hourly rate as shown above. Training hours do not count toward the Longevity Incentive pay.</p>
            <p><b>Incentive Program for Hourly Employees Only:</b> Employee understands and agrees that successful completion of the work season is a condition of incentive pay eligibility. Should the Employee voluntarily terminate employment or be discharged for cause prior to completion of this Agreement, Employee is not eligible for any incentive program. Driver training hours will not be included in incentive pay calculations.</p>
            <p><b>Season Completion Bonus:</b> Earn up to #theEmp.wageIncPct#% of Gross Pay based on longevity.
        </cfif>
    </td>
</tr>
<tr>
    <td class="text">
        <h2>LODGING AND MEALS:</h2>
        <p><b>Lodging:</b> Company lodging <cfif theEmp.ldgAvail GT 0>is available<cfelse>is <b>not available</b></cfif> at Point of Hire.</p>
        <cfif theEmp.ldgAvail GT 0>
            <p>Employee's lodging cost is #dollarformat(theEmp.ldgCost)# (<b>per day for US based employees and per month for Canada based employees</b>) per day for the duration of Employee's employment and according to this Agreement.</p>
            <p>Company housing/lodging is conditioned upon active employment with HAPA ALASKA-YUKON. When employment terminates, whether voluntarily or involuntarily, employee must vacate the housing and property immediately.  If Company lodging is elected by employee, employee agrees that the cost of lodging will be deducted from the employee's pay cheque. The Company reserves the right of entry into employee's room or accommodation provided by Company for the purpose of inspection or in the event of any emergency involving threat of life or health, safety or welfare of Company employee(s) or property according to applicable provincial/territorial laws. The Company reserves the right to conduct periodic accommodation inspections. All rules of conduct, discipline, etc. as outlined in the Employee Handbook apply to employees residing in Company provided housing. Lodging will be provided at Company expense when employee is required to overnight at a location other than point of hire. 
            A meal plan/or meal discount <cfif theEmp.wageIncAvl EQ 2>may be<cfelse>is</cfif> required for employees living in Company lodging.</p>
        </cfif>
        <cfset foodProg = theEmp.foodCostDay + theEmp.foodCostEach + len(theEmp.foodDiscount)>
        <p><b>Meals:</b> <cfif foodProg GT 0>Employee shall be eligible for the following discounts.<cfelse>No meal discounts are available.</cfif></p>
        <ul>
        <cfif theEmp.foodCostDay GT 0><li>Meals are provided at a cost of #dollarformat(theEmp.foodCostDay)# per day in designated Company dining areas. Employee agrees to have #dollarformat(theEmp.foodCostDay)#/day deducted each pay period for the cost of meals.</li></cfif>
        <cfif theEmp.foodDiscount GT 0><li>Meal discount of #theEmp.foodDiscount#% off of menu pricing in designated Company dining areas.</li></cfif>
        <cfif theEmp.foodCostEach GT 0><li>On-shift meal(s) will be provided in designated Company dining room areas at a cost of #dollarformat(theEmp.foodCostEach)# per meal. Employee agrees to have #dollarformat(theEmp.foodCostEach)# per meal deducted each pay period for the cost of meals.</li></cfif>
        </ul>
    </td>
</tr>	
<tr>
    <td class="text">
        <h2>UNIFORMS and WORKPLACE APPEARANCE:</h2>
        <p>In order to maintain a professional environment in the workplace, employees are expected to exercise good judgment in selecting their dress and in their appearance by striving to present a positive, polished professional image. Company standards of dress, personal hygiene, and safety must be observed at all times.</p>
        <p><b>Uniforms: </b>The appropriate uniform for each position has been carefully selected; of which some portions may be furnished by the company and others by the employee. If employee is provided Company-issued uniform items, employee agrees to maintain the uniform items in clean and good condition throughout the term of employment. Any Company-issued uniform(s) will remain the property of the Company, and employee agrees to return cleaned Company-issued uniform item(s) promptly to the Company upon termination of employment. Shoes should be clean and polished at all times. You are expected to maintain a neat and conservative appearance and any aspect of dress or appearance that attracts undue attention is not permitted. (Please refer to your divisional management team for the specific uniform requirements of your position.)</p>
        <p><b>Workplace Appearance: </b>Employee agrees to meet and follow the workplace appearance standards provided below. Individual job requirements and health and safety standards may have additional requirements and must be observed.
        <ul>
        <li>No facial or tongue jewelry or visible piercing (aside from earrings).</li>
        <li>No visible tattoos.</li>
        <li>No excessive jewelry, makeup, nail polish, or fragrances. Earrings should be conservative, limited to one per earlobe, and not exceed one inch in dangle.</li>
        <li>Hair must be in a conservative style, (no faddish colors) and should always be clean and combed.</li>
        <li>Hair must be clean and worn back off of the face; ponytails or buns must be trimmed and neat.</li>
        <li>Men who have beards or mustaches at the beginning of their employment are permitted to maintain them. They must be clean and neatly trimmed, and sideburns must be clean and neatly trimmed. Facial hair must not interfere with work or be offensive to customers.</li>
        <li>Management reserves the right to determine proper work attire and appearance based on health and safety standards and departmental needs. Supervisors may send inappropriately dressed employees home. Employees sent home will not be compensated for the time away from work. Frequent or intentional disregard of this policy by employees may result in disciplinary action, up to and including termination of employment. If you have any questions or concerns regarding these guidelines, please discuss them with your supervisor. If you have medical, religious, or other reasons for being unable to comply with the Workplace Appearance standards, you must notify your supervisor immediately.</li>
        </ul>
        <p><b>Off-Duty Appearance: </b>Employees living on Company properties/facilities or employees visiting Company properties/facilities must observe appropriate appearance standards. When in public areas and visible to guests, off-duty appearance must be conservative, modest, non-offensive to guests, and appropriate. Clothes must be of an acceptable style for being in a vacation/resort environment and must be clean, not torn, and personal items (i.e. clothing, jewelry, buttons, pins, etc.) may not bear political or personal slogans, statements, or slang.</p>
        <h2>DUTIES AND RESPONSIBILITIES:</h2>
        <p><b>Health: </b>Employee agrees to report to work at Point of Hire on the Temporary/Seasonal Agreement Start Date indicated above and agrees to be ready and able to perform all essential job functions. If the employee requires a reasonable accommodation to perform an essential job function, then an accommodation request should be submitted to the Seattle Corporate Human Resources Manager, as soon as possible before the Start Date.</p>
        <p><b>Performance of Duties: </b>Employee agrees to faithfully perform the duties and to work the hours assigned by employee's supervisor or manager, pursuant to the schedule (prepared by management), and to work any additional hours required.</p>
        <p><b>Company Rules, Regulations, Policies and Procedures: </b>Employee agrees to abide by all Company rules, regulations, policies and procedures; to observe Company, federal and provincial/territorial laws, regulations, policies and procedures related to safety, health and environment.</p>
        <h2>TERMINATION OF AGREEMENT:</h2>
        <p>Employee understands and agrees that if the Company terminates the employee's employment prior to the end of this Agreement without cause, the Company shall only be obliged to provide the employee the notice or pay in lieu of notice and severance pay, if any, required by the Canada Labour Code (for employees working in British Columbia) or the Yukon Employment Standards Act (for employees working in the Yukon), without any further obligation in respect of notice, pay in lieu of notice or severance pay. If the amount of notice that the Company would be required to provide the employee under the Canada Labour Code or the Yukon Employment Standards Act is, at the time of termination, less that the time remaining in the term of this Agreement, then the Company's sole obligation will be to pay the employee the pay the employee would have earned to the end of the Agreement. The Company may terminate the employee's employment at any time for cause, without pay or notice. If the amount of notice that the Company would be required to provide the employee under the Canada Labour Code or the Yukon Employment Standards Act is, at the time of termination, less that the time remaining in the term of this Agreement, then the Company's sole obligation will be to pay the employee the pay the employee would have earned to the end of the Agreement. The Company may terminate the employee's employment at any time for cause, without pay or notice.</p>
        <h2>EMPLOYEE RECORDS:</h2>
        <p>Employee understands and agrees that personnel records relating to the employee may be kept in the United States of America. Employee consents to the transfer and maintenance of employee's personnel records to the Company in the U.S.</p>
        <h2>ENTIRE AGREEMENT:</h2>
        <p>This Agreement and the policies of the Company constitute the entire employment agreement and supersedes any and all prior representations, understandings or agreements. No modification or waiver of this agreement will be effective unless evidenced in a written agreement and signed by both the employee and the President of the Company.</p>
    </td>
</tr>
<tr>
	<td class="little" align="left">
		If you were referred by another Employee please provide their name and location.
		<br>Referred By: #theEmp.refName# &nbsp; Location: #theEmp.refLoc#
	</td>
</tr>
<cfif theEmp.ldgAvail EQ 1>
	<tr>
		<td class="little" align="left">
			<b>Please select a Company lodging choice and specify preferences as applicable.</b><br>
			<cfif theEmp.ldgOK EQ "1">
				I accept provisions for Company lodging listed in this Agreement, and I decline to use accessible alternate public lodging.
			<cfelse>
				I decline Company lodging listed in this Agreement.
			</cfif>
		</td>
	</tr>
</cfif>
<tr>
	<td align="left" class="little">
		<b>You must acknowledge and agree to all conditions of this Agreement in order to submit this form.</b><br />
		<cfif theEmp.appOK EQ "1">
			Yes, I acknowledge and agree to all above conditions.
		<cfelse>
			No, I don't agree.
		</cfif>
	</td>
</tr>
<tr>
	<td align="left" class="little">
		<b>By electronically signing the form at right I agree to the terms of this agreement.</b><br />
		By: #theEmp.empSigName# on #dateformat(theEmp.empSigDate,"mm/dd/yy")# at #timeformat(theEmp.empSigDate,"hh:mm tt")#
	</td>
</tr>
</table>
</cfdocument>
</cfoutput>