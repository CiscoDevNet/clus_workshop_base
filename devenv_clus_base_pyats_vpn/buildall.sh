for i in `ls -1 Dockerfile.*`
do
    ext=`echo $i | cut -d '.' -f 2` 
    dockerimage="npateriya/dockergotty:$ext"
    docker build -t $dockerimage -f $i .
    docker push $dockerimage 
done 
