FROM httpd:2.4
COPY src/configure-app-name.sh /tmp/
RUN chmod +x /tmp/configure-app-name.sh
ENTRYPOINT ["/tmp/configure-app-name.sh"]
CMD ["httpd"]
