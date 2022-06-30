#!/bin/bash

username=$1
ip_address=$2
backup_dir=$3

report_file=/home/$username/$ip_address-system_report_$(date +\%d_%B_%Y)
touch $report_file

printf "Uptime: " >> $report_file
echo $(uptime) | cut -d" " -f3,4 | cut -d, -f1 >> $report_file

printf "root volume size: " >> $report_file
sudo df -h / --output=size | tail -1 | xargs >> $report_file

used_dir_volume=$(sudo df -h / --output=used | tail -1 | xargs)
percent_dir_volume=$(sudo df -h / --output=pcent | tail -1 | xargs)
echo "Used root volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file

if [ $ip_address == "[Host_ip]" ]; then
    printf "default/containers/bistro volume size: " >> $report_file
    sudo df -h /var/lib/lxd/storage-pools/default/containers/bistro --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /var/lib/lxd/storage-pools/default/containers/bistro --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /var/lib/lxd/storage-pools/default/containers/bistro --output=pcent | tail -1 | xargs)
    echo "Used default/containers/bistro volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file
fi

if [ $ip_address == "[Host_ip]" ]; then
    printf "/dev/vdb1 volume size: " >> $report_file
    sudo df -h /storage --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /storage --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /storage --output=pcent | tail -1 | xargs)
    echo "Used /dev/vdb1 volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file
fi

if [ $ip_address == "[Host_ip]" ]; then
    printf "/backup volume size: " >> $report_file
    sudo df -h /backup --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /backup --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /backup --output=pcent | tail -1 | xargs)
    echo "Used /backup volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file
fi

if [ $ip_address == "[Host_ip]" ]; then
    printf "/dev/vdb1 volume size: " >> $report_file
    sudo df -h /data/storage1 --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /data/storage1 --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /data/storage1 --output=pcent | tail -1 | xargs)
    echo "Used /dev/vdb1 volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file

    printf "smurfit1:/smurfit_production volume size: " >> $report_file
    sudo df -h /home/skmyvacanciescom/skmyvacancies.com/storage/app --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /home/skmyvacanciescom/skmyvacancies.com/storage/app --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /home/skmyvacanciescom/skmyvacancies.com/storage/app --output=pcent | tail -1 | xargs)
    echo "Used smurfit1:/smurfit_production volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file

    printf "smurfit1:/smurfit_production_backup volume size: " >> $report_file
    sudo df -h /home/skmyvacanciescom/skmyvacancies.com/storage/backups --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /home/skmyvacanciescom/skmyvacancies.com/storage/backups --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /home/skmyvacanciescom/skmyvacancies.com/storage/backups --output=pcent | tail -1 | xargs)
    echo "Used smurfit1:/smurfit_production_backup volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file
fi

if [ $ip_address == "[Host_ip]" ]; then
    printf "/dev/vdb1 volume size: " >> $report_file
    sudo df -h /data/storage1 --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /data/storage1 --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /data/storage1 --output=pcent | tail -1 | xargs)
    echo "Used /dev/vdb1 volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file

    printf "smurfit2:/smurfit_production volume size: " >> $report_file
    sudo df -h /home/skmyvacanciescom/skmyvacancies.com/storage/app --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /home/skmyvacanciescom/skmyvacancies.com/storage/app --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /home/skmyvacanciescom/skmyvacancies.com/storage/app --output=pcent | tail -1 | xargs)
    echo "Used smurfit2:/smurfit_production volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file

    printf "smurfit2:/smurfit_production_backup volume size: " >> $report_file
    sudo df -h /home/skmyvacanciescom/skmyvacancies.com/storage/backups --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /home/skmyvacanciescom/skmyvacancies.com/storage/backups --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /home/skmyvacanciescom/skmyvacancies.com/storage/backups --output=pcent | tail -1 | xargs)
    echo "Used smurfit2:/smurfit_production_backup volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file
fi

if [ $ip_address == "[Host_ip]" ]; then
    printf "/dev/vdb1 volume size: " >> $report_file
    sudo df -h /data/storage1 --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /data/storage1 --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /data/storage1 --output=pcent | tail -1 | xargs)
    echo "Used /dev/vdb1 volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file
fi

if [ $ip_address == "[Host_ip]" ]; then
    printf "/dev/vdb1 volume size: " >> $report_file
    sudo df -h /data/storage1 --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /data/storage1 --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /data/storage1 --output=pcent | tail -1 | xargs)
    echo "Used /dev/vdb1 volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file

    printf "evicare2:/evicare_staging volume size: " >> $report_file
    sudo df -h /home/evicarestaging/api.evicare.appelit.com/storage/app --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /home/evicarestaging/api.evicare.appelit.com/storage/app --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /home/evicarestaging/api.evicare.appelit.com/storage/app --output=pcent | tail -1 | xargs)
    echo "Used evicare2:/evicare_staging volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file

    printf "evicare2:/evicare_production volume size: " >> $report_file
    sudo df -h /home/evicarenl/api.evicare.nl/storage/app --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /home/evicarenl/api.evicare.nl/storage/app --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /home/evicarenl/api.evicare.nl/storage/app --output=pcent | tail -1 | xargs)
    echo "Used evicare2:/evicare_production volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file
fi

if [ $ip_address == "[Host_ip]" ]; then
    printf "evicare3:/evicare_staging volume size: " >> $report_file
    sudo df -h /home/evicarenl/api.evicare.nl/storage/app --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /home/evicarenl/api.evicare.nl/storage/app --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /home/evicarenl/api.evicare.nl/storage/app --output=pcent | tail -1 | xargs)
    echo "Used evicare3:/evicare_staging volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file

    printf "evicare3:/evicare_production volume size: " >> $report_file
    sudo df -h /home/evicarenl/api.evicare.nl/storage/app --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /home/evicarenl/api.evicare.nl/storage/app --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /home/evicarenl/api.evicare.nl/storage/app --output=pcent | tail -1 | xargs)
    echo "Used evicare3:/evicare_production volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file
fi

if [ $ip_address == "[Host_ip]" ]; then
    printf "/dev/vdb1 volume size: " >> $report_file
    sudo df -h /data/storage1 --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /data/storage1 --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /data/storage1 --output=pcent | tail -1 | xargs)
    echo "Used /dev/vdb1 volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file

    printf "evicare4:/evicare_staging volume size: " >> $report_file
    sudo df -h /home/evicarestaging/api.evicare.appelit.com/storage/app --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /home/evicarestaging/api.evicare.appelit.com/storage/app --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /home/evicarestaging/api.evicare.appelit.com/storage/app --output=pcent | tail -1 | xargs)
    echo "Used evicare4:/evicare_staging volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file

    printf "evicare4:/evicare_production volume size: " >> $report_file
    sudo df -h /home/evicarenl/api.evicare.nl/storage/app --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /home/evicarenl/api.evicare.nl/storage/app --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /home/evicarenl/api.evicare.nl/storage/app --output=pcent | tail -1 | xargs)
    echo "Used evicare4:/evicare_production volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file
fi

if [ $ip_address == "[Host_ip]" ]; then
    printf "/dev/vdb1 volume size: " >> $report_file
    sudo df -h /data/storage1 --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /data/storage1 --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /data/storage1 --output=pcent | tail -1 | xargs)
    echo "Used /dev/vdb1 volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file

    printf "proofy:proefy_production volume size: " >> $report_file
    sudo df -h /home/proefyproduction/app.proefy.com/storage/app --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /home/proefyproduction/app.proefy.com/storage/app --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /home/proefyproduction/app.proefy.com/storage/app --output=pcent | tail -1 | xargs)
    echo "Used proofy:proefy_production volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file
fi

if [ $ip_address == "[Host_ip]" ]; then
    printf "/dev/vdb1 volume size: " >> $report_file
    sudo df -h /storage/data1 --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /storage/data1 --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /storage/data1 --output=pcent | tail -1 | xargs)
    echo "Used /dev/vdb1 volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file
fi

if [ $ip_address == "[Host_ip]" ]; then
    printf "/dev/vdb1 volume size: " >> $report_file
    sudo df -h /storage/data --output=size | tail -1 | xargs >> $report_file
    used_dir_volume=$(sudo df -h /storage/data --output=used | tail -1 | xargs)
    percent_dir_volume=$(sudo df -h /storage/data --output=pcent | tail -1 | xargs)
    echo "Used /dev/vdb1 volume size: $used_dir_volume ($percent_dir_volume)" >> $report_file
fi

printf "Total Inodes of root volume: " >> $report_file
sudo df -h / --output=itotal | tail -1 | xargs >> $report_file

used_inode_volume=$(sudo df -h / --output=iused | tail -1 | xargs)
percent_inode_volume=$(sudo df -h / --output=ipcent | tail -1 | xargs)
echo "Used Inodes of root volume: $used_inode_volume ($percent_inode_volume)" >> $report_file

printf "Pending Updates: " >> $report_file
pending_updates=$(sudo apt-get dist-upgrade -s 2>/dev/null | grep ^Inst | wc -l)
printf "$pending_updates" >> $report_file

printf "\nCritical Updates: " >> $report_file
critical_updates=$(sudo apt-get dist-upgrade -s 2>/dev/null | grep -i security | grep ^Inst | wc -l)
printf "$critical_updates" >> $report_file

printf "\nRestart Required: " >> $report_file
if [ $critical_updates -ne 0 ]; then
    printf "Yes\n" >> $report_file
else
    printf "No\n" >> $report_file
fi

printf "$backup_dir size: "  >> $report_file
sudo du -chs $backup_dir | awk '{w=$1} END{print w}' | xargs >> $report_file

if [ $ip_address == "[Host_ip]" ]; then
    printf "fitandsave.nl size: " >> $report_file
    sudo du -chs $backup_dir/web1 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "georgetest.nl size: " >> $report_file
    sudo du -chs $backup_dir/web3 | awk '{w=$1} END{print w}' | xargs >> $report_file
fi

if [ $ip_address == "[Host_ip]" ]; then
    printf "onderbouwdapp.nl size: " >> $report_file
    sudo du -chs $backup_dir/web1 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "app.leerwijzeronline.nl size: " >> $report_file
    sudo du -chs $backup_dir/web2 | awk '{w=$1} END{print w}' | xargs >> $report_file
fi

if [ $ip_address == "[Host_ip]" ]; then
    printf "pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web1 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "merin.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web3 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "geste.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web5 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "test.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web6 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "sigv.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web7 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "heel-goed.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web8 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "duwo.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web9 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "zdvv.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web10 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "zdvvdb.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web12 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "curo.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web13 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "vastestate.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web14 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "vastestatedb.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web15 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "bewaaktenbewoond.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web16 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "wfc.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web18 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "groenwest.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web19 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "ssh.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web20 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "boers-lem.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web21 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "gestedb.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web22 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "metea.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web23 | awk '{w=$1} END{print w}' | xargs >> $report_file
    printf "change-oa.pdj-vastgoedapps.nl size: "  >> $report_file
    sudo du -chs $backup_dir/web24 | awk '{w=$1} END{print w}' | xargs >> $report_file
fi