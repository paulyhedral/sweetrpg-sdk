# ================================
# Build image
# ================================
FROM swift:5.4-focal as build

# Install OS updates and, if needed, sqlite3
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get -q install openssh-client git \
    && rm -rf /var/lib/apt/lists/*

# Set up a build area
WORKDIR /build

# First just resolve dependencies.
# This creates a cached layer that can be reused
# as long as your Package.swift/Package.resolved
# files do not change.
COPY ./Package.* ./
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh swift package resolve

# Copy entire repo into container
COPY . .

# Build everything, with optimizations and test discovery
RUN --mount=type=ssh swift build --enable-test-discovery -c release

# Switch to the staging area
WORKDIR /staging

# Copy main executable to staging area
# RUN cp "$(swift build --package-path /build -c release --show-bin-path)/Run" ./

# Copy any resouces from the public directory and views directory if the directories exist
# Ensure that by default, neither the directory nor any of its contents are writable.
# RUN [ -d /build/Public ] && { mv /build/Public ./Public && chmod -R a-w ./Public; } || true
# RUN [ -d /build/Resources ] && { mv /build/Resources ./Resources && chmod -R a-w ./Resources; } || true
