#/bin/bash
cd /home/projects/cu_10181/people/tuhu/PAXgene
module load jdk/18.0.2.1 nextflow/22.10.4 singularity/3.9.6 anaconda3/2023.03
nextflow run nf-core/rnaseq \
    -revision 3.12.0 \
    -profile singularity \
    -w data/nextflow_wd_salmon \
    --fasta /home/projects/cu_10181/data/_reference/macaca_fascicularis/Macaca_fascicularis.Macaca_fascicularis_6.0.dna_rm.toplevel.fa.gz \
    --gtf /home/projects/cu_10181/data/_reference/macaca_fascicularis/Macaca_fascicularis.Macaca_fascicularis_6.0.109.gtf.gz \
    --trimmer fastp \
    --pseudo_aligner salmon \
    --skip_alignment \
    --input data/nextflow_input.csv \
    --outdir data/nextflow_outputdir_salmon \
    --max_cpus 40 \
    --max_memory 170GB 

# qsub -W group_list=ku_00216 -A ku_00216 -l nodes=1:thinnode:ppn=40,mem=175gb,walltime=120:00:00 /home/projects/cu_10181/people/tuhu/PAXgene/analysis/0_RNA_SEQ_MAPPING_SALMON.sh