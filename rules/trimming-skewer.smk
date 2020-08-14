# =================================================================================================
#     Trimming
# =================================================================================================

rule trim_reads_se:
    input:
        unpack(get_fastq)
    output:
        # Output of the trimmed files, as well as the log file for multiqc
        temp("trimmed/{sample}-{unit}-se-trimmed.fastq.gz"),
        "trimmed/{sample}-{unit}-se-trimmed.log"
    params:
        extra="--format sanger --compress",
        params=config["params"]["skewer"]["se"],
        outpref="trimmed/{sample}-{unit}-se"
    threads:
        config["params"]["skewer"]["threads"]
    log:
        "logs/skewer/{sample}-{unit}.log"
    benchmark:
        "benchmarks/skewer/{sample}-{unit}.bench.log"
    conda:
        "../envs/skewer.yaml"
    shell:
        "skewer {params.extra} {params.params} --threads {threads} --output {params.outpref} "
        "{input.r1} > {log} 2>&1"

rule trim_reads_pe:
    input:
        unpack(get_fastq)
    output:
        # Output of the trimmed files, as well as the log file for multiqc
        r1=temp("trimmed/{sample}-{unit}-pe-trimmed-pair1.fastq.gz"),
        r2=temp("trimmed/{sample}-{unit}-pe-trimmed-pair2.fastq.gz"),
        log="trimmed/{sample}-{unit}-pe-trimmed.log"
    params:
        extra="--format sanger --compress",
        params=config["params"]["skewer"]["pe"],
        outpref="trimmed/{sample}-{unit}-pe"
    threads:
        config["params"]["skewer"]["threads"]
    log:
        "logs/skewer/{sample}-{unit}.log"
    benchmark:
        "benchmarks/skewer/{sample}-{unit}.bench.log"
    conda:
        "../envs/skewer.yaml"
    shell:
        "skewer {params.extra} {params.params} --threads {threads} --output {params.outpref} "
        "{input.r1} {input.r2} > {log} 2>&1"

# =================================================================================================
#     Trimming Results
# =================================================================================================

def is_single_end(sample, unit):
    """Return True if sample-unit is single end."""
    return pd.isnull(samples.loc[(sample, unit), "fq2"])

def get_trimmed_reads(wildcards):
    """Get trimmed reads of given sample-unit."""
    if is_single_end(**wildcards):
        # single end sample
        return [ "trimmed/{sample}-{unit}-se-trimmed.fastq.gz".format(**wildcards) ]
    else:
        # paired-end sample
        return expand("trimmed/{sample}-{unit}-pe-trimmed-pair{group}.fastq.gz", group=[1, 2], **wildcards)
