# swift-mysqlkit-console

This is an example of how to create a mysql server using docker compose file and connect it to a swift console application.  

This entire setup (docker and swift connection) is for development purposes and unsafe for production.  

Usage:
 Install docker desktop and swift on your computer.
 Go to terminal and navigate to where docker-compose file is. Then type:  
 docker compose up -d  
 To run the swift:  
 swift run  

 To shut down docker container, run this in the same folder:  
 docker compose down
