FROM utkarshyeo/lbbase:v1

RUN mkdir "/home/app" 

ENV app="/home/app"

COPY "package.json" "$app"

WORKDIR "$app"

RUN npm install --production

COPY "app.js" "$app"

COPY "check-mode.sh" "$app"

COPY "src" "$app/src"

EXPOSE 3000

RUN sed -i 's/\r$//' $app/check-mode.sh  && \  
    chmod +x $app/check-mode.sh

ENTRYPOINT  $app/check-mode.sh

