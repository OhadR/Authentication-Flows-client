echo "Running Maven Build WITHOUT tests... For development purposes only !"
export MAVEN_OPTS="-Xmx2048m -XX:MaxPermSize=512M"

# mvn clean install eclipse:clean eclipse:eclipse -DskipTests -DdownloadSources=true

mvn clean install -U -DskipTests -DdownloadSources=true
