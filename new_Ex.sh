comm=`cat /root/var.txt`
if [ "$url_unique" != "$comm" ]
then

i=$((i-50))
for var in `cat /root/var.txt`
do
#81 8443 8080 8000 8880
echo "http://${var}" >> /root/var1231.txt
echo "http://${var}:81" >> /root/var1231.txt
echo "http://${var}:8443" >> /root/var1231.txt
echo "http://${var}:8080" >> /root/var1231.txt
echo "http://${var}:8000" >> /root/var1231.txt
echo "http://${var}:8880" >> /root/var1231.txt

echo "https://${var}" >> /root/var1231.txt
echo "https://${var}:81" >> /root/var1231.txt
echo "https://${var}:8443" >> /root/var1231.txt
echo "https://${var}:8080" >> /root/var1231.txt
echo "https://${var}:8000" >> /root/var1231.txt
echo "https://${var}:8880" >> /root/var1231.txt
done

vl /root/var1231.txt | grep -v "\[50" | grep -oP "http.*" >> /root/var123.txt ; rm /root/var1231.txt
sort -u /root/var123.txt -o /root/var123.txt
#whatsweb
rm apps.json
webanalyze -update
for line in `cat /root/var123.txt`
do
echo "webanalyze -crawl 12 -host $line -output csv >> /root/whatsweb.txt ; sort -u /root/whatsweb.txt -o /root/whatsweb.txt ; wc -l /root/whatsweb.txt" > analyze.sh
timeout 16 bash analyze.sh
done
rm analyze.sh
rm /root/var123.txt
url_unique=$comm

fi







#确认存在
a=`curl --speed-time 5 --speed-limit 1  https://www.exploit-db.com/download/${i} | grep "Exploit\ Database\ 404"`

if [ "$a" = "" ]
then


#确认类型
curl --speed-time 5 --speed-limit 1  https://www.exploit-db.com/exploits/${i} > curl.txt
web=`cat curl.txt | grep -oP "type=webapps"`

if [ "$web" = "type=webapps" ]
then

#提取指纹
grep -oP "http.*" whatsweb.txt | awk -F, '{print $(NF-1)}' > service.txt ; sort -u service.txt -o service.txt
num=`cat service.txt | wc -l`

#匹配
for((wordnum=1;wordnum<=${num};wordnum+=1))
do
word=`head -$wordnum service.txt | tail -1`
grep2=`cat curl.txt | grep -oP "(?<=title\>).*?(?=\<\/title)" | grep -oP ".*?\ -\ " | head -1 | grep -i "$word"`
grep22=`cat curl.txt | grep -oP "(?<=title\>).*?(?=\<\/title)" | grep -oP ".*?\ -\ " | awk 'NF{NF-=1};1' | head -1 | grep -i "$word"`
#存在则执行
if [ "$grep22" != "" ]
then
grep -i $word whatsweb.txt | awk -F, '{print $1}' > i.txt
toomuch=`cat i.txt | wc -l`
if [ $toomuch -eq 1 ]
then
echo 'go'
for url in `cat i.txt`
do
echo $url >> target.txt
add=,
url=$url$add
grep "$url" whatsweb.txt | awk -F, '{print $(NF-1) $(NF)}' >> to.txt
num=`cat to.txt | wc -l`
for((numto=1;numto<=$num;numto+=1))
do
add=`head -$numto to.txt | tail -1`
up=+
add=$up$add
echo $add >> target.txt
done
rm to.txt
echo '' >> target.txt

target=`cat target.txt`
url=`grep -oP "http.*?(?=\")" /root/script/webhook.sh`
echo "curl -X POST -H \"Content-type:application/json\" --data '{\"text\":\"${word}\n${grep2}\n${target}\nhttps://www.exploit-db.com/exploits/${i}\n\n\"}' $url" > slack.sh
bash slack.sh ; rm slack.sh
rm target.txt
sleep 1
done
rm i.txt
else

mkdir /root/cve
for url in `cat i.txt`
do
name=`echo $grep2 | sed "s, ,_,g"`
echo $url >> /root/cve/${name}.txt
add=,
url=$url$add
grep "$url" whatsweb.txt | awk -F, '{print $(NF-1) $(NF)}' >> to.txt
num=`cat to.txt | wc -l`
for((numto=1;numto<=$num;numto+=1))
do
add=`head -$numto to.txt | tail -1`
up=+
add=$up$add
echo $add >> /root/cve/${name}.txt
done
rm to.txt
echo '' >> /root/cve/${name}.txt
done
rm i.txt

include=`echo $grep2 | grep -oP "\."`
if [ "$include" != "" ]
then

num_blank_if=`echo $grep2 | grep -oP ".*\ .\." | head -1 |awk 'NF{NF-=1};1' | grep -o " " | wc -l`
if [ "$num_blank_if" = "1" ]
then
echo $grep2 | awk '{print $1}' >> keyword.txt
echo $grep2 | awk '{print $2}' >> keyword.txt
elif [ "$num_blank_if" = "0" ]
then
echo $grep2 | awk '{print $1}' >> keyword.txt
elif [ "$num_blank_if" = "2" ]
then
echo $grep2 | awk '{print $1}' >> keyword.txt
echo $grep2 | awk '{print $2}' >> keyword.txt
echo $grep2 | awk '{print $3}' >> keyword.txt
elif [ "$num_blank_if" = "3" ]
then
echo $grep2 | awk '{print $1}' >> keyword.txt
echo $grep2 | awk '{print $2}' >> keyword.txt
echo $grep2 | awk '{print $3}' >> keyword.txt
echo $grep2 | awk '{print $4}' >> keyword.txt
fi

else
num_blank_if=`echo $grep2 | grep -oP ".*?\ -" | head -1 | awk 'NF{NF-=1};1' | grep -o " " | wc -l`
if [ "$num_blank_if" = "1" ]
then
echo $grep2 | awk '{print $1}' >> keyword.txt
echo $grep2 | awk '{print $2}' >> keyword.txt
elif [ "$num_blank_if" = "0" ]
then
echo $grep2 | awk '{print $1}' >> keyword.txt
elif [ "$num_blank_if" = "2" ]
then
echo $grep2 | awk '{print $1}' >> keyword.txt
echo $grep2 | awk '{print $2}' >> keyword.txt
echo $grep2 | awk '{print $3}' >> keyword.txt
elif [ "$num_blank_if" = "3" ]
then
echo $grep2 | awk '{print $1}' >> keyword.txt
echo $grep2 | awk '{print $2}' >> keyword.txt
echo $grep2 | awk '{print $3}' >> keyword.txt
echo $grep2 | awk '{print $4}' >> keyword.txt
fi
fi

num_key=`echo $grep2 | grep -oP "\ .\..*?\ " | sed 's/[[:space:]]//g'`
if [ "$num_key" != "" ]
then
for key in `cat keyword.txt`
do
grep "${key}" /root/whatsweb.txt | grep "num_key" | awk -F, '{print $1}' >> /root/cve/${name}______match.txt ; sort -u /root/cve/${name}______match.txt -o /root/cve/${name}______match.txt
grep -oP "http.*" /root/cve/${name}.txt >> /root/cve/${name}______allurl.txt ; sort -u /root/cve/${name}______all.txt -o /root/cve/${name}______allurl.txt
done
rm keyword.txt
else
for key in `cat keyword.txt`
do
grep "${key}" /root/whatsweb.txt >> /root/cve/${name}______match.txt ; sort -u /root/cve/${name}______match.txt -o /root/cve/${name}______match.txt
grep -oP "http.*" /root/cve/${name}.txt >> /root/cve/${name}______allurl.txt ; sort -u /root/cve/${name}______all.txt -o /root/cve/${name}______allurl.txt
done
fi

resultline=`cat /root/cve/${name}______match.txt | wc -l`
if [ $resultline -eq 0 ]
then
result=`echo "......................." ; echo "nano /root/cve/${name}.txt       nano /root/cve/${name}______allurl.txt"`
else
result=`echo "!!!!!!!!!!!!!!!!!!!!!!!" ; echo "nano /root/cve/${name}.txt       nano /root/cve/${name}______allurl.txt          nano /root/cve/${name}______match.txt"`
fi
url=`grep -oP "http.*?(?=\")" /root/script/webhook.sh`
echo "curl -X POST -H \"Content-type:application/json\" --data '{\"text\":\"${word}\n${grep2}\n${result}\nhttps://www.exploit-db.com/exploits/${i}\n\n\"}' $url" > slack.sh
bash slack.sh ; rm slack.sh
fi
fi
done
rm curl.txt
rm service.txt

fi
i=$((i+1))
echo $i
sleep 6
else
sleep 6
fi
