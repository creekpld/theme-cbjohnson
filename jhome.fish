function jhome
    set JAVA_HOME (/usr/libexec/java_home $argv)
    echo "JAVA_HOME:" $JAVA_HOME
    echo "java -version:"
    java -version
end
