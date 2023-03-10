# 12.0.7.0-r4
FROM cp.icr.io/cp/appc/ace-server-prod@sha256:558e2d74fdd4ea291d56eab1360167294e3385defa7fe1f4701b27dbb6e6bba6

ENV SUMMARY="Integration Server for App Connect Enterprise" \
    DESCRIPTION="Integration Server for App Connect Enterprise" \
    PRODNAME="AppConnectEnterprise" \
    COMPNAME="IntegrationServer" \
    LICENSE="accept" \
    LOG_FORMAT="basic"

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Integration Server for App Connect Enterprise" \
      io.openshift.tags="$PRODNAME,$COMPNAME" \
      com.redhat.component="$PRODNAME-$COMPNAME" \
      name="$PRODNAME/$COMPNAME" \
      version="12.0.7.0-r4"

# Copy the projects into the image
RUN mkdir /tmp/projects
COPY NewOrdersService /tmp/projects/NewOrdersService
COPY HelloWorldAPI /tmp/projects/HelloWorldAPI

# Load the projects into the work directory, compiling and optimizing for faster startup
RUN source /opt/ibm/ace-12/server/bin/mqsiprofile && \
    ibmint deploy --compile-maps-and-schemas --input-path /tmp/projects --output-work-directory /home/aceuser/ace-server && \
    ibmint optimize server --work-directory /home/aceuser/ace-server

USER 0
RUN chmod -R 777 /home/aceuser/ace-server/run/* /home/aceuser/ace-server/*yaml
    
USER aceuser
