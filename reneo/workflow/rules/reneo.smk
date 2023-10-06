rule run_reneo:
    input:
        graph = GRAPH_FILE,
        coverage = COVERAGE_FILE,
        pickle = PICKLE_FILE,
        bams = expand(os.path.join(BAM_PATH, "{sample}.{ext}"), sample=SAMPLE_NAMES, ext=["bam","bam.bai"]),
        other = preprocessTargets
    output:
        genomes_fasta = os.path.join(RESDIR, "resolved_paths.fasta"),
        # genomes_folder = directory(os.path.join(RESDIR, "resolved_viruses")), # todo: optional
        genome_info = os.path.join(RESDIR, "resolved_genome_info.txt"),
        # unitigs = os.path.join(RESDIR, "resolved_edges.fasta"), # todo: optional
        component_info = os.path.join(RESDIR, "resolved_component_info.txt"),
        vog_comp_info = os.path.join(RESDIR, "component_vogs.txt"),
        unresolved_edges = os.path.join(RESDIR, "unresolved_virus_like_edges.fasta"),
    params:
        # graph = GRAPH_FILE,
        vogs=lambda w: VOG_ANNOT if config["hmmsearch"] else "",
        hmmout=lambda w: SMG_FILE if config["hmmsearch"] else "",
        # coverage = COVERAGE_FILE,
        bampath = BAM_PATH,
        minlength = ML,
        mincov = MC,
        compcount = CC,
        maxpaths = MP,
        mgfrac = MGF,
        evalue = EV,
        hmmscore = HS,
        covtol = CT,
        alpha = AL,
        output = RESDIR,
        # nthreads = config["resources"]["big"]["cpu"],
        log = os.path.join(LOGSDIR, "reneo_output.log")
    threads:
        config["resources"]["big"]["cpu"]
    resources:
        mem_mb = config["resources"]["big"]["mem"],
        mem = str(config["resources"]["big"]["mem"]) + "MB",
        time = config["resources"]["big"]["time"]
    log:
        os.path.join(LOGSDIR, "reneo_output.log")
    conda:
        os.path.join("..", "envs", "reneo.yaml")
    script:
        os.path.join("..", "scripts", "reneo.py")
