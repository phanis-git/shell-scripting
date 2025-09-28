rootUserId=$(id -u)

if [ $rootUserId -eq 0 ]; then
    dnf install mysql-server -y
    mysql_server_install_status=$?
    if [$mysql_server_install_status -eq 0]; then
    echo "Mysql server installed successfully"
    else 
    echo "There is a problem in Mysql server installation"
    fi 
    else 
    echo "User doesnot have sudo or root access , Take root access "
fi 