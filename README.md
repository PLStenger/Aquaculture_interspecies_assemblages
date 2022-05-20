# Aquaculture_interspecies_assemblages
Role of inter-species assemblages (shrimp, clams and sea cucumbers) on the composition of their microbiota and their ability to respond to a pathogen.

### Installing pipeline :

First, open your terminal. Then, run these two command lines :

    cd -place_in_your_local_computer
    git clone https://github.com/PLStenger/Aquaculture_interspecies_assemblages.git

### Update the pipeline in local by :

    git pull
    
### If necessary, install softwares by :   

    cd 99_softwares/
    conda install -c bioconda fastqc
    conda install -c bioconda trimmomatic
    conda install -c bioconda multiqc

For install QIIME2, please refer to http://qiime.org/install/install.html

### Know the number of CPU (threads) of your computer (here for MacOs) :   

    sysctl hw.ncpu
    > hw.ncpu: 4

### How to deal with the space problem due to too much data :  

    # In the header :
    TMPDIR=/scratch_vol1
    
    # After call conda, etc    
    export TMPDIR='/scratch_vol1/fungi'
    echo $TMPDIR

### Run scripts in local by :


    # Put you in your working directory
    cd /scratch_vol1/fungi/Aquaculture_interspecies_assemblages/00_scripts
    
    
    # For run all pipeline, lunch only this command line : 
    time nohup bash 000_run_all_pipeline_in_one_script.sh &> 000_run_all_pipeline_in_one_script.out

    # For run pipeline step by step, lunch :
    # Run the first script for check the quality of your data and then for choosing the good cleanning parameters
    time nohup bash 01_quality_check_by_FastQC.sh &> 01_quality_check_by_FastQC.out
    
        real    88m55,890s
        user    107m48,092s
        sys     3m55,322s   
        
    # Go out of the folder
    cd ..
    
    # Go in the "02_quality_check" folder
    cd 02_quality_check
    
    # Run multiqc for synthetized information
    multiqc .
    
    # Go out of the folder
    cd ..
    
    # Go in the script folder
    cd 00_script

    # Run the second script for cleaned your data
    time nohup bash 02_trimmomatic_q30.sh &> 02_trimmomatic_q30.out
    
        real    678m51,846s
        user    5499m17,996s
        sys     29m41,624s

    # Run the third script for checking the quality of your cleaned data 
    time nohup bash 03_check_quality_of_cleaned_data.sh &> 03_check_quality_of_cleaned_data.out

        real    105m34,074s
        user    146m24,320s
        sys     5m1,645s
        
    # Go out of the folder
    cd ..
    
    # Go in the "04_quality_check" folder
    cd 04_quality_check
    
    # Run multiqc for synthetized information
    multiqc .
    
    # Go out of the folder
    cd ..
    
    # Go in the script folder
    cd 00_script

    # Import the data in QIIME2 format
    time nohup bash 05_qiime2_import_PE.sh &> 05_qiime2_import_PE.out
        real    41m4,560s
        user    39m38,854s
        sys     1m29,967s

    # Run the Denoise
    time nohup bash 06_qiime2_denoise_PE.sh &> 06_qiime2_denoise_PE.out
        real    1401m40,630s
        user    10347m32,928s
        sys     39m45,571s
    
    # Run the tree construction
    time nohup bash 07_qiime2_tree_PE.sh &> 07_qiime2_tree_PE.out
        real    0m49,197s
        user    0m55,185s
        sys     0m13,526s
    
    # Run the rarefaction
    time nohup bash 08_qiime2_rarefaction_PE.sh &> 08_qiime2_rarefaction_PE.out
        real	1m15.788s
        user	0m28.194s
        sys	       0m8.118s
        
    # For obtainning better plots, run this script on your computer :    
    08_qiime2_rarefaction_PE_plots.R
    
    time nohup bash 09_qiime2_calculate_and_explore_diversity_metrics_PE.sh &> 09_qiime2_calculate_and_explore_diversity_metrics_PE.out
        real    3m56,363s
        user    4m40,288s
        sys     1m38,207s
    
    time nohup bash 10_qiime2_assign_taxonomy_PE.sh &> 10_qiime2_assign_taxonomy_PE.out
        real    61m27,887s
        user    61m12,318s
        sys     0m49,538s
        
    time nohup bash 11_core_biom_PE.sh &> 11_core_biom_PE.out
        real    0m20,052s
        user    0m25,242s
        sys     0m9,371s
    
    time nohup bash 99_junk.sh &> 99_junk.out
