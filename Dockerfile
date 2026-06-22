# Langkah 1: Tentukan fondasi server
FROM tomcat:9.0-jdk11-openjdk-slim

# Langkah 2: Bersihkan server bawaan
RUN rm -rf /usr/local/tomcat/webapps/*

# Langkah 3: Masukkan aplikasi LogisTel ke server
COPY target/LogisTel.war /usr/local/tomcat/webapps/ROOT.war

# Langkah 4: Buka gerbang port internal
EXPOSE 8080

# Langkah 5: Jalankan perintah adaptasi port dan nyalakan server
CMD ["sh", "-c", "sed -i 's/port=\"8080\"/port=\"'\"$PORT\"'/g' /usr/local/tomcat/conf/server.xml && catalina.sh run"]