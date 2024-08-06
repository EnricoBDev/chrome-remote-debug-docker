FROM alpine:3.19

# Installs latest Chromium package.
RUN apk upgrade --no-cache --available \
    && apk add --no-cache \
      chromium-swiftshader \
      ttf-freefont \
      font-noto-emoji \
    && apk add --no-cache \
      --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
      font-wqy-zenhei
RUN apk add wget zip

RUN wget https://github.com/gorhill/uBlock/releases/download/1.59.0/uBlock0_1.59.0.chromium.zip
RUN unzip uBlock0_1.59.0.chromium.zip
COPY local.conf /etc/fonts/local.conf

# Add Chrome as a user
RUN mkdir -p /usr/src/app \
    && adduser -D chrome \
    && chown -R chrome:chrome /usr/src/app
# Run Chrome as non-privileged
USER chrome
WORKDIR /usr/src/app

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

CMD ["chromium-browser", "--no-sandbox", "--headless", "--disable-web-security", "--disable-dev-shm-usage", "--disable-software-rasterizer", "--remote-debugging-port=9222", "--load-extension=uBlock0.chromium", "--remote-debugging-address=0.0.0.0", "--disable-features=IsolateOrigins,site-per-process", "--enable-features=ConversionMeasurement,AttributionReportingCrossAppWeb"]
