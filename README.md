# About

How to debug the node application deployed on kubernetes :

Debugging application on kubernetes is not as easy as on local. We have come up
with the approach, where we are using shell script, which decides whether the application
should run in debug mode or normal mode. 

## STEPS

### 1. SHELL SCRIPT : 

Shell script checks for the environment variable "DEBUG_MODE", whether it is defined or not in the container, if it is not defined it will continue with the normal execution process, or else it will start the container in debug mode.

Script also provides an option to debug specific file if needed on container start, for that we would require defining environment variable "DEBUG_FILE" and the value will be 
the absolute path of the file.

Ex : DEBUG_FILE=/home/app/src/server.js



### 2. Moving shell script into the container/image : 

For moving the shell script into the container, we need to specify it into the docker file, and also make it as a EntryPoint in dockerFile. Also, there are some encoding issue, when we create a shell script on windows, so sed is required.

	a. COPY "check-mode.sh" "$app"
	
	b. RUN sed -i 's/\r$//' $app/check-mode.sh  && \  
    chmod +x $app/check-mode.sh

	c. ENTRYPOINT  $app/check-mode.sh


### 3. Create an Image using this dockerFile. 

Till this step we are ready with the image to be deployed on kubernetes.

### 4. Create StatefulSet/Services :

In this repo, I already added json's for statefulset and service.

### 5. Define Environmet Variable :

Once the pod is started, we can add environment variable in the statefulset 
{name :DEBUG_MODE, value :"debug"}, value generally doesn't matter as I am just
checking env variable defined or not in the script.

Restart the pod, once the environment variable is defined, so that the changes can
be reflected to the container.

### 6. Port-Forwarding the running container/pod to local :

	a. Port-forward : Check the logs in the pod, for the exposed debugger port, and
	 then run the following command, and wait until it has started forwarding the request.

		kubectl –namespace=node-demo port-forward nodeapp-0 9229:9229

	b. Open Chrome://inspect to attach a debugger : Once the port is forwarded open the chrome://inspect and in the remote devices section the debugging file will be listed.

### 7. Switched back to normal mode :


Once completed with debugging, we can easily switch to the normal mode, by just removing the environment variables from the statefulset and then restarting the pod again.

We don't need to re-build the image again.
