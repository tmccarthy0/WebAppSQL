<cfinclude template="../_ptsT.cfm">
<cfinclude template="../_ptsIntro.cfm">

<!--- Initialize specific form fields. --->
<cfoutput>
<cfparam name="form.empID" default="#theEmp.empID#">
<cfparam name="form.empEIN" default="#theEmp.empEIN#">
<cfparam name="form.empFirst" default="#theEmp.empFirst#">
<cfparam name="form.empMiddle" default="#theEmp.empMiddle#">
<cfparam name="form.empLast" default="#theEmp.empLast#">
<cfparam name="form.empAddress1" default="#theEmp.empAddress1#">
<cfparam name="form.empState" default="#theEmp.empState#">
<cfparam name="form.empCity" default="#theEmp.empCity#">
<cfparam name="form.empZip" default="#theEmp.empZip#">
<cfparam name="form.empBirth" default="#theEmp.empBirth#">
<cfparam name="form.ptcNonRes" default="#theEmp.ptcNonRes#">
<cfparam name="form.ptcOtherEmp" default="#theEmp.ptcOtherEmp#">
<cfparam name="form.ptcIncLess" default="#theEmp.ptcIncLess#">
<cfparam name="form.ptcIncRem" default="#theEmp.ptcIncRem#">
<cfparam name="form.ptcRemZone" default="#theEmp.ptcRemZone#">
<cfparam name="form.ptcAddlTax" default="#theEmp.ptcAddlTax#">
<cfloop index="iCtr" from="1" to="13"><cfparam name="form.ptc#iCtr#" default="#evaluate('theEmp.ptc' & iCtr)#"></cfloop>
</cfoutput>

<!--- Initialize instruction fields. --->
<cfif isdefined('form.ins1')>
    <cfloop index="iCtr" from="1" to="13">
    <cfparam name="form.ins#iCtr#" default="#evaluate('form.ins' & iCtr)#">
    </cfloop>
<cfelse>
	<cfset form.ins1 = "<b>1. Basic personal amount</b> -  Every person employed in the Yukon and every pensioner residing in the Yukon can claim this
	amount. If you will have more than one employer or payer at the same time in #year(now())#, see 'More than one employer or payer at the same time' at the bottom.">
	<cfset form.ins2 = "<b>2. Family caregiver amount for infirm children under age 18</b> -  Either parent (but not both), may claim $2,273 for each infirm child
	born in 2003 or later, that resides with both parents throughout the year. If the child does not reside with both parents throughout the
	year, the parent who is entitled to claim the “Amount for an eligible dependant” on line 8 may also claim the family caregiver amount for
	that same child who is under age 18.">
	<cfset form.ins3 = "<b>3. Age amount</b> - If you will be 65 or older on December 31, #year(now())#, and your net income for the year from all sources will be 	$38,508 or less, enter $7,637. If your net income for the year will be between $38,508 and $89,422 and you want to calculate a partial claim,
	get Form TD1YT-WS, Worksheet for the Yukon #year(now())# Personal Tax Credits Return, and complete the appropriate section.">
	
	<cfset form.ins4 = "<b>4. Pension income amount</b> - If you will receive regular pension payments from a pension plan or fund (excluding Canada Pension
		Plan, Quebec Pension Plan, Old Age Security, or Guaranteed Income Supplement payments), enter $2,000 or your estimated
		annual pension income, whichever is less.">
	
	<cfset form.ins5 = "<b>5. Tuition (full time and part time)</b> - If you are a student enrolled at a university or college, or an educational institution certified 	by Employment and Social Development Canada, and you will pay more than $100 per institution in tuition fees, fill in this section. If you
		are enrolled full time or part time, enter the total of the tuition fees you will pay.">
	<cfset form.ins6 = "<b>6. Disability amount</b> - If you will claim the disability amount on your income tax return by using Form T2201, Disability tax credit
		application, enter $8,576.">
	<cfset form.ins7 = "<b>7. Spouse or common-law partner amount</b> - If you are supporting your spouse or common-law partner who lives with you and
		whose net income for the year will be less than $12,298 ($14,571 if he or she is infirm) enter the difference between this amount
		and his or her estimated net income for the year. If his or her net income for the year will be $12,298 or more ($14,571 or more if he or
		she is infirm), you cannot claim this amount. In all cases, if his or her net income for the year will be $24,361 or less and he or she is inform go to line 		9.">
	<cfset form.ins8 = "<b>8. Amount for an eligible dependant</b> - If you do not have a spouse or common-law partner and you support a dependent relative
		who lives with you, and whose net income for the year will be less than $12,298 ($14,571 if he or she is infirm and you did not
		claim the child amount for this dependant), enter the difference between this amount and his or her estimated net income. If his or
		her net income for the year will be $12,298 or more ($14,571 or more if he or she is infirm), you cannot claim this amount. In all cases, if his or her net 		income for the year will be $24,361 or less and he or she is inform go to line 9.">
	<cfset form.ins9 = "<b>9. Yukon Caregiver amount for eligible dependent or spouse or common-law partner</b> - If at any time of the year, you support an infirm 			eligible dependant (aged 18 or older) or an infirm spouse or common-law partner whose net income will be $24,361 or less, get Form TD1YT-WS and fill in 		the appropriate section.">
	<cfset form.ins10 = "<b>10. Yukon caregiver amount for the eligible dependant or spouse or common-law partner</b> - If, at any time in the year, you support an 			infirm dependant age 18 or older (other than the spouse or common-law partner or eligible dependant you claimed an amount for on line 9, or could
		have claimed an amount for if his or her net income were under $14,571) whose net income for the year will be $17,085 or less,
		enter $7,276. If his or her net income for the year will be between $17,085 and $24,361 and you want to calculate a partial claim, get		
		Form TD1YT-WS and fill in the appropriate section. You can claim this amount for more than one infirm dependant age 18 or older. If you
		are sharing this amount with another caregiver who supports the same dependant, get the Form TD1YT-WS and fill in the appropriate
		section.">
	<cfset form.ins11 = "<b>11. Amounts transferred from your spouse or common-law partner</b> - If your spouse or common-law partner will not use all of
		their age amount, pension income amount, tuition amount, or disability amount on their income tax and benefit return, enter the unused
		amount.">
	<cfset form.ins12 = "<b>12. Amounts transferred from a dependant</b> -  If your dependant will not use all of their <b>disability amount</b> on their
		income tax and benefit return, enter the unused amount. If your or your spouse's or common-law partner's dependent child or
		grandchild will not use all of their <b>tuition amount</b> on their income tax and benefit return, enter the unused amount. ">
	<cfset form.ins13 = "<b>13. TOTAL CLAIM AMOUNT</b> - Add lines 1 to 12.
		Your employer or payer will use this amount to determine the amount of your tax deductions.">
</cfif>


<!--- Check for post-form errors and process form submittal or approval. --->
<cfif isdefined('send')>
	<cfset errors = "">
	<cfif form.ptcOtherEmp><cfset form.ptc13 = 0></cfif>
    <cfif form.ptcIncRem><cfset form.ptc13 = 0></cfif>
	<cfif form.ptc13 EQ 0>
		<cfloop index="iCtr" from="1" to="12">
		<cfset "form.ptc#iCtr#" = 0>
        </cfloop>
	<cfelse>
		<cfset fTot = 0>
		<cfloop index="iCtr" from="1" to="12">
		<cfset fTot = fTot + evaluate("form.ptc" & iCtr)>
        </cfloop>
		<cfset form.ptc13 = fTot>
    </cfif>

	<cfif hash(ucase(form.captcha)) NEQ form.captchaHash><cfset errors = errors & "Please correctly enter the security code below.<br />"></cfif>
	<!--- If no errors, process form data. --->
	<cfif errors IS "">
		<cfset showForm = false>
		<!--- Take action on form data, if employee. --->
		<cfif URL.AFX EQ 0>
			<cfset form.appUpdate = now()>
			<cfupdate datasource="#session.orgData#" tablename="employees" formfields="empID, empEIN,
            	empFirst, empMiddle, empLast, empAddress1, empCity, empState, empZip,
                ptc1, ptc2, ptc3, ptc4, ptc5, ptc6, ptc7, ptc8, ptc9, ptc10, ptc11, ptc12, ptc13,
                ptcNonRes, ptcOtherEmp, ptcIncLess, ptcIncRem, ptcRemZone, ptcAddlTax">
			<cfinclude template="../_ptsSubmit.cfm">

		<!--- Take action on form data, if supervisor. --->
		<cfelseif URL.AFX EQ 1>
			<cfset form.appUpdate = now()>
			<cfupdate datasource="#session.orgData#" tablename="employees" formfields="empID, empEIN,
            	empFirst, empMiddle, empLast, empAddress1, empCity, empState, empZip,
                ptc1, ptc2, ptc3, ptc4, ptc5, ptc6, ptc7, ptc8, ptc9, ptc10, ptc11, ptc12, ptc13,
                ptcNonRes, ptcOtherEmp, ptcIncLess, ptcIncRem, ptcRemZone, ptcAddlTax">
			<cfinclude template="../_ptsApprove.cfm">
		</cfif>
	</cfif>
</cfif>


<!--- Display specific form. --->
<cfif showform>
	<cfoutput>
	<cfset captcha = makeRandomString()>
	<cfset captchaHash = hash(captcha)>

	<cfset sURL = #cgi.script_name# & "?FFX=" & #URL.FFX# & "&CFX=" & #URL.CFX#>
	<cfif URL.AFX GT 0><cfset sURL = sURL & "&AFX=" & #URL.AFX#></cfif>

	<cfform action="#sURL#" method="post">
	<cfif len(errors) GT 0><h2 align="center" style="color: red">Form not submitted - please resubmit after correcting errors in red below.</h2></cfif>

	<table width="800" align="center" cellpadding="5" cellspacing="0" border="0">
	<tr>
		<td align="left" class="text" width="30%"><b>Canadian Revenue Agency<br />Agence du Revenue du Canada</b></td>
		<td align="center" class="text" width="40%"><h1>#year(now())# Personal Tax Credit Return</h1></td>
		<td align="right" class="text" width="30%"><b>Protected B</b> When Completed<h1>TD1YT</h1></td>
	</tr>
	<tr>
    	<td align="left" class="text" colspan="3">
			Your employer or payer will use this form to determine the amount of your tax deductions.
            <br>Complete this form based on the best estimate of your circumstances.
			<p>The section 2 includes the proposal to eliminate the Child amount for #year(now())# and subsequent taxation years in conjunction with the enhancements to the universal child care benefit (UCCB).</p>
        </td>
    </tr>
	</table>

	<table width="800" align="center" cellpadding="5" cellspacing="0" border="1">
	<tr>
		<td align="left" class="text" width="25%">First Name<br /><cfinput type="Text" class="text" name="empFirst" value="#form.empFirst#" size="15" maxlength="25" required="yes" message="Please enter your first name."></td>
		<td align="left" class="text" width="25%">Middle Name<br /><cfinput type="Text" class="text" name="empMiddle" value="#form.empMiddle#" size="15" maxlength="15"></td>
		<td align="left" class="text" width="25%">Last Name<br /><cfinput type="Text" class="text" name="empLast" value="#form.empLast#" size="15" maxlength="25" required="yes" message="Please enter your last name."></td>
		<td align="left" class="text" width="25%">Social Insurance Number<br /><cfinput type="Text" class="text" name="empEIN" value="#form.empEIN#" size="15" maxlength="20" required="yes" message="Please enter your social security number."></td>
	</tr>
	<tr>
		<td align="left" class="text" colspan="3">Mailing Address<br /><cfinput type="Text" class="text" name="empAddress1" value="#form.empAddress1#" size="60" maxlength="75"  required="yes" message="Please enter your mailing address."></td>
		<td align="left" class="text">Date of Birth<br><cfinput type="Text" class="text" name="empBirth" value="#dateformat(form.empBirth,'mm/dd/yyyy')#" size="15" required="yes" message="Please enter your birth date in format mm/dd/yy."></td>
	</tr>
	<tr>
		<td align="left" class="text">City<br /><cfinput type="Text" class="text" name="empCity" value="#form.empCity#" size="15" maxlength="25" required="yes" message="Please enter your city."></td>
		<td align="left" class="text">Province<br /><cfinput type="Text" class="text" name="empState" value="#form.empState#" size="15" maxlength="15" required="yes" message="Please enter your state code."></td>
		<td align="left" class="text">Postal Code<br /><cfinput type="Text" class="text" name="empZip" value="#form.empZip#" size="15" maxlength="15" required="yes" message="Please enter your zip code."></td>
		<td align="left" class="text">Country of Residence<br><cfinput type="Text" class="text" name="ptcNonRes" value="#form.ptcNonRes#" size="15" maxlength="25" required="no"></td>
	</tr>
	</table>

	<table width="800" align="center" cellpadding="5" cellspacing="0" border="1">
	<cfset fTot = 12298>
	<cfif form.ptcOtherEmp><cfset fTot = 0></cfif>
    <cfif form.ptcIncRem><cfset fTot = 0></cfif>
	<cfloop index="iCtr" from="1" to="13">
	<tr>
		<td align="left" class="text" colspan="5" width="83%">#evaluate('form.ins' & iCtr)#</td>
		<td align="center" class="text" width="17%">
			<cfif iCtr EQ 1>
				#fTot#
				<input type="hidden" name="ptc1" value="#fTot#">
			<cfelseif iCtr EQ 13>
				#fTot#
				<input type="hidden" name="ptc13" value="#fTot#">
            <cfelse>
				<cfset fAmt = evaluate('form.ptc' & iCtr)>
				<cfif form.ptcOtherEmp><cfset fAmt = 0></cfif>
                <cfif form.ptcIncRem><cfset fAmt = 0></cfif>
				<cfif isnumeric(fAmt)><cfset fTot = fTot + fAmt></cfif>
	        	<cfinput type="text" size="5" value="#fAmt#" name="ptc#iCtr#" required="no" validate="integer" message="Please enter a non-negative integer or leave field #iCtr# blank.">
			</cfif>
        </td>
	</tr>
	<input type="hidden" name="ins#iCtr#" value="#evaluate('form.ins' & iCtr)#">
    </cfloop>
	<tr>
		<td class="text" align="left" colspan="3" width="50%"><b>By typing the security characters at right as my online signature, I declare under penalty of perjury that I have examined this certificate and to the best of my knowledge and belief, it is true, correct, and complete.</b></td>
		<td align="left" colspan="3" class="text" width="50%">
			<cfif len(errors) GT 0><font color="red"><b>#errors#</b></font><br /></cfif>
			<input type="hidden" name="formID" value="#form.formID#">
			<input type="hidden" name="empID" value="#form.empID#">
			<cfimage action="captcha" text="#captcha#">
			<input type="hidden" name="captchaHash" value="#captchaHash#">
			<input type="text" name="captcha">
		</td>
	</tr>
	</table>
	<p align="center" class="text">
	<cfif URL.AFX EQ 1>
		<input type="submit" class="text" name="calc" value="Calculate Total"> <input type="submit" class="text" name="send" value="Approve Form"> Any Revisions Will be Saved
	<cfelse>
		<a href="JavaScript:window.print();">Print this Form</a><input type="submit" class="text" name="calc" value="Calculate Total"> <input type="submit" class="text" name="send" value="Submit Form"> <a href="JavaScript:window.print();">Print this Form</a>
	</cfif>
	</p>
	<table width="800" align="center" cellpadding="5" cellspacing="0" border="1">
	<tr>
		<td align="left" class="text" colspan="2">
			<h1>Filling out Form TD1YT</h1>
            <p>Fill out this form <b>only</b> if you are an employee working in the Yukon or a pensioner residing in the Yukon and any of the following apply:</p>
            <ul>
            <li> you have a new employer or payer and you will receive salary, wages, commissions, pensions, employment insurance benefits, or any other remuneration;</li>
            <li> you want to change amounts you previously claimed (for example, the number of your eligible dependants has changed); </li>
            <li> you want to increase the amount of tax deducted at source.</li>
			</ul>
            <p>Sign and date it, and give it to your employer or payer.</p>
            <p>If you do not complete Form TD1YT, your employer or payer will deduct taxes after allowing the basic personal amount <b>only</b>.</p>
		</td>
    </tr>
	<tr>
		<td align="left" class="text" width="83%">
            <h2>More than one employer or payer at the same time</h2>
            If you have more than one employer or payer at the same time and you have already claimed personal tax credit amounts on another Form TD1YT for
            #year(now())#, <B>you cannot claim them again</B>. If your total income from all sources will be more than the personal tax credits you claimed on another
            Form TD1YT, check this box and enter "0" on line 13 and do not fill in lines 2 - 12.  
		</td>
		<td align="center" class="text" width="17%">
        	<cfif form.ptcOtherEmp>
                <input type="checkbox" value="1" name="ptcOtherEmp" checked>
			<cfelse>
                <input type="checkbox" value="1" name="ptcOtherEmp">
			</cfif>
        </td>
	</tr>
	<tr>
		<td align="left" class="text" width="83%">
            <h2>Total income less than total claim amount</h2>
            Check this box if your total income for the year from <B>all</B> employers and payers will be <B>less</B> than your total claim amount on line 13. Your employer or
            payer will not deduct tax from your earnings.
		</td>
		<td align="center" class="text" width="17%">
        	<cfif form.ptcIncLess>
	        	<input type="checkbox" value="1" name="ptcIncLess" checked>
			<cfelse>
	        	<input type="checkbox" value="1" name="ptcIncLess">
			</cfif>
        </td>
	</tr>
	
		<td align="left" class="text" width="83%">
            <h2>Additional tax to be deducted</h2>
            If you wish to have more tax deducted, fill in "Additional tax to be deducted" on the federal Form TD1.
   		</td>
	</tr>
	<tr>
		<td align="left" class="text" colspan="2">
            <h2>Reduction in tax deductions</h2>
            You can ask to have less tax deducted on your income tax and benefit return if you are eligible for deductions or non-refundable tax credits that are not listed
on this form (for example, periodic contributions to a registered retirement savings plan (RRSP), child care or employment expenses, charitable donations, and
tuition and education amounts carried forward from the previous year). To make this request, fill out Form T1213, Request to Reduce Tax Deductions at
Source, to get a letter of authority from your tax services office. Give the letter of authority to your employer or payer. You do not need a letter of authority if
your employer deducts RRSP contributions from your salary
   		</td>
    </tr>
    </table>
	<p align="center" class="text">
	<cfif URL.AFX EQ 1>
		<input type="submit" class="text" name="calc" value="Calculate Total"> <input type="submit" class="text" name="send" value="Approve Form"> Any Revisions Will be Saved
	<cfelse>
		<a href="JavaScript:window.print();">Print this Form</a><input type="submit" class="text" name="calc" value="Calculate Total"> <input type="submit" class="text" name="send" value="Submit Form"> <a href="JavaScript:window.print();">Print this Form</a>
	</cfif>
	</p>
	</cfform>
	</cfoutput>
</cfif>

<cfoutput>
<cfinclude template="../_ptsB.cfm">
</cfoutput>