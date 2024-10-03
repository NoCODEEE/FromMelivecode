# Use a specific Flutter version that includes Dart SDK >=3.4.3
# It's recommended to specify the Flutter version to ensure compatibility
FROM cirrusci/flutter:3.10.5

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_SDK_ROOT=/opt/android-sdk

# Install necessary packages as root
RUN apt-get update && apt-get install -y --no-install-recommends \
    android-sdk \
    android-tools-adb \
    android-tools-fastboot \
    libgl1-mesa-dev \
    libpulse0 \
    libxcb-xinerama0 \
    xorg \
    openjdk-11-jdk \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Accept Android SDK licenses
RUN mkdir -p $ANDROID_SDK_ROOT/licenses \
    && yes | sdkmanager --licenses

# Create a non-root user named 'flutteruser'
RUN useradd -m flutteruser

# Set the working directory
WORKDIR /app

# Copy the project files to the container
COPY . .

# Change ownership of the app directory to 'flutteruser'
RUN chown -R flutteruser:flutteruser /app

# Switch to the non-root user
USER flutteruser

# Ensure Flutter is on the stable channel and upgrade to the latest compatible version
RUN flutter channel stable && flutter upgrade

# Verify Flutter setup (optional but recommended for debugging)
RUN flutter doctor

# Get Flutter dependencies
RUN flutter pub get

# Expose necessary ports (e.g., for debugging)
EXPOSE 5554 5555

# Default command to keep the container running
CMD ["/bin/bash"]