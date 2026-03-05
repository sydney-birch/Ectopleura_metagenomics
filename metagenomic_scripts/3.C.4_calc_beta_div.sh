#! /bin/bash

## General 
# All groups together
python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs/CML_AAM_2.bracken bracken_outputs/CML_AAM_5.bracken bracken_outputs/CML_AAM_9.bracken bracken_outputs/Wells_AAM_1.bracken bracken_outputs/Wells_AAM_6.bracken bracken_outputs/Wells_AAM_8.bracken bracken_outputs/York_AAM_10.bracken bracken_outputs/York_AAM_6.bracken bracken_outputs/York_AAM_9.bracken bracken_outputs/Wells_Biofilm_10.bracken bracken_outputs/Wells_Biofilm_6.bracken bracken_outputs/Wells_Biofilm_7.bracken bracken_outputs/York_Biofilm_3.bracken bracken_outputs/York_Biofilm_4.bracken bracken_outputs/CML_Biofilm_10.bracken bracken_outputs/CML_Biofilm_1.bracken --type bracken >> beta_general_all_groups.txt

# Only AAM
python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs/CML_AAM_2.bracken bracken_outputs/CML_AAM_5.bracken bracken_outputs/CML_AAM_9.bracken bracken_outputs/Wells_AAM_1.bracken bracken_outputs/Wells_AAM_6.bracken bracken_outputs/Wells_AAM_8.bracken bracken_outputs/York_AAM_10.bracken bracken_outputs/York_AAM_6.bracken bracken_outputs/York_AAM_9.bracken --type bracken >> beta_general_AAM_groups.txt

#Only Biofilm
python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs/Wells_Biofilm_10.bracken bracken_outputs/Wells_Biofilm_6.bracken bracken_outputs/Wells_Biofilm_7.bracken bracken_outputs/York_Biofilm_3.bracken bracken_outputs/York_Biofilm_4.bracken bracken_outputs/CML_Biofilm_10.bracken bracken_outputs/CML_Biofilm_1.bracken --type bracken >> beta_general_Biofilm_groups.txt


## Species
# All groups together
python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs/CML_AAM_2.bracken bracken_outputs/CML_AAM_5.bracken bracken_outputs/CML_AAM_9.bracken bracken_outputs/Wells_AAM_1.bracken bracken_outputs/Wells_AAM_6.bracken bracken_outputs/Wells_AAM_8.bracken bracken_outputs/York_AAM_10.bracken bracken_outputs/York_AAM_6.bracken bracken_outputs/York_AAM_9.bracken bracken_outputs/Wells_Biofilm_10.bracken bracken_outputs/Wells_Biofilm_6.bracken bracken_outputs/Wells_Biofilm_7.bracken bracken_outputs/York_Biofilm_3.bracken bracken_outputs/York_Biofilm_4.bracken bracken_outputs/CML_Biofilm_10.bracken bracken_outputs/CML_Biofilm_1.bracken --type bracken --level S >> beta_species_all_groups.txt

# Only AAM
python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs/CML_AAM_2.bracken bracken_outputs/CML_AAM_5.bracken bracken_outputs/CML_AAM_9.bracken bracken_outputs/Wells_AAM_1.bracken bracken_outputs/Wells_AAM_6.bracken bracken_outputs/Wells_AAM_8.bracken bracken_outputs/York_AAM_10.bracken bracken_outputs/York_AAM_6.bracken bracken_outputs/York_AAM_9.bracken --type bracken --level S >> beta_species_AAM_groups.txt

#Only Biofilm
python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs/Wells_Biofilm_10.bracken bracken_outputs/Wells_Biofilm_6.bracken bracken_outputs/Wells_Biofilm_7.bracken bracken_outputs/York_Biofilm_3.bracken bracken_outputs/York_Biofilm_4.bracken bracken_outputs/CML_Biofilm_10.bracken bracken_outputs/CML_Biofilm_1.bracken --type bracken --level S >> beta_species_Biofilm_groups.txt


## Genus
# All groups together
python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs_genus/CML_AAM_2.bracken bracken_outputs_genus/CML_AAM_5.bracken bracken_outputs_genus/CML_AAM_9.bracken bracken_outputs_genus/Wells_AAM_1.bracken bracken_outputs_genus/Wells_AAM_6.bracken bracken_outputs_genus/Wells_AAM_8.bracken bracken_outputs_genus/York_AAM_10.bracken bracken_outputs_genus/York_AAM_6.bracken bracken_outputs_genus/York_AAM_9.bracken bracken_outputs_genus/Wells_Biofilm_10.bracken bracken_outputs_genus/Wells_Biofilm_6.bracken bracken_outputs_genus/Wells_Biofilm_7.bracken bracken_outputs_genus/York_Biofilm_3.bracken bracken_outputs_genus/York_Biofilm_4.bracken bracken_outputs_genus/CML_Biofilm_10.bracken bracken_outputs_genus/CML_Biofilm_1.bracken --type bracken --level G >> beta_genus_all_groups.txt

# Only AAM
python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs_genus/CML_AAM_2.bracken bracken_outputs_genus/CML_AAM_5.bracken bracken_outputs_genus/CML_AAM_9.bracken bracken_outputs_genus/Wells_AAM_1.bracken bracken_outputs_genus/Wells_AAM_6.bracken bracken_outputs_genus/Wells_AAM_8.bracken bracken_outputs_genus/York_AAM_10.bracken bracken_outputs_genus/York_AAM_6.bracken bracken_outputs_genus/York_AAM_9.bracken --type bracken --level G >> beta_genus_AAM_groups.txt

#Only Biofilm
python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs_genus/Wells_Biofilm_10.bracken bracken_outputs_genus/Wells_Biofilm_6.bracken bracken_outputs_genus/Wells_Biofilm_7.bracken bracken_outputs_genus/York_Biofilm_3.bracken bracken_outputs_genus/York_Biofilm_4.bracken bracken_outputs_genus/CML_Biofilm_10.bracken bracken_outputs_genus/CML_Biofilm_1.bracken --type bracken --level G >> beta_genus_Biofilm_groups.txt


## Family
# All groups together
python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs_family/CML_AAM_2.bracken bracken_outputs_family/CML_AAM_5.bracken bracken_outputs_family/CML_AAM_9.bracken bracken_outputs_family/Wells_AAM_1.bracken bracken_outputs_family/Wells_AAM_6.bracken bracken_outputs_family/Wells_AAM_8.bracken bracken_outputs_family/York_AAM_10.bracken bracken_outputs_family/York_AAM_6.bracken bracken_outputs_family/York_AAM_9.bracken bracken_outputs_family/Wells_Biofilm_10.bracken bracken_outputs_family/Wells_Biofilm_6.bracken bracken_outputs_family/Wells_Biofilm_7.bracken bracken_outputs_family/York_Biofilm_3.bracken bracken_outputs_family/York_Biofilm_4.bracken bracken_outputs_family/CML_Biofilm_10.bracken bracken_outputs_family/CML_Biofilm_1.bracken --type bracken --level F >> beta_famaily_all_groups.txt

# Only AAM
python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs_family/CML_AAM_2.bracken bracken_outputs_family/CML_AAM_5.bracken bracken_outputs_family/CML_AAM_9.bracken bracken_outputs_family/Wells_AAM_1.bracken bracken_outputs_family/Wells_AAM_6.bracken bracken_outputs_family/Wells_AAM_8.bracken bracken_outputs_family/York_AAM_10.bracken bracken_outputs_family/York_AAM_6.bracken bracken_outputs_family/York_AAM_9.bracken --type bracken --level F >> beta_famaily_AAM_groups.txt

#Only Biofilm
python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs_family/Wells_Biofilm_10.bracken bracken_outputs_family/Wells_Biofilm_6.bracken bracken_outputs_family/Wells_Biofilm_7.bracken bracken_outputs_family/York_Biofilm_3.bracken bracken_outputs_family/York_Biofilm_4.bracken bracken_outputs_family/CML_Biofilm_10.bracken bracken_outputs_family/CML_Biofilm_1.bracken --type bracken --level F >> beta_famaily_Biofilm_groups.txt

