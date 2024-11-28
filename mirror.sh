#!/bin/bash

SOURCE_LIST="/etc/apt/sources.list"

cp $SOURCE_LIST $SOURCE_LIST.bak

sed -i 's|http://[a-zA-Z0-9.-]*/ubuntu|http://ftp.kaist.ac.kr/ubuntu|g' $SOURCE_LIST

echo "미러 사이트가 ftp.kaist.ac.kr로 변경되었습니다. 다음은 변경된 내용입니다:"
grep "ftp.kaist.ac.kr" $SOURCE_LIST