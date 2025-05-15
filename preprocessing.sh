curl --output refsnp-chrMT.json.bz2 https://ftp.ncbi.nih.gov/snp/latest_release/JSON/refsnp-chrMT.json.bz2
curl --output refsnp-chrMT.json.bz2.md5 https://ftp.ncbi.nih.gov/snp/latest_release/JSON/refsnp-chrMT.json.bz2.md5

md5sum -c refsnp-chrMT.json.bz2.md5
bzip2 -d refsnp-chrMT.json.bz2

jq '{refsnp_id:.refsnp_id} + {primary_snapshot_data:.primary_snapshot_data.placements_with_allele[] | select(.is_ptlp==true) | .alleles[] | select(.hgvs | contains(">"))}' -c refsnp-chrMT.json > exData.json
jq '[.refsnp_id, .primary_snapshot_data.allele.spdi.deleted_sequence, .primary_snapshot_data.allele.spdi.inserted_sequence, .primary_snapshot_data.hgvs]' -c -r exData.json > exData2.json
sed -e 's/\[//g' -e 's/\]//g' -e 's/\"//g' exData2.json > exData3.json
awk -F ',' '{OFS="\t"; print $1, $2, $3, substr($4, length($4)-2) }' exData3.json > result.tsv
