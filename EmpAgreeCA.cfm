<cfinclude template="../_ptsT.cfm">
<cfinclude template="../_ptsIntro.cfm">

<!--- Initialize specific form fields. --->
<cfoutput>
<cfparam name="form.empID" default="#theEmp.empID#">
<cfparam name="form.empSigName" default="#theEmp.empSigName#">
<cfparam name="form.empSigDate" default="#theEmp.empSigDate#">
<cfparam name="form.empID" default="#theEmp.empID#">
<cfparam name="form.empHash" default="#theEmp.empHash#">
<cfparam name="form.appOK" default="#theEmp.appOK#">
<cfparam name="form.ldgOK" default="#theEmp.ldgOK#">
<cfparam name="form.refName" default="#theEmp.refName#">
<cfparam name="form.refLoc" default="#theEmp.refLoc#">
<cfparam name="form.photoOK" default="#theEmp.photoOK#">
<cfif len(form.appOK) EQ 0><cfset form.appOK = 0></cfif>
<cfif len(form.ldgOK) EQ 0><cfset form.ldgOK = 0></cfif>
<cfif len(form.photoOK) EQ 0><cfset form.photoOK = 1></cfif>
<cfset oRef = #form.refName# & " of " & #form.refLoc#>
<cfparam name="form.oLogRef" default="#oRef#">
<cfif form.ldgOK><cfset oOK = "Lodging=Yes, "><cfelse><cfset oOK = "Lodging=No, "></cfif>
<cfif form.photoOK><cfset oOK = oOK & "Photo=Yes"><cfelse><cfset oOK = oOK & "Photo=No"></cfif>
<cfparam name="form.oLogOK" default="#oOK#">
</cfoutput>


<!--- Check for post-form errors and process form submittal or approval. --->
<cfif isdefined('send')>
	<cfset errors = "">
	<cfif hash(ucase(form.captcha)) NEQ form.captchaHash><cfset errors = errors & "Please correctly enter the security code below.<br />"></cfif>
	<cfif form.appOK NEQ "1"><cfset errors = errors & "Please agree to the conditions of this Agreement below.<br>"></cfif>
	
	<!--- If no errors, process form data. --->
	<cfif errors IS "">
		<cfset showForm = false>
		<cfset form.appUpdate = now()>
		<cfupdate datasource="#session.orgData#" tablename="employees" formfields="empID, appOK, appUpdate, ldgOK, refName, refLoc, photoOK, empSigName, empSigDate"> 

		<!--- Log form data. --->
		<cfset form.appDate = now()>
		<cfset form.accID = session.accID><cfset form.appUser = session.appUser>
		<cfset nRef = #form.refName# & " of " & #form.refLoc#>
		<cfif nRef NEQ form.oLogRef>
			<cfset form.appType = "Emp Agreement: Ref">
			<cfset form.appFrom = form.oLogRef>
			<cfset form.appTo = nRef>
			<cfinsert datasource="#session.orgData#" tablename="appLog" formfields="appType, empID, accID, appUser, appDate, appFrom, appTo">
		</cfif>
		<cfif form.ldgOK><cfset nOK = "Lodging=Yes, "><cfelse><cfset nOK = "Lodging=No, "></cfif>
		<cfif form.photoOK><cfset nOK = nOK & "Photo=Yes"><cfelse><cfset nOK = nOK & "Photo=No"></cfif>
		<cfif nOK NEQ form.oLogOK>
			<cfset form.appType = "Emp Agreement: OKs">
			<cfset form.appFrom = form.oLogOK>
			<cfset form.appTo = nOK>
			<cfinsert datasource="#session.orgData#" tablename="appLog" formfields="appType, empID, accID, appUser, appDate, appFrom, appTo">
		</cfif>

		<!--- Take action on form data. --->
		<cfif URL.AFX EQ 1><cfinclude template="../_ptsApprove.cfm"><cfelse><cfinclude template="../_ptsSubmit.cfm"></cfif>
	</cfif>
</cfif>


<!--- Display specific form. --->
<cfif showform>
	<cfset captcha = makeRandomString()>
	<cfset captchaHash = hash(captcha)>

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

	<cfset sURL = #cgi.script_name# & "?FFX=" & #URL.FFX# & "&CFX=" & #URL.CFX#>
	<cfif URL.AFX GT 0><cfset sURL = sURL & "&AFX=" & #URL.AFX#></cfif>
	
	<cfform action="#sURL#" method="post">
	<cfoutput>
	<cfif len(errors) GT 0>
		<h2 align="center" style="color: red">Form not submitted - please resubmit after correcting errors in red below.</h2>
	<cfelse>
		<cfquery datasource="#session.orgData#" name="theInstr">
		SELECT docContent1 FROM documents
		WHERE docID = #theForm.formHead#
		</cfquery>
		<cfif theInstr.recordcount GT 0>
			<table width="800" align="center" cellpadding="5" cellspacing="0" border="0">
			<tr><td class="text">#theInstr.docContent1#</td></tr>
			</table>
		</cfif>			
	</cfif>
	
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
				<p>Employee's lodging cost is #dollarformat(theEmp.ldgCost)# (<b>per day for US based employees and per month for Canada based employees</b>) for the duration of Employee's employment and according to this Agreement.</p>
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
	</table>
	</cfoutput>
	
	<h2 align="center">Please Complete Remainder of Form Below (<cfif theEmp.empRehire>Returning Employee<cfelse>New Employee</cfif>)</h2>
	<table width="800" align="center" cellpadding="5" cellspacing="0" border="1">
	<cfif len(errors) GT 0><tr><td class="text" style="color:red" align="center" colspan="2"><cfoutput><b>#errors#</b></cfoutput></td></tr></cfif>
	<tr>
		<td class="text" align="right" width="50%">If you were referred by another Employee<br />please provide their name and location.</td>
		<td align="left" class="little">
			Referred By <cfoutput><cfinput type="Text" class="little" name="refName" value="#form.refName#" size="48" maxlength="50"></cfoutput><br />
			<br />Location&nbsp; &nbsp; <select name="refLoc" class="little" style="width:250px">
			<option value=""></option>
			<cfoutput query="TheLocs"><option value="#locName#" <cfif locName EQ form.refLoc>selected</cfif> >#locName#</option></cfoutput>
			</select>
		</td>
	</tr>
	<cfoutput>
	<cfif theEmp.ldgAvail EQ 1>
		<tr>
			<td class="text" align="right"><b>Please select a Company lodging choice and specify preferences as applicable.</b></td>
			<td class="little" align="left">
				<cfif form.ldgOK>
                    <cfinput type="radio" name="ldgOK" value="1" checked> I accept provisions for Company lodging listed above,<br /> &nbsp; &nbsp; &nbsp; &nbsp; and I agree that the amount of #dollarformat(theEmp.ldgCost)# per day<br /> &nbsp; &nbsp; &nbsp; &nbsp; will be deducted by the company each pay period for the cost of lodging.
                    <br /><cfinput type="radio" name="ldgOK" value="0"> I decline Company lodging listed above.
				<cfelse>
                    <cfinput type="radio" name="ldgOK" value="1"> I accept provisions for Company lodging listed above,<br /> &nbsp; &nbsp; &nbsp; &nbsp; and I agree that the amount of #dollarformat(theEmp.ldgCost)# per day<br /> &nbsp; &nbsp; &nbsp; &nbsp; will be deducted by the company each pay period for the cost of lodging.
                    <br /><cfinput type="radio" name="ldgOK" value="0" checked> I decline Company lodging listed above.
                </cfif>
			</td>
		</tr>
	<cfelse>
		<input type="hidden" name="ldgOK" value="0">
	</cfif>
	<!---
	<tr>
		<td class="text" align="right"><b>Please select your photo release preference. Granting of a photo release is not a pre-condition of employment.</b></td>
		<td class="little" align="left">
			<cfif form.photoOK EQ "1">
				<cfinput type="radio" name="photoOK" value="1" checked> I grant a photo release subject to terms & conditions of this Agreement. <br />
				<cfinput type="radio" name="photoOK" value="0"> I <b>do not</b> grant a photo release.
			<cfelse>
				<cfinput type="radio" name="photoOK" value="1"> I grant a photo release subject to terms & conditions of this Agreement. <br />
				<cfinput type="radio" name="photoOK" value="0" checked> I <b>do not</b> grant a photo release.
			</cfif><br />
		</td>
	</tr>
	--->
	<input type="hidden" name="photoOK" value="0">
	<tr>
		<td class="text" align="right"><b>You must acknowledge and agree to all conditions<br />of this Agreement in order to submit this form.</b></td>
		<td align="left" class="little">
			<cfif form.appOK EQ "1">
				<cfinput type="radio" name="appOK" value="1" checked> <b>Yes, I acknowledge and agree to all above conditions.</b><br /><cfinput type="radio" name="appOK" value="0">No, I don't agree.
			<cfelse>
				<cfinput type="radio" name="appOK" value="1"> <b>Yes, I acknowledge and agree to all above conditions.</b><br /><cfinput type="radio" name="appOK" value="0" checked>No, I don't agree.
			</cfif>
		</td>
	</tr>
	<cfif URL.AFX EQ 1>
		<input type="hidden" name="empSigName" value="#form.empSigName#">
		<input type="hidden" name="empSigDate" value="#form.empSigDate#">
		<tr>
			<td class="text" align="right"><b>Electronically signed by:</b></td>
			<td align="left" class="little">#form.empSigName# on #dateformat(theEmp.empSigDate,"mm/dd/yy")# at #timeformat(theEmp.empSigDate,"hh:mm tt")#</td>
		</tr>
	<cfelse>
		<tr>
			<td class="text" align="right"><b>By electronically signing the form at right<br />I agree to the terms of this agreement.</b></td>
			<td align="left" class="little">
				<b>My Full Name</b> 
				<cfinput type="Text" class="little" name="empSigName" value="#form.empSigName#" size="48" maxlength="50" required="yes" message="Please provide your full name as an electronic signature.">
				<input type="hidden" name="empSigDate" value="#now()#">
			</td>
		</tr>
	</cfif>
	<tr>
		<td class="text" align="right">
			<cfif URL.AFX EQ 1>
				<b>By typing the security characters at right as my<br />online signature I approve this hiring form.</b>
			<cfelse>
				<b>Please type the security characters at right.</b>
			</cfif>
		</td>
		<td align="left">
			<input type="hidden" name="formID" value="#form.formID#">
			<input type="hidden" name="empID" value="#form.empID#">
			<cfimage action="captcha" text="#captcha#">
			<input type="hidden" name="captchaHash" value="#captchaHash#">
			<input type="text" name="captcha">

			<input type="hidden" name="oLogRef" value="#form.oLogRef#">
			<input type="hidden" name="oLogOK" value="#form.oLogOK#">
		</td>
	</tr>
	</table>
	<p align="center" class="text">
	<cfif URL.AFX EQ 1>
		<input type="submit" class="text" name="send" value="Approve Form"> Any Revisions Will be Saved
	<cfelse>
		<a href="JavaScript:window.print();">Print this Agreement</a> <input type="submit" class="text" name="send" value="Submit Form"> <a href="JavaScript:window.print();">Print this Agreement</a>
	</cfif>
	</p>
	</cfoutput>
	</cfform>
</cfif>

<cfoutput>
<cfinclude template="../_ptsB.cfm">
</cfoutput>