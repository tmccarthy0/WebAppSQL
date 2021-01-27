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
	
	<table width="800" align="center" cellpadding="10" cellspacing="0" border="1">
	<tr>
		<td class="text">
			This agreement between <b><cfif len(theEmp.empHon) GT 0>#theEmp.empHon# </cfif>#theEmp.empFirst# <cfif len(theEmp.empMiddle) GT 0>#theEmp.empMiddle# </cfif>#theEmp.empLast# <cfif len(theEmp.empSuffix) GT 0>#theEmp.empSuffix# </cfif></b> (Employee) 
			and <b>#theEmployer.erName#</b> (hereinafter referred to as the Company) constitutes the entire Agreement. 
		</td>
	</tr>
	<tr>
		<td class="text">
			<h2>Position and Dates of Employment (Term)</h2>
			<p><b>Position Title: </b>#theJob.jobName#.<cfif len(theEmp.jobCode) GT 0>&nbsp; &nbsp; &nbsp; <font class="little"><b>(P/R Code: #theEmp.jobCode#)</b></font></cfif></p>
			<p><b>Term of Temporary/Seasonal Agreement: </b>#dateformat(theEmp.empBeg,'mm/dd/yy')# through #dateformat(theEmp.empEnd,'mm/dd/yy')#.</p>
			<cfif len(theEmp.empTrain) GT 0><p><b>Training Start Date (1): </b>#dateformat(theEmp.empTrain,'mm/dd/yy')#.</p></cfif>
			<cfif len(theEmp.empTrain2) GT 0><p><b>Training Start Date (2): </b>#dateformat(theEmp.empTrain2,'mm/dd/yy')#.</p></cfif>
		</td>
	</tr>
	<tr>
		<td class="text">
			<h2>Point of Hire</h2>
			<p>Employee's "Point of Hire" shall be the <b>#theDiv.divName#</b> division in the location of <b>#theLoc.locName#</b>.</p>
			<cfif theEmp.transCost EQ 0><p>Employee is responsible for transportation to and from Point of Hire.<cfelse>The Company will select and pay for Employee transportation to and from Point of Hire.</p></cfif>
		</td>
	</tr>
	<cfif theEmp.tLocID GT 0>
		<cfquery datasource="#session.orgData#" name="TheTLoc">
		SELECT * FROM trainingLocs
		WHERE tLocID = #theEmp.tLocID#
		</cfquery>
		<cfif TheTLoc.recordcount GT 0>
			<tr>
				<td class="text">
					<h2>Training & Training Location</h2>
					<p><b>Training</b>: Company intends to provide certain training to the Employee to ensure that Employee has the minimum
					certifications required for their position with Company.  Employee acknowledges that Company would not provide this
					training unless Employee intended to continue to work for Company for the Term of this Employee Agreement as set
					forth above.  Accordingly, if Employee voluntarily terminates his/her employment with Company prior to the end of
					the Term or within one (1) year of completing their training (whichever is earlier), Employee agrees to reimburse
					Company, within 30 days of voluntarily terminating his/her employment, 100% of the actual, reasonable and
					documented cost of the training incurred by Company.  The training costs vary depending on the position and minimum
					certifications required, and may include (but are not limited to), registration fees, books, tuition, transportation to and
					from the training site, food, lodging, attending the training, exam fees, and certification fees. </p>
					<p>Employee's "Training Location" shall be #TheTLoc.tLocName#.&nbsp; &nbsp; &nbsp; <font class="little"><b>(#TheTLoc.tLocAbbrev#<cfif #len(TheTLoc.tLocCode)# GT 0>-#TheTLoc.tLocCode#</cfif>)</b></font></p>
				</td>
			</tr>
		</cfif>
	</cfif>
	<tr>
		<td class="text">
			<h2>Compensation</h2>
			<p><b>Compensation</b> will comply with applicable state and federal laws and guidelines. Hourly employees will be paid for hours worked at an hourly rate, with overtime at one and one-half times the hourly rate. For training purposes, the training wage is paid at an hourly rate. Training hours do not count toward the Longevity Incentive pay.</p>
			<cfif theEmp.wageT1 GT 0><p><b>Training Wage(1):</b> #dollarformat(theEmp.wageT1)# per hour. <cfif theEmp.empTrainCode GT 0>(#theEmp.empTrainCode#)</cfif></p></cfif>
			<cfif theEmp.wageT2 GT 0><p><b>Training Wage(2):</b> #dollarformat(theEmp.wageT2)# per hour. <cfif theEmp.empTrainCode2 GT 0>(#theEmp.empTrainCode2#)</cfif></p></cfif>
			<p><b>Temporary/Seasonal Agreement Rate of Pay:</b> <cfif theEmp.wageHr GT 0>#dollarformat(theEmp.wageHr)# per hour.<cfelseif theEmp.wageBw GT 0>Exempt status at the bi-weekly rate of #dollarformat(theEmp.wageBw)#.<cfelseif theEmp.wageDay GT 0>Exempt status at the daily rate of #dollarformat(theEmp.wageDay)#.</cfif></p>
			<cfif theEmp.wageIncAvl EQ 1>
				<p><b>Longevity Incentive:</b> Upon successful completion of the work season, Employee (hourly employees only) shall be eligible for a Longevity Incentive Bonus equal to 
					<cfif theEmp.wageIncPct GT 0>#theEmp.wageIncPct#% of gross earnings<cfelse>#dollarformat(theEmp.wageIncRT)# per regular time hour<cfif theEmp.wageIncOT GT 0> and #dollarformat(theEmp.wageIncOT)# per overtime hour</cfif></cfif>.</p>
				<p>Successful completion of the work season is a requirement for incentive pay eligibility.  If the Employee voluntarily terminates employment, or is discharged for any reason prior to completion of this Agreement, the Employee will NOT BE eligible for any incentive pay.  Training periods do not count toward the longevity incentive (bonus) calculation.  Eligible longevity incentive pay will be paid by October 31, or by the end of Agreement, whichever comes last.</p>
			<cfelseif theEmp.wageIncAvl EQ 2>
				<h2><b>Incentive Program for Non Exempt Employees Only:</b></h2>
				<p>Employee understands and agrees that successful completion of the work season is a condition of incentive pay eligibility.  Should the Employee voluntarily terminate employment or be discharged for cause prior to completion of this Agreement, Employee is not eligible for any incentive program.  Driver training hours will not be included in incentive pay calculations.</p>
				<p><b>Safety Incentive Bonus</b> - Earn up to 5%.</p>
				<p><b>Season Compliance & Longevity Bonus</b> - depending upon years of service.</p>
                <ul>
                <li> Years of Service: #theEmp.wageIncYrs#.</li>
                <li> Longevity Bonus: #theEmp.wageIncLng#.</li>
                </ul>
                <h2><b>CDL Driver Guide Additional Bonus Opportunity</b></h2>
				<p><b>1) Remote Highway Assignment Bonus</b> - $25 bonus per revenue trip for North Klondike and Denali Highway routes. <b>2) Overnight Shuttle Assignment Bonus</b> - $25 bonus per overnight shuttle assignment in Denali.</p>
				<ul>
                <li> Eligibility: Employee is assigned specific remote highway route or overnight shuttle route as part of work assignment.</li>
				<li> Payment: All bonuses are taxable.  Bonus is awarded upon successful completion of seasonal contract.</li>
				</ul>
			</cfif>
		</td>
	</tr>
	

		<td class="text">
			<h2>Lodging and Meals</h2>
			<p><b>Lodging:</b> Company lodging <cfif theEmp.ldgAvail GT 0>is available<cfelse>is not available</cfif> at Point of Hire.</p>
			<cfif theEmp.ldgAvail GT 0>
				<p>Employee's lodging cost is #dollarformat(theEmp.ldgCost)# (<b>per day for US based employees and per month for Canada based employees</b>), for the duration of Employee's employment and according to this Agreement.</p>
				<p><b>Company housing/lodging is conditional upon active employment with the Company. When employment terminates, whether voluntarily or involuntarily, employee must vacate the housing and property immediately.</b> 
				If Company lodging is elected by employee, employee agrees that the cost of lodging will be deducted from the Employee's pay check. The Company reserves the right of entry into Employee's room or accommodation provided by Company 
				for the purpose of inspection, or in the event of any emergency involving threat of life or health, safety or welfare of Company employee(s) or property according to applicable state laws. 
				The Company reserves the right to conduct periodic accommodation inspections. All rules of conduct, discipline, etc. as outlined in the Employee Handbook apply to employees residing in Company provided housing. 
				Lodging will be provided at Company expense when Employee is required to overnight at a location other than Point of Hire. A meal plan or meal discount is required for employees living in Company housing.</p>
			</cfif>
			<cfset foodProg = theEmp.foodCostDay + theEmp.foodCostEach + len(theEmp.foodDiscount)>
			<p><b>Meals:</b> <cfif foodProg GT 0>Employee shall be eligible for the following discounts.<cfelse>No meal discounts are available at Point of Hire.</cfif></p>
			<ul>
			<cfif theEmp.foodCostDay GT 0><li>Meals are provided at a cost of #dollarformat(theEmp.foodCostDay)# per day in designated Company dining areas. Employee agrees to have the costs of meals deducted from paycheck.</li></cfif>
			<cfif theEmp.foodCostEach GT 0><li>On-shift meal(s) are provided at a cost of #dollarformat(theEmp.foodCostEach)# per meal in designated Company dining areas. Employee agrees to have the costs of meals deducted from paycheck.</li></cfif>
			<cfif theEmp.foodDiscount GT 0><li>Meal discount of #theEmp.foodDiscount#% off of menu pricing in designated Company dining areas.</li></cfif>
			</ul>
		</td>
	</tr>	
	<tr><td class="text">#thePolicy.docContent1#</td></tr>
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
				<cfif form.ldgOK EQ "1">
					<cfinput type="radio" name="ldgOK" value="1" checked> I accept provisions for Company lodging listed in this Agreement,<br /> &nbsp; &nbsp; &nbsp; &nbsp; and I decline to use accessible alternate public lodging.
					<br /><cfinput type="radio" name="ldgOK" value="0"> I decline Company lodging listed in this Agreement.
				<cfelse>
					<cfinput type="radio" name="ldgOK" value="1"> I accept provisions for Company lodging listed in this Agreement,<br /> &nbsp; &nbsp; &nbsp; &nbsp; and I decline to use accessible alternate public lodging.
					<br /><cfinput type="radio" name="ldgOK" value="0" checked> I decline Company lodging listed in this Agreement.
				</cfif>
			</td>
		</tr>
	<cfelse>
		<input type="hidden" name="ldgOK" value="0">
	</cfif>
	<tr>
		<td class="text" align="right"><b>Please select your photo release preference. Granting of a photo release is not a pre-condition of employment.</b></td>
		<td class="little" align="left">
			<cfif form.photoOK EQ "1">
				<cfinput type="radio" name="photoOK" value="1" checked> I grant a photo and/or social media post(s) release subject to terms & conditions of this Agreement. <br />
				<cfinput type="radio" name="photoOK" value="0"> I <b>do not</b> grant a photo release.
			<cfelse>
				<cfinput type="radio" name="photoOK" value="1"> I grant a photo release and/or social media post(s) subject to terms & conditions of this Agreement. <br />
				<cfinput type="radio" name="photoOK" value="0" checked> I <b>do not</b> grant a photo release.
			</cfif><br />
		</td>
	</tr>
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