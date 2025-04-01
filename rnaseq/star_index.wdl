task star_index {

    File reference_fasta
    File annotation_gtf
    String prefix
    Int overhang

    Int memory
    Int disk_space
    Int num_threads
    Int num_preempt

    command {
        mkdir ${prefix}
        STAR \
            --runMode genomeGenerate \
            --genomeDir ${prefix} \
            --genomeFastaFiles ${reference_fasta} \
            --sjdbGTFfile ${annotation_gtf} \
            --sjdbOverhang ${overhang} \
            --runThreadN ${num_threads}
        tar -cvzf ${prefix}.tar.gz ${prefix}
    }

    output {
        File star_index = "${prefix}.tar.gz"
    }

    runtime {
        docker: "us.gcr.io/broad-dsp-lrma/gtex_v8_rnaseq_star_2.7.10a"
        memory: "${memory}GB"
        disks: "local-disk ${disk_space} HDD"
        cpu: "${num_threads}"
        preemptible: "${num_preempt}"
    }

    meta {
        author: "Francois Aguet"
    }
}


workflow star_index_workflow {
    call star_index
}
