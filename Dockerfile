FROM icr.io/appc-dev/ace-server@sha256:a41f7501fe4025d2705bcabf1ad2ff523bcaf9ec263b98054501de1fc0cf5f62

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
      version="12.0.4.0-r2"
    

COPY NewOrdersService /home/aceuser/NewOrdersService
COPY HelloWorldAPI /home/aceuser/HelloWorldAPI

RUN mkdir /home/aceuser/bars && \
        source /opt/ibm/ace-12/server/bin/mqsiprofile && \
        /opt/ibm/ace-12/server/bin/mqsipackagebar -a bars/NewOrdersService.bar -k NewOrdersService && \
        /opt/ibm/ace-12/server/bin/mqsipackagebar -a bars/HelloWorldAPI.bar -k HelloWorldAPI && \
        ace_compile_bars.sh && \
        mv -v bars /home/aceuser/initial-config/bars        
USER 0
RUN chmod -R 777 /home/aceuser/initial-config/bars && \
    chmod -R 777 /home/aceuser/ace-server/run/NewOrdersService && \
    chmod -R 777 /home/aceuser/ace-server/run/HelloWorldAPI
    
USER aceuser
