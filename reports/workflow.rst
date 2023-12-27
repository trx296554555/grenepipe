Variants where called *roughly* following the `GATK best practices workflow`_:
Reads were mapped onto the {{ snakemake.config["data"]["reference-genome"]["name"] }} reference genome with `BWA mem`_.
{% if snakemake.config["settings"]["remove-duplicates"] %}
Both optical and PCR duplicates were removed with Picard_.
{% endif %}
{% if snakemake.config["settings"]["recalibrate-base-qualities"] %}
This was followed by recalibration of base qualities with GATK_.
{% endif %}
{% if snakemake.config["settings"]["calling-tool"] == "haplotypecaller" %}
The GATK_ HaplotypeCaller was used to call variants per sample, including summarized evidence for non-variant sites (GVCF_ approach).
Then, GATK_ genotyping was done in a joint way over GVCF_ files of all samples.
{% elif snakemake.config["settings"]["calling-tool"] == "freebayes" %}
Next, Freebayes_ was used to call variants per sample.
{% elif snakemake.config["settings"]["calling-tool"] == "bcftools" %}
Next, bcftools_ was used to call variants per sample.
{% endif %}
{% if snakemake.config["settings"]["vqsr"] %}
Genotyped variants were filtered with the GATK_ VariantRecalibrator approach.
{% else %}
Genotyped variants were filtered using hard thresholds.
For SNVs, the criterion ``{{ snakemake.config["params"]["gatk-variantfiltration"]["SNP"] }}`` was used, for Indels the criterion ``{{ snakemake.config["params"]["gatk-variantfiltration"]["INDEL"] }}`` was used.
{% endif %}
Finally, SnpEff_ was used to predict and report variant effects.
In addition, quality control was performed with FastQC_, Samtools_, and Picard_ and aggregated into an interactive report via MultiQC_.

.. _GATK best practices workflow: https://gatk.broadinstitute.org/hc/en-us/sections/360007226651-Best-Practices-Workflows
.. _GATK: https://software.broadinstitute.org/gatk/
.. _BWA mem: http://bio-bwa.sourceforge.net/
.. _Picard: https://broadinstitute.github.io/picard
.. _Freebayes: https://github.com/ekg/freebayes
.. _bcftools: http://samtools.github.io/bcftools/bcftools.html
.. _GVCF: https://gatkforums.broadinstitute.org/gatk/discussion/4017/what-is-a-gvcf-and-how-is-it-different-from-a-regular-vcf
.. _SnpEff: http://snpeff.sourceforge.net
.. _MultiQC: http://multiqc.info/
.. _Samtools: http://samtools.sourceforge.net/
.. _FastQC: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
