FROM ghcr.io/k4czp3r/linuxdeploy-tauri-arm64:latest AS build-stage

# Get version from env
ARG VERSION


# Get Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - 
RUN apt-get install -y nodejs npm

WORKDIR /build/plu-v2-web
COPY ./plu-v2-web/package.json ./package.json
COPY ./plu-v2-web/package-lock.json ./package-lock.json
RUN npm install
COPY ./plu-v2-web .
RUN npm run tauri-build; exit 0
WORKDIR /build/plu-v2-web/src-tauri/target/release/bundle/appimage
ENV OUTPUT="plu-v2-web_${VERSION}_aarch64.AppImage"

RUN /executables/linuxdeploy --appdir "plu-v2-web.AppDir" --plugin gtk --output appimage


# Sign AppImage
FROM node:latest As sign-stage

ARG VERSION
ARG PRIVATE_KEY

WORKDIR /sign
COPY --from=build-stage /build/plu-v2-web/src-tauri/target/release/bundle/appimage/plu-v2-web_${VERSION}_aarch64.AppImage .
RUN chmod +x plu-v2-web_${VERSION}_aarch64.AppImage
RUN tar -czvf plu-v2-web_${VERSION}_aarch64.tar.gz plu-v2-web_${VERSION}_aarch64.AppImage
RUN npx @tauri-apps/cli signer sign ./plu-v2-web_${VERSION}_aarch64.tar.gz  --private-key ${PRIVATE_KEY} --password ""

# Export
FROM scratch AS export-stage
COPY --from=sign-stage /sign .
