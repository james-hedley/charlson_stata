{smcl}
{cmd:help charlson}
{hline}

{title:Title}

{p2col :{hi:charlson} {hline 2}}Calculate the Charlson Comorbidity Index based on ICD-10 diagnosis codes{p_end}


{title:Syntax}

{phang}{cmd:icdcode_flag} , {opt g:enerate(name)} [{opt r:eplace} {opt d:iag_code_vars(varlist)} {opt i:cdcodes(string)} | {opt r:egex(string)}]

{phang}{cmd:charlson} , [{opt g:enerate(name)} {opt r:eplace} {opt d:iag_code_vars(varlist)} {opt drop_f:lags} {opt c:ategories} {opt category_v:ar(name)} {opt category_var_r:eplace} {opt category_b:reaks(numlist)} {opt category_l:abels(string)} {opt category_label_n:ame}  {opt regex_ami(string)} {opt regex_chf(string)} {opt regex_pvd(string)} {opt regex_cva(string)} {opt regex_dementia(string)} {opt regex_pulmonary_disease(string)} {opt regex_ctd(string)} {opt regex_peptic_ulcer(string)} {opt regex_liver_disease(string)} {opt regex_diabetes(string)} {opt regex_diabetes_complications(string)} {opt regex_paraplegia(string)} {opt regex_renal_disease(string)} {opt regex_cancer(string)} {opt regex_metastatic_cancer(string)} {opt regex_severe_liver_disease(string)} {opt regex_hiv(string)} {opt icdcodes_ami(string)} {opt icdcodes_chf(string)} {opt icdcodes_pvd(string)} {opt icdcodes_cva(string)} {opt icdcodes_dementia(string)} {opt icdcodes_pulmonary_disease(string)} {opt icdcodes_ctd(string)} {opt icdcodes_peptic_ulcer(string)} {opt icdcodes_liver_disease(string)} {opt icdcodes_diabetes(string)} {opt icdcodes_diabetes_complications(string)} {opt icdcodes_paraplegia(string)} {opt icdcodes_renal_disease(string)} {opt icdcodes_cancer(string)} {opt icdcodes_metastatic_cancer(string)} {opt icdcodes_severe_liver_disease(string)} {opt icdcodes_hiv(string)} {opt weight_ami(numeric)} {opt weight_chf(numeric)} {opt weight_pvd(numeric)} {opt weight_cva(numeric)} {opt weight_dementia(numeric)} {opt weight_pulmonary_disease(numeric)} {opt weight_ctd(numeric)} {opt weight_peptic_ulcer(numeric)} {opt weight_liver_disease(numeric)} {opt weight_diabetes(numeric)} {opt weight_diabetes_complications(numeric)} {opt weight_paraplegia(numeric)} {opt weight_renal_disease(numeric)} {opt weight_cancer(numeric)} {opt weight_metastatic_cancer(numeric)} {opt weight_severe_liver_disease(numeric)} {opt weight_hiv(numeric)}]


{title:Description}

{phang}{cmd:icdcode_flag} Creates a binary flag variable (0 or 1) for whether any specified ICD codes are present

{phang}{cmd:charlson} Creates a variable containing the Charlson Comorbidity Index based on ICD-10 codes


{title:Options}

{phang}{it:filename} is the name of the REDCap logging CSV file to be cleaned

{phang}{opt generate} the name of the new variable to be created. There is no default for the icdcodes_flag command. The default for the charlson command is cci

{phang}{opt replace} if the new variable to be created already exisits, should it be overridden?

{phang}{opt diag_code_vars} the variables containing ICD-10 codes. By default, this will be diagnosis_codeP and diagnosis_code1-diagnosis_code50

{phang}{opt icdcodes} the ICD codes which should be flagged. Note: Only one of icdcodes or regex should be specified

{phang}{opt regex} a regular expression pattern that should be flagged. Note: Only one of icdcodes or regex should be specified

{phang}{opt flag_vars} the names of the variable to be created that will flag each condition that makes up the Charlson Comorbidity Index

{phang}{opt drop_flags} should individual flag variables be dropped after the Charlson Comorbidity Index has been calculated?

{phang}{opt categories} should a categorical variable for Charlson Comorbidity Index be calculated?

{phang}{opt category_var} name of the categorical variable to be created

{phang}{opt category_var_replace} if the new categorical variable name already exisits, should it be overridden?

{phang}{opt category_breaks} the breakpoints for determining the Charlson Comorbidity Index categories. The default is 0 1 3 1000, which creates categories 3 categories: 0, 1-2, 3+

{phang}{opt category_labels} the value labels for the categorical Charlson Comorbditiy Index variable. The default is "0", "1-2", "3+"

{phang}{opt category_label_name} the name of the value labels for the categorical variable. The default is ccicatlbl

{phang}{opt regex_} the regular expression pattern used to flag each condition that makes up the Charlson Comorbidity Index. These options are provided so you can alter the default calulation of the Charlson Comorbidity Index

{phang}{opt icdcodes_} the ICD-10 codes used to flag each condition that makes up the Charlson Comorbidity Index. Specifying this option will override any regular expression previously provided. These options are provided so you can alter the default calulation of the Charlson Comorbidity Index

{phang}{opt weight_} the weight applied to each condition when calculating the Charlson Comorbidity Index. These options are provided so you can alter the default calulation of the Charlson Comorbidity Index



{title:Author}

{pstd}James Hedley{p_end}
{pstd}University of Sydney{p_end}
{pstd}Sydney, NSW, Australia{p_end}
{pstd}{browse "mailto:jhed6213@uni.sydney.edu.au":jhed6213@uni.sydney.edu.au}

{pstd}Adpated from code written by Judy Simpson, Patrick Kelly, and Erin Cvejic{p_end}


{title:Reference}
{pstd}Charlson ME, Pompei P, Ales KL, et al. A new method of classifying prognostic comorbidity in longitudinal studies: development and validation. Journal of Chronic Diseases 1987; 40:373-383.{p_end}

