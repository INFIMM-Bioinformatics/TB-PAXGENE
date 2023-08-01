#/bin/bash

# This analysis is performed on Computerome 2.0 (The Danish National Life Science Supercomputing Center)

cd /home/projects/cu_10181/people/tuhu/PAXgene
module load jdk/18.0.2.1 nextflow/22.10.4 singularity/3.9.6 anaconda3/2023.03
nextflow run nf-core/rnaseq \
    -revision 3.12.0 \
    -profile singularity \
    -w data/nextflow_wd \
    --fasta /home/projects/cu_10181/data/_reference/macaca_fascicularis/Macaca_fascicularis.Macaca_fascicularis_6.0.dna_rm.toplevel.fa.gz \
    --gtf /home/projects/cu_10181/data/_reference/macaca_fascicularis/Macaca_fascicularis.Macaca_fascicularis_6.0.109.gtf.gz \
    --input data/nextflow_input.csv \
    --outdir data/nextflow_outputdir \
    --max_cpus 40 \
    --max_memory 170GB \
    -resume

# The job submission code to Computerome.

# qsub -W group_list=ku_00216 -A ku_00216 -l nodes=1:thinnode:ppn=40,mem=175gb,walltime=120:00:00 /home/projects/cu_10181/people/tuhu/PAXgene/analysis/0_RNA_SEQ_MAPPING.sh

# The job failed (CPU disconnects from RAM). The code below is for restarting from where failed.

# nextflow run nf-core/rnaseq -revision 3.12.0 -profile singularity -w data/nextflow_wd --fasta /home/projects/cu_10181/data/_reference/macaca_fascicularis/Macaca_fascicularis.Macaca_fascicularis_6.0.dna_rm.toplevel.fa.gz --gtf /home/projects/cu_10181/data/_reference/macaca_fascicularis/Macaca_fascicularis.Macaca_fascicularis_6.0.109.gtf.gz --input data/nextflow_input.csv --outdir data/nextflow_outputdir --max_cpus 40 --max_memory 170GB -resume b6faa4dd-eba5-4c7b-8c33-456656b6ff03