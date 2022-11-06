// Project: Stata command to calculate the Charlson Comorbidity Index based on ICD-10 diagnosis codes
// Created by: James Hedley
// Adapted from: charlson.R by James Hedley
// Date created: 6th November 2022
// Last updated: 6th November 2022


* Program to create a flag variable based on the ICD codes specified
capture program drop icdcode_flag
program define icdcode_flag, rclass
	syntax , ///
		Generate(namelist max=1) [Replace] ///
		[Diag_code_vars(varlist min=1)] ///
		[Icdcodes(string)] ///
		[Regex(string)]	
	
	
	* Fill in default diagnosis code variables
	if "`diag_code_vars'" == "" {
		local diag_code_vars = "diagnosis_codeP"
		forvalues i=1/50 {
			local diag_code_vars = "`diag_code_vars' diagnosis_code`i'"
		}
	}
	
	* Confirm that only one of ICDcodes or Regex is specified
	if "`icdcodes'" != "" & "`regex'" != "" {
		display as error "Only one of ICDcodes and Regex can be specified"
	}

	if "`icdcodes'" == "" & "`regex'" == "" {
		display as error "One of ICDcodes or Regex must be specified"
	}
	
	
	* Confirm that new variable name does not already exist (if replace has not been specified)
	if "`replace'" == "" confirm new variable `generate'
	
		
	* Create a flag variable based on specified ICDcodes
	if "`icdcodes'" != "" {
		if "`replace'" != "" capture drop `generate'
		gen `generate' = 0
		foreach var in `diag_code_vars' {
			foreach icdcode in `icdcodes' {
				quietly replace `generate' = 1 if `var' == "`icdcode'"
			} // End of loop through ICD codes
		} // End of loop through diagnosis code variables
	} // End of if statement to check if ICD codes were specified
	

	* Create a flag variable based on specified Regex pattern
	if "`regex'" != "" {
		if "`replace'" != "" capture drop `generate'
		gen `generate' = 0
		foreach var in `diag_code_vars' {
			quietly replace `generate' = 1 if ustrregexm(`var', "`regex'") == 1
		} // End of loop through diagnosis code variables
	} // End of if statement to check if Regex pattern was specified
	

end


* Program to calculate Charlson Comorbidity Index (CCI)
capture program drop charlson
program define charlson, rclass
	syntax , ///
		[Generate(varlist max=1) Replace] ///
		[Diag_code_vars(varlist min=1)] ///
		[Flag_vars(varlist min=1)] [DROP_Flags] ///
		[Categories CATEGORY_Var(varlist max=1) CATEGORY_VAR_Replace] ///
		[CATEGORY_Breaks(numlist min=2) CATEGORY_Labels(string) CATEGORY_LABEL_Name(string)] ///
		[regex_ami(string)] ///
		[regex_chf(string)] /// 
		[regex_pvd(string)] ///
		[regex_cva(string)] ///
		[regex_dementia(string)] ///
		[regex_pulmonary_disease(string)] ///
		[regex_ctd(string)] ///
		[regex_peptic_ulcer(string)] ///
		[regex_liver_disease(string)] ///
		[regex_diabetes(string)] ///
		[regex_diabetes_complications(string)] ///
		[regex_paraplegia(string)] ///
		[regex_renal_disease(string)] ///
		[regex_cancer(string)] ///
		[regex_metastatic_cancer(string)] ///
		[regex_severe_liver_disease(string)] ///
		[regex_hiv(string)] ///
		[icdcodes_ami(string)] ///
		[icdcodes_chf(string)] /// 
		[icdcodes_pvd(string)] ///
		[icdcodes_cva(string)] ///
		[icdcodes_dementia(string)] ///
		[icdcodes_pulmonary_disease(string)] ///
		[icdcodes_ctd(string)] ///
		[icdcodes_peptic_ulcer(string)] ///
		[icdcodes_liver_disease(string)] ///
		[icdcodes_diabetes(string)] ///
		[icdcodes_diabetes_complications(string)] ///
		[icdcodes_paraplegia(string)] ///
		[icdcodes_renal_disease(string)] ///
		[icdcodes_cancer(string)] ///
		[icdcodes_metastatic_cancer(string)] ///
		[icdcodes_severe_liver_disease(string)] ///
		[icdcodes_hiv(string)] ///
		[weight_ami(numlist max=1)] ///
		[weight_chf(numlist max=1)] ///
		[weight_pvd(numlist max=1)] ///
		[weight_cva(numlist max=1)] ///
		[weight_dementia(numlist max=1)] ///
		[weight_pulmonary_disease(numlist max=1)] ///
		[weight_ctd(numlist max=1)] ///
		[weight_peptic_ulcer(numlist max=1)] ///
		[weight_liver_disease(numlist max=1)] ///
		[weight_diabetes(numlist max=1)] ///
		[weight_diabetes_complications(numlist max=1)] ///
		[weight_paraplegia(numlist max=1)] ///
		[weight_renal_disease(numlist max=1)] ///
		[weight_cancer(numlist max=1)] ///
		[weight_metastaic_cancer(numlist max=1)] ///
		[weight_severe_liver_disease(numlist max=1)] ///
		[weight_hiv(numlist max=1)]
		
	* Fill in default new variable name
	if "`generate'" == "" local generate = "cci"	
	
	
	* Fill in default diagnosis code variables
	if "`diag_code_vars'" == "" {
		local diag_code_vars = "diagnosis_codeP"
		forvalues i=1/50 {
			local diag_code_vars = "`diag_code_vars' diagnosis_code`i'"
		}
	}
	
	* Fill in default flag variables
	if "`flag_vars'" == "" {
		local flag_vars = "ami chf pvd cva dementia pulmonary_disease ctd " + ///
			"peptic_ulcer liver_disease diabetes diabetes_complications " + ///
			"paraplegia renal_disease cancer metastatic_cancer severe_liver_disease hiv"
	}
	
	
	* Creae local macros for each flag variable
	local flag_ami : word 1 of `flag_vars'
	local flag_chf : word 2 of `flag_vars'
	local flag_pvd : word 3 of `flag_vars'
	local flag_cva : word 4 of `flag_vars'
	local flag_dementia : word 5 of `flag_vars'
	local flag_pulmonary_disease : word 6 of `flag_vars'
	local flag_ctd : word 7 of `flag_vars'
	local flag_peptic_ulcer : word 8 of `flag_vars'
	local flag_liver_disease : word 9 of `flag_vars'
	local flag_diabetes : word 10 of `flag_vars'
	local flag_diabetes_complications : word 11 of `flag_vars'
	local flag_paraplegia : word 12 of `flag_vars'
	local flag_renal_disease : word 13 of `flag_vars'
	local flag_cancer : word 14 of `flag_vars'
	local flag_metastatic_cancer : word 15 of `flag_vars'
	local flag_severe_liver_disease : word 16 of `flag_vars'
	local flag_hiv : word 17 of `flag_vars'
	
	
	* Fill in default values for category variables
	if "`category_var'" == "" local category_var = "ccicat"
	if "`category_breaks'" == "" local category_breaks 0 1 3 1000
	if "`category_labels'" == "" local category_labels "0 1-2 3+"
	if "`category_label_name'" == "" local category_label_name "ccicatlbl"

	
	* Fill in default Regex patterns
	if "`regex_ami'" == "" local regex_ami = ///
		"(?i)^(I21|I22|I25\.2)"
		
	if "`regex_chf'" == "" local regex_chf = ///
		"(?i)^(I50)"
		
	if "`regex_pvd'" == "" local regex_pvd = ///
		"(?i)^(I71|I79\.0|I73\.9|R02|Z95\.8|Z95\.9)"
		
	if "`regex_cva'" == "" local regex_cva = ///
		"(?i)^(I60|I61|I62|I63|I64|I65|I66" + ///
		"|I67\.0|I67\.1|I67\.2" + ///
		"|I67\.4|I67\.5|I67\.6|I67\.7|I67\.8|I67\.9" + ///
		"|I68\.1|I68\.2|I68\.8|I69|G46" + ///
		"|G45\.0|G45\.1|G45\.2|G45\.4|G45\.8|G45\.9)"
		
	if "`regex_dementia'" == "" local regex_dementia = ///
		"(?i)^(F00|F01|F02|F05\.1)"
		
	if "`regex_pulmonary_disease'" == "" local regex_pulmonary_disease = ///
		"(?i)^(J40|J41|J42|J43|J44|J45|J46|J47" + ///
		"|J60|J61|J62|J63|J64|J65|J66|J67)"
		
	if "`regex_ctd'" == "" local regex_ctd = ///
		"(?i)^(M05\.0|M05\.1|M05\.2|M05\.3" + ///
		"|M05\.8|M05\.9|M06\.0" + ///
		"|M32|M34|M33\.2|M06\.3|M06\.9|M35\.3)"
		
	if "`regex_peptic_ulcer'" == "" local regex_peptic_ulcer = ///
		"(?i)^(K25|K26|K27|K28)"
		
	if "`regex_liver_disease'" == "" local regex_liver_disease = ///
		"(?i)^(K74\.2|K74\.3|K74\.4|K74\.5|K74\.6" + ///
		"|K70\.2|K70\.3|K71\.7|K73|K74\.0)"
		
	if "`regex_diabetes'" == "" local regex_diabetes = ///
		"(?i)^(E10\.9|E11\.9|E13\.9|E14\.9" + ///
		"|E10\.1|E11\.1|E13\.1|E14\.1" + ///
		"|E10\.5|E11\.5|E13\.5|E14\.5)"
		
	if "`regex_diabetes_complications'" == "" local regex_diabetes_complications = ///
		"(?i)^(E10\.2|E11\.2|E13\.2|E14\.2" + ///
		"|E10\.3|E11\.3|E13\.3|E14\.3" + ///
		"|E10\.4|E11\.4|E13\.4|E14\.4)"
		
	if "`regex_paraplegia'" == "" local regex_paraplegia = ///
		"(?i)^(G82\.0|G82\.1|G82\.2" + ///
        "|G04\.1|G81)"
		
	if "`regex_renal_disease'" == "" local regex_renal_disease = ///
		"(?i)^(N05\.2|N05\.3|N05\.4|N05\.5|N05\.6" + ///
		"|N07\.2|N07\.3|N07\.4" + ///
		"|N01|N03|N18|N19|N25)"
		
	if "`regex_cancer'" == "" local regex_cancer = ///
		"(?i)^(C40|C41|C43|C95|C96" + ///
		"|C00|C01|C02|C03|C04|C05|C06|C07|C08|C09" + ///
		"|C10|C11|C12|C13|C14|C15|C16|C17|C18|C19" + ///
		"|C20|C21|C22|C23|C24|C25|C26|C27|C28|C29" + ///
		"|C30|C31|C32|C33|C34|C35|C36|C37|C38|C39" + ///
		"|C45|C46|C47|C48|C49" + ///
		"|C50|C51|C52|C53|C54|C55|C56|C57|C58|C59" + ///
		"|C60|C61|C62|C63|C64|C65|C66|C67|C68|C69" + ///
		"|C70|C71|C72|C73|C74|C75|C76" + ///
		"|C80|C81|C82|C83|C84|C85" + ///
		"|C88\.3|C88\.7|C88\.9|C90\.0|C90\.1|C94\.7" + ///
		"|C91|C92|C93" + ///
		"|C94\.0|C94\.1|C94\.2|C94\.3" + ///
		"|C94.51)"
		
	if "`regex_metastatic_cancer'" == "" local regex_metastatic_cancer = ///
		"(?i)^(C77|C78|C79|C80)"
		
	if "`regex_severe_liver_disease'" == "" local regex_severe_liver_disease = ///
		"(?i)^(K72\.9|K76\.6|K76\.7|K72\.1)"
		
	if "`regex_hiv'" == "" local regex_hiv = ///
		"(?i)^(B20|B21|B22|B23|B24)"
	
	
	* If ICD codes are specified, remove Regex pattern
	if "`icdcodes_ami'" != "" local regex_ami = ""
	if "`icdcodes_chf'" != "" local regex_chf = ""
	if "`icdcodes_pvd'" != "" local regex_pvd = ""
	if "`icdcodes_cva'" != "" local regex_cva = ""
	if "`icdcodes_dementia'" != "" local regex_dementia = ""
	if "`icdcodes_pulmonary_disease'" != "" local regex_pulmonary_disease = ""
	if "`icdcodes_ctd'" != "" local regex_ctd = ""
	if "`icdcodes_peptic_ulcer'" != "" local regex_peptic_ulcer = ""
	if "`icdcodes_liver_disease'" != "" local regex_liver_disease = ""
	if "`icdcodes_diabetes'" != "" local regex_diabetes = ""
	if "`icdcodes_diabetes_complications'" != "" local regex_diabetes_complications = ""
	if "`icdcodes_paraplegia'" != "" local regex_paraplegia = ""
	if "`icdcodes_renal_disease'" != "" local regex_renal_disease = ""
	if "`icdcodes_cancer'" != "" local regex_cancer = ""
	if "`icdcodes_metastatic_cancer'" != "" local regex_metastatic_cancer = ""
	if "`icdcodes_severe_liver_disease'" != "" local regex_severe_liver_disease = ""
	if "`icdcodes_hiv'" != "" local regex_hiv = ""
	
	
	* Fill in default weights
	if "`weight_ami'" == "" local weight_ami = 1
	if "`weight_chf'" == "" local weight_chf = 1
	if "`weight_pvd'" == "" local weight_pvd = 1
	if "`weight_cva'" == "" local weight_cva = 1
	if "`weight_dementia'" == "" local weight_dementia = 1
	if "`weight_pulmonary_disease'" == "" local weight_pulmonary_disease = 1
	if "`weight_ctd'" == "" local weight_ctd = 1
	if "`weight_peptic_ulcer'" == "" local weight_peptic_ulcer = 1
	if "`weight_liver_disease'" == "" local weight_liver_disease = 1
	if "`weight_diabetes'" == "" local weight_diabetes = 1
	if "`weight_diabetes_complications'" == "" local weight_diabetes_complications = 2
	if "`weight_paraplegia'" == "" local weight_paraplegia = 2
	if "`weight_renal_disease'" == "" local weight_renal_disease = 2
	if "`weight_cancer'" == "" local weight_cancer = 2
	if "`weight_metastatic_cancer'" == "" local weight_metastatic_cancer = 6
	if "`weight_severe_liver_disease'" == "" local weight_severe_liver_disease = 3
	if "`weight_hiv'" == "" local weight_hiv = 6
	
	
	* Create flags for each condition
	local n_flag_vars : word count `flag_vars'
	
	local i = 0
	foreach flag in `flag_vars' {
		local i = `i' + 1
		local progress = string(round((`i'/`n_flag_vars') * 100, 0.1)) + "%"
		display as result "Progress: `progress'"
		
		icdcode_flag, gen(`flag') `replace' diag_code_vars(`diag_code_vars') ///
			regex("`regex_`flag''") icdcodes("`icdcodes_`flag''")
	}

	
	* Calculate Charlson Comorbidity Index
	if "`replace'" != "" capture drop `generate'
	gen `generate' = 0
	replace `generate' = ///
		`weight_ami' * `flag_ami' + ///
		`weight_chf' * `flag_chf' + ///
		`weight_pvd' * `flag_pvd' + ///
		`weight_cva' * `flag_cva' + ///
		`weight_dementia' * `flag_dementia' + ///
		`weight_pulmonary_disease' * `flag_pulmonary_disease' + ///
		`weight_ctd' * `flag_ctd' + ///
		`weight_peptic_ulcer' * `flag_peptic_ulcer' + ///
		`weight_liver_disease' * `flag_liver_disease' + ///
		`weight_diabetes' * `flag_diabetes' + ///
		`weight_diabetes_complications' * `flag_diabetes_complications' + ///
		`weight_paraplegia' * `flag_paraplegia' + ///
		`weight_renal_disease' * `flag_renal_disease' + ///
		`weight_cancer' * `flag_cancer' + ///
		`weight_metastatic_cancer' * `flag_metastatic_cancer' + ///
		`weight_severe_liver_disease' * `flag_severe_liver_disease' + ///
		`weight_hiv' * `flag_hiv'
	
	
	* Create categorical variable for Charlson Comorbidity Index
	if "`categories'" != "" {
		if "`category_var_replace'" != "" capture drop `category_var'
		egen `category_var' = cut(`generate'), icodes at(`category_breaks')
		replace `category_var' = `category_var' + 1
		
		if "`category_labels'" != "" {
			local i = 0
			foreach lbl in `category_labels' {
				local i = `i' + 1
				label define `category_label_name' `i' "`lbl'", add
			}
		}
		label values `category_var' `category_label_name'
	}
	
	
	* Remove flag variables i foption to drop them is specified
	if "`drop_flags'" != "" {
		foreach var in `flag_vars' {
			drop `var'
		}
	}
	
end

